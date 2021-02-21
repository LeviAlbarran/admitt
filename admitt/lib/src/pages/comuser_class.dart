import 'dart:convert';

import 'package:admitt/src/http.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:admitt/src/usuario_class.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../comunidad_class.dart';

class Comuser {
  String pkSubComunidad;
  String pkUsuario;
  int cantidadFlyer;
  int cantidadMuro;
  int cantidadDato;
  String miembroSubComunidad;

  Comuser(
    this.pkSubComunidad,
    this.pkUsuario,
    this.cantidadFlyer,
    this.cantidadMuro,
    this.cantidadDato,
    this.miembroSubComunidad,
  );
}

class Comuser2 {
  String idSubComunidad;
  String nombreComunidad;
  String descripcionComunidad;

  Comuser2(
      this.idSubComunidad, this.nombreComunidad, this.descripcionComunidad);
}

List<Comuser> comusers = [];

Future getComuser(List<Usuario> usuario, comusers) async {
  sharedPreferences = await SharedPreferences.getInstance();
  var idUsuario = usuario[0].idUsuario;
  var result = await httpGet('subcomunidad_usuario/usuario/$idUsuario');
  if (result.ok) {
    comusers.clear();
    var inComusers = result.data as List<dynamic>;
    inComusers.forEach((element) {
      comusers.add(Comuser(
        element['pk_comunidad'].toString(),
        element['pk_usuario'].toString(),
        element['cantidad_flyer'],
        element['cantidad_muro'],
        element['cantidad_dato'],
        element['miembro_comunidad'].toString(),
      ));
    });
  }
  return comusers;
}

Future getComuserUsuarios(subcomunidad, comusers) async {
  var idSubComunidad = subcomunidad.idSubComunidad;
  var result = await httpGet('comuser/usuarios/$idSubComunidad/s');
  if (result.ok) {
    comusers.clear();
    var inComusers = result.data as List<dynamic>;
    if (inComusers.length > 0) {
      inComusers.forEach((element) {
        comusers.add(Comuser(
          element['pk_subcomunidad'].toString(),
          element['pk_usuario'].toString(),
          element['cantidad_flyer'],
          element['cantidad_muro'],
          element['cantidad_dato'],
          element['miembro_comunidad'].toString(),
        ));
      });
    }
  }
  return comusers;
}

Future getComunidadUsuarioPertenece(comusers) async {
  sharedPreferences = await SharedPreferences.getInstance();
  var idUsuario = sharedPreferences.getInt('id_usuario');
  var result = await httpGet('subcomunidad_usuario/id/$idUsuario');
  if (result.ok) {
    comusers.clear();
    var inComusers = result.data as List<dynamic>;
    inComusers.forEach((element) {
      comusers.add(Comunidad(
        element['id_comunidad'].toString(),
        element['nombre_comunidad'],
        element['descripcion_comunidad'],
      ));
    });
    var s;
    s = json.encode(inComusers);
    sharedPreferences.setString("lista_comunidad", s);
  }
  return comusers;
}

Future getSubComunidadUsuarioPertenece(comusers) async {
  sharedPreferences = await SharedPreferences.getInstance();
  var idUsuario = sharedPreferences.getInt('id_usuario');
  var result = await httpGet('subcomunidad_usuario/id/$idUsuario');
  if (result.ok) {
    comusers.clear();
    var inComusers = result.data as List<dynamic>;
    inComusers.forEach((element) {
      comusers.add(SubComunidad(
          element['id_subcomunidad'].toString(),
          element['nombre_subcomunidad'],
          element['descripcion_subcomunidad'],
          element['fk_comunidad'].toString()));
    });
    var s;
    s = json.encode(inComusers);
    sharedPreferences.setString("lista_comunidad", s);
  }
  return comusers;
}

postComuserSolicitud(idSubComunidad) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  var idUsuario = sharedPreferences.getInt("id_usuario");
  var result = await httpPost("crear_comuser_solicitud", {
    "pk_subcomunidad": idSubComunidad,
    "pk_usuario": idUsuario,
  });
  return result;
}

Future getComuserPertenece(idSubComunidad, comusers) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  var idUsuario = sharedPreferences.getInt("id_usuario");
  var result =
      await httpGet('subcomunidad_usuario/comuser/$idSubComunidad/$idUsuario');
  if (result.ok) {
    comusers.clear();
    var inComusers = result.data as List<dynamic>;
    inComusers.forEach((element) {
      comusers.add(Comuser(
        element['pk_comunidad'].toString(),
        element['pk_usuario'].toString(),
        element['cantidad_flyer'],
        element['cantidad_muro'],
        element['cantidad_dato'],
        element['miembro_subcomunidad'].toString(),
      ));
    });
  }
  return comusers;
}

Future<void> actualizarComuserEstado(idSubComunidad, idUsuario, estado) async {
  var result = await httpPut(
      'update_comuser/miembro/$idSubComunidad/$idUsuario',
      {"miembro_subcomunidad": estado});
  if (result.ok) {}
}
