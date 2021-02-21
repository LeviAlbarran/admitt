import 'package:admitt/src/comunidad_class.dart';
import 'package:admitt/src/constants.dart';
import 'package:admitt/src/http.dart';
import 'package:admitt/src/pages/comuser_class.dart';
import 'package:admitt/src/solicitu_usuario_class.dart';
import 'package:admitt/src/solicitud_class.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListaSolicitudPage extends StatefulWidget {
  SubComunidad subComunidad;
  ListaSolicitudPage({Key key, this.subComunidad}) : super(key: key);

  static String tag = 'lista-solicitud-page';

  @override
  _ListaSolicitudPage createState() => _ListaSolicitudPage();
}

class _ListaSolicitudPage extends State<ListaSolicitudPage> {
  List<Solicitud> solicitudes = List<Solicitud>();
  List<SolUsuario> misVotos = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: BarraApp(titulo: "Solicitudes pendientes"),
      drawer: MenuLateral(),
      body: solicitudes.length > 0 ? contenedorSolicitudes() : Container(),
    );
  }

  @override
  void initState() {
    super.initState();
    _getSolicitudesSubComunidadUsuario(widget.subComunidad, solicitudes);
    print(solicitudes);
  }

  Future _getSolicitudesSubComunidadUsuario(
      SubComunidad subComunidad, solicitudes) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var idUsuario = sharedPreferences.getInt("id_usuario");
    var idSubComunidad = subComunidad.idSubComunidad;
    var result = await httpGet('solicitud_subcomunidad/$idSubComunidad/p');
    if (result.ok) {
      //solicitudes.clear();
      var inSolicitudes = result.data as List<dynamic>;
      if (inSolicitudes.length > 0) {
        inSolicitudes.forEach((element) {
          solicitudes.add(Solicitud(
            element['id_solicitud'].toString(),
            element['descripcion_solicitud'].toString(),
            element['fk_subcomunidad_solicitud'].toString(),
            element['fk_usuario_solicitud'].toString(),
            element['voto_maximo'],
            element['negativas_acumuladas'],
            element['estado_solicitud'].toString(),
          ));
        });

        setState(() {});
      }
    }
    return solicitudes;
  }

  contenedorSolicitudes() {
    return Column(
      children: <Widget>[
        ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: solicitudes?.length,
            itemBuilder: (context, i) => ListTile(
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.thumb_up,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          aceptarSolicitud(solicitudes[i]);
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.thumb_down,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          rechazarSolicitud(solicitudes[i]);
                        }),
                  ],
                ),
                leading: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Material(
                      color: Colors.orange,
                      child: Container(
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.person_outline,
                            size: 25,
                            color: Colors.orange[800],
                          )),
                      shape: CircleBorder(),
                    )),
                title: Text(
                  solicitudes[i].descripcion.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                ),
                subtitle: Text(solicitudes[i].descripcion)),
            separatorBuilder: (context, i) => Divider(
                  height: 20,
                  color: Colors.grey,
                )),
      ],
    );
  }

  void aceptarSolicitud(Solicitud solicitud) async {
    await postSolicitudVotoSubcomunidad(solicitud, 'a');
    actualizarSolicitudEstado(solicitud.idSolicitud, 'a');
    await getSolicitudesUsuario(misVotos);

    solicitudes
        .removeWhere((element) => element.idSolicitud == solicitud.idSolicitud);

    // actualizar comunidad usuario
    actualizarComuserEstado(solicitud.fkSubComunidad, solicitud.fkUsuario, 's');
    setState(() {});
  }

  void rechazarSolicitud(Solicitud solicitud) async {
    await postSolicitudVotoSubcomunidad(solicitud, 'r');
    solicitudes
        .removeWhere((element) => element.idSolicitud == solicitud.idSolicitud);
    //acutualizar actual votos
    solicitud.negativasAcumuladas++;
    //chekear maimo
    if (solicitud.negativasAcumuladas == solicitud.votoMaximo) {
      solicitud.estadoSolicitud = "r";
    }
    //actializar solicitud
    actualizarSolicitudCompleto(solicitud.idSolicitud,
        solicitud.estadoSolicitud, solicitud.negativasAcumuladas);

    setState(() {});
  }
}
