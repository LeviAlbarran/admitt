import 'dart:convert';

import 'package:admitt/src/http.dart';
import 'package:admitt/src/pages/home_page_sv.dart';
import 'package:admitt/src/bloc/provider.dart';
import 'package:admitt/src/pages/navigator_page.dart';
import 'package:admitt/src/usuario_class.dart';
import 'package:flutter/material.dart';
import 'package:admitt/src/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController contrasenaController = TextEditingController();
  final TextEditingController correoController = TextEditingController();

  SharedPreferences sharedPreferences;

  static String tag = 'login-page';
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    Widget _createBackground(BuildContext context) {
      final size = MediaQuery.of(context).size;
      final background = Container(
        height: size.height * 0.4,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: <Color>[pink, hardPink])),
      );

      final circle = Container(
          width: 200.0,
          height: 200.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color: Color.fromRGBO(255, 255, 255, 0.3)));

      return Stack(
        children: <Widget>[
          background,
          Positioned(child: circle, top: -80.0, left: -80.0),
          Positioned(child: circle, top: 200.0, right: -80.0),
          Container(
              padding: EdgeInsets.only(top: 80.0),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                      backgroundColor: Colors.orange,
                      radius: 70.0,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/logo4.jpeg'),
                        backgroundColor: Colors.transparent,
                        radius: 65.0,
                      )),
                  SizedBox(height: 10.0, width: double.infinity)
                ],
              ))
        ],
      );
    }

    Widget alertas() {
      return AlertDialog(
        content: Text('Email o contraseña incorrecta'),
        actions: [
          FlatButton(
              child: Text("Aceptar"),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      );
    }

    List<Usuario> usuarios = [];
    login() async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      var jsonResponse;

      var result = await httpPost("login", {
        "correo_usuario": correoController.text,
        "contrasena_usuario": contrasenaController.text,
      });
      if (result.ok) {
        bool auth = result.data['auth'];
        if (!auth) {
          showDialog(
              context: context,
              builder: (_) => alertas(),
              barrierDismissible: false);
          return;
        }

        var token = result.data['token'];
        var jwt = token.split(".");
        jsonResponse =
            json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
        print('Response body: ${result.data}');
        if (jsonResponse != null) {
          sharedPreferences.setString("token", jsonResponse.toString());
          await getUsuarioData(usuarios);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => BottomNavBar()),
              (Route<dynamic> route) => false);
        }
      } else {
        showDialog(
            context: context,
            builder: (_) => alertas(),
            barrierDismissible: false);
      }
    }

    _login(BuildContext context, Loginbloc bloc) {
      print('==========================');
      print('Email   : ${bloc.email}');
      print('Password: ${bloc.password}');
      print('==========================');

      login();
    }

    Widget _createEmail(Loginbloc bloc) {
      return StreamBuilder(
          stream: bloc.emailStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: correoController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    icon: Icon(Icons.alternate_email, color: pink),
                    hintText: 'ejemplo@correo.com',
                    labelText: 'Correo electrónico',
                    labelStyle: TextStyle(color: hardGrey),
                    errorText: snapshot.error),
                onChanged: bloc.changeEmail,
              ),
            );
          });
    }

    Widget _createPassword(Loginbloc bloc) {
      return StreamBuilder(
          stream: bloc.passwordStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: contrasenaController,
                obscureText: true,
                decoration: InputDecoration(
                    icon: Icon(Icons.lock_outline, color: pink),
                    labelText: 'Contraseña',
                    labelStyle: TextStyle(color: hardGrey),
                    errorText: snapshot.error),
                onChanged: bloc.changePassword,
              ),
            );
          });
    }

    Widget _createButton(Loginbloc bloc) {
      return StreamBuilder(
          stream: bloc.formValidStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return RaisedButton(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
                child: Text('Log In',
                    style: TextStyle(color: Colors.white, fontSize: 17.0)),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              elevation: 0.0,
              color: hardPink,
              textColor: Colors.white,
              onPressed: snapshot.hasData ? () => _login(context, bloc) : null,
            );
          });
    }

    Widget _loginForm(BuildContext context) {
      final size = MediaQuery.of(context).size;
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SafeArea(
              child: Container(height: 180.0),
            ),
            Container(
              width: size.width * 0.85,
              margin: EdgeInsets.symmetric(vertical: 30.0),
              padding: EdgeInsets.symmetric(vertical: 50.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 3.0,
                        offset: Offset(0.0, 5.0),
                        spreadRadius: 3.0)
                  ]),
              child: Column(
                children: <Widget>[
                  Text('Ingreso', style: TextStyle(fontSize: 20.0)),
                  SizedBox(height: 60.0),
                  _createEmail(bloc),
                  SizedBox(height: 30.0),
                  _createPassword(bloc),
                  SizedBox(height: 30.0),
                  _createButton(bloc)
                ],
              ),
            ),
            FlatButton(
              child: Text(
                '¿No tienes una cuenta? ¡Regístrate Acá!',
                style: TextStyle(color: hardPink, fontSize: 15.0),
              ),
              onPressed: () => Navigator.pushNamed(context, 'registro-page'),
            ),
            SizedBox(height: 100.0)
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[_createBackground(context), _loginForm(context)],
      ),
    );
  }
}
