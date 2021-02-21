import 'dart:convert';

import 'package:admitt/src/subcomunidad_class.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:admitt/src/flyer_class.dart';

import 'package:admitt/src/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class FlyerDetallePage extends StatefulWidget {
  Flyer flyer;
  bool esEditable;
  FlyerDetallePage({this.flyer, this.esEditable});

  static String tag = "flyer-detalle-page";
  @override
  _FlyerDetallePageState createState() => _FlyerDetallePageState();
}

class _FlyerDetallePageState extends State<FlyerDetallePage> {
  String response = "";

  Future<void> eliminarPublicacion(idPublicacion) async {
    var result = await httpDelete('eliminar_publicacion/$idPublicacion');
    if (result.ok) {
      setState(() {
        response = result.data['status'];
        showDialog(
            context: context,
            builder: (_) => alerta(),
            barrierDismissible: false);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final Flyer flyer = ModalRoute.of(context).settings.arguments;
    final _screenSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: BarraApp(titulo: widget.flyer.nombreSubComunidad),
        //drawer: MenuLateral(),
        body: SingleChildScrollView(
            child: Container(
          height: _screenSize.height,
          child: Container(

              //margin: EdgeInsets.only(top: 10, bottom: 10),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.flyer.nombreFlyer.toUpperCase(),
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child:
                        Text(('    Categoría: ') + widget.flyer.nombreCategoria,
                            style: TextStyle(
                              fontSize: 15.0,
                            )),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  widget.flyer.imagenFlyer == null
                      ? Container()
                      : Image.network(
                          "$PROTOCOL://$DOMAIN/upload/" +
                              widget.flyer.imagenFlyer,
                          fit: BoxFit.contain,
                        ),
                  SizedBox(
                    height: 13.0,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(widget.flyer.descripcionFlyer,
                            maxLines: 5,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontSize: 15.0, fontStyle: FontStyle.italic)),
                      )),
                  SizedBox(
                    height: 15.0,
                  ),
                  widget.esEditable == false
                      ? Container()
                      : Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          width: double.infinity,
                          child: RaisedButton(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 80.0, vertical: 15.0),
                              child: Text('Modificar'.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0)),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                            elevation: 0.0,
                            color: Colors.black,
                            textColor: Colors.white,
                            onPressed: () => Navigator.pushNamed(
                                context, 'modificar-flyer-page',
                                arguments: widget.flyer),
                          ),
                        ),
                  SizedBox(
                    height: 10.0,
                  ),
                  widget.esEditable == false
                      ? Container()
                      : Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          width: double.infinity,
                          child: RaisedButton(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 80.0, vertical: 15.0),
                              child: Text('Eliminar Flyer'.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0)),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                            elevation: 0.0,
                            color: Colors.red,
                            textColor: Colors.white,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) =>
                                      alertaEliminar(widget.flyer.idFlyer),
                                  barrierDismissible: false);
                            },
                          ),
                        ),
                ],
              )),
        )));
  }

  Widget alerta() {
    return AlertDialog(
      title: Text('Flyer Eliminado'),
      content: Text('El Flyer fue eliminado!'),
      actions: [
        FlatButton(
            child: Text("Volver a Mis Flyers"),
            onPressed: () => Navigator.pushNamed(context, 'flyer-page')),
      ],
    );
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
}
