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

  Future<ResponseApi> updateImage(Report report) async {
    try {
      Uri url = Uri.http(_url, '$_api/updateImage');
      //String bodyParams = json.encode(report);
      String bodyParams =
          jsonEncode(<String, dynamic>{"image": report.image, "id": report.id});
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

  Future<ResponseApi> create(Report report) async {
    print('parametros ${report.id}');
    try {
      Uri url = Uri.http(_url, '$_api/create');
      // String bodyParams = json.encode(report); ya no me servia esta codificacion
      String bodyParams = jsonEncode(<String, dynamic>{
        'id': report.id,
        'description': report.description,
        'address': report.address,
        'latitude': report.latitude,
        'longitude': report.longitude,
        'image': report.image
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

  

  /*Future<List<Report>> getAll() async {
    //replace your restFull API here.
    String url = '$_api/getAll';
    final response = await http.get(Uri.parse(url));

    var responseData = json.decode(response.body);
    
    //Creating a list to store input data;
    List<Report> reports = [];
    for (var singleReport in responseData) {
      Report report = Report(
        id: singleReport["id"],
        description: singleReport["descripcion"],
        address: singleReport["address"],
        latitude: singleReport["latitude"],
        longitude: singleReport["longitude"],
      );

      //Adding report to the list.
      reports.add(report);
    }
    print(reports);
    return reports;
  }*/
}
