import 'dart:convert';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

import 'http.dart';

class Flyer {
  String idFlyer;
  String nombreFlyer;
  String imagenFlyer;
  String nombreCategoria;
  String nombreSubComunidad;
  String descripcionFlyer;
  String cantidadComentarios;
  String nombreUsuario;
  String apellidoUsuario;
  String idUsuario;
  String fecha;
  Flyer(
      this.idFlyer,
      this.nombreFlyer,
      this.imagenFlyer,
      this.nombreCategoria,
      this.nombreSubComunidad,
      this.descripcionFlyer,
      this.cantidadComentarios,
      this.nombreUsuario,
      this.apellidoUsuario,
      this.idUsuario,
      {this.fecha});
}

class Flyer2 {
  String idFlyer;
  String nombreFlyer;
  String imagenFlyer;
  String nombreCategoria;
  String nombreSubComunidad;
  String descripcionFlyer;

  Flyer2(this.idFlyer, this.nombreFlyer, this.imagenFlyer, this.nombreCategoria,
      this.nombreSubComunidad, this.descripcionFlyer);
}

Future obtenerFlyer(idComunidad, flyers) async {
  var result =
      await httpGet('subcomunidad_usuario/flyers_swipper/$idComunidad/1');
  if (result.ok) {
    flyers.clear();
    var inflyers = result.data as List<dynamic>;
    inflyers.forEach((inflyer) {
      flyers.add(
        Flyer2(
            inflyer['id_publicacion'].toString(),
            inflyer['titulo_publicacion'],
            inflyer['flyer_publicacion'],
            inflyer['nombre_categoria'],
            inflyer['nombre_comunidad'],
            inflyer['descripcion_publicacion']),
      );
    });
  }

  return flyers;
}

Future obtenerFlyerBusqueda(idComunidad, flyers, nombreFlyer) async {
  var result =
      await httpGet('subcomunidad_usuario/flyers_swipper/$idComunidad/1');
  if (result.ok) {
    flyers.clear();
    var inflyers = result.data as List<dynamic>;
    inflyers.forEach((inflyer) {
      flyers.add(
        Flyer(
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
        ),
      );
      nombreFlyer.add(inflyer['titulo_publicacion']);
    });
  }

  return flyers;
}

Future obtenerListaFlyer(flyers) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  var idUsuario = sharedPreferences.getInt("id_usuario");
  var result = await httpGet(
      'subcomunidad_usuario/flyers_swipper_pertenece/1/$idUsuario');
  if (result.ok) {
    flyers.clear();
    var inflyers = result.data as List<dynamic>;
    inflyers.forEach((inflyer) {
      flyers.add(
        Flyer2(
            inflyer['id_publicacion'].toString(),
            inflyer['titulo_publicacion'],
            inflyer['flyer_publicacion'],
            inflyer['nombre_categoria'],
            inflyer['nombre_subcomunidad'],
            inflyer['descripcion_publicacion']),
      );
    });
  }

  return flyers;
}
