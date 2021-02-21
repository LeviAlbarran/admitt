import 'package:admitt/src/bloc/buscar_bloc.dart';
import 'package:admitt/src/bloc/comunidad_bloc.dart';
import 'package:admitt/src/bloc/flyer_bloc.dart';
import 'package:admitt/src/bloc/registro_bloc.dart';
import 'package:flutter/material.dart';
import 'package:admitt/src/bloc/login_bloc.dart';
import 'package:admitt/src/bloc/contacto_bloc.dart';
import 'package:admitt/src/bloc/publicacion_bloc.dart';
export 'package:admitt/src/bloc/login_bloc.dart';
export 'package:admitt/src/bloc/registro_bloc.dart';
export 'package:admitt/src/bloc/flyer_bloc.dart';
export 'package:admitt/src/bloc/comunidad_bloc.dart';
export 'package:admitt/src/bloc/contacto_bloc.dart';
export 'package:admitt/src/bloc/publicacion_bloc.dart';
export 'package:admitt/src/bloc/buscar_bloc.dart';

class Provider extends InheritedWidget {
  static Provider _instance;

  factory Provider({Key key, Widget child}) {
    if (_instance == null) {
      _instance = new Provider._internal(key: key, child: child);
    }

    return _instance;
  }

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  final loginBloc = Loginbloc();
  final registroBloc = Registrobloc();
  final comunidadBloc = Comunidadbloc();
  final flyerBloc = Flyerbloc();
  final contactoBloc = Contactobloc();
  final publicacionBloc = Publicacionbloc();
  final buscarBloc = Buscarbloc();
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static Loginbloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }

  static Registrobloc of2(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().registroBloc;
  }

  static Comunidadbloc of3(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().comunidadBloc;
  }

  static Flyerbloc of4(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().flyerBloc;
  }

  static Contactobloc of5(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().contactoBloc;
  }

  static Publicacionbloc of6(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<Provider>()
        .publicacionBloc;
  }

  static Buscarbloc of7(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().buscarBloc;
  }

  static Publicacionbloc of8(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<Provider>()
        .publicacionBloc;
  }
}
