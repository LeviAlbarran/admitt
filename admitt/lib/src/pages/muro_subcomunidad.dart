import 'dart:convert';
import 'dart:ui';

import 'package:admitt/src/Animations/FadeAnimation.dart';
import 'package:admitt/src/http.dart';
import 'package:admitt/src/pages/create/add_comentario.dart';
import 'package:admitt/src/pages/create/add_publicacion.dart';
import 'package:admitt/src/pages/flyers_categorias.dart';
import 'package:admitt/src/pages/flyers_subcomunidades.dart';
import 'package:admitt/src/pages/grupos.dart';
import 'package:admitt/src/pages/home_page_sv.dart';
import 'package:admitt/src/pages/tabs/flyers_usuario_page.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/common_widget.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admitt/src/flyer_class.dart';

import '../constants.dart';

class MuroSubcomunidad extends StatefulWidget {
  final SubComunidad subcomunidad;
  MuroSubcomunidad({@required this.subcomunidad});
  static String tag = 'muro-subcomunidad-page';
  @override
  _MuroSubcomunidadState createState() => _MuroSubcomunidadState();
}

class _MuroSubcomunidadState extends State<MuroSubcomunidad> {
  SharedPreferences sharedPreferences;
  List<Flyer> flyers = [];
  List subcomunidades = [];

  Future<void> getFlyer() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var idUsuario = sharedPreferences.getInt("id_usuario");
    var result = await httpGet(
        'subcomunidad_usuario_service/publicacion/$idUsuario/2/' +
            widget.subcomunidad.idComunidad +
            '/' +
            widget.subcomunidad.idSubComunidad);
    if (result.ok && result.data != null) {
      if (this.mounted) {
        setState(() {
          flyers.clear();
          var inflyers = result.data as List<dynamic>;
          if (inflyers.length > 0) {
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
                fecha: inflyer['fecha'].toString(),
              ));
            });
          }
        });
      }
    }
  }

  Widget tabViewMuro(element) {
    return Container(
        child: Column(children: [
      widget.subcomunidad.idSubComunidad == '0'
          ? Container()
          : FadeAnimation(0.2, _getButonAgregar()),
      flyers.length == 0
          ? Expanded(
              child: FadeAnimation(
                  2,
                  Center(
                      child: commonWidget
                          .noData('No hay publicaciones disponibles'))),
            )
          : Expanded(
              child: ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: flyers.length,
              itemBuilder: (context, i) => InkWell(
                onTap: () => {},
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: FadeAnimation(
                    0.05 + (i * 0.03),
                    Container(
                        /*elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.white, width: 0)),*/
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
                                        color: Colors.blue[300],
                                        child: Container(
                                            padding: EdgeInsets.all(13),
                                            child: Icon(
                                              Icons.person_outline,
                                              size: 24,
                                              color: Colors.blue[600],
                                            )),
                                        shape: CircleBorder(),
                                      )),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
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
                                        /* Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        (('') + flyers[i].nombreFlyer)
                                            .toUpperCase(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w500)),
                                  ),*/

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
                                        SizedBox(
                                          height: 3.0,
                                        ),
                                        flyers[i].fecha == null
                                            ? Container()
                                            : Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                    (('') + flyers[i].fecha)
                                                        .toUpperCase(),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 11.0,
                                                    )),
                                              ),
                                      ],
                                    ),
                                  ),
                                ]),
                            Container(
                              height: 10,
                            ),
                            flyers[i].imagenFlyer == null
                                ? Container()
                                : Image.network(
                                    "$PROTOCOLIMAGE://$DOMAINIMAGE/upload/" +
                                        flyers[i].imagenFlyer,
                                    width:
                                        MediaQuery.of(context).size.width * 1,
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
                                        left: 10,
                                        right: 10,
                                        top: 0,
                                        bottom: 10),
                                    child: Text(
                                      flyers[i].descripcionFlyer,
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 13),
                                    )),
                            Divider(
                              thickness: 1.0,
                              color: Colors.grey[200],
                            ),
                            botonesAccion(flyers[i]),
                            //_addComentarios(flyers[i])
                          ],
                        )),
                  ),
                ),
              ),
              separatorBuilder: (context, i) => Divider(
                height: 0,
                //thickness: 1.0,
                //color: Colors.white,
              ),
            )),
    ]));
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
            child: _verMuro(element),
          ),
          Flexible(
              child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.blue, width: 0)),
            color: Colors.blue[400],
            child: Container(
              margin: EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
              child: Text(
                element.nombreSubComunidad.toString().toUpperCase(),
                //maxLines: 1,
                overflow: TextOverflow.fade,
                style: TextStyle(
                    fontSize: 9,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget _getButonAgregar() {
    return Material(
      elevation: 0,
      child: Container(
          padding: EdgeInsets.only(left: 15, right: 10),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  child: Text(
                'MURO',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
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
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddPublicacionPage(
                                  subComunidad: widget.subcomunidad),
                            ));

                        setState(() {
                          getFlyer();
                        });
                      }))
            ],
          )),
    );
  }

  _verMuro(Flyer element) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddComentarioPage(flyer: element),
            ));
        setState(() {
          getFlyer();
        });
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

  @override
  void initState() {
    super.initState();
    getFlyer();
  }

  @override
  Widget build(BuildContext context) {
    TabController _controller;
    return Scaffold(
        backgroundColor: Colors.grey[200], body: tabViewMuro('MURO'));
  }
}
