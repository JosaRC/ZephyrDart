import 'package:dart_jwt/dart_jwt.dart';
import 'package:test/expect.dart';

void main(List<String> arguments) {
  var accountId = "633f2c6b88ed2ebef97ee604";

  var accessKey =
      "OWQ2YTBkZjEtYjhiMy0zNDE0LTgzMmQtZWQzNzU4M2FkZTMxIDYzM2YyYzZiODhlZDJlYmVmOTdlZTYwNCBVU0VSX0RFRkFVTFRfTkFNRQ";

  var secretKey = "a31SmSK9aoCihzhvCc11BK26G7rxrMdBxRcu1D36dVM";

  String query = "projectId=10000&versionId=-1";

  var actionApi = "cycles/search";

  var peticion = Zephyr(secretKey, accessKey, accountId);
  //peticion.getMethod(
  //'/public/rest/api/1.0/cycles/search', 'projectId=10002&versionId=-1');

  peticion.getMethod("/public/rest/api/1.0/$actionApi", query);
  //Zephyr.getInfo2();
}
