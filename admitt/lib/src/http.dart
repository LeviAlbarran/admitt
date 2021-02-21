import 'dart:convert';
import 'dart:io';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

class RequestResult {
  bool ok;
  dynamic data;
  RequestResult(this.ok, this.data);
}

var status;
var token;

const PROTOCOL = "http";
const PROTOCOLIMAGE = "http";
const DOMAIN = "45.236.129.179";
const DOMAINIMAGE = "45.236.129.179";
//const DOMAINIMAGE = "192.168.1.81:3000";
//const DOMAIN = "api-admintt-backend.herokuapp.com";
//const DOMAIN = "192.168.1.81:80";
//const DOMAINIMAGE = "192.168.1.81:80";
//const DOMAIN = "127.0.0.1:3000";

Future<RequestResult> httpGet(String route, [dynamic data]) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'token';
  final value = prefs.get(key) ?? 0;
  var dataStr = jsonEncode(data);
  var url = "$PROTOCOL://$DOMAIN/$route?data=$dataStr";
  // var result = await http.get(url);
  http.Response result = await http.get(url, headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer $value'
  });

  return RequestResult(true, jsonDecode(result.body));
}

Future<RequestResult> httpPost(String route, [dynamic data]) async {
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);

  var result = await http
      .post(url, body: dataStr, headers: {"Content-Type": "application/json"});
  return RequestResult(true, jsonDecode(result.body));
}

Future<RequestResult> httpPut(String route, [dynamic data]) async {
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);

  var result = await http
      .put(url, body: dataStr, headers: {"Content-Type": "application/json"});
  return RequestResult(true, jsonDecode(result.body));
}

Future<RequestResult> httpDelete(String route, [dynamic data]) async {
  var url = "$PROTOCOL://$DOMAIN/$route";
  var result =
      await http.delete(url, headers: {"Content-Type": "application/json"});
  return RequestResult(true, jsonDecode(result.body));
}

Future<RequestResult> httpFile(String route, filename, id, nombre) async {
  var url = "$PROTOCOL://$DOMAIN/$route";
  var request = http.MultipartRequest('POST', Uri.parse(url));

  request.files.add(http.MultipartFile.fromBytes(
      'file', File(filename).readAsBytesSync(),
      filename: filename.split("/").last));

  request.fields['id'] = id;
  request.fields['nombre'] = nombre;
  var res = await request.send();
  return RequestResult(true, res);
}
