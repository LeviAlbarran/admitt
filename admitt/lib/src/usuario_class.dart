import 'package:shared_preferences/shared_preferences.dart';
import 'package:admitt/src/http.dart';

class Usuario {
  String idUsuario;
  String nombreUsuario;
  String apellidoUsuario;
  String correoUsuario;
  String telefonoUsuario;
  String premiumUsuario;
  String usuarioConfirmado;
  String contrasenaUsuario;
  String codigoUsuario;
  String mostrarContacto;

  Usuario(
      this.idUsuario,
      this.nombreUsuario,
      this.apellidoUsuario,
      this.correoUsuario,
      this.telefonoUsuario,
      this.premiumUsuario,
      this.usuarioConfirmado,
      this.contrasenaUsuario,
      this.codigoUsuario,
      {this.mostrarContacto});
}

List<Usuario> usuarios = [];
SharedPreferences sharedPreferences;

Future getUsuarioData(usuarios) async {
  sharedPreferences = await SharedPreferences.getInstance();

  if (sharedPreferences.getString("token") != null) {
    List<String> tokenList = sharedPreferences.getString("token").split(' ');
    List<String> token = tokenList[1].split(',');
    String correo = token[0];

    var result = await httpGet('usuarios/correo/$correo');
    if (result.ok) {
      usuarios.clear();
      var inUsuarios = result.data as List<dynamic>;
      inUsuarios.forEach((inUsuario) {
        usuarios.add(Usuario(
            inUsuario['id_usuario'].toString(),
            inUsuario['nombre_usuario'],
            inUsuario['apellido_usuario'],
            inUsuario['correo_usuario'],
            inUsuario['telefono_usuario'],
            inUsuario['premium_usuario'].toString(),
            inUsuario['usuario_confirmado'].toString(),
            inUsuario['contrasena_usuario'],
            inUsuario['codigo_usuario']));
      });
      if (inUsuarios.isNotEmpty) {
        sharedPreferences.setInt("id_usuario", inUsuarios[0]['id_usuario']);
        sharedPreferences.setString(
            "nombre_usuario", inUsuarios[0]['nombre_usuario']);
        sharedPreferences.setString(
            "apellido_usuario", inUsuarios[0]['apellido_usuario']);
        sharedPreferences.setString(
            "correo_usuario", inUsuarios[0]['correo_usuario']);
        sharedPreferences.setString(
            "telefono_usuario", inUsuarios[0]['telefono_usuario']);
        sharedPreferences.setString(
            "premium_usuario", inUsuarios[0]['premium_usuario'].toString());
        sharedPreferences.setString("usuario_confirmado",
            inUsuarios[0]['usuario_confirmado'].toString());
        sharedPreferences.setString(
            "contrasena_usuario", inUsuarios[0]['contrasena_usuario']);
        sharedPreferences.setString(
            "contrasena_usuario", inUsuarios[0]['codigo_usuario']);
      } else {
        sharedPreferences.clear();
        await httpGet("logout");
      }
    }
  }
  return usuarios;
}
