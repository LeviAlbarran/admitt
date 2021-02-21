import 'package:admitt/src/Animations/FadeAnimation.dart';
import 'package:admitt/src/pages/subcomunidades_page.dart';
import 'package:flutter/material.dart';

import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:admitt/src/http.dart';
import 'package:admitt/src/usuario_class.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import 'package:admitt/src/pages/comuser_class.dart';
import 'dart:core';

class UsuariosSubComunidadPage extends StatefulWidget {
  final SubComunidad subcomunidad;
  UsuariosSubComunidadPage({@required this.subcomunidad, Key key})
      : super(key: key);
  static String tag = 'usuarios-subcomunidad-page';
  @override
  _UsuariosSubComunidadPageState createState() =>
      _UsuariosSubComunidadPageState();
}

class _UsuariosSubComunidadPageState extends State<UsuariosSubComunidadPage> {
  List<Usuario> usuarios = [];

  Future<void> refreshUsuariosSubComunidad(idSubComunidad) async {
    var result =
        await httpGet('subcomunidad_usuario/subcomunidad/$idSubComunidad');
    if (result.ok) {
      if (this.mounted) {
        setState(() {
          usuarios.clear();
          var inUsuarios = result.data as List<dynamic>;
          inUsuarios.forEach((inUsuario) {
            usuarios.add(Usuario(
                inUsuario['id_usuario'].toString(),
                inUsuario['nombre_usuario'],
                inUsuario['apellido_usuario'],
                inUsuario['correo_usuario'],
                inUsuario['telefono_usuario'],
                inUsuario['premium_usuario'].toString(),
                inUsuario['usuario_confirmado'].toString(),
                inUsuario['contrasena_usuario'],
                inUsuario['codigo_usuario'],
                mostrarContacto: inUsuario['mostrar_contacto'].toString()));
          });
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    refreshUsuariosSubComunidad(null);
  }

  @override
  Widget build(BuildContext context) {
    //final SubComunidad subcomunidad = ModalRoute.of(context).settings.arguments;
    var idSubComunidad = widget.subcomunidad.idSubComunidad;
    var nombreSubComunidad = widget.subcomunidad.nombreSubComunidad;
    return futuro(idSubComunidad, nombreSubComunidad);
  }

  Widget futuro(idSubComunidad, nombreSubComunidad) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return Scaffold(
          //appBar: BarraApp(titulo: nombreSubComunidad),
          //drawer: MenuLateral(),

          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                children: <Widget>[
                  ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: usuarios.length,
                      itemBuilder: (context, i) => FadeAnimation(
                            0.2 + (i * 0.1),
                            ListTile(
                              trailing: usuarios[i].mostrarContacto != '1'
                                  ? Container(
                                      width: 30,
                                    )
                                  : Container(
                                      width: 30,
                                      margin: EdgeInsets.only(right: 10),
                                      alignment: Alignment.centerRight,
                                      child: PopupMenuButton<String>(
                                        icon: Icon(Icons.more_horiz),
                                        onSelected: (data) async {
                                          if (data == 'ENVIAR EMAIL') {
                                            final mailtoLink = Mailto(
                                              to: [usuarios[i].correoUsuario],
                                              cc: [
                                                //'cc1@example.com'
                                              ],
                                              subject:
                                                  'TE CONTACTO DESDE ADMITT',
                                              body: '',
                                            );
                                            await launch('$mailtoLink');
                                          } else {
                                            bool res =
                                                await FlutterPhoneDirectCaller
                                                    .callNumber(usuarios[i]
                                                        .telefonoUsuario);
                                          }
                                        },
                                        itemBuilder: (BuildContext context) {
                                          return [
                                            'ENVIAR EMAIL',
                                            'LLAMAR A SU TELÉFONO'
                                          ].map((choice) {
                                            return PopupMenuItem<String>(
                                                value: choice,
                                                child: Container(
                                                    child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      choice,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                )));
                                          }).toList();
                                        },
                                      ),
                                    ),
                              leading: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Material(
                                    color: Colors.orange,
                                    child: Container(
                                        padding: EdgeInsets.all(5),
                                        child: Icon(
                                          Icons.person_outline,
                                          size: 25,
                                          color: Colors.orange[800],
                                        )),
                                    shape: CircleBorder(),
                                  )),
                              title: Text(
                                (usuarios[i].nombreUsuario +
                                        ' ' +
                                        usuarios[i].apellidoUsuario)
                                    .toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 14),
                              ),
                            ),
                          ),
                      separatorBuilder: (context, i) => Divider(
                            height: 20,
                            color: Colors.grey,
                          ))
                ],
              ),
            ),
          ),
        );
      },
      future: refreshUsuariosSubComunidad(idSubComunidad),
    );
  }
}
