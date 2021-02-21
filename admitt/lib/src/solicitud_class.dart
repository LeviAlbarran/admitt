import 'package:admitt/src/comunidad_class.dart';
import 'package:admitt/src/http.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Solicitud {
  String idSolicitud;
  String descripcion;
  String fkSubComunidad;
  String fkUsuario;
  int votoMaximo;
  int negativasAcumuladas;
  String estadoSolicitud;

  Solicitud(
      this.idSolicitud,
      this.descripcion,
      this.fkSubComunidad,
      this.fkUsuario,
      this.votoMaximo,
      this.negativasAcumuladas,
      this.estadoSolicitud);
}

List<Solicitud> solocitudes = [];

Future getSolicitudesSubComunidad(
    SubComunidad subcomunidad, solicitudes) async {
  var idSubComunidad = subcomunidad.idSubComunidad;
  var result = await httpGet('solicitud_comunidad/$idSubComunidad/p');
  if (result.ok) {
    solicitudes.clear();
    var inSolicitudes = result.data as List<dynamic>;
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
  }
  return solicitudes;
}

Future getSolicitudesSubComunidadUsuario(
    SubComunidad subComunidad, solicitudes) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  var idUsuario = sharedPreferences.getInt("id_usuario");
  var idSubComunidad = subComunidad.idSubComunidad;
  var result = await httpGet(
      'solicitud_subcomunidad/usuario/$idSubComunidad/$idUsuario');
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
    }
  }
  return solicitudes;
}

postSolicitud(idSubComunidad, maximo) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  var idUsuario = sharedPreferences.getInt("id_usuario");
  var nombreUsuario = sharedPreferences.getString("nombre_usuario");
  var apellidoUsuario = sharedPreferences.getString("apellido_usuario");
  var result = await httpPost("crear_solicitud", {
    "fk_subcomunidad_solicitud": idSubComunidad,
    "fk_usuario_solicitud": idUsuario,
    "voto_maximo": maximo,
    "descripcion_solicitud": nombreUsuario + ' ' + apellidoUsuario,
  });
  return result;
}

Future<void> actualizarSolicitudEstado(idSolicitud, estado) async {
  var result = await httpPut(
      'modificar_solicitud_voto/$idSolicitud', {"estado_solicitud": estado});
  if (result.ok) {}
}

Future<void> actualizarSolicitudCompleto(idSolicitud, estado, votos) async {
  var result = await httpPut('modificar_solicitud_estado/$idSolicitud',
      {"negativas_acumuladas": votos, "estado_solicitud": estado});
  if (result.ok) {}
}
