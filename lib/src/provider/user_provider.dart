import 'dart:convert';
import 'dart:io';
import 'package:street_report/src/api/enviroment.dart';
import 'package:street_report/src/models/response_api.dart';
import 'package:street_report/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class UserProvider {
  String _url = Enviroment.API_STREET_REPORT;
  String _api = "/api/users";
  BuildContext? context;
  Future? init(BuildContext context) {
    this.context = context;
  }

  Future<Stream> createWithImage(User user, File image) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      final request = http.MultipartRequest('POST', url);
      if (image != null) {
        request.files.add(http.MultipartFile('image',
            http.ByteStream(image.openRead().cast()), await image.length(),
            filename: basename(image.path)));
      }
      request.fields['user'] = json.encode(<String, dynamic>{
        'email': user.email,
        'password': user.password,
        'name': user.name,
        'lastname': user.lastname,
        'phone': user.phone
      });
      final response = await request.send(); //Envia la peticion
      return response.stream.transform(utf8.decoder);
    } catch (e) {
      print('Error $e');
      Uri url = Uri.http(_url, '$_api/create');
      final request = http.MultipartRequest('POST', url);
      final response = await request.send(); //e
      return response.stream.transform(utf8.decoder);
    }
  }

  Future<ResponseApi> create(User user) async {
    print('parametros ${user.id}');
    try {
      Uri url = Uri.http(_url, '$_api/create');
      // String bodyParams = json.encode(user); ya no me servia esta codificacion
      String bodyParams = jsonEncode(<String, dynamic>{
        'email': user.email,
        'password': user.password,
        'name': user.name,
        'lastname': user.lastname,
        'phone': user.phone
      });

      Map<String, String> header = {'Content-type': 'application/json'};
      final res = await http.post(url, headers: header, body: bodyParams);
      final data = json.decode(res.body);

      ResponseApi responseApi = ResponseApi.fromJson(data);

      return responseApi;
    } catch (e) {
      print('Error: $e');
      Map<String, bool> header = {'error': false};
      return ResponseApi.fromJson(header);
    }
  }
/*
  Future<ResponseApi> create(User user) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(user);
      Map<String, String> header = {'Content-type': 'application/json'};
      final res = await http.post(url, headers: header, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      Map<String, bool> header = {'error': false};
      return ResponseApi.fromJson(header);
    }
  }*/

  Future<ResponseApi> login(String email, String password) async {
    try {
      Uri url = Uri.http(_url, '$_api/login');
      String bodyParams = json.encode({
        'email': email,
        'password': password
      });

      Map<String, String> header = {'Content-type': 'application/json'};
      final res = await http.post(url, headers: header, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e ');
      Map<String, bool> header = {'error': false};
      return ResponseApi.fromJson(header);
    }
  }


  Future<ResponseApi> email(String email) async {
    try {
      Uri url = Uri.http(_url, '$_api/email');
      String bodyParams = json.encode({'email': email});
      Map<String, String> header = {'Content-type': 'application/json'};
      final res = await http.post(url, headers: header, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      Map<String, bool> header = {'error': false};
      return ResponseApi.fromJson(header);
    }
  }

  Future<ResponseApi> phone(String phone) async {
    try {
      Uri url = Uri.http(_url, '$_api/phone');
      String bodyParams = json.encode({'phone': phone});
      Map<String, String> header = {'Content-type': 'application/json'};
      final res = await http.post(url, headers: header, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      Map<String, bool> header = {'error': false};
      return ResponseApi.fromJson(header);
    }
  }
}
