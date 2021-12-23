#include <stdio.h>   /* Standard input/output definitions */
#include <termios.h> /* POSIX terminal control definitions */
#include <fcntl.h>   /* File control definitions */
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <unistd.h>

#include <gre/greio.h>

#define SEND_CHANNEL "medical"
#define RECEIVE_CHANNEL "medical_backend"
#define MEDICAL_UPDATE_EVENT "device_update"
#define	BLOOD_PRESSURE_EVENT "blood_pressure_event"
#define	PULSE_OX_EVENT "pulse_oximeter_event"
#define TEMPERATURE_EVENT "temperature_event"
#define ECG_EVENT "ecg_event"
#define ECG_ID 1
#define PULSE_OX_ID 2
#define THERMOMETER_ID 3
#define BPC_ID 4
#define BLOOD_UPDATE_FMT "4u1 header 4u1 pressure 4s40 waveform 4u1 waveform_count 4s1 wave_min 4s1 wave_max 4u1 systolic 4u1 diastolic 4u1 bpm"
#define PULSE_OX_FMT "4s10 pulsation_waveform 4u1 waveform_count 4s1 wave_min 4s1 wave_max 4u1 blood_oxygen_level 4u1 bpm"
#define TEMPERATURE_UPDATE_FMT "4f1 value 1s1 unit"
#define ECG_UPDATE_FMT "4s40 wave 4s1 wave_min 4s1 wave_max 4u1 count"
#define ECG_WAVE_COUNT 40
#define BLOOD_PRESSURE_WAVE_COUNT 40
#define PULSE_WAVE_COUNT 10

typedef struct ecg_update {
	int32_t		wave[ECG_WAVE_COUNT];
	int32_t		wave_min;
	int32_t		wave_max;
	uint32_t	count;
} ecg_update_t;

typedef struct pulse_ox_update {
	int32_t	pulsation_waveform[PULSE_WAVE_COUNT];
	uint32_t	waveform_count;
	int32_t		wave_min;
	int32_t		wave_max;
	uint32_t	blood_oxygen_level;
	uint32_t	bpm;
} pulse_ox_update_t;

typedef struct blood_pressure_update {
	uint32_t	header;
	uint32_t	pressure;
	int32_t		waveform[BLOOD_PRESSURE_WAVE_COUNT];
	uint32_t	waveform_count;
	int32_t		wave_min;
	int32_t		wave_max;
	uint32_t 	systolic;
	uint32_t 	diastolic;
	uint32_t	bpm;
} blood_pressure_update_t;

typedef struct temperature_update {
	float		value;
	char		unit[1];
} temperature_update_t;

typedef struct ui_update {
	int32_t device;
	char 	command;
} ui_update_t;

static gre_io_t					*send_handle;
static pthread_mutex_t			lock;
static pthread_t				thread_pulse;
static pthread_t				thread_temp;
static pthread_t				thread_blood;
static pthread_t				thread_ecg;
static pthread_t				thread_sbio_receive;
static int 						pulse_fd;
static int						bpc_fd;
static int						temp_fd;
static int						ecg_fd;
static int						ui_up = 0;

void * sbio_receive() {
	gre_io_t					*handle;
	gre_io_serialized_data_t	*nbuffer = NULL;
	char 						*event_addr;
	char 						*event_name;
	char 						*event_format;
	void 						*event_data;
	int						 	ret, device, nbytes;
	char						command;
	char						ecg_user_data[] = {0xAA, 0xAA, 0x4E, 0x4F, 0x52, 0x4D};
	char						ecg_demo_data[] = {0xAA, 0xAA, 0x44, 0x45, 0x4D, 0x4F};

	// Connect to a channel to receive messages
	handle = gre_io_open(RECEIVE_CHANNEL, GRE_IO_TYPE_RDONLY);
	if (handle == NULL) {
		fprintf(stderr, "Can't open receive channel\n");
		return 0;
	}

	nbuffer = gre_io_size_buffer(NULL, 100);

	while (1) {
		ret = gre_io_receive(handle, &nbuffer);
		if (ret < 0) {
			return 0;
		}

		event_name = NULL;
		nbytes = gre_io_unserialize(nbuffer, &event_addr, &event_name, &event_format, &event_data);
		if (!event_name) {
			printf("Missing name \n");
			return 0;
		}
		if (strcmp(event_name, "ui_ready") == 0){
			ui_up = 1;
		}else if(strcmp(event_name, "device_event") == 0){
			ui_update_t *uidata = (ui_update_t *)event_data;
			device = uidata->device;
			command = uidata->command;		
			pthread_mutex_lock(&lock);
			
			if(device == THERMOMETER_ID) {
				if(command == 'c' || command == 'f' || command == 'r'){
					write(temp_fd, &command, 1);
				}
			}else if(device == PULSE_OX_ID) {
				if(command == 'r'){
					write(pulse_fd, &command, 1);
				}
			}else if(device == ECG_ID) {
				if(command == 'n') {
					write(ecg_fd, &ecg_user_data, 6);
				}else if(command == 'd') {
					write(ecg_fd, &ecg_demo_data, 6);
				}
			}else if(device == BPC_ID) {
				if(command == '1' || command == '0' || command == 'r') {
					write(bpc_fd, &command, 1);
				}
			}
			pthread_mutex_unlock(&lock);
		}

	}
	//Release the buffer memory, close the send handle
	gre_io_free_buffer(nbuffer);
	gre_io_close(handle);
}

void * read_ecg() {
	int 						i, j, n, ret, min, max;
	struct 						termios tty;
	char 						hdr1, hdr2;
	char 						buf[ECG_WAVE_COUNT];
	short 						dat;
	int 						count = 0;
	int 						valid = 0;
	int 						wave_buffer_count = 0;
	int							min_max_baselined = 0;
	gre_io_serialized_data_t	*nbuffer = NULL;
	ecg_update_t 				ecg_event;

	ecg_fd = open("/dev/ttyS1", O_RDWR | O_NOCTTY);
		if (temp_fd == -1) {
		printf("Unable to open /dev/ttyS1\n");
	}

	memset (&tty, 0, sizeof tty);
	if (tcgetattr (ecg_fd, &tty) != 0) {
		printf("error from tcgetattr");
		return;
	}

	cfsetospeed (&tty, B115200);
	cfsetispeed (&tty, B115200);

	tty.c_cflag = (tty.c_cflag & ~CSIZE) | CS8;	 // 8-bit chars
	tty.c_iflag &= ~IGNBRK;		 // disable break processing
	tty.c_lflag = 0;				// no signaling chars, no echo,
									// no canonical processing
	tty.c_oflag = 0;				// no remapping, no delays
	tty.c_cc[VMIN]  = 0;			// read doesn't block
	tty.c_cc[VTIME] = 5;			// 0.5 seconds read timeout

	tty.c_iflag &= ~(IXON | IXOFF | IXANY); // shut off xon/xoff ctrl
	tty.c_cflag |= (CLOCAL | CREAD);// ignore modem controls,
											// enable reading
	tty.c_cflag &= ~(PARENB | PARODD);	  // shut off parity
	tty.c_cflag &= ~CSTOPB;
	tty.c_cflag &= ~CRTSCTS;

	if (tcsetattr (ecg_fd, TCSANOW, &tty) != 0) {
		printf("error from tcsetattr");
		return;
	}

	memset(&ecg_event, 0, sizeof(ecg_event));
	wave_buffer_count = 0;
	while (1) {
		while (1) {
			n = read(ecg_fd, &hdr1, 1);
			if (n == 1 && hdr1 == 0xAA) {
				do {
					n = read(ecg_fd, &hdr2, 1);
					if (n == 1 && hdr2 == 0xAA) 
						break;
				} while (n != 1);
			}
			if (hdr1 == 0xAA && hdr2 == 0xAA) {
				hdr1 = 0;
				hdr2 = 0;
				break;
			}
		}
		while (count < sizeof(buf)) {
			n = read(ecg_fd, &buf[count], sizeof(buf) - count);
			count = count += n;
		}
		count = 0;
		
		for (i=0; i<20; i+=2) {
			dat = buf[i+1] | buf[i] << 8;
			
			if (min_max_baselined == 0) {
				min = dat;
				max = dat;
				min_max_baselined = 1;
			}
			
			if(dat < min) {
				min = dat;
			}
			
			if(dat > max) {
				max = dat;
			}
			
			ecg_event.wave_min = min;
			ecg_event.wave_max = max;
			
			ecg_event.wave[wave_buffer_count] = (int)dat;
			wave_buffer_count++;
		}
		ecg_event.count = wave_buffer_count;
		
		if(wave_buffer_count >= 20){
			min_max_baselined = 0;
			nbuffer = gre_io_size_buffer(nbuffer, sizeof(ecg_event));
			if(!nbuffer) {
				fprintf(stderr, "Couldn't resize buffer, exiting\n");
			}
			
			nbuffer = gre_io_serialize(nbuffer, NULL, ECG_EVENT, ECG_UPDATE_FMT, &ecg_event, sizeof(ecg_event));
			if(!nbuffer) {
				fprintf(stderr, "Can't serialized data to buffer, exiting\n");
				break;
			}
			wave_buffer_count = 0;
			pthread_mutex_lock(&lock);
			// Send the serialized event buffer
			ret = gre_io_send(send_handle, nbuffer);
			pthread_mutex_unlock(&lock);
			if(ret < 0){
				fprintf(stderr, "Send failed, exiting\n");
				break;
			}
		}
	}
	close(ecg_fd);
}

void * read_temp() {
	int 						i, j, n, ret;
	int 						count = 0;
	int 						valid = 0;
	struct 						termios tty;
	char 						buf[18];
	gre_io_serialized_data_t 	*nbuffer = NULL;
	temperature_update_t 		temperature_event;

	temp_fd = open("/dev/ttyS3", O_RDWR | O_NOCTTY);
	if (temp_fd == -1) {
		printf("Unable to open /dev/ttyS3\n");
		return;
	}

	memset (&tty, 0, sizeof tty);
	if (tcgetattr (temp_fd, &tty) != 0) {
		printf("error from tcgetattr");
		return;
	}

	cfsetospeed (&tty, B115200);
	cfsetispeed (&tty, B115200);

	tty.c_cflag = (tty.c_cflag & ~CSIZE) | CS8;	 // 8-bit chars
	tty.c_iflag &= ~IGNBRK;		 // disable break processing
	tty.c_lflag = 0;				// no signaling chars, no echo,
									// no canonical processing
	tty.c_oflag = 0;				// no remapping, no delays
	tty.c_cc[VMIN]  = 0;			// read doesn't block
	tty.c_cc[VTIME] = 5;			// 0.5 seconds read timeout

	tty.c_iflag &= ~(IXON | IXOFF | IXANY); // shut off xon/xoff ctrl
	tty.c_cflag |= (CLOCAL | CREAD);// ignore modem controls,
											// enable reading
	tty.c_cflag &= ~(PARENB | PARODD);	  // shut off parity
	tty.c_cflag &= ~CSTOPB;
	tty.c_cflag &= ~CRTSCTS;

	if (tcsetattr (temp_fd, TCSANOW, &tty) != 0) {
		printf("error from tcsetattr");
		return;
	}

	memset(&temperature_event, 0, sizeof(temperature_event));
	while (1) {
		while (count < sizeof(buf)) {
			n = read(temp_fd, &buf[count], sizeof(buf) - count);
			if (n < 0) {
				printf("read failed!\n");
				return;
			}
			count += n;
		}
		count = 0;
		for (i=0; i<sizeof(buf); i++) { // 15;25.5C;
			if (buf[i] == '1' && buf[i+1] == '5' && buf[i+2] == ';' && buf[i+8] == ';') {
				valid = 1;
				break;
			}
		}
		if (valid) {
			valid = 0;
			temperature_event.value = atof(&buf[i]+3);
			memcpy(temperature_event.unit, &buf[i]+7, 1);
			nbuffer = gre_io_size_buffer(nbuffer, sizeof(temperature_event));
			if(!nbuffer) {
				fprintf(stderr, "Couldn't resize buffer, exiting\n");
			}
			
			nbuffer = gre_io_serialize(nbuffer, NULL, TEMPERATURE_EVENT, TEMPERATURE_UPDATE_FMT, &temperature_event, sizeof(temperature_event));
			if(!nbuffer) {
				fprintf(stderr, "Can't serialized data to buffer, exiting\n");
				break;
			}

			pthread_mutex_lock(&lock);
			// Send the serialized event buffer
			ret = gre_io_send(send_handle, nbuffer);
			pthread_mutex_unlock(&lock);
			if(ret < 0){
				fprintf(stderr, "Send failed, exiting\n");
				break;
			}
		}
	}
	close(temp_fd);
}

void * read_blood_pressure(){
	int 						i, j, n, to_read, ret, data, min, max;
	struct 						termios tty;
	char 						header[7];
	char 						buf[18];
	gre_io_serialized_data_t 	*nbuffer = NULL;
	blood_pressure_update_t 	bpc_event;
	char 						header_live[6] = "00015;";
	char 						header_results[6] = "00014;";
	int 						count = 0;
	int 						valid = 0;
	int 						test_complete = 0;
	int							min_max_baselined = 0;
	int							blood_pressure_wave_count = 0;

	bpc_fd = open("/dev/ttyS4", O_RDWR | O_NOCTTY);
		if (bpc_fd == -1) {
		printf("Unable to open /dev/ttyS4\n");
	}

	memset (&tty, 0, sizeof tty);
	if (tcgetattr (bpc_fd, &tty) != 0) {
		printf("error from tcgetattr");
		return;
	}

	cfsetospeed (&tty, B115200);
	cfsetispeed (&tty, B115200);

	tty.c_cflag = (tty.c_cflag & ~CSIZE) | CS8;	 // 8-bit chars
	tty.c_iflag &= ~IGNBRK;		 // disable break processing
	tty.c_lflag = 0;				// no signaling chars, no echo,
									// no canonical processing
	tty.c_oflag = 0;				// no remapping, no delays
	tty.c_cc[VMIN]  = 0;			// read doesn't block
	tty.c_cc[VTIME] = 5;			// 0.5 seconds read timeout

	tty.c_iflag &= ~(IXON | IXOFF | IXANY); // shut off xon/xoff ctrl
	tty.c_cflag |= (CLOCAL | CREAD);// ignore modem controls,
											// enable reading
	tty.c_cflag &= ~(PARENB | PARODD);	  // shut off parity
	tty.c_cflag &= ~CSTOPB;
	tty.c_cflag &= ~CRTSCTS;

	if (tcsetattr (bpc_fd, TCSANOW, &tty) != 0) {
			printf("error from tcsetattr");
			return;
	}

	memset(&bpc_event, 0, sizeof(bpc_event));

	while (1) {
		count = 0;
		test_complete = 0;
		while (1) {
			if (count == 6) {
				valid = 1;
				header[6] = '\0';
				break;
			}
			n = read(bpc_fd, &header[count], 1);
			if (n == 1 && (header[count] == header_live[count] || header[count] == header_results[count])) {
				
				count++;
			} else {
				break;
			}
		}
		count = 0;
		if (valid == 1) {
			
			// 00015;00148;08397; -- 12
			// 00014;00116;00079;00059; -- 18
			to_read = 12;
			if (header[4] == '4') {
				to_read = 18;
				test_complete = 1;
			}

			while (count < to_read) {
				n = read(bpc_fd, &buf[count], to_read - count);
				count = count += n;
			}
			bpc_event.header = strtol(&header[0],NULL,10);
			if(test_complete == 1) {
				bpc_event.pressure = 0;
				memset(bpc_event.waveform, 0, sizeof(bpc_event.waveform));
				bpc_event.waveform_count = 0;
				bpc_event.systolic = strtol(&buf[0],NULL,10);
				bpc_event.diastolic = strtol(&buf[6],NULL,10);
				bpc_event.bpm = strtol(&buf[12],NULL,10);
				blood_pressure_wave_count = BLOOD_PRESSURE_WAVE_COUNT;
			} else {
				data = strtol(&buf[6],NULL,10);
				if (min_max_baselined == 0) {
					min = data;
					max = data;
					min_max_baselined = 1;
				}
				
				if(data < min) {
					min = data;
				}
				
				if(data > max) {
					max = data;
				}
				
				bpc_event.wave_min = min;
				bpc_event.wave_max = max;
				
				bpc_event.pressure = strtol(&buf[0],NULL,10);
				bpc_event.waveform[blood_pressure_wave_count] = data;
				bpc_event.waveform_count = blood_pressure_wave_count;
				bpc_event.systolic = 0;
				bpc_event.diastolic = 0;
				bpc_event.bpm = 0;
				blood_pressure_wave_count++;
			}
			
			if(blood_pressure_wave_count >= BLOOD_PRESSURE_WAVE_COUNT) {
				blood_pressure_wave_count = 0;
				min_max_baselined = 0;
				nbuffer = gre_io_size_buffer(nbuffer, sizeof(bpc_event));
				if(!nbuffer) {
					fprintf(stderr, "Couldn't resize buffer, exiting\n");
				}
				
				nbuffer = gre_io_serialize(nbuffer, NULL, BLOOD_PRESSURE_EVENT, BLOOD_UPDATE_FMT, &bpc_event, sizeof(bpc_event));
				if(!nbuffer) {
					fprintf(stderr, "Can't serialized data to buffer, exiting\n");
					break;
				}
				pthread_mutex_lock(&lock);
				// Send the serialized event buffer
				ret = gre_io_send(send_handle, nbuffer);
				pthread_mutex_unlock(&lock);
				if(ret < 0){
					fprintf(stderr, "Send failed, exiting\n");
					break;
				}
			}
			valid = 0;
		}
	}
	close(bpc_fd);
}

void * read_pulse_ox(){
	int 						i, j, n, ret, data, min, max;
	struct 						termios tty;
	char 						buf[48*4];
	int 						count = 0;
	int 						valid = 0;
	int							dirty = 1;
	gre_io_serialized_data_t	*nbuffer = NULL;
	int							pulse_wave_count = 0;
	int							min_max_baselined = 0;
	pulse_ox_update_t 			pulse_event;

	pulse_fd = open("/dev/ttyS2", O_RDWR | O_NOCTTY);
	if (pulse_fd == -1) {
		printf("Unable to open /dev/ttyS2\n");
		return;
	}

	memset (&tty, 0, sizeof tty);
	if (tcgetattr (pulse_fd, &tty) != 0) {
		printf("error from tcgetattr");
		return;
	}

	cfsetospeed (&tty, B115200);
	cfsetispeed (&tty, B115200);

	tty.c_cflag = (tty.c_cflag & ~CSIZE) | CS8;	 // 8-bit chars
	tty.c_iflag &= ~IGNBRK;		 // disable break processing
	tty.c_lflag = 0;				// no signaling chars, no echo,
									// no canonical processing
	tty.c_oflag = 0;				// no remapping, no delays
	tty.c_cc[VMIN]  = 0;			// read doesn't block
	tty.c_cc[VTIME] = 5;			// 0.5 seconds read timeout

	tty.c_iflag &= ~(IXON | IXOFF | IXANY); // shut off xon/xoff ctrl
	tty.c_cflag |= (CLOCAL | CREAD);// ignore modem controls,
											// enable reading
	tty.c_cflag &= ~(PARENB | PARODD);	  // shut off parity
	tty.c_cflag &= ~CSTOPB;
	tty.c_cflag &= ~CRTSCTS;

	if (tcsetattr (pulse_fd, TCSANOW, &tty) != 0) {
		printf("error from tcsetattr");
		return;
	}

	memset(&pulse_event, 0, sizeof(pulse_event));

	while (1) {
		while (count < sizeof(buf)) {
				n = read(pulse_fd, &buf[count], sizeof(buf) - count);
			if (n < 0) {
				printf("read failed!\n");
				return;
			}
			count += n;
		}

		count = 0;
		// Data format 00015;00743;00099;00055;
		for (i=0; i<(sizeof(buf)/2)+4; i++) {
			if (buf[i] == '1' && buf[i+1] == '5' && buf[i+2] == ';' && buf[i+20] == ';') {
				valid = 1;
				break;
			}
		}
		if (valid) {
			valid = 0;
			data = strtol(&buf[i]+3,NULL,10);
			
			if (min_max_baselined == 0) {
				min = data;
				max = data;
				min_max_baselined = 1;
			}
			
			if(data < min) {
				min = data;
			}
			
			if(data > max) {
				max = data;
			}
			
			pulse_event.wave_min = min;
			pulse_event.wave_max = max;
			
			if(pulse_event.pulsation_waveform[pulse_event.waveform_count] != data){
				dirty = 1;
				pulse_event.pulsation_waveform[pulse_wave_count] = data;
				pulse_event.waveform_count = pulse_wave_count; 
				pulse_wave_count++;
			}
			
			data = strtol(&buf[i]+9,NULL,10);
			if(pulse_event.blood_oxygen_level != data) {
				dirty = 1;
				pulse_event.blood_oxygen_level = data;
			}
			
			data = strtol(&buf[i]+15,NULL,10);
			if(pulse_event.bpm != data){
				dirty = 1;
			pulse_event.bpm = strtol(&buf[i]+15,NULL,10);
			} 
			
			if(dirty == 1 && pulse_wave_count >= PULSE_WAVE_COUNT) {
				pulse_wave_count = 0;
				dirty = 0;
				min_max_baselined = 0;
				nbuffer = gre_io_size_buffer(nbuffer, sizeof(pulse_event));
				if(!nbuffer) {
					fprintf(stderr, "Couldn't resize buffer, exiting\n");
				}
				
				nbuffer = gre_io_serialize(nbuffer, NULL, PULSE_OX_EVENT, PULSE_OX_FMT, &pulse_event, sizeof(pulse_event));
				if(!nbuffer) {
					fprintf(stderr, "Can't serialized data to buffer, exiting\n");
					break;
				}
				pthread_mutex_lock(&lock);
				// Send the serialized event buffer
				ret = gre_io_send(send_handle, nbuffer);
				pthread_mutex_unlock(&lock);
				if(ret < 0){
					fprintf(stderr, "Send failed, exiting\n");
					break;
				}
			}
		}
	}
	close(pulse_fd);
}

int main(void)
{
	gre_io_serialized_data_t	*nbuffer = NULL;
	int 						ret;
	
	pthread_mutex_init(&lock, NULL);
	while(1) {
		usleep(50000);
		send_handle = gre_io_open(SEND_CHANNEL, GRE_IO_TYPE_WRONLY);
		if(send_handle != NULL) {
			printf("Send channel: %s successfully opened\n", SEND_CHANNEL);
			break;
		}
	}
	ret = pthread_create(&thread_sbio_receive, NULL, sbio_receive, NULL);
	if(ret != 0){
		printf("Failed to create pthread for receive, exiting\n");
		return 0;
	}
	
	while(ui_up != 1){
		usleep(100000);
	}
	
	ret = pthread_create(&thread_pulse, NULL, read_pulse_ox, NULL);
	if(ret != 0){
		printf("Failed to create pthread for pulse ox, exiting\n");
		return 0;
	}
	
	ret = pthread_create(&thread_temp, NULL, read_temp, NULL);
	if(ret != 0){
		printf("Failed to create pthread for thermometer, exiting\n");
		return 0;
	}
	
	ret = pthread_create(&thread_blood, NULL, read_blood_pressure, NULL);
	if(ret != 0){
		printf("Failed to create pthread for thermometer, exiting\n");
		return 0;
	}
	
	ret = pthread_create(&thread_ecg, NULL, read_ecg, NULL);
	if(ret != 0){
		printf("Failed to create pthread for ecg, exiting\n");
		return 0;
	}

	while (1) { //Should do something smarter like wait for the threads to terminate
		usleep(250000);
	}
	
	gre_io_free_buffer(nbuffer);
	gre_io_close(send_handle);
	return 0;
}

