import 'dart:convert';
import 'dart:io';

import 'package:street_report/src/models/response_api.dart';
import 'package:street_report/src/models/user.dart';
import 'package:street_report/src/provider/user_provider.dart';
import 'package:street_report/src/utils/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../../utils/my_colors.dart';

class RegisterController {
  BuildContext? context;
  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController confirmPassController = new TextEditingController();
  UserProvider userProvider = new UserProvider();

  PickedFile? pickedFile;
  File? imageFile;
  Function? refresh;
  ProgressDialog? _progressDialog;
  bool? isEnable = true;

  Future? init(BuildContext context, Function refresh) {
    this.context = context;
    this.refresh = refresh;
    userProvider.init(context);
    _progressDialog = ProgressDialog(context: context);
  }

  void register() async {
    String email = emailController.text.trim();
    String name = nameController.text;
    String lastName = lastNameController.text;
    String phone = phoneController.text.trim();
    String pass = passController.text.trim();
    String confirmPass = confirmPassController.text.trim();

    if (email.isEmpty ||
        name.isEmpty ||
        lastName.isEmpty ||
        phone.isEmpty ||
        pass.isEmpty ||
        confirmPass.isEmpty) {
      MySnackbar.show(context!, 'Debes Ingresar Todos los Datos');
      return;
    }

    if (pass != confirmPass) {
      MySnackbar.show(context!, 'Las Contraseñas no coinciden');
      return;
    }

    if (pass.length < 4) {
      MySnackbar.show(context!, 'Las Contraseña tiene menos de 4 Digitos');
      return;
    }

    User user = new User(
        email: email,
        password: pass,
        name: name,
        lastname: lastName,
        phone: phone);

    ResponseApi responseApi = await userProvider.create(user);

    MySnackbar.show(context!, responseApi.message!);

    if (responseApi.success!) {
      Future.delayed(Duration(seconds: 4), () {
        Navigator.pushReplacementNamed(context!, 'login');
      });
    }

    print('Respuesta: ${responseApi.toJson()} ');
  }

  void back() {
    Navigator.pop(context!);
  }
}

