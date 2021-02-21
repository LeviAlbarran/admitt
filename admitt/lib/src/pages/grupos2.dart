import 'dart:convert';
import 'dart:math';

import 'package:admitt/src/Animations/FadeAnimation.dart';
import 'package:admitt/src/flyer_class.dart';
import 'package:admitt/src/http.dart';
import 'package:admitt/src/pages/create/add_subcomunidad_page.dart';
import 'package:admitt/src/pages/nav_home_page.dart';
import 'package:admitt/src/subcomunidad_class.dart';
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

class Grupos2 extends StatefulWidget {
  final Grupo subcomunidad;
  Grupos2({@required this.subcomunidad});

  @override
  _Grupos2State createState() => _Grupos2State(subcomunidad: subcomunidad);
}

class _Grupos2State extends State<Grupos2> {
  final Grupo subcomunidad;
  _Grupos2State({@required this.subcomunidad});
  List<Grupo> subcomunidades = [];
  List<Grupo> listSubcomunidades = [];

  Future<void> getcomunidades() async {
    subcomunidades.clear();
    listSubcomunidades.clear();
    var sharedPreferences = await SharedPreferences.getInstance();
    List<String> tokenList = sharedPreferences.getString("token").split(' ');
    List<String> token = tokenList[1].split(',');
    var idUsuario = sharedPreferences.getInt("id_usuario");
    String correo = token[0];
    var result =
        await httpGet('comunidad_service-v2/comunidad_usuario/correo/$correo/');
    if (result.ok) {
      if (this.mounted) {
        subcomunidades.clear();
        var insubcomunidades = result.data['data'] as List<dynamic>;
        if (insubcomunidades.length > 0) {
          insubcomunidades.forEach((inSubcomunidad) async {
            var resultSubcomunidad = await httpGet(
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
                  element['estado_solicitud'],
                  element['fk_comunidad'].toString(),
                  element['mostrar_contacto'].toString(),
                ));
              });
            }

            subcomunidades.add(Grupo(
                '0',
                inSubcomunidad['nombre_comunidad'],
                inSubcomunidad['descripcion_comunidad'],
                inSubcomunidad['estado_solicitud'],
                inSubcomunidad['id_comunidad'].toString(),
                inSubcomunidad['mostrar_contacto'].toString(),
                subcomunidades: _listadoSubcomunidades));
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
    if (result.ok && result.data['subcomunidades'].length > 0) {
      if (this.mounted) {
        setState(() {
          subcomunidades.clear();
          var insubcomunidades = result.data['subcomunidades'][0]
              ['subcomunidades'] as List<dynamic>;
          if (insubcomunidades.length > 0) {
            insubcomunidades.forEach((inSubcomunidad) {
              var list = inSubcomunidad['subcomunidades'] as List<dynamic>;
              List<Grupo> _listadoSubcomunidades = new List<Grupo>();
              if (list.length > 0) {
                list.forEach((element) {
                  _listadoSubcomunidades.add(Grupo(
                      element['id_subcomunidad'].toString(),
                      element['nombre_subcomunidad'],
                      element['descripcion_subcomunidad'],
                      element['estado_solicitud'],
                      element['fk_comunidad'].toString(),
                      element['mostrar_contacto'].toString()));
                });
              }

              subcomunidades.add(Grupo(
                  inSubcomunidad['id_subcomunidad'].toString(),
                  inSubcomunidad['nombre_subcomunidad'],
                  inSubcomunidad['descripcion_subcomunidad'],
                  inSubcomunidad['estado_solicitud'],
                  inSubcomunidad['fk_comunidad'].toString(),
                  inSubcomunidad['mostrar_contacto'].toString(),
                  subcomunidades: _listadoSubcomunidades));
            });
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
    subcomunidad.idComunidad == '0' ? getcomunidades() : getsubcomunidades();
    //  obtenerFlyer(subcomunidad.idSubComunidad, listSubcomunidades);
  }

  bool soloDondeSoyMiembro = false;
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Material(
          color: Colors.grey[200],
          elevation: 2,
          child: CheckboxListTile(
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
            },
          )),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            //futuro(idComunidad, _screenSize),

            _button(),

            Container(
                color: Colors.grey[200],
                child: _mostrarSwipper(widget.subcomunidad.idSubComunidad,
                    _screenSize, subcomunidad)),
          ],
        ),
      ),
    );
  }

  _button() {
    return Material(
      elevation: 1,
      child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 15, right: 10),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  child: Text(
                subcomunidad.idComunidad == '0'
                    ? 'Comunidades'.toUpperCase()
                    : 'GRUPOS2'.toUpperCase(),
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
                        if (subcomunidad.idComunidad == '0') {
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
                                        subcomunidad.idSubComunidad,
                                        subcomunidad.descripcionSubComunidad)),
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
    return SizedBox(
        height: _screenSize.height,
        child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            itemCount: subcomunidades.length,
            itemBuilder: (context, index) => Container(
                color: Colors.white,
                margin: EdgeInsets.only(top: index == 0 ? 8 : 4, bottom: 4),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(subcomunidades[index].nombreSubComunidad,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    mostrarListCard(index, _screenSize,
                        subcomunidades[index].subcomunidades),
                    SizedBox(
                      height: 20,
                    ),
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
                  ],
                )),
            separatorBuilder: (context, index) => Container()));
  }

  List<Widget> getCard(_screenSize, Grupo subcomunidadPadre, List<Grupo> list) {
    List<Widget> _arrayCard = new List<Widget>();
    _arrayCard.clear();
    if (list.length > 0) {
      _arrayCard.add(Container(width: 15));
      _arrayCard.add(FadeAnimation(
          0.3,
          cardItem(
              _screenSize,
              subcomunidadPadre,
              Grupo(
                  subcomunidadPadre.idSubComunidad,
                  subcomunidadPadre.nombreSubComunidad,
                  subcomunidadPadre.descripcionSubComunidad,
                  subcomunidadPadre.estadoSolicitud,
                  subcomunidadPadre.idComunidad,
                  subcomunidadPadre.mostrarContacto,
                  subcomunidades: subcomunidadPadre.subcomunidades))));
      var _animacion = 0.5;
      list.forEach((x) {
        var _data = FadeAnimation(
            _animacion, cardItem(_screenSize, subcomunidadPadre, x));

        _arrayCard.add(_data);
        _animacion = _animacion + 0.5;
      });
    }

    return _arrayCard;
  }

  Widget cardItem(_screenSize, Grupo subComunidadPadre, Grupo x) {
    return x.nombreSubComunidad == null ||
            ((soloDondeSoyMiembro &&
                (x.estadoSolicitud == 'p' || x.estadoSolicitud == 'n')))
        ? Container()
        : Container(
            width: _screenSize.width * 0.35,
            margin: EdgeInsets.only(right: 10),
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
                  onTap: () {
                    if (x.estadoSolicitud == 'a' || x.estadoSolicitud == null) {
                      /*Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NavHomePage(subcomunidad: x),
                          ));*/
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
                              colors: x.nombreSubComunidad ==
                                      subComunidadPadre.nombreSubComunidad
                                  ? [Colors.black, Colors.black54]
                                  : [colorRandom(), colorRandom()],
                            ),
                          ),
                          child: Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                x.nombreSubComunidad !=
                                        subComunidadPadre.nombreSubComunidad
                                    ? Container()
                                    : Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: Icon(
                                          Icons.list,
                                          color: Colors.white,
                                          size: 35,
                                        )),
                                Text(
                                  x.nombreSubComunidad ==
                                          subComunidadPadre.nombreSubComunidad
                                      ? 'TODOS'
                                      : x.nombreSubComunidad,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11),
                                )
                              ]))))),
              x.nombreSubComunidad == subComunidadPadre.nombreSubComunidad
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
                          child: InkWell(
                              onTap: () {
                                /*Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NavHomePage(
                                          subcomunidad: x, ocultarGrupo: true),
                                    ));*/
                              },
                              child: mostrarTagSolicitud(x.estadoSolicitud))),
            ]));
  }

  Widget mostrarTagSolicitud(estado) {
    return estado == 'n'
        ? Container(
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
          )
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

  Widget mostrarListCard(int i, _screenSize, List<Grupo> _subcomunidades) {
    if (_subcomunidades.isNotEmpty) {
      return Container(
          width: double.infinity,
          height: _screenSize.height * 0.13,
          child: ListView(
              scrollDirection: Axis.horizontal,
              children:
                  getCard(_screenSize, subcomunidades[i], _subcomunidades)));
    }
    return Container(
      width: double.infinity,
      height: _screenSize.height * 0.1,
      child: Align(child: Text('No hay flyer en esta categoría')),
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
