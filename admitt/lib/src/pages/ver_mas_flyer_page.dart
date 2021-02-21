import 'dart:convert';

import 'package:admitt/src/http.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admitt/src/flyer_class.dart';
import 'package:admitt/src/categoria_class.dart';

import '../comunidad_class.dart';
import '../constants.dart';

class VerMasFlyerPage extends StatefulWidget {
  static String tag = 'ver-mas-flyer-page';
  @override
  _VerMasFlyerPageState createState() => _VerMasFlyerPageState();
}

class _VerMasFlyerPageState extends State<VerMasFlyerPage> {
  SharedPreferences sharedPreferences;
  List<Flyer> flyers = [];

  Future<void> getFlyer(idComunidad, idCategoria) async {
    var result = await httpGet(
        'subcomunidad_usuario/vermas/$idComunidad/$idCategoria/1');
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
              inflyer['nombre_comunidad'],
              inflyer['descripcion_publicacion'],
              inflyer['cantidad_comentarios'].toString(),
              inflyer['nombre_usuario'],
              inflyer['apellido_usuario'],
              inflyer['id_usuario'].toString(),
            ));
          });
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        final List<dynamic> args = ModalRoute.of(context).settings.arguments;
        var idComunidad = args[1].idComunidad;
        var idCategoria = args[0].idCategoria;
        getFlyer(idComunidad, idCategoria);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        //appBar: BarraApp(titulo: args[0].nombreCategoria),
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.grey[200],
          title: Text(
            args[0].nombreCategoria.toUpperCase(),
            style: TextStyle(fontSize: 15),
          ),
        ),
        body: ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: flyers.length,
          itemBuilder: (context, i) => InkWell(
            onTap: () => Navigator.pushNamed(
                context, 'ver-mas-flyer-detalle-page',
                arguments: flyers[i]),
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.white, width: 0)),
                  color: Colors.grey[200],
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 15, top: 15, bottom: 15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(flyers[i].nombreFlyer.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold)),
                          )),
                      Image.network(
                        "$PROTOCOL://$DOMAIN/upload/" + flyers[i].imagenFlyer,
                        fit: BoxFit.contain,
                      ),
                      Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 15, top: 15, bottom: 15),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                flyers[i].descripcionFlyer,
                                style: TextStyle(fontSize: 13.0),
                              ))),
                    ],
                  )),
            ),
          ),
          separatorBuilder: (context, i) => Divider(
            height: 0,
            thickness: 0.0,
            color: Colors.grey[200],
          ),
        ));
  }
}
