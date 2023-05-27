import 'dart:convert';
import 'dart:io';
import 'package:street_report/src/api/enviroment.dart';
import 'package:street_report/src/models/response_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EntityProvider {
  String _url = Enviroment.API_STREET_REPORT;
  String _api = "/api/entities";
  BuildContext? context;
  Future? init(BuildContext context) {
    this.context = context;
  }


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
}
