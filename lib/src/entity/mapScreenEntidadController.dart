import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../models/reportsEntity.dart';
import '../models/response_api.dart';
import '../provider/reportEntity_provider.dart';
import '../utils/my_snackbar.dart';
import '../utils/shared_pref.dart';

class MapScreenEntidadController {
  BuildContext? context;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  SharedPref _sharedPref = new SharedPref();
  ReportEntityProvider reportEntityProvider = new ReportEntityProvider();

  ReportEntity? reportEntity;
  Function? refresh;
  File? image;

  Future? init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    refresh();
  }

  void create() async {
    String description = descriptionController.text.trim();
    String address = addressController.text;
    String latitude = latitudeController.text;
    String longitude = longitudeController.text.trim();

    if (description.isEmpty || address.isEmpty) {
      MySnackbar.show(context!, 'Debes Ingresar Todos los Datos');
      return;
    }

    ReportEntity reportEntity = new ReportEntity(
      description: description,
      address: address,
      latitude: latitude,
      longitude: longitude,
    );

    ResponseApi responseApi = await reportEntityProvider.create(reportEntity);

    MySnackbar.show(context!, responseApi.message!);

    print('Respuesta: ${responseApi.toJson()} ');

    /*Stream stream = await reportProvider.createWithImage(report, image!);
    stream.listen((res) {
      // ResponseApi responseApi = await ReportProvider.create(Report);
      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      print('Respuesta: ${responseApi.toJson()} ');
      MySnackbar.show(context!, responseApi.message!);
    });*/
  }

  void logout() {
    _sharedPref.logout(context!);
  }
}
