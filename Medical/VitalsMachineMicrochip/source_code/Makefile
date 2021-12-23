SB_ROOT=/home/buildbot/nik/pulse_ox/linux-sama5d-armle-fbdev-obj
SB_INC=-I$(SB_ROOT)/include -I/home/buildbot/toolchains/sama5d/sysroots/cortexa5t2hf-vfp-poky-linux-gnueabi/usr/include/
SB_LIB=-L$(SB_ROOT)/lib -lgreio
CC=/home/buildbot/toolchains/sama5d/sysroots/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi/arm-poky-linux-gnueabi-gcc
CFLAGS+=-mfloat-abi=hard -mtune=cortex-a5 
# Linux users may need to add this 
#CFLAGS+= -m32
SB_LIB+=-lpthread

all: readtty


readtty: readtty.c
	$(CC) $(CFLAGS) --sysroot=/home/buildbot/toolchains/sama5d/sysroots/cortexa5t2hf-vfp-poky-linux-gnueabi $(SB_INC) -o read_tty readtty.c $(SB_LIB)