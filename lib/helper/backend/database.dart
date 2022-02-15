const SERVER_ERROR_CODE = 500;
const SUCCESS_CODE = 200;
// 200 401 404 500
// SUCESS: 200
// BAD REQUEST: 401
// NOT FOUND: 404
// INTERNAL SEVER ERROR: 500
// const endpoint = "http://192.168.0.212:9000/"; /// FOR REAL DEVICE :)
const endpoint = "http://10.0.2.2:9000/";

const ErrorCodesCustom = {
  100: "Couldn't connect to the server!",
  999: "Miscellaneous error!"
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

Map unPackLocally(Map data, {bool toPrint=true}) {
  bool receivedResponseFromServer = data["local_status"] == 200;
  Map localData = data["local_result"];

  if (receivedResponseFromServer) {
    bool dataReceivedSuccessfully = localData["status"] == 200;

    if(toPrint) print("Server responded! Status:${localData["status"]}");

    if (dataReceivedSuccessfully) {
      var requestedSuccessData = localData["data"];

      if(toPrint)
        {
          print("SUCCESS DATA:");
          print(requestedSuccessData);
          print("-----------------\n\n");
        }

      return {"success": 1, "unpacked": requestedSuccessData};
    } else {
      Map? requestFailedData = localData["data"];
      if(toPrint)
      {
        print("INCORRECT DATA:");
        print(requestFailedData);
        print("-----------------\n\n");
      }
      return {
        "success": 0,
        "unpacked": "Internal Server error!Wrong request sent!"
      };
    }
  } else {
    if(toPrint)
    {
      print(localData);
      print("Server Down! Status:$localData");
      print("-----------------\n\n");
    }

    return {"success": 0, "unpacked": "Couldn't reach the servers!"};
  }
}