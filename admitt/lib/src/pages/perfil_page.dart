import 'dart:ui';

import 'package:admitt/src/Animations/FadeAnimation.dart';
import 'package:admitt/src/constants.dart';
import 'package:admitt/src/http.dart';
import 'package:admitt/src/pages/tabs/contacto_page.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:admitt/src/usuario_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilPage extends StatelessWidget {
  static String tag = 'perfil-page';
  @override
  Widget build(BuildContext context) {
    return futuro();
  }

  logout(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    await httpGet("logout");
    Navigator.pushNamed(context, 'login-page');
  }

  Widget futuro() {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container();
        } else {
          return Scaffold(
            //appBar: BarraApp(titulo: 'Mi Perfil'),
            //drawer: MenuLateral(),
            body: SingleChildScrollView(
              child: Container(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                              Colors.grey[100],
                              Colors.white,
                              Colors.grey[100],
                            ])
                            /*image: DecorationImage(
                            image: AssetImage('assets/images/fondo.jpg'),
                            fit: BoxFit.fill,
                          ),*/
                            //shape: BoxShape.circle,
                            ),
                        child: Column(children: [
                          SizedBox(height: 40.0),
                          FlatButton(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('CERRAR SESIÓN ',
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 12)),
                                    /*Icon(
                                      Icons.exit_to_app,
                                      color: Colors.blue,
                                      size: 17,
                                    )*/
                                  ]),
                              onPressed: () {
                                logout(context);
                              }),
                          Container(
                              margin: EdgeInsets.only(top: 0),
                              child: Material(
                                color: Colors.blue[300],
                                child: Container(
                                    padding: EdgeInsets.all(13),
                                    child: Icon(
                                      Icons.person_outline,
                                      size: 60,
                                      color: Colors.blue[600],
                                    )),
                                shape: CircleBorder(),
                              )),
                          SizedBox(height: 35.0),
                        ]),
                      ),
                      Divider(
                          color: Colors.grey[300], height: 0, thickness: 1.2),
                      Container(
                          color: Colors.grey[200],
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  color: Colors.black87,
                                ),
                                Text(
                                  '  Nombre'.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                )
                              ])),
                      Divider(
                          color: Colors.grey[300], height: 0, thickness: 1.2),
                      FadeAnimation(
                        0.2,
                        Container(
                          margin: EdgeInsets.all(20),
                          child: Text(usuarios[0].nombreUsuario +
                              ' ' +
                              usuarios[0].apellidoUsuario),
                        ),
                      ),
                      Divider(
                          color: Colors.grey[300], height: 0, thickness: 1.2),
                      Container(
                          color: Colors.grey[200],
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.mail_outline,
                                color: Colors.black87,
                              ),
                              Text(
                                '  Correo'.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600),
                              )
                            ],
                          )),
                      Divider(
                          color: Colors.grey[300], height: 0, thickness: 1.2),
                      FadeAnimation(
                        0.2,
                        Container(
                            margin: EdgeInsets.all(20),
                            child: Text(usuarios[0].correoUsuario)),
                      ),
                      Divider(
                          color: Colors.grey[300], height: 0, thickness: 1.2),
                      Container(
                          color: Colors.grey[200],
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.phone,
                                  color: Colors.black87,
                                ),
                                Text('  Teléfono'.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600))
                              ])),
                      Divider(
                          color: Colors.grey[300], height: 0, thickness: 1.2),
                      FadeAnimation(
                        0.2,
                        Container(
                            margin: EdgeInsets.all(20),
                            child: Text(usuarios[0].telefonoUsuario)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
      future: getUsuarioData(usuarios),
    );
  }
}
