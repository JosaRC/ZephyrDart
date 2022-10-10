// ignore: depend_on_referenced_packages
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:io';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class Zephyr {
  //definición de parametros
  String secretKey;
  String accessKey;
  String accountId;

  Zephyr(this.secretKey, this.accessKey,
      this.accountId); //You create a zephyr object with contains the information about your accound.

  var urlBase = "prod-api.zephyr4jiracloud.com";

  static var expireTime = 3600;

  var contextPath = "/connect";

  static var utc0 = DateTime.utc(1970, 1, 1, 0, 0, 0);

  static var issueTime = DateTime.now();

  var iat = issueTime.difference(utc0).inMilliseconds;

  var exp = issueTime
      .add(Duration(milliseconds: expireTime))
      .difference(utc0)
      .inMilliseconds;

  void getMethod(String relativePath, String queryPath) async {
    String canonicalPath = "GET&$relativePath&$queryPath";
    print("El canonical path es $canonicalPath");
    //Aquí se genera el JWT

    //Creación de diccionario en dart se llama Map
    Map<String, dynamic> values = {
      'sub': accountId,
      'qsh': getQSH(canonicalPath),
      'iss': accessKey,
      'iat': iat,
      'exp': exp
    };

    String token;

    final jwt = JWT(values);

    token = jwt.sign(SecretKey(secretKey));

    print("Signed token: $token\n");

    try {
      final jwt = JWT.verify(token, SecretKey(secretKey));
      print('Payload ${jwt.payload}');
    } on JWTExpiredError {
      print('JWT Expire');
    } on JWTError catch (ex) {
      print(ex.message);
    }
    //Aquí se realiza la petición al API
    var client = HttpClient();
    Map<String, dynamic> query = getMapQuery(queryPath);

    var url = Uri.https(urlBase, "$contextPath$relativePath", query);
    print(url);

    try {
      HttpClientRequest request = await client.getUrl(url);

      request.headers.add("Authorization", "JWT $token");
      request.headers.add("zapiAccessKey", accessKey);
      request.headers.add("User-Agent", "ZAPI");

      HttpClientResponse response = await request.close();
      // Process the response
      final stringData = await response.transform(utf8.decoder).join();
      print("Esta es la informacion: $stringData");
    } finally {
      client.close();
    }
  }

  void postMethod(String relativePath, String queryPath,
      Map<String, dynamic> bodyRequest) async {
    String canonicalPath = "POST&$relativePath&$queryPath";
    print("El canonical path es $canonicalPath");
    //Aquí se genera el JWT

    //Creación de diccionario en dart se llama Map
    Map<String, dynamic> values = {
      'sub': accountId,
      'qsh': getQSH(canonicalPath),
      'iss': accessKey,
      'iat': iat,
      'exp': exp
    };

    String token;

    final jwt = JWT(values);

    token = jwt.sign(SecretKey(secretKey));

    print("Signed token: $token\n");

    try {
      final jwt = JWT.verify(token, SecretKey(secretKey));
      print('Payload ${jwt.payload}');
    } on JWTExpiredError {
      print('JWT Expire');
    } on JWTError catch (ex) {
      print(ex.message);
    }
    //Aquí se realiza la petición al API
    var client = http.Client();
    var jsonBodyrequest = jsonEncode(bodyRequest);

    print("Este es el Json BODY: $jsonBodyrequest");

    Map<String, String> headerRequest = {
      'Authorization': 'JWT $token',
      'zapiAccessKey': accessKey,
      'User-Agent': 'ZAPI',
      'Content-Type': 'application/json'
    };
    var url = Uri.https(urlBase, "$contextPath$relativePath");

    if (queryPath.isNotEmpty) {
      Map<String, dynamic> query = getMapQuery(queryPath);
      url = Uri.https(urlBase, "$contextPath$relativePath", query);
    }
    try {
      var response =
          await client.post(url, headers: headerRequest, body: jsonBodyrequest);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } finally {
      client.close();
    }
  }

  void putMethod(String relativePath, String queryPath,
      Map<String, dynamic> bodyRequest) async {
    String canonicalPath = "PUT&$relativePath&$queryPath";
    print("El canonical path es $canonicalPath");
    //Aquí se genera el JWT

    //Creación de diccionario en dart se llama Map
    Map<String, dynamic> values = {
      'sub': accountId,
      'qsh': getQSH(canonicalPath),
      'iss': accessKey,
      'iat': iat,
      'exp': exp
    };

    String token;

    final jwt = JWT(values);

    token = jwt.sign(SecretKey(secretKey));

    print("Signed token: $token\n");

    try {
      final jwt = JWT.verify(token, SecretKey(secretKey));
      print('Payload ${jwt.payload}');
    } on JWTExpiredError {
      print('JWT Expire');
    } on JWTError catch (ex) {
      print(ex.message);
    }
    //Aquí se realiza la petición al API
    var client = http.Client();
    var jsonBodyrequest = jsonEncode(bodyRequest);

    print("Este es el Json BODY: $jsonBodyrequest");

    Map<String, String> headerRequest = {
      'Authorization': 'JWT $token',
      'zapiAccessKey': accessKey,
      'User-Agent': 'ZAPI',
      'Content-Type': 'application/json'
    };
    var url = Uri.https(urlBase, "$contextPath$relativePath");

    if (queryPath.isNotEmpty) {
      Map<String, dynamic> query = getMapQuery(queryPath);
      url = Uri.https(urlBase, "$contextPath$relativePath", query);
    }
    try {
      var response =
          await client.put(url, headers: headerRequest, body: jsonBodyrequest);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } finally {
      client.close();
    }
  }

  String getQSH(String qString) {
    var bytes = utf8.encode(qString);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Map<String, dynamic> getMapQuery(String query) {
    Map<String, dynamic> queryfinal = {};
    var separado = query.split('&');
    for (String palabra in separado) {
      var result = palabra.split('=');
      queryfinal.addAll({result[0]: result[1]});
    }
    return queryfinal;
  }

  //Propiedades del objeto

}
