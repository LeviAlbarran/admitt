import 'dart:convert';

import 'package:admitt/src/http.dart';
import 'package:admitt/src/pages/create/add_comentario.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admitt/src/flyer_class.dart';

import '../constants.dart';

class MuroPage extends StatefulWidget {
  static String tag = 'solicitud-contacto-page';
  @override
  _MuroPageState createState() => _MuroPageState();
}

class _MuroPageState extends State<MuroPage> {
  SharedPreferences sharedPreferences;
  List<Flyer> flyers = [];
  List subcomunidades = [];
  List<Widget> subcomunidadesTabs = new List<Widget>();
  List<Widget> subcomunidadesTabsView = new List<Widget>();

  int _lengthTabs = 1;
  Future<void> getFlyer() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var idUsuario = sharedPreferences.getInt("id_usuario");
    var result = await httpGet('subcomunidad_usuario/flyers/$idUsuario/2');
    if (result.ok) {
      if (this.mounted) {
        setState(() {
          flyers.clear();
          var inflyers = result.data as List<dynamic>;
          inflyers.forEach((inflyer) {
            flyers.add(Flyer(
              inflyer['id_publicacion'].toString(),
              inflyer['titulo_publicacion'],
              inflyer['flyer_publicacion'],
              inflyer['nombre_categoria'],
              inflyer['nombre_subcomunidad'],
              inflyer['descripcion_publicacion'],
              inflyer['cantidad_comentarios'].toString(),
              inflyer['nombre_usuario'],
              inflyer['apellido_usuario'],
              inflyer['id_usuario'].toString(),
            ));
          });

          final list = flyers.map((e) => e.nombreSubComunidad).toSet();
          subcomunidades = [
            ...{...list}
          ];
          if (subcomunidades.length > 0) {
            List<Widget> arrayView = List<Widget>();
            List<Widget> arrayTab = List<Widget>();
            subcomunidadesTabs.clear();
            subcomunidadesTabsView.clear();
            arrayTab.add(Tab(
              text: 'TODOS',
            ));
            arrayView.add(tabView('TODOS'));

            subcomunidades.forEach((element) {
              arrayTab.add(Tab(text: element.toString().toUpperCase()));
              arrayView.add(tabView(element));
            });
            subcomunidadesTabs = arrayTab;
            subcomunidadesTabsView = arrayView;
            _lengthTabs = 1 + subcomunidades.length;
          }
        });
      }
    }
  }

  Widget tabView(element) {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Expanded(
            child: ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: flyers.length,
          itemBuilder: (context, i) => element != 'TODOS' &&
                  element != flyers[i].nombreSubComunidad
              ? Container()
              : InkWell(
                  onTap: () => {},
                  child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side:
                              BorderSide(color: Colors.grey[500], width: 1.8)),
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Material(
                                      color: Colors.orange,
                                      child: Container(
                                          padding: EdgeInsets.all(13),
                                          child: Icon(
                                            Icons.person_outline,
                                            size: 24,
                                            color: Colors.white,
                                          )),
                                      shape: CircleBorder(),
                                    )),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            (('') + flyers[i].nombreFlyer)
                                                .toUpperCase(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      SizedBox(
                                        height: 3.0,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                            (flyers[i].nombreUsuario +
                                                    ' ' +
                                                    flyers[i].apellidoUsuario)
                                                .toUpperCase(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                      SizedBox(
                                        height: 3.0,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                            (('Categoría: ') +
                                                    flyers[i].nombreCategoria)
                                                .toUpperCase(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12.0,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                          Divider(
                            thickness: 2.0,
                          ),
                          flyers[i].imagenFlyer == null
                              ? Container()
                              : Image.network(
                                  "$PROTOCOL://$DOMAIN/upload/" +
                                      flyers[i].imagenFlyer,
                                  width: MediaQuery.of(context).size.width * 1,
                                  height: 220,
                                  fit: BoxFit.fitWidth,
                                ),
                          SizedBox(
                            height: 13.0,
                          ),
                          flyers[i].descripcionFlyer == null
                              ? Container()
                              : Container(
                                  alignment: Alignment.bottomLeft,
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 0, bottom: 20),
                                  child: Text(
                                    flyers[i].descripcionFlyer,
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                          Divider(
                            thickness: 2.0,
                          ),
                          botonesAccion(flyers[i]),
                          //_addComentarios(flyers[i])
                        ],
                      )),
                ),
          separatorBuilder: (context, i) => Divider(
            height: 0,
            //thickness: 1.0,
            //color: Colors.white,
          ),
        )));
  }

  botonesAccion(element) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 35,
            width: MediaQuery.of(context).size.width * 0.6,
            child: _verComentarios(element),
          ),
          Container(child: Icon(Icons.phone_locked, color: Colors.grey)),
        ],
      ),
    );
  }

  _verComentarios(Flyer element) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddComentarioPage(flyer: element),
            ));
      },
      child: Container(
          margin: EdgeInsets.only(top: 10),
          width: MediaQuery.of(context).size.width * 0.6,
          child: Text(
            'Ver ' + element.cantidadComentarios + ' comentarios',
            style: TextStyle(color: Colors.grey[500]),
          )),
    );
  }

  _addComentarios(element) {
    return InkWell(
        onTap: () {},
        child: Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(children: [
              Container(
                  margin: EdgeInsets.only(left: 8, right: 10),
                  child: Material(
                    color: Colors.lightBlue,
                    child: Container(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.person_outline,
                          size: 20,
                          color: Colors.white,
                        )),
                    shape: CircleBorder(),
                  )),
              //_inputText()
            ])));
  }

  TextEditingController comentarioController = TextEditingController();

  crearComentario(idflyer) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var idUsuario = sharedPreferences.getInt("id_usuario");
    if (comentarioController.text == null || comentarioController.text == '') {
      return;
    }

    var result = await httpPost("crear_comentarios", {
      "fk_usuario": idUsuario,
      "fk_publicacion": idflyer,
      "comentario": comentarioController.text
    });
    if (result.ok) {
      if (this.mounted) {
        setState(() {
          comentarioController.text = '';
          flyers.clear();
          getFlyer();
        });
      }
    }
  }

  _inputText() {
    return Container(
        child: TextFormField(
      controller: comentarioController,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        enabled: true,
        labelText: 'Agregar comentario',
        //hintText: "Agregar comentario..",
        labelStyle: TextStyle(color: Colors.grey[500]),
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0)),
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    subcomunidadesTabs.add(Tab(
      text: 'TODOS',
    ));
    subcomunidadesTabsView.add(Container());
    getFlyer();
  }

  @override
  Widget build(BuildContext context) {
    TabController _controller;
    return DefaultTabController(
        length: _lengthTabs,
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.orange,
                bottom: TabBar(
                  controller: _controller,
                  indicatorColor: Colors.white,
                  isScrollable: true,
                  tabs: subcomunidadesTabs,
                ),
                title: Text('Muro'),
                actions: <Widget>[
                  IconButton(
                      color: white,
                      icon: Icon(Icons.message),
                      onPressed: () async {
                        Navigator.pushNamed(context, 'add-publicacion-page',
                            arguments: null);
                      })
                ]),
            drawer: MenuLateral(),
            body: TabBarView(
                controller: _controller, children: subcomunidadesTabsView)));
  }
}
