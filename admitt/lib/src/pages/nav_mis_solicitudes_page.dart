import 'package:admitt/src/Animations/FadeAnimation.dart';
import 'package:admitt/src/comunidad_class.dart';
import 'package:admitt/src/constants.dart';
import 'package:admitt/src/http.dart';
import 'package:admitt/src/pages/comuser_class.dart';
import 'package:admitt/src/solicitu_usuario_class.dart';
import 'package:admitt/src/solicitud_class.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/common_widget.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavMisSolicitudesPage extends StatefulWidget {
  static String tag = 'nav-mis-solicitudes-page';

  @override
  _NavMisSolicitudesPage createState() => _NavMisSolicitudesPage();
}

class _NavMisSolicitudesPage extends State<NavMisSolicitudesPage> {
  List<Solicitud> solicitudes = List<Solicitud>();
  List<SolUsuario> misVotos = [];
  bool vacio = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 1,
        backgroundColor: Colors.white,
        title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              'MIS SOLICITUDES',
              style: TextStyle(fontWeight: FontWeight.w800),
            )),
      ),
      //drawer: MenuLateral(),

      body: solicitudes.length > 0
          ? contenedorSolicitudes()
          : FadeAnimation(2,
              Center(child: commonWidget.noData('No solicitudes pendientes'))),
    );
  }

  @override
  void initState() {
    super.initState();
    _getSolicitudes();
  }

  Future _getSolicitudes() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var idUsuario = sharedPreferences.getInt("id_usuario");

    var result = await httpGet('solicitud/usuario/$idUsuario/p');
    if (result.ok) {
      //solicitudes.clear();

      var inSolicitudes = result.data as List<dynamic>;
      if (inSolicitudes.length > 0) {
        inSolicitudes.forEach((element) {
          solicitudes.add(Solicitud(
            element['id_solicitud'].toString(),
            element['descripcion_subcomunidad'].toString(),
            element['nombre_subcomunidad'].toString(),
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
            itemBuilder: (context, i) {
              return FadeAnimation(
                0.2 + (i * 0.1),
                ListTile(
                    /*trailing: Row(
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
                  ),*/
                    trailing: Container(
                      padding:
                          EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Text(
                        'PENDIENTE',
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    leading: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Material(
                          color: Colors.orange,
                          child: Container(
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.person_add,
                                size: 25,
                                color: Colors.orange[800],
                              )),
                          shape: CircleBorder(),
                        )),
                    title: Text(
                      solicitudes[i].fkSubComunidad.toUpperCase(),
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                    ),
                    subtitle: Text(solicitudes[i].descripcion)),
              );
            },
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
