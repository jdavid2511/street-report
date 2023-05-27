import 'package:street_report/src/models/response_api.dart';
import 'package:street_report/src/models/user.dart';
import 'package:street_report/src/models/entity.dart';
import 'package:street_report/src/provider/user_provider.dart';
import 'package:street_report/src/provider/entity_provider.dart';
import 'package:street_report/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';

import '../../utils/my_snackbar.dart';

class LoginController {
  BuildContext? context;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  UserProvider userProvider = UserProvider();
  EntityProvider entityProvider = EntityProvider();
  SharedPref _sharedPref = SharedPref();

  Future? init(BuildContext context) async {
    this.context = context;

    await entityProvider.init(context);
    await userProvider.init(context);

    User user = User.fromJson(await _sharedPref.read('user') ?? {});
    Entity entity = Entity.fromJson(await _sharedPref.read('entity') ?? {});

    if (user.sessionToken != null) {
      Navigator.pushNamedAndRemoveUntil(context, 'user', (route) => false);
    }
    if (entity.sessionToken != null) {
      Navigator.pushNamedAndRemoveUntil(context, 'entity', (route) => false);
    }
  }

  void goToRegisterPage() {
    Navigator.pushNamed(context!, 'register');
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      MySnackbar.show(context!, "Debes Ingresar Todos los Datos");
      return;
    }

    ResponseApi responseApi = await userProvider.login(email, password);
    ResponseApi responseApiEntiy = await entityProvider.login(email, password);

    if (responseApi.success!) {
      User user = User.fromJson(responseApi.data);

      _sharedPref.save('user', user.toJson());
      Navigator.pushNamedAndRemoveUntil(context!, 'user', (route) => false);
      //hacer el salto a la lista
    }
    if (responseApiEntiy.success!) {
      Entity entity = Entity.fromJson(responseApiEntiy.data);

      _sharedPref.save('entity', entity.toJson());
      Navigator.pushNamedAndRemoveUntil(context!, 'entity', (route) => false);
      //hacer el salto a la lista
    } else {
      MySnackbar.show(context!, responseApi.message!);
    }
  }
}
