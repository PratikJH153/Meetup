const SERVER_ERROR_CODE = 500;
const SUCCESS_CODE = 200;

// const endpoint = "http://192.168.0.212:9000/"; /// FOR REAL DEVICE :)
const endpoint = "http://10.0.2.2:9000/";

const ErrorCodesCustom  = {
  100:"Couldn't connect to the server!",
  999:"Miscellaneous error!"
};

final miscellaneousErrorMessage = {
  "flutter-caught-error": "Miscellaneous Exception",
  "message": ErrorCodesCustom[999],
  "errCode": 999 // Server connection error
};

final socketErrorMessage = {
  "flutter-caught-error": "Socket Exception",
  "message": ErrorCodesCustom[100],
  "errCode": 100 // Server connection error
};
