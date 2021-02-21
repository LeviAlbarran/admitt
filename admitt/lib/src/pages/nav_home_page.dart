import 'dart:convert';
import 'dart:ui';

import 'package:admitt/src/Animations/FadeAnimation.dart';
import 'package:admitt/src/comunidad_class.dart';
import 'package:admitt/src/http.dart';
import 'package:admitt/src/pages/create/add_comentario.dart';
import 'package:admitt/src/pages/create/add_comunidad_page.dart';
import 'package:admitt/src/pages/create/add_subcomunidad_page.dart';
import 'package:admitt/src/pages/flyers_categorias.dart';
import 'package:admitt/src/pages/flyers_subcomunidades.dart';
import 'package:admitt/src/pages/grupos.dart';
import 'package:admitt/src/pages/home_page_sv.dart';
import 'package:admitt/src/pages/lista_solicitudes_page.dart';
import 'package:admitt/src/pages/login_page.dart';
import 'package:admitt/src/pages/muro_subcomunidad.dart';
import 'package:admitt/src/pages/navigator_page.dart';
import 'package:admitt/src/pages/tabs/flyers_usuario_page.dart';
import 'package:admitt/src/pages/usuarios_subcomunidad_page.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:admitt/src/usuario_class.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/common_widget.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admitt/src/flyer_class.dart';

import '../constants.dart';

class NavHomePage extends StatefulWidget {
  final Grupo subcomunidad;
  final bool ocultarGrupo;
  NavHomePage({@required this.subcomunidad, this.ocultarGrupo});
  static String tag = 'nav-home-page';
  @override
  _NavHomePageState createState() => _NavHomePageState();
}

class _NavHomePageState extends State<NavHomePage> {
  List<Flyer> flyers = [];
  List subcomunidades = [];
  List<Widget> tabs = new List<Widget>();
  List<Widget> tabsView = new List<Widget>();
  var mostrarDatosDeContacto = 0;
  int _lengthTabs = 3;
  bool sePuedeEliminar = true;

  Future<void> compartirContacto() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var idUsuario = sharedPreferences.getInt("id_usuario");
    var result = await httpPost(
        'contacto/id/$idUsuario/' + widget.subcomunidad.idSubComunidad, {
      'mostrar_contacto': widget.subcomunidad.mostrarContacto == '0' ? '1' : '0'
    });
    if (result.ok) {
      if (this.mounted) {
        setState(() {
          widget.subcomunidad.mostrarContacto =
              widget.subcomunidad.mostrarContacto == '0' ? '1' : '0';
        });
      }
    }
  }

  Future<void> eliminarComunidad(idComunidad) async {
    var result = await httpDelete('eliminar_comunidad/$idComunidad');
    if (result.ok) {
      commonWidget.breadcrumbData.clear();
      new Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => BottomNavBar()),
            (Route<dynamic> route) => false);
      });
    }
  }

  Future<void> eliminarSubcomunidad(idSubComunidad) async {
    var result = await httpDelete('eliminar_subcomunidad/$idSubComunidad');
    if (result.ok) {
      commonWidget.breadcrumbData.clear();
      new Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => BottomNavBar()),
            (Route<dynamic> route) => false);
      });
    }
  }

  getCantidadComunidad() async {
    var result = await httpGet('comunidades/cantidad_subcomunidades/' +
        widget.subcomunidad.idComunidad);
    if (result.ok) {
      if (result.data['cantidad'] == 0) {
        sePuedeEliminar = true;
      } else {
        sePuedeEliminar = false;
      }
    }
  }

  getCantidadUsuarios() async {
    var result = await httpGet('subcomunidad_usuario/cantidad_usuarios/' +
        widget.subcomunidad.idComunidad);
    if (result.ok) {
      if (result.data['cantidad'] > 1) {
        sePuedeEliminar = false;
      } else {
        sePuedeEliminar = true;
      }
    }
  }

  Widget alertaEliminarSubComunidad(idSubComunidad) {
    if (sePuedeEliminar == false) {
      return AlertDialog(
        title: Text(''),
        content: Text(
            'No puede eliminar este grupo porque tiene más de un usuarios'),
        actions: [
          FlatButton(
              child: Text("Aceptar"), onPressed: () => Navigator.pop(context)),
        ],
      );
    } else {
      return AlertDialog(
        title: Text('Eliminar grupo'),
        content: Text('¿Está seguro que desea eliminar este grupo?'),
        actions: [
          FlatButton(
              child: Text("Eliminar"),
              onPressed: () => eliminarSubcomunidad(idSubComunidad)),
          FlatButton(
              child: Text("Cancelar"), onPressed: () => Navigator.pop(context)),
        ],
      );
    }
  }

  Widget alertaEliminarComunidad(idComunidad) {
    if (sePuedeEliminar == false) {
      return AlertDialog(
        title: Text(''),
        content: Text(
            'No puede eliminar esta comunidad porque tiene un grupo creado'),
        actions: [
          FlatButton(
              child: Text("Aceptar"), onPressed: () => Navigator.pop(context)),
        ],
      );
    } else {
      return AlertDialog(
        title: Text('Eliminar comunidad'),
        content: Text('¿Está seguro que desea eliminar esta comunidad?'),
        actions: [
          FlatButton(
              child: Text("Eliminar"),
              onPressed: () => eliminarComunidad(idComunidad)),
          FlatButton(
              child: Text("Cancelar"), onPressed: () => Navigator.pop(context)),
        ],
      );
    }
  }

  @override
  void initState() {
    super.initState();

    List<Widget> arrayView = List<Widget>();
    List<Widget> arrayTab = List<Widget>();
    tabs.clear();
    tabsView.clear();

    if (widget.ocultarGrupo != true) {
      arrayTab.add(FadeAnimation(
          0.1,
          Tab(
            text: widget.subcomunidad.idComunidad == '0' &&
                    widget.subcomunidad.idSubComunidad == '0'
                ? 'COMUNIDADES'
                : 'GRUPOS',
          )));
      arrayView.add(Grupos(
          subcomunidad: Grupo(
        widget.subcomunidad.idSubComunidad,
        widget.subcomunidad.nombreSubComunidad,
        widget.subcomunidad.descripcionSubComunidad,
        widget.subcomunidad.estadoSolicitud,
        widget.subcomunidad.idComunidad,
        widget.subcomunidad.mostrarContacto,
      )));
    }

    arrayTab.add(FadeAnimation(
        0.2,
        Tab(
          text: 'MURO',
        )));
    arrayView.add(MuroSubcomunidad(
        subcomunidad: SubComunidad(
            widget.subcomunidad.idSubComunidad,
            widget.subcomunidad.nombreSubComunidad,
            widget.subcomunidad.descripcionSubComunidad,
            widget.subcomunidad.idComunidad)));

    arrayTab.add(FadeAnimation(
        0.3,
        Tab(
          text: 'FLYERS',
        )));

    arrayView.add(FlyerCategorias(
        subcomunidad: SubComunidad(
            widget.subcomunidad.idSubComunidad,
            widget.subcomunidad.nombreSubComunidad,
            widget.subcomunidad.descripcionSubComunidad,
            widget.subcomunidad.idComunidad)));

    if (widget.subcomunidad.idSubComunidad != null &&
        widget.subcomunidad.idSubComunidad != '0') {
      arrayTab.add(FadeAnimation(
          0.4,
          Tab(
            text: 'MIEMBROS',
          )));

      arrayView.add(UsuariosSubComunidadPage(
          subcomunidad: SubComunidad(
              widget.subcomunidad.idSubComunidad,
              widget.subcomunidad.nombreSubComunidad,
              widget.subcomunidad.descripcionSubComunidad,
              widget.subcomunidad.idComunidad)));

      arrayTab.add(FadeAnimation(
          0.5,
          Tab(
            text: 'SOLICITUDES',
          )));

      arrayView.add(ListaSolicitudPage(
          subComunidad: SubComunidad(
              widget.subcomunidad.idSubComunidad,
              widget.subcomunidad.nombreSubComunidad,
              widget.subcomunidad.descripcionSubComunidad,
              widget.subcomunidad.idComunidad)));
    }

    tabs = arrayTab;
    tabsView = arrayView;
    _lengthTabs = arrayTab.length;
    widget.subcomunidad.idSubComunidad != null &&
            widget.subcomunidad.idSubComunidad != '0'
        ? getCantidadUsuarios()
        : getCantidadComunidad();
  }

  @override
  Widget build(BuildContext context) {
    TabController _controller;
    return DefaultTabController(
        length: _lengthTabs,
        child: Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
                centerTitle: false,
                elevation: 1,
                backgroundColor: Colors.white,
                bottom: TabBar(
                  controller: _controller,
                  indicatorColor: Colors.white,
                  isScrollable: true,
                  tabs: tabs,
                  unselectedLabelColor: Colors.black54,
                  labelColor: Colors.blue,
                ),
                title: FadeAnimation(
                    0.2,
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: widget.subcomunidad.nombreSubComunidad != 'TODOS'
                          ? Text(
                              widget.subcomunidad.nombreSubComunidad,
                              style: TextStyle(fontWeight: FontWeight.w800),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 45.0,
                              child: Image.asset('assets/logo5.png'),
                            ),
                    )),
                actions: <Widget>[
                  /*IconButton(
                      color: Colors.black,
                      icon: Icon(Icons.search),
                      onPressed: () async {
                        Navigator.pushNamed(context, 'add-publicacion-page',
                            arguments: null);
                      }),*/

                  widget.subcomunidad.idSubComunidad == '0'
                      ? widget.subcomunidad.idComunidad == '0'
                          ? Container()
                          : Container(
                              margin: EdgeInsets.only(right: 10),
                              alignment: Alignment.centerRight,
                              child: PopupMenuButton<String>(
                                icon: Icon(Icons.more_horiz),
                                onSelected: (data) async {
                                  print(data);
                                  if (data == 'EDITAR') {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddComunidadPage(
                                              editar: true,
                                              comunidad: Comunidad(
                                                  widget
                                                      .subcomunidad.idComunidad,
                                                  widget.subcomunidad
                                                      .nombreSubComunidad,
                                                  widget.subcomunidad
                                                      .descripcionSubComunidad)),
                                        ));
                                    setState(() {});
                                  }

                                  if (data == 'ELIMINAR') {
                                    showDialog(
                                        context: context,
                                        builder: (_) => alertaEliminarComunidad(
                                            widget.subcomunidad.idComunidad),
                                        barrierDismissible: false);
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return ['EDITAR', 'ELIMINAR']
                                      .map((String choice) {
                                    return PopupMenuItem<String>(
                                        value: choice,
                                        child: Container(
                                            child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              choice,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 11),
                                            )
                                          ],
                                        )));
                                  }).toList();
                                },
                              ))
                      : Container(
                          margin: EdgeInsets.only(right: 10),
                          alignment: Alignment.centerRight,
                          child: PopupMenuButton<String>(
                            icon: Icon(Icons.more_horiz),
                            onSelected: (data) async {
                              print(data);

                              if (data == 'COMPARTIR CONTACTO') {
                                compartirContacto();
                              }

                              if (data == 'ELIMINAR') {
                                showDialog(
                                    context: context,
                                    builder: (_) => alertaEliminarSubComunidad(
                                        widget.subcomunidad.idSubComunidad),
                                    barrierDismissible: false);
                              }
                              if (data == 'EDITAR') {
                                SubComunidad result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddSubComunidadPage(
                                          editar: true,
                                          subcomunidad: SubComunidad(
                                              widget
                                                  .subcomunidad.idSubComunidad,
                                              widget.subcomunidad
                                                  .nombreSubComunidad,
                                              widget.subcomunidad
                                                  .descripcionSubComunidad,
                                              widget.subcomunidad.idComunidad)),
                                    ));
                                if (result != null) {
                                  setState(() {
                                    widget.subcomunidad.nombreSubComunidad =
                                        result.nombreSubComunidad;
                                    widget.subcomunidad
                                            .descripcionSubComunidad =
                                        result.descripcionSubComunidad;
                                  });
                                }
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                'EDITAR',
                                'ELIMINAR',
                                'COMPARTIR CONTACTO',
                              ].map((String choice) {
                                return PopupMenuItem<String>(
                                    value: choice,
                                    child: Container(
                                        child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          choice,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 11),
                                        ),
                                        choice != 'COMPARTIR CONTACTO'
                                            ? Container()
                                            : widget.subcomunidad
                                                        .mostrarContacto ==
                                                    '0'
                                                ? Icon(Icons.check,
                                                    color: Colors.green)
                                                : Icon(Icons.close,
                                                    color: Colors.grey)
                                      ],
                                    )));
                              }).toList();
                            },
                          ),
                        )
                ]),
            //  drawer: MenuLateral(),
            /*drawer: Drawer(
                child: Container(
              child: Text('data'),
            )),*/
            body: TabBarView(controller: _controller, children: tabsView)));
  }
}
