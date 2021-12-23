require "json"

TODAY = {}
SEVEN_DAY = {}
TWELVE_HOUR = {}

ACTIVE_CITY = "Austin,Tx"

loading_anim_active = 0
local getting_weather = 0

local myenv = gre.env({ "target_os", "target_cpu" })

local today_string = "{\"coord\":{\"lon\":-75.7,\"lat\":45.41},\"sys\":{\"type\":1,\"id\":3694,\"message\":0.1617,\"country\":\"CA\",\"sunrise\":1417782430,\"sunset\":1417814410},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],\"base\":\"cmc stations\",\"main\":{\"temp\":-5.16,\"pressure\":1031,\"humidity\":67,\"temp_min\":-7,\"temp_max\":-3},\"wind\":{\"speed\":4.1,\"deg\":60},\"clouds\":{\"all\":90},\"dt\":1417809679,\"id\":6094817,\"name\":\"Ottawa\",\"cod\":200}"
local twelve_hour_string = "{\"cod\":\"200\",\"message\":1.7195,\"city\":{\"id\":6094817,\"name\":\"Ottawa\",\"coord\":{\"lon\":-75.69812,\"lat\":45.411171},\"country\":\"CA\",\"population\":0,\"sys\":{\"population\":0}},\"cnt\":40,\"list\":[{\"dt\":1417975200,\"main\":{\"temp\":-8.64,\"temp_min\":-10.06,\"temp_max\":-8.64,\"pressure\":1034.66,\"sea_level\":1056.69,\"grnd_level\":1034.66,\"humidity\":47,\"temp_kf\":1.42},\"weather\":[{\"id\":800,\"main\":\"Clear\",\"description\":\"sky is clear\",\"icon\":\"01d\"}],\"clouds\":{\"all\":0},\"wind\":{\"speed\":2.12,\"deg\":1.00815},\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2014-12-07 18:00:00\"},{\"dt\":1417986000,\"main\":{\"temp\":-9.42,\"temp_min\":-10.77,\"temp_max\":-9.42,\"pressure\":1034.22,\"sea_level\":1056.23,\"grnd_level\":1034.22,\"humidity\":49,\"temp_kf\":1.35},\"weather\":[{\"id\":800,\"main\":\"Clear\",\"description\":\"sky is clear\",\"icon\":\"01d\"}],\"clouds\":{\"all\":0},\"wind\":{\"speed\":1.34,\"deg\":357.501},\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2014-12-07 21:00:00\"},{\"dt\":1417996800,\"main\":{\"temp\":-13.05,\"temp_min\":-14.33,\"temp_max\":-13.05,\"pressure\":1034.92,\"sea_level\":1057.14,\"grnd_level\":1034.92,\"humidity\":66,\"temp_kf\":1.28},\"weather\":[{\"id\":800,\"main\":\"Clear\",\"description\":\"sky is clear\",\"icon\":\"01n\"}],\"clouds\":{\"all\":0},\"wind\":{\"speed\":1.48,\"deg\":356.503},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2014-12-08 00:00:00\"},{\"dt\":1418007600,\"main\":{\"temp\":-14.62,\"temp_min\":-15.83,\"temp_max\":-14.62,\"pressure\":1034.9,\"sea_level\":1057.11,\"grnd_level\":1034.9,\"humidity\":65,\"temp_kf\":1.21},\"weather\":[{\"id\":801,\"main\":\"Clouds\",\"description\":\"few clouds\",\"icon\":\"02n\"}],\"clouds\":{\"all\":20},\"wind\":{\"speed\":1.07,\"deg\":27.5009},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2014-12-08 03:00:00\"},{\"dt\":1418018400,\"main\":{\"temp\":-14.08,\"temp_min\":-15.22,\"temp_max\":-14.08,\"pressure\":1033.31,\"sea_level\":1055.65,\"grnd_level\":1033.31,\"humidity\":71,\"temp_kf\":1.14},\"weather\":[{\"id\":802,\"main\":\"Clouds\",\"description\":\"scattered clouds\",\"icon\":\"03n\"}],\"clouds\":{\"all\":32},\"wind\":{\"speed\":1.82,\"deg\":76.0004},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2014-12-08 06:00:00\"},{\"dt\":1418029200,\"main\":{\"temp\":-13.09,\"temp_min\":-14.16,\"temp_max\":-13.09,\"pressure\":1032.41,\"sea_level\":1054.5,\"grnd_level\":1032.41,\"humidity\":73,\"temp_kf\":1.07},\"weather\":[{\"id\":802,\"main\":\"Clouds\",\"description\":\"scattered clouds\",\"icon\":\"03n\"}],\"clouds\":{\"all\":44},\"wind\":{\"speed\":1.96,\"deg\":88.0022},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2014-12-08 09:00:00\"},{\"dt\":1418040000,\"main\":{\"temp\":-13.06,\"temp_min\":-14.06,\"temp_max\":-13.06,\"pressure\":1031.32,\"sea_level\":1053.44,\"grnd_level\":1031.32,\"humidity\":72,\"temp_kf\":0.99},\"weather\":[{\"id\":801,\"main\":\"Clouds\",\"description\":\"few clouds\",\"icon\":\"02n\"}],\"clouds\":{\"all\":20},\"wind\":{\"speed\":2.52,\"deg\":96.0007},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2014-12-08 12:00:00\"},{\"dt\":1418050800,\"main\":{\"temp\":-11.06,\"temp_min\":-11.99,\"temp_max\":-11.06,\"pressure\":1030.43,\"sea_level\":1052.39,\"grnd_level\":1030.43,\"humidity\":54,\"temp_kf\":0.92},\"weather\":[{\"id\":802,\"main\":\"Clouds\",\"description\":\"scattered clouds\",\"icon\":\"03d\"}],\"clouds\":{\"all\":32},\"wind\":{\"speed\":2.56,\"deg\":111.004},\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2014-12-08 15:00:00\"},{\"dt\":1418061600,\"main\":{\"temp\":-7.23,\"temp_min\":-8.08,\"temp_max\":-7.23,\"pressure\":1027.61,\"sea_level\":1049.22,\"grnd_level\":1027.61,\"humidity\":50,\"temp_kf\":0.85},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":64},\"wind\":{\"speed\":2.47,\"deg\":116},\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2014-12-08 18:00:00\"},{\"dt\":1418072400,\"main\":{\"temp\":-6.91,\"temp_min\":-7.69,\"temp_max\":-6.91,\"pressure\":1025.83,\"sea_level\":1047.16,\"grnd_level\":1025.83,\"humidity\":58,\"temp_kf\":0.78},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":64},\"wind\":{\"speed\":2.56,\"deg\":120.501},\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2014-12-08 21:00:00\"},{\"dt\":1418083200,\"main\":{\"temp\":-7.58,\"temp_min\":-8.29,\"temp_max\":-7.58,\"pressure\":1024.41,\"sea_level\":1045.94,\"grnd_level\":1024.41,\"humidity\":65,\"temp_kf\":0.71},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04n\"}],\"clouds\":{\"all\":68},\"wind\":{\"speed\":2.91,\"deg\":115.505},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2014-12-09 00:00:00\"},{\"dt\":1418104800,\"main\":{\"temp\":-5.29,\"temp_min\":-5.93,\"temp_max\":-5.29,\"pressure\":1020.86,\"sea_level\":1042.18,\"grnd_level\":1020.86,\"humidity\":75,\"temp_kf\":0.64},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04n\"}],\"clouds\":{\"all\":92},\"wind\":{\"speed\":2.51,\"deg\":122.508},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2014-12-09 06:00:00\"},{\"dt\":1418115600,\"main\":{\"temp\":-4.38,\"temp_min\":-4.95,\"temp_max\":-4.38,\"pressure\":1018.86,\"sea_level\":1039.96,\"grnd_level\":1018.86,\"humidity\":85,\"temp_kf\":0.57},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04n\"}],\"clouds\":{\"all\":92},\"wind\":{\"speed\":2.21,\"deg\":107.502},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2014-12-09 09:00:00\"},{\"dt\":1418126400,\"main\":{\"temp\":-3.58,\"temp_min\":-4.08,\"temp_max\":-3.58,\"pressure\":1017.78,\"sea_level\":1038.83,\"grnd_level\":1017.78,\"humidity\":94,\"temp_kf\":0.5},\"weather\":[{\"id\":600,\"main\":\"Snow\",\"description\":\"light snow\",\"icon\":\"13n\"}],\"clouds\":{\"all\":92},\"wind\":{\"speed\":2.07,\"deg\":93.0036},\"snow\":{\"3h\":0.25},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2014-12-09 12:00:00\"},{\"dt\":1418137200,\"main\":{\"temp\":-1.88,\"temp_min\":-2.31,\"temp_max\":-1.88,\"pressure\":1015.69,\"sea_level\":1036.74,\"grnd_level\":1015.69,\"humidity\":88,\"temp_kf\":0.43},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":92},\"wind\":{\"speed\":2.31,\"deg\":82.5015},\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2014-12-09 15:00:00\"},{\"dt\":1418148000,\"main\":{\"temp\":-0.34,\"temp_min\":-0.69,\"temp_max\":-0.34,\"pressure\":1012.06,\"sea_level\":1033.02,\"grnd_level\":1012.06,\"humidity\":86,\"temp_kf\":0.36},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":92},\"wind\":{\"speed\":2.43,\"deg\":55.5028},\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2014-12-09 18:00:00\"},{\"dt\":1418158800,\"main\":{\"temp\":0.19,\"temp_min\":-0.1,\"temp_max\":0.19,\"pressure\":1008.94,\"sea_level\":1029.71,\"grnd_level\":1008.94,\"humidity\":90,\"temp_kf\":0.28},\"weather\":[{\"id\":601,\"main\":\"Snow\",\"description\":\"snow\",\"icon\":\"13d\"}],\"clouds\":{\"all\":92},\"wind\":{\"speed\":3.31,\"deg\":24.5019},\"snow\":{\"3h\":4.25},\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2014-12-09 21:00:00\"},{\"dt\":1418169600,\"main\":{\"temp\":0.65,\"temp_min\":0.43,\"temp_max\":0.65,\"pressure\":1006.23,\"sea_level\":1027,\"grnd_level\":1006.23,\"humidity\":92,\"temp_kf\":0.21},\"weather\":[{\"id\":601,\"main\":\"Snow\",\"description\":\"snow\",\"icon\":\"13n\"}],\"clouds\":{\"all\":92},\"wind\":{\"speed\":4.27,\"deg\":21.5007},\"snow\":{\"3h\":4},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2014-12-10 00:00:00\"},{\"dt\":1418180400,\"main\":{\"temp\":0.87,\"temp_min\":0.73,\"temp_max\":0.87,\"pressure\":1003.66,\"sea_level\":1024.39,\"grnd_level\":1003.66,\"humidity\":85,\"temp_kf\":0.14},\"weather\":[{\"id\":601,\"main\":\"Snow\",\"description\":\"snow\",\"icon\":\"13n\"}],\"clouds\":{\"all\":92},\"wind\":{\"speed\":4.52,\"deg\":16.0017},\"snow\":{\"3h\":2.5},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2014-12-10 03:00:00\"},{\"dt\":1418191200,\"main\":{\"temp\":0.82,\"temp_min\":0.75,\"temp_max\":0.82,\"pressure\":1001.64,\"sea_level\":1022.26,\"grnd_level\":1001.64,\"humidity\":82,\"temp_kf\":0.07},\"weather\":[{\"id\":600,\"main\":\"Snow\",\"description\":\"light snow\",\"icon\":\"13n\"}],\"clouds\":{\"all\":92},\"wind\":{\"speed\":4.02,\"deg\":8.50027},\"snow\":{\"3h\":1.5},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2014-12-10 06:00:00\"},{\"dt\":1418202000,\"main\":{\"temp\":0.05,\"temp_min\":0.05,\"temp_max\":0.05,\"pressure\":1000.46,\"sea_level\":1020.88,\"grnd_level\":1000.46,\"humidity\":81},\"weather\":[{\"id\":600,\"main\":\"Snow\",\"description\":\"light snow\",\"icon\":\"13n\"}],\"clouds\":{\"all\":92},\"wind\":{\"speed\":4.45,\"deg\":359.503},\"snow\":{\"3h\":1.5},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2014-12-10 09:00:00\"},{\"dt\":1418212800,\"main\":{\"temp\":-0.55,\"temp_min\":-0.55,\"temp_max\":-0.55,\"pressure\":999.72,\"sea_level\":1020.4,\"grnd_level\":999.72,\"humidity\":79},\"weather\":[{\"id\":601,\"main\":\"Snow\",\"description\":\"snow\",\"icon\":\"13n\"}],\"clouds\":{\"all\":92},\"wind\":{\"speed\":4.76,\"deg\":357},\"snow\":{\"3h\":2.5},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2014-12-10 12:00:00\"},{\"dt\":1418223600,\"main\":{\"temp\":0.22,\"temp_min\":0.22,\"temp_max\":0.22,\"pressure\":999.1,\"sea_level\":1019.63,\"grnd_level\":999.1,\"humidity\":75},\"weather\":[{\"id\":600,\"main\":\"Snow\",\"description\":\"light snow\",\"icon\":\"13d\"}],\"clouds\":{\"all\":92},\"wind\":{\"speed\":4.76,\"deg\":354.001},\"snow\":{\"3h\":1},\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2014-12-10 15:00:00\"},{\"dt\":1418234400,\"main\":{\"temp\":1.93,\"temp_min\":1.93,\"temp_max\":1.93,\"pressure\":997.24,\"sea_level\":1017.76,\"grnd_level\":997.24,\"humidity\":84},\"weather\":[{\"id\":600,\"main\":\"Snow\",\"description\":\"light snow\",\"icon\":\"13d\"}],\"clouds\":{\"all\":92},\"wind\":{\"speed\":4.25,\"deg\":352.5},\"snow\":{\"3h\":1.5},\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2014-12-10 18:00:00\"},{\"dt\":1418245200,\"main\":{\"temp\":2.41,\"temp_min\":2.41,\"temp_max\":2.41,\"pressure\":997.02,\"sea_level\":1017.48,\"grnd_level\":997.02,\"humidity\":96},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":92},\"wind\":{\"speed\":4.11,\"deg\":355.005},\"snow\":{\"3h\":0},\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2014-12-10 21:00:00\"},{\"dt\":1418256000,\"main\":{\"temp\":2.69,\"temp_min\":2.69,\"temp_max\":2.69,\"pressure\":997.5,\"sea_level\":1017.83,\"grnd_level\":997.5,\"humidity\":97},\"weather\":[{\"id\":500,\"main\":\"Rain\",\"description\":\"light rain\",\"icon\":\"10n\"}],\"clouds\":{\"all\":92},\"wind\":{\"speed\":4.06,\"deg\":357.504},\"snow\":{\"3h\":0},\"rain\":{\"3h\":1},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2014-12-11 00:00:00\"},{\"dt\":1418266800,\"main\":{\"temp\":2.22,\"temp_min\":2.22,\"temp_max\":2.22,\"pressure\":996.54,\"sea_level\":1016.98,\"grnd_level\":996.54,\"humidity\":95},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04n\"}],\"clouds\":{\"all\":92},\"wind\":{\"speed\":4.22,\"deg\":352.5},\"snow\":{\"3h\":0},\"rain\":{\"3h\":0},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2014-12-11 03:00:00\"},{\"dt\":1418277600,\"main\":{\"temp\":1.22,\"temp_min\":1.22,\"temp_max\":1.22,\"pressure\":995.59,\"sea_level\":1016.06,\"grnd_level\":995.59,\"humidity\":95},\"weather\":[{\"id\":500,\"main\":\"Rain\",\"description\":\"light rain\",\"icon\":\"10n\"}],\"clouds\":{\"all\":92},\"wind\":{\"speed\":4.11,\"deg\":342.5},\"snow\":{\"3h\":0.5},\"rain\":{\"3h\":1},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2014-12-11 06:00:00\"},{\"dt\":1418288400,\"main\":{\"temp\":0.74,\"temp_min\":0.74,\"temp_max\":0.74,\"pressure\":994.49,\"sea_level\":1015.06,\"grnd_level\":994.49,\"humidity\":91},\"weather\":[{\"id\":601,\"main\":\"Snow\",\"description\":\"snow\",\"icon\":\"13n\"}],\"clouds\":{\"all\":92},\"wind\":{\"speed\":4.17,\"deg\":341.502},\"snow\":{\"3h\":5},\"rain\":{\"3h\":0},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2014-12-11 09:00:00\"},{\"dt\":1418299200,\"main\":{\"temp\":1,\"temp_min\":1,\"temp_max\":1,\"pressure\":994.87,\"sea_level\":1015.32,\"grnd_level\":994.87,\"humidity\":82},\"weather\":[{\"id\":601,\"main\":\"Snow\",\"description\":\"snow\",\"icon\":\"13n\"}],\"clouds\":{\"all\":92},\"wind\":{\"speed\":4.16,\"deg\":339.5},\"snow\":{\"3h\":2},\"rain\":{\"3h\":0},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2014-12-11 12:00:00\"},{\"dt\":1418310000,\"main\":{\"temp\":1.33,\"temp_min\":1.33,\"temp_max\":1.33,\"pressure\":995.86,\"sea_level\":1016.26,\"grnd_level\":995.86,\"humidity\":80},\"weather\":[{\"id\":600,\"main\":\"Snow\",\"description\":\"light snow\",\"icon\":\"13d\"}],\"clouds\":{\"all\":92},\"wind\":{\"speed\":4,\"deg\":336.003},\"snow\":{\"3h\":1},\"rain\":{\"3h\":0},\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2014-12-11 15:00:00\"},{\"dt\":1418320800,\"main\":{\"temp\":1.49,\"temp_min\":1.49,\"temp_max\":1.49,\"pressure\":995.66,\"sea_level\":1016.1,\"grnd_level\":995.66,\"humidity\":77},\"weather\":[{\"id\":600,\"main\":\"Snow\",\"description\":\"light snow\",\"icon\":\"13d\"}],\"clouds\":{\"all\":92},\"wind\":{\"speed\":4.01,\"deg\":332.003},\"snow\":{\"3h\":1.5},\"rain\":{\"3h\":0},\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2014-12-11 18:00:00\"},{\"dt\":1418331600,\"main\":{\"temp\":1.58,\"temp_min\":1.58,\"temp_max\":1.58,\"pressure\":996.79,\"sea_level\":1017.21,\"grnd_level\":996.79,\"humidity\":77},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":92},\"wind\":{\"speed\":3.46,\"deg\":326.003},\"snow\":{\"3h\":0},\"rain\":{\"3h\":0},\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2014-12-11 21:00:00\"},{\"dt\":1418342400,\"main\":{\"temp\":0.65,\"temp_min\":0.65,\"temp_max\":0.65,\"pressure\":999.04,\"sea_level\":1019.58,\"grnd_level\":999.04,\"humidity\":77},\"weather\":[{\"id\":600,\"main\":\"Snow\",\"description\":\"light snow\",\"icon\":\"13n\"}],\"clouds\":{\"all\":80},\"wind\":{\"speed\":3.41,\"deg\":320.504},\"snow\":{\"3h\":0.5},\"rain\":{\"3h\":0},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2014-12-12 00:00:00\"},{\"dt\":1418353200,\"main\":{\"temp\":-0.49,\"temp_min\":-0.49,\"temp_max\":-0.49,\"pressure\":999.98,\"sea_level\":1020.55,\"grnd_level\":999.98,\"humidity\":76},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04n\"}],\"clouds\":{\"all\":92},\"wind\":{\"speed\":3.25,\"deg\":315.503},\"snow\":{\"3h\":0},\"rain\":{\"3h\":0},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2014-12-12 03:00:00\"},{\"dt\":1418364000,\"main\":{\"temp\":-1.94,\"temp_min\":-1.94,\"temp_max\":-1.94,\"pressure\":1000.66,\"sea_level\":1021.15,\"grnd_level\":1000.66,\"humidity\":79},\"weather\":[{\"id\":600,\"main\":\"Snow\",\"description\":\"light snow\",\"icon\":\"13n\"}],\"clouds\":{\"all\":88},\"wind\":{\"speed\":2.86,\"deg\":316},\"snow\":{\"3h\":1},\"rain\":{\"3h\":0},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2014-12-12 06:00:00\"},{\"dt\":1418374800,\"main\":{\"temp\":-2.54,\"temp_min\":-2.54,\"temp_max\":-2.54,\"pressure\":1000.8,\"sea_level\":1021.59,\"grnd_level\":1000.8,\"humidity\":76},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04n\"}],\"clouds\":{\"all\":76},\"wind\":{\"speed\":2.86,\"deg\":316.501},\"snow\":{\"3h\":0},\"rain\":{\"3h\":0},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2014-12-12 09:00:00\"},{\"dt\":1418385600,\"main\":{\"temp\":-2.64,\"temp_min\":-2.64,\"temp_max\":-2.64,\"pressure\":1002.29,\"sea_level\":1023.14,\"grnd_level\":1002.29,\"humidity\":77},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04n\"}],\"clouds\":{\"all\":88},\"wind\":{\"speed\":2.86,\"deg\":322},\"snow\":{\"3h\":0},\"rain\":{\"3h\":0},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2014-12-12 12:00:00\"},{\"dt\":1418396400,\"main\":{\"temp\":-1.53,\"temp_min\":-1.53,\"temp_max\":-1.53,\"pressure\":1003.56,\"sea_level\":1024.36,\"grnd_level\":1003.56,\"humidity\":71},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":92},\"wind\":{\"speed\":2.76,\"deg\":327.502},\"snow\":{\"3h\":0},\"rain\":{\"3h\":0},\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2014-12-12 15:00:00\"},{\"dt\":1418407200,\"main\":{\"temp\":0.56,\"temp_min\":0.56,\"temp_max\":0.56,\"pressure\":1003.86,\"sea_level\":1024.39,\"grnd_level\":1003.86,\"humidity\":71},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":88},\"wind\":{\"speed\":3.31,\"deg\":327.5},\"snow\":{\"3h\":0},\"rain\":{\"3h\":0},\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2014-12-12 18:00:00\"}]}"
local seven_day_string = "{\"cod\":\"200\",\"message\":0.1754,\"city\":{\"id\":6094817,\"name\":\"Ottawa\",\"coord\":{\"lon\":-75.69812,\"lat\":45.411171},\"country\":\"CA\",\"population\":0,\"sys\":{\"population\":0}},\"cnt\":7,\"list\":[{\"dt\":1417795200,\"temp\":{\"day\":-4.76,\"min\":-4.78,\"max\":-3.87,\"night\":-3.87,\"eve\":-4.24,\"morn\":-4.76},\"pressure\":1033.47,\"humidity\":61,\"weather\":[{\"id\":600,\"main\":\"Snow\",\"description\":\"light snow\",\"icon\":\"13d\"}],\"speed\":1.61,\"deg\":101,\"clouds\":68,\"snow\":0.5},{\"dt\":1417881600,\"temp\":{\"day\":-0.62,\"min\":-3.81,\"max\":0.39,\"night\":-3.81,\"eve\":-0.61,\"morn\":-1.21},\"pressure\":1026.65,\"humidity\":99,\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],\"speed\":1.41,\"deg\":333,\"clouds\":92},{\"dt\":1417968000,\"temp\":{\"day\":-10.34,\"min\":-12.41,\"max\":-8,\"night\":-12.41,\"eve\":-8.54,\"morn\":-9.32},\"pressure\":1044.53,\"humidity\":51,\"weather\":[{\"id\":800,\"main\":\"Clear\",\"description\":\"sky is clear\",\"icon\":\"01d\"}],\"speed\":2.16,\"deg\":5,\"clouds\":0},{\"dt\":1418054400,\"temp\":{\"day\":-10.63,\"min\":-13.12,\"max\":-3.94,\"night\":-3.94,\"eve\":-5.94,\"morn\":-13.12},\"pressure\":1040.64,\"humidity\":55,\"weather\":[{\"id\":802,\"main\":\"Clouds\",\"description\":\"scattered clouds\",\"icon\":\"03d\"}],\"speed\":2.12,\"deg\":79,\"clouds\":48},{\"dt\":1418140800,\"temp\":{\"day\":-1.13,\"min\":-3.3,\"max\":1.6,\"night\":1.6,\"eve\":0.28,\"morn\":-3.3},\"pressure\":1024.08,\"humidity\":0,\"weather\":[{\"id\":601,\"main\":\"Snow\",\"description\":\"snow\",\"icon\":\"13d\"}],\"speed\":3.66,\"deg\":59,\"clouds\":100,\"rain\":21.4,\"snow\":4.33},{\"dt\":1418227200,\"temp\":{\"day\":3.61,\"min\":2.87,\"max\":6.02,\"night\":6.02,\"eve\":5,\"morn\":2.87},\"pressure\":1002.99,\"humidity\":0,\"weather\":[{\"id\":502,\"main\":\"Rain\",\"description\":\"heavy intensity rain\",\"icon\":\"10d\"}],\"speed\":4.31,\"deg\":51,\"clouds\":100,\"rain\":23.4},{\"dt\":1418313600,\"temp\":{\"day\":5.52,\"min\":2.06,\"max\":5.52,\"night\":2.06,\"eve\":4.13,\"morn\":3.88},\"pressure\":1001.4,\"humidity\":0,\"weather\":[{\"id\":800,\"main\":\"Clear\",\"description\":\"sky is clear\",\"icon\":\"01d\"}],\"speed\":1.77,\"deg\":239,\"clouds\":85,\"rain\":3.4,\"snow\":0}]}"

if myenv.target_os  == "android"  or myenv.target_os  == "macos"  or myenv.target_os  == "win32" then
  package.path = gre.SCRIPT_ROOT .. "/" .. myenv.target_os .. "-" .. myenv.target_cpu .."/?.lua;"..package.path
  if myenv.target_os  == "win32" then
    package.cpath = gre.SCRIPT_ROOT .. "/" .. myenv.target_os .. "-" .. myenv.target_cpu .."/?.dll;"..package.cpath
  else
    package.cpath = gre.SCRIPT_ROOT .. "/" .. myenv.target_os .. "-" .. myenv.target_cpu .."/?.so;"..package.cpath
  end
  http = require("socket.http")
end

function app_init(mapargs)
  print("app init")
  
  getting_weather = 1
  gre.timer_set_timeout(app_timeout,10000)
  
  gre.thread_create(app_get_weather)
end

function app_get_weather()

    local url_current = string.format("http://api.openweathermap.org/data/2.5/weather?q=%s&units=metric",ACTIVE_CITY)
    local url_5day = string.format("http://api.openweathermap.org/data/2.5/forecast/daily?q=%s&cnt=7&mode=json&units=metric",ACTIVE_CITY)  
    local url_12hour = string.format("http://api.openweathermap.org/data/2.5/forecast/hourly?q=%s&cnt=12&mode=json&units=metric",ACTIVE_CITY)
    
    b, c, h = http.request(url_current)
    TODAY = json.decode(b)
    
    print(b)
    
    b, c, h = http.request(url_5day)
    SEVEN_DAY = json.decode(b)
    
    b, c, h = http.request(url_12hour)
    TWELVE_HOUR = json.decode(b)
    
    local data = {}
    data["information.city.text"] = ACTIVE_CITY
    data["information.date.text"] = os.date("%b %d, %H:%M")
    gre.set_data(data)
    
    loading_anim_active = 0
    getting_weather = 0    
      
    daily_fill_weather()

end


function app_select_city(mapargs)

  ACTIVE_CITY = mapargs.city
  gre.thread_create(app_get_weather)
  
  getting_weather = 1
  gre.timer_set_timeout(app_timeout,10000)
  
  gre.animation_trigger("loading_anim")
  loading_anim_active = 1
  gre.animation_trigger("close_circle_around")

  
end

function app_loading_anim()

  if(loading_anim_active == 1)then
    gre.animation_trigger("loading_anim")
  else
    gre.animation_trigger("loading_anim_close")
  end
  
end

function app_timeout()
  local data = {}
  if(getting_weather == 1)then
    loading_anim_active = 0 
    
    
    data["inner_circle.current_temp.text"] = "--"
    data["inner_circle.high_temp.text"] = "--"
    data["inner_circle.low_temp.text"] = "--"
    data["inner_circle.description.text"] = "no connection"
    data["inner_circle.weather_icon.image"] = "images/icons/inc_50.png"  
    
    local dk_data = {}
    dk_data["active"] = 0
    
    for i=1, 5 do
    
      data["outer_circles.outer_circle_"..i.."_bg.time"] = "--:--"
      data["outer_circles.outer_circle_"..i.."_icon.image"] = "images/icons/inc_30.png"
      gre.set_control_attrs("outer_circles.outer_circle_"..i.."_bg",dk_data)
    
    end
    
    gre.set_control_attrs("navigation.Day", dk_data)
    gre.set_control_attrs("navigation.Week", dk_data)
    
    gre.set_data(data)
    
    gre.animation_trigger("open_circle_around")
 
  end 
    
end

function open_circle()
  gre.animation_trigger("open_circle_around")
end

function get_icon(id, size)
  -- need to add extreme air conditions, and storm icons
  -- codes : http://bugs.openweathermap.org/projects/api/wiki/Weather_Condition_Codes
  -- icons : http://adamwhitcroft.com/climacons/, http://www.danvierich.de/weather/
   
  --Rain Icons
  if(id > 190 and id < 550)then
    return "images/icons/rain_"..size..".png"
  elseif(id > 599 and id < 630)then
    return "images/icons/snow_"..size..".png"
  elseif(id > 700 and id < 790)then
    return "images/icons/wind_"..size..".png"  
  elseif(id > 800 and id < 805)then
    return "images/icons/clouds_"..size..".png"  
  elseif(id  == 800 or id == 951)then
    return "images/icons/sun_"..size..".png"
  elseif(id > 951 and id < 970)then
    return "images/icons/wind_"..size..".png"  
  else
    return "images/icons/clouds_"..size..".png"  
  end
   
end


