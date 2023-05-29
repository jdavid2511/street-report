import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import '../models/report.dart';
import '../models/response_api.dart';
import '../models/user.dart';
import '../provider/user_provider.dart';
import '../provider/report_provider.dart';
import '../utils/my_colors.dart';
import '../utils/my_snackbar.dart';
import '../utils/shared_pref.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:street_report/firebase_options.dart';

class MapScreenUsuarioController {
  BuildContext? context;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  SharedPref _sharedPref = new SharedPref();

  ReportProvider reportProvider = new ReportProvider();

  ImagePicker _picker = ImagePicker();
  PickedFile? pickedFile;
  User? user;
  Report? report;
  Function? refresh;
  File? image;

  Future? init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    reportProvider.init(context);
    user = User.fromJson(await _sharedPref.read('user'));
    refresh();
  }

  void create() async {
    String description = descriptionController.text.trim();
    String address = addressController.text;
    String latitude = latitudeController.text;
    String longitude = longitudeController.text.trim();

    if (description.isEmpty ||
        address.isEmpty ||
        latitude.isEmpty ||
        longitude.isEmpty) {
      MySnackbar.show(context!, 'Debe ingresar todos los datos');
      return;
    }

    Report _report = new Report(
      image: report?.image,
      description: description,
      address: address,
      latitude: latitude,
      longitude: longitude,
    );

    ResponseApi responseApi = await reportProvider.create(_report);
    MySnackbar.show(context!, responseApi.message!);
    print('Respuesta: ${responseApi.toJson()} ');
  }

  Future<List<File>> pickImage() async {
    List<File> images = [];
    try {
      var files = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );
      if (files != null && files.files.isNotEmpty) {
        for (int i = 0; i < files.files.length; i++) {
          images.add(File(files.files[i].path!));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return images;
  }

  logout(BuildContext context) {
    print("salir");
    _sharedPref.logout(context!);
  }

  reportScreen(BuildContext context){
    Navigator.pushNamedAndRemoveUntil(
          context!, 'reports/screen', (route) => false);
  }
}
