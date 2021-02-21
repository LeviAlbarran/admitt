import 'dart:convert';
import 'dart:math';

import 'package:admitt/src/Animations/FadeAnimation.dart';
import 'package:admitt/src/flyer_class.dart';
import 'package:admitt/src/http.dart';
import 'package:admitt/src/pages/create/add_subcomunidad_page.dart';
import 'package:admitt/src/pages/login_page.dart';
import 'package:admitt/src/pages/nav_home_page.dart';
import 'package:admitt/src/solicitud_class.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:admitt/src/usuario_class.dart';
import 'package:admitt/src/widgets/common_widget.dart';
import 'package:admitt/src/widgets/swipper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../comunidad_class.dart';
import '../constants.dart';
import 'comunidades_page.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:admitt/src/categoria_class.dart';

class Grupo {
  String idSubComunidad;
  String nombreSubComunidad;
  String descripcionSubComunidad;
  String estadoSolicitud;
  String idComunidad;
  String mostrarContacto;
  List<Grupo> subcomunidades = [];
  Grupo(
      this.idSubComunidad,
      this.nombreSubComunidad,
      this.descripcionSubComunidad,
      this.estadoSolicitud,
      this.idComunidad,
      this.mostrarContacto,
      {this.subcomunidades});
}

class Grupos extends StatefulWidget {
  final Grupo subcomunidad;
  Grupos({@required this.subcomunidad});

  @override
  _GruposState createState() => _GruposState(subcomunidad: subcomunidad);
}

class _GruposState extends State<Grupos> {
  final Grupo subcomunidad;
  _GruposState({@required this.subcomunidad});
  List<Grupo> subcomunidades = [];
  List<Grupo> listSubcomunidades = [];
  checkLoginStatus() async {
    await Future.delayed(Duration(milliseconds: 300));

    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  Future<void> getcomunidades() async {
    await checkLoginStatus();
    subcomunidades.clear();
    listSubcomunidades.clear();

    var sharedPreferences = await SharedPreferences.getInstance();

    List<String> tokenList = sharedPreferences.getString("token").split(' ');
    List<String> token = tokenList[1].split(',');
    var idUsuario = sharedPreferences.getInt("id_usuario");
    //String correo = token[0];
    var result = await httpGet(
        'comunidad_service_usuario/comunidad_usuario/id_usuario/$idUsuario');
    if (result.ok) {
      if (this.mounted) {
        subcomunidades.clear();
        var insubcomunidades = result.data['data'] as List<dynamic>;
        if (insubcomunidades.length > 0) {
          insubcomunidades.forEach((inSubcomunidad) async {
            /*var resultSubcomunidad = await httpGet(
                'subcomunidad_service-v2/comunidad_usuario/$idUsuario/' +
                    inSubcomunidad['id_comunidad'].toString() +
                    '/' +
                    widget.subcomunidad.idSubComunidad);
            var list =
                resultSubcomunidad.data['subcomunidades'] as List<dynamic>;
            List<Grupo> _listadoSubcomunidades = new List<Grupo>();
            if (list.length > 0) {
              list.forEach((element) {
                _listadoSubcomunidades.add(Grupo(
                  element['id_subcomunidad'].toString(),
                  element['nombre_subcomunidad'],
                  element['descripcion_subcomunidad'],
                  element[''],
                  element['fk_comunidad'].toString(),
                  element['mostrar_contacto'].toString(),
                ));
              });
            }*/

            subcomunidades.add(Grupo(
              '0',
              inSubcomunidad['nombre_comunidad'],
              inSubcomunidad['descripcion_comunidad'],
              inSubcomunidad['estado_solicitud'],
              inSubcomunidad['id_comunidad'].toString(),
              inSubcomunidad['mostrar_contacto'].toString(),
              //subcomunidades: _listadoSubcomunidades
            ));
          });
          await new Future.delayed(const Duration(milliseconds: 300));
          setState(() {});
        }
      }
    }
  }

  Future<void> getsubcomunidades() async {
    subcomunidades.clear();
    listSubcomunidades.clear();
    var sharedPreferences = await SharedPreferences.getInstance();

    var idUsuario = sharedPreferences.getInt("id_usuario");
    var result = await httpGet(
        'subcomunidad_service-v2/comunidad_usuario/$idUsuario/' +
            widget.subcomunidad.idComunidad +
            '/' +
            widget.subcomunidad.idSubComunidad);
    if (result.ok && result.data.length > 0) {
      if (this.mounted) {
        setState(() {
          subcomunidades.clear();
          /*var insubcomunidades = widget.subcomunidad.idComunidad != '0'
              ? result.data['subcomunidades'][0]['subcomunidades']
              : result.data['subcomunidades'] as List<dynamic>;*/
          var insubcomunidades = result.data['data'] as List<dynamic>;
          if (insubcomunidades.length > 0) {
            insubcomunidades.forEach((inSubcomunidad) {
              if (inSubcomunidad['nombre_subcomunidad'] != null) {
                subcomunidades.add(Grupo(
                  inSubcomunidad['id_subcomunidad'].toString(),
                  inSubcomunidad['nombre_subcomunidad'],
                  inSubcomunidad['descripcion_subcomunidad'],
                  inSubcomunidad['estado_solicitud'],
                  inSubcomunidad['fk_comunidad'].toString(),
                  inSubcomunidad['mostrar_contacto'].toString(),
                ));
              }
            });

            print(insubcomunidades);
          }
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    subcomunidades.clear();
    listSubcomunidades.clear();
    subcomunidad.idComunidad == '0' && subcomunidad.idSubComunidad == '0'
        ? getcomunidades()
        : getsubcomunidades();
    //  obtenerFlyer(subcomunidad.idSubComunidad, listSubcomunidades);
  }

  bool soloDondeSoyMiembro = false;
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar:
          /* widget.subcomunidad.idComunidad == '0' &&
              widget.subcomunidad.idSubComunidad == '0'*/
          false
              ? Material()
              : Material(
                  color: Colors.grey[200],
                  elevation: 2,
                  child: FadeAnimation(
                      0.2,
                      CheckboxListTile(
                        title: Text(
                          "Solo donde soy miembro",
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ), //    <-- label
                        value: soloDondeSoyMiembro,
                        onChanged: (newValue) {
                          setState(() {
                            if (newValue) {
                              soloDondeSoyMiembro = true;
                            } else {
                              soloDondeSoyMiembro = false;
                            }
                          });
                          setState(() {});
                        },
                      ))),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //futuro(idComunidad, _screenSize),

            _button(),
            Container(
                padding:
                    EdgeInsets.only(top: 10, bottom: 0, left: 10, right: 10),
                width: MediaQuery.of(context).size.width,
                color: Colors.grey[200],
                child: commonWidget.breadcrumb()),
            Container(
                padding: EdgeInsets.only(top: 5),
                color: Colors.grey[200],
                child: _mostrarSwipper(widget.subcomunidad.idSubComunidad,
                    _screenSize, subcomunidad)),
          ],
        ),
      ),
    );
  }

  _button() {
    return FadeAnimation(
      0.2,
      Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 15, right: 10),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  child: Text(
                subcomunidad.idComunidad == '0' &&
                        subcomunidad.idSubComunidad == '0'
                    ? 'Comunidades'.toUpperCase()
                    : 'GRUPOS'.toUpperCase(),
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w400),
              )),
              Container(
                  margin: EdgeInsets.only(right: 10, top: 5, bottom: 5),
                  child: RaisedButton(
                      child: Text("AGREGAR",
                          style:
                              TextStyle(color: Colors.white, fontSize: 10.0)),
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0)),
                      onPressed: () async {
                        if (subcomunidad.idComunidad == '0' &&
                            subcomunidad.idSubComunidad == '0') {
                          await Navigator.pushNamed(
                              context, 'add-comunidad-page',
                              arguments: subcomunidad);
                          setState(() {
                            getcomunidades();
                          });
                        } else {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddSubComunidadPage(
                                    subcomunidad: SubComunidad(
                                  subcomunidad.idSubComunidad,
                                  subcomunidad.nombreSubComunidad,
                                  subcomunidad.descripcionSubComunidad,
                                  subcomunidad.idComunidad,
                                )),
                              ));
                          setState(() {
                            getsubcomunidades();
                          });
                        }
                      }))
            ],
          )),
    );
  }

  _mostrarSwipper(idSubComunidad, _screenSize, subcomunidad) {
    List<Grupo> _subcomunidades = List<Grupo>();

    if (soloDondeSoyMiembro) {
      if (widget.subcomunidad.idComunidad == '0') {
        _subcomunidades =
            subcomunidades.where((i) => i.estadoSolicitud == 'a').toList();
      }

      if (widget.subcomunidad.idComunidad != '0') {
        _subcomunidades = subcomunidades
            .where((i) =>
                i.estadoSolicitud != 'p' &&
                i.estadoSolicitud != 'n' &&
                i.estadoSolicitud != null)
            .toList();
      }
    } else {
      _subcomunidades = subcomunidades;
    }

    return SizedBox(
        height: _screenSize.height,
        child: GridView.builder(
            shrinkWrap: false,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 3.5),
            ),
            itemCount: _subcomunidades.length,
            itemBuilder: (context, index) {
              //color: Colors.white,
              //margin: EdgeInsets.only(top: index == 0 ? 8 : 4, bottom: 4),

              return FadeAnimation(
                  0.3 + (index * 0.1),
                  Container(
                      margin: EdgeInsets.only(
                          top: 10, bottom: 10, left: 10, right: 10),
                      child: cardItem(
                        _screenSize,
                        _subcomunidades[index],
                      )));

              /*FlatButton(
                      child: Text(
                        'Ver todos +',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () => Navigator.pushNamed(
                          context, 'ver-mas-flyer-page',
                          arguments: [subcomunidades[index], subcomunidad]),
                      color: Colors.transparent,
                    ),*/
            }));
  }

  Widget cardItem(_screenSize, Grupo x) {
    return Container(
        width: _screenSize.width * 0.40,
        height: 100,
        //margin: EdgeInsets.only(right: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Stack(children: <Widget>[
          InkWell(
              onTap: () async {
                if (x.idSubComunidad == '0' || x.estadoSolicitud == 'a') {
                  commonWidget.breadcrumbData.add(SubComunidad(
                      x.idSubComunidad,
                      x.nombreSubComunidad,
                      x.descripcionSubComunidad,
                      x.idComunidad));
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavHomePage(subcomunidad: x),
                      ));
                  commonWidget.breadcrumbData.removeWhere(
                      (item) => item.idSubComunidad == x.idSubComunidad);
                }
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          end: Alignment.topRight,
                          begin: Alignment.bottomLeft,
                          colors: [colorRandom(), colorRandom()],
                        ),
                      ),
                      child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            /* x.nombreSubComunidad == x.nombreSubComunidad
                                ? Container()
                                : Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Icon(
                                      Icons.list,
                                      color: Colors.white,
                                      size: 35,
                                    )),*/
                            Text(
                              x.nombreSubComunidad.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11),
                            )
                          ]))))),
          widget.subcomunidad.idComunidad == '0' &&
                  subcomunidad.idSubComunidad == '0'
              ? Container()
              : x.estadoSolicitud == 'a'
                  ? new Positioned(
                      right: 0.0,
                      bottom: 0.0,
                      child: RawMaterialButton(
                        constraints: const BoxConstraints(
                            minWidth: 25.0, minHeight: 25.0),
                        onPressed: () {},
                        elevation: 2.0,
                        fillColor: Colors.white,
                        child: Icon(
                          Icons.arrow_forward,
                          size: 16.0,
                        ),
                        padding: EdgeInsets.all(0),
                        shape: CircleBorder(),
                      ))
                  : new Positioned(
                      right: 10.0,
                      bottom: 10.0,
                      child: mostrarTagSolicitud(x, x.estadoSolicitud)),
        ]));
  }

  Widget mostrarTagSolicitud(x, estado) {
    return estado == 'n' || estado == null
        ? InkWell(
            onTap: () async {
              await postSolicitud(x.idSubComunidad, '0');
              setState(() {
                x.estadoSolicitud = 'p';
              });
            },
            child: Container(
              padding: EdgeInsets.only(left: 12, right: 12, top: 3, bottom: 3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: Text(
                  'Solicitar'.toUpperCase(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 9,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ))
        : Container(
            padding: EdgeInsets.only(left: 12, right: 12, top: 3, bottom: 3),
            decoration: BoxDecoration(
              color: Colors.yellow[700],
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Text(
                'Pendiente'.toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700),
              ),
            ),
          );
  }

  Color colorRandom() {
    List<Color> hexColor = [
      Colors.blue,
      Colors.blueGrey,
      Colors.blueAccent,
      Colors.lightBlue,
      Colors.lightBlueAccent,
      Colors.orange,
      Colors.orangeAccent,
      Colors.deepOrange,
      Colors.deepOrangeAccent,
      Colors.black87
    ];

    final _random = Random();
    return hexColor[_random.nextInt(hexColor.length - 1)];
  }

  buscarFlyer(idSubComunidad) async {
    await obtenerFlyer(idSubComunidad, listSubcomunidades);
  }
}
