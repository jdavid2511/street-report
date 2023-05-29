import 'package:street_report/src/screens/login/login_controller.dart';
import 'package:street_report/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController _con = new LoginController();

  @override
  void initState() {
    // TODO: implement initState
    _con.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _lottieAnimation(),
                  //
                  _textFieldEmail(),
                  //
                  _textFieldPassword(),
                  //
                  _buttonLogin(),
                  //
                  _textDontHaveAccount()
                ],
              ),
            ),
            Positioned(
              child: _circleLogin(),
              top: -100,
              left: -110,
            ),
            Positioned(
              child: _textLogin(),
              top: 50,
              left: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget _textFieldEmail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: _con.emailController,
        decoration: InputDecoration(
            hintText: 'Correo Electronico',
            hintStyle: TextStyle(color: MyColors.primaryColor),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.email,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
        decoration: BoxDecoration(
            color: MyColors.primaryOpacityColor,
            borderRadius: BorderRadius.circular(30)),
        child: TextField(
          obscureText: true,
          controller: _con.passwordController,
          decoration: InputDecoration(
              hintText: 'Contraseña',
              hintStyle: TextStyle(color: MyColors.primaryColor),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(15),
              prefixIcon: Icon(
                Icons.lock,
                color: MyColors.primaryColor,
              )),
        ));
  }

  Widget _buttonLogin() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
      child: ElevatedButton(
        onPressed: _con.login,
        child: const Text('INGRESAR',
            style: TextStyle(
              color: Colors.white,
            )),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
      ),
    );
  }

  Widget _textDontHaveAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'No tienes Cuenta',
          style: TextStyle(color: MyColors.primaryColor),
        ),
        //
        const SizedBox(
          width: 20,
        ),
        GestureDetector(
          onTap: _con.goToRegisterPage,
          child: Text('Registrate',
              style: TextStyle(
                  color: MyColors.primaryColor, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _circleLogin() {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: MyColors.primaryColor),
    );
  }

  Widget _textLogin() {
    return const Text(
      "LOGIN",
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
          fontFamily: "NinbusSans"),
    );
  }

  Widget _lottieAnimation() {
    return Container(
      margin: const EdgeInsets.only(top: 150, bottom: 30),
      child: Lottie.asset('assets/json/map.json',
          width: 350, height: 200, fit: BoxFit.fill),
    );
  }
}
