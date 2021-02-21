import 'package:admitt/src/comunidad_class.dart';
import 'package:admitt/src/constants.dart';
import 'package:admitt/src/pages/comuser_class.dart';
import 'package:admitt/src/solicitud_class.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SolicitudPage extends StatefulWidget {
  SolicitudPage({Key key}) : super(key: key);
  static String tag = 'solicitud-page';

  @override
  _SolicitudPageState createState() => _SolicitudPageState();
}

class _SolicitudPageState extends State<SolicitudPage> {
  List<Comuser> totalUser = [];
  List<Comuser> comusers = [];

  List<Solicitud> solicitudes = [];

  SharedPreferences sharedPreferences;
  @override
  Widget build(BuildContext context) {
    final SubComunidad subComunidad = ModalRoute.of(context).settings.arguments;
    getComuserUsuarios(subComunidad, totalUser);
    return Scaffold(
      appBar: BarraApp(
        titulo: subComunidad.nombreSubComunidad,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              subComunidad.descripcionSubComunidad,
              style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
            ),
            Divider(
              height: 50,
              thickness: 2,
              color: hardPink,
            ),
            _joinSubComunidad(subComunidad),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  _joinSubComunidad(SubComunidad subcomunidad) {
    //Se verifica si ya ha enviado una solicitud

    return FutureBuilder(
      builder: (context, snapshot) {
        if (comusers.isEmpty) {
          //si no hay una solicitud previa se llama a una funcion para hacer la solicitud
          return RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            onPressed: () {
              postComuserSolicitud(subcomunidad.idSubComunidad);
              postSolicitud(subcomunidad.idSubComunidad, totalUser.length);
              setState(() {});
            },
            padding: EdgeInsets.all(12),
            color: hardPink,
            child: Text('Unirte a la comunidad',
                style: TextStyle(color: Colors.white, fontSize: 17.0)),
          );
        } else {
          if (solicitudes.length > 0 &&
              solicitudes[solicitudes.length - 1].estadoSolicitud == 'p') {
            return RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0)),
              onPressed: () {},
              padding: EdgeInsets.all(12),
              color: hardGrey,
              child: Text('Aprobación pendiente',
                  style: TextStyle(color: Colors.white, fontSize: 17.0)),
            );
          }
        }
        return Column(
          children: <Widget>[
            Text(
              "Tu última solicitud fue rechazada",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0)),
              onPressed: () {
                postSolicitud(subcomunidad.idSubComunidad, totalUser.length);
                setState(() {});
              },
              padding: EdgeInsets.all(12),
              color: hardPink,
              child: Text('Reenviar solicitud',
                  style: TextStyle(color: Colors.white, fontSize: 17.0)),
            ),
          ],
        );
      },
      future: _obtenerdatos(subcomunidad, comusers, solicitudes),
    );
  }

  _obtenerdatos(SubComunidad subComunidad, comusers, solicitudes) async {
    await getComuserPertenece(subComunidad.idSubComunidad, comusers);

    await getSolicitudesSubComunidadUsuario(subComunidad, solicitudes);
  }
}
