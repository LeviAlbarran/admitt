import 'dart:convert';

import 'package:admitt/src/Animations/FadeAnimation.dart';
import 'package:admitt/src/http.dart';
import 'package:admitt/src/pages/create/add_comentario.dart';
import 'package:admitt/src/pages/flyer_detalle_page.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/common_widget.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admitt/src/flyer_class.dart';

import '../constants.dart';

class MisFlyerPage extends StatefulWidget {
  String tipoPublicacion;
  MisFlyerPage({this.tipoPublicacion});
  static String tag = 'mis-flyer-page';
  @override
  _MisFlyerPageState createState() => _MisFlyerPageState();
}

class _MisFlyerPageState extends State<MisFlyerPage> {
  SharedPreferences sharedPreferences;
  List<Flyer> flyers = [];
  String response = "";

  Future<void> getFlyer() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var idUsuario = sharedPreferences.getInt("id_usuario");
    var result = await httpGet(
        'subcomunidad_usuario/flyers/$idUsuario/' + widget.tipoPublicacion);
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
              fecha: inflyer['fecha'],
            ));
          });
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getFlyer();
  }

  botonesAccion(element) {
    return Container(
      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 35,
            child: _verComentarios(element),
          ),
          Flexible(
              child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.grey, width: 0)),
            color: Colors.grey[200],
            child: Container(
              margin: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
              child: Text(
                element.nombreSubComunidad.toString().toUpperCase(),
                //maxLines: 1,
                overflow: TextOverflow.fade,
                style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold),
              ),
            ),
          ))
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

  void seleccionAccion(String choice, flyer) async {
    if (choice == 'ELIMINAR') {
      showDialog(
          context: context,
          builder: (_) => alertaEliminar(flyer.idFlyer),
          barrierDismissible: false);
    } else {
      await Navigator.pushNamed(context, 'modificar-flyer-page',
          arguments: flyer);
      setState(() {
        getFlyer();
      });
    }
  }

  Widget alerta() {
    return AlertDialog(
      title: Text('Flyer Eliminado'),
      content: Text('El Flyer fue eliminado!'),
      actions: [
        FlatButton(
            child: Text("Aceptar"),
            onPressed: () {
              Navigator.pop(context);
              setState(() {});
            }),
      ],
    );
  }

  Future<void> eliminarPublicacion(idPublicacion) async {
    var result = await httpDelete('eliminar_publicacion/$idPublicacion');
    if (result.ok) {
      flyers.removeWhere((item) => item.idFlyer == idPublicacion);
      setState(() {
        response = result.data['status'];
        /*showDialog(
            context: context,
            builder: (_) => alerta(),
            barrierDismissible: false);*/
      });
      Navigator.pop(context);
    }
  }

  Widget alertaEliminar(idPublicacion) {
    return AlertDialog(
      title: Text('Eliminar Flyer'),
      content: Text('¿Está seguro que desea eliminar su flyer?'),
      actions: [
        FlatButton(
            child: Text("Eliminar"),
            onPressed: () => eliminarPublicacion(idPublicacion)),
        FlatButton(
            child: Text("Cancelar"), onPressed: () => Navigator.pop(context)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: BarraApp(titulo: 'Mis Flyers'),
        //drawer: MenuLateral(),
        backgroundColor: Colors.grey[200],
        body: flyers.length == 0
            ? Center(
                child: commonWidget.noData('No hay publicaciones disponibles'))
            : ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: flyers.length,
                itemBuilder: (context, i) => FadeAnimation(
                  0.1 + (i * 0.1),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FlyerDetallePage(
                                esEditable: true, flyer: flyers[i]),
                          ));
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: i == 0 ? 8 : 4, bottom: 4),
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
                                        color: Colors.blue[400],
                                        child: Container(
                                            padding: EdgeInsets.all(13),
                                            child: Icon(
                                              Icons.person_outline,
                                              size: 24,
                                              color: Colors.blue[700],
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
                                        flyers[i].nombreFlyer == ''
                                            ? Container()
                                            : Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    (('') +
                                                            flyers[i]
                                                                .nombreFlyer)
                                                        .toUpperCase(),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 13.0,
                                                        fontWeight:
                                                            FontWeight.w500)),
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
                                        SizedBox(
                                          height: 3.0,
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              (('') + flyers[i].fecha)
                                                  .toUpperCase(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.w500)),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    margin: EdgeInsets.only(right: 10),
                                    alignment: Alignment.centerRight,
                                    child: PopupMenuButton<String>(
                                      icon: Icon(Icons.more_horiz),
                                      onSelected: (data) {
                                        seleccionAccion(data, flyers[i]);
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return ['EDITAR', 'ELIMINAR']
                                            .map((String choice) {
                                          return PopupMenuItem<String>(
                                              value: choice,
                                              child: Container(
                                                  child: Text(choice,
                                                      style: TextStyle(
                                                          fontSize: 12))));
                                        }).toList();
                                      },
                                    ),
                                  ))
                                ]),
                            Container(
                              height: 10,
                            ),
                            flyers[i].imagenFlyer == null
                                ? Container()
                                : Image.network(
                                    "$PROTOCOL://$DOMAIN/upload/" +
                                        flyers[i].imagenFlyer,
                                    fit: BoxFit.contain,
                                  ),
                            SizedBox(
                              height: 10.0,
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
                            widget.tipoPublicacion == '2'
                                ? Divider(
                                    thickness: 1.0,
                                    color: Colors.grey[200],
                                  )
                                : Container(),
                            widget.tipoPublicacion == '2'
                                ? botonesAccion(flyers[i])
                                : Container()
                          ],
                        )),
                  ),
                ),
                separatorBuilder: (context, i) => Container(
                  height: 0,
                ),
              ));
  }
}
