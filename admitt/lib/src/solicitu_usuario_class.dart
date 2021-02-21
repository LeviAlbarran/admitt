import 'package:admitt/src/http.dart';
import 'package:admitt/src/solicitud_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SolUsuario {
  String idSolicitud;
  String idUsuario;
  String voto;
  SolUsuario(this.idSolicitud, this.idUsuario, this.voto);
}

List<SolUsuario> solicitudesPropias;

Future getSolicitudesUsuario(solicitudesPropias) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  var idUsuario = sharedPreferences.getInt("id_usuario");
  var result = await httpGet('solicitud_usuario_votado/$idUsuario');
  if (result.ok) {
    solicitudesPropias.clear();
    var inSolicitudes = result.data as List<dynamic>;
    inSolicitudes.forEach((element) {
      solicitudesPropias.add(SolUsuario(
        element['fk_solicitud'].toString(),
        element['fk_usuario'].toString(),
        element['voto'].toString(),
      ));
    });
  }
  return solicitudesPropias;
}

postSolicitudVoto(idSolicitud, voto) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  var idUsuario = sharedPreferences.getInt("id_usuario");
  var result = await httpPost("crear_solicitud_usuario",
      {"fk_solicitud": idSolicitud, "fk_usuario": idUsuario, "voto": voto});
  return result;
}

postSolicitudVotoSubcomunidad(Solicitud solicitud, voto) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  var idUsuario = sharedPreferences.getInt("id_usuario");
  var result = await httpPost("crear_solicitud_usuario/subcomunidad/voto", {
    "id_solicitud": solicitud.idSolicitud,
    "id_usuario_voto": idUsuario,
    "voto": voto,
    "id_usuario_solicitud": solicitud.fkUsuario,
    "id_subcomunidad": solicitud.fkSubComunidad
  });
  return result;
}
