import 'dart:convert';

import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:admitt/src/flyer_class.dart';

import 'package:admitt/src/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class VerMasFlyerDetallePage extends StatefulWidget {
  static String tag = "ver-mas-flyer-detalle-page";
  @override
  _VerMasFlyerDetallePageState createState() => _VerMasFlyerDetallePageState();
}

class _VerMasFlyerDetallePageState extends State<VerMasFlyerDetallePage> {
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
    final Flyer flyer = ModalRoute.of(context).settings.arguments;
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: BarraApp(titulo: 'Detalle Flyer'),
        drawer: MenuLateral(),
        body: SingleChildScrollView(
            child: Container(
          height: _screenSize.height * 0.85,
          child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey[500], width: 1.8)),
              color: Colors.amber[50],
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(('   Publicación: ') + flyer.nombreFlyer,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child:
                        Text(('    Subcomunidad: ') + flyer.nombreSubComunidad,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            )),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(('    Categoría: ') + flyer.nombreCategoria,
                        style: TextStyle(
                          fontSize: 15.0,
                        )),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Divider(
                    thickness: 2.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Image.network(
                    "$PROTOCOL://$DOMAIN/upload/" + flyer.imagenFlyer,
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                  Divider(
                    thickness: 2.0,
                  ),
                  SizedBox(
                    height: 13.0,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(('    Descripción:'),
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 13.0,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(('    ') + flyer.descripcionFlyer,
                        style: TextStyle(
                            fontSize: 15.0, fontStyle: FontStyle.italic)),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Divider(
                    thickness: 2.0,
                  ),
                  SizedBox(
                    height: 11.0,
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
