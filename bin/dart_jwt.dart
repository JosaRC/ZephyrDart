import 'package:dart_jwt/dart_jwt.dart';

void main(List<String> arguments) {
  //
  var accountId = "";

  var accessKey = "";

  var secretKey = "";

  String query = "";

  var actionApi = "execution/ddec9811-eb83-4d53-a3fb-73fc7b1da762";

  var peticion = Zephyr(secretKey, accessKey, accountId);

  var bodyrequest = {
    'status': {'id': 1},
    'projectId': 10000,
    'issueId': 10003,
    'cycleId': '4a6963ef-a4a9-471b-8e25-ce270a20bd3d',
    'versionId': -1
  };

  peticion.putMethod("/public/rest/api/1.0/$actionApi", query, bodyrequest);
}
