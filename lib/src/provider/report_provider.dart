import 'dart:convert';
import 'dart:io';
import 'package:latlong2/latlong.dart';
import 'package:street_report/src/api/enviroment.dart';
import 'package:street_report/src/models/report.dart';
import 'package:street_report/src/models/response_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ReportProvider {
  List<LatLng> points = [];
  String _url = Enviroment.API_STREET_REPORT;
  String _api = "/api/reports";
  BuildContext? context;
  Future? init(BuildContext context) {
    this.context = context;
  }

  Future<Stream> createWithImage(Report report, File image) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      final request = http.MultipartRequest('POST', url);
      if (image != null) {
        request.files.add(http.MultipartFile('image',
            http.ByteStream(image.openRead().cast()), await image.length(),
            filename: basename(image.path)));
      }
      request.fields['report'] = json.encode(<String, dynamic>{
        'id': report.id,
        'description': report.description,
        'address': report.address,
        'latitude': report.latitude,
        'longitude': report.longitude
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

  Future<ResponseApi> create(Report report) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(report);
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

  Future<void> fetchPointsFromAPI() async {
    try {
      final response = await http
          .get(Uri.parse(_url)); // Reemplaza 'TU_URL_API' con la URL de tu API
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        points = data.map<LatLng>((item) {
          final latitude = item['latitude'] as double;
          final longitude = item['longitude'] as double;
          return LatLng(latitude, longitude);
        }).toList();
      } else {
        // Manejo de errores
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  /*Future<ResponseApi> create(Report report) async {
    print('parametros ${report.id}');
    try {
      Uri url = Uri.http(_url, '$_api/create');
      // String bodyParams = json.encode(report); ya no me servia esta codificacion
      String bodyParams = jsonEncode(<String, dynamic>{
        'description': report.description,
        'address': report.address,
        'latitude': report.latitude,
        'longitude': report.longitude
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
  }*/
}