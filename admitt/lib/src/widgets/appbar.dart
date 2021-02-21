import 'package:admitt/src/comunidad_class.dart';
import 'package:admitt/src/pages/lista_solicitudes_page.dart';
import 'package:admitt/src/solicitu_usuario_class.dart';
import 'package:admitt/src/solicitud_class.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:admitt/src/usuario_class.dart';
import 'package:admitt/src/widgets/busqueda_flyers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../http.dart';
import '../flyer_class.dart';

class BarraApp extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  BarraApp({@required this.titulo});
  SharedPreferences sharedPreferences;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      backgroundColor: Colors.grey[200],
      title: Text(
        titulo.toUpperCase(),
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

class BarraAppComunidad extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  BarraAppComunidad({@required this.titulo});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(titulo),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [pink, hardPink, hardGrey])),
      ),
      actions: <Widget>[
        IconButton(
          color: white,
          icon: Icon(Icons.group_add),
          onPressed: () => Navigator.pushNamed(context, 'add-comunidad-page'),
        )
      ],
    );
  }

  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

// AppBar para comunidades, Contiene el incono de notificacion
// que cambia segun hay o no peticiones pendientes
class BarraAppSelect extends StatefulWidget implements PreferredSizeWidget {
  final SubComunidad subcomunidad;
  BarraAppSelect({@required this.subcomunidad});

  @override
  _BarraAppSelect createState() => _BarraAppSelect(subcomunidad: subcomunidad);
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

class _BarraAppSelect extends State<BarraAppSelect> {
  List<SolUsuario> misVotos = [];
  SubComunidad subcomunidad;
  _BarraAppSelect({@required this.subcomunidad});
  List<Solicitud> solicitud = [];
  List<Flyer> flyers = [];
  List<String> nombreFlyer = [];

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(subcomunidad.nombreSubComunidad),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [pink, hardPink, Colors.orange[800]])),
      ),
      actions: <Widget>[
        searchPeticiones(),
        IconButton(
            onPressed: () => Navigator.pushNamed(
                context, 'usuarios-subcomunidad-page',
                arguments: subcomunidad),
            icon: Icon(Icons.supervised_user_circle),
            color: Colors.white),
        IconButton(
            onPressed: () {
              obtenerFlyerBusqueda(
                  subcomunidad.idSubComunidad, flyers, nombreFlyer);
              showSearch(
                  context: context, delegate: SearchComu(flyers, nombreFlyer));
            },
            icon: Icon(Icons.search),
            color: Colors.white),
      ],
    );
  }

  Size get preferredSize => new Size.fromHeight(kToolbarHeight);

  searchPeticiones() {
    return FutureBuilder(
      builder: (context, snapshot) {
        return IconButton(
            icon: Icon(Icons.add_alert,
                color: solicitud.isNotEmpty ? hardPink : white),
            onPressed: solicitud.isNotEmpty
                ? () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ListaSolicitudPage(subComunidad: subcomunidad),
                        ));
                  }
                : () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ListaSolicitudPage(subComunidad: subcomunidad),
                        ));
                  });
      },
      future: resolverSolicitudes(),
    );
  }

  resolverSolicitudes() async {
    List borrado = [];
    await getSolicitudesUsuario(misVotos);
    if (solicitud.isNotEmpty) {
      if (misVotos.isNotEmpty) {
        solicitud.forEach((element) {
          misVotos.forEach((element2) {
            if (element.idSolicitud == element2.idSolicitud) {
              borrado.add(element.idSolicitud);
            }
          });
        });
        borrado.forEach((element) {
          solicitud.removeWhere((item) => item.idSolicitud == element);
        });
      }
    }
  }

  String response = '';
  Future<void> salirComunidad(idComunidad) async {
    sharedPreferences = await SharedPreferences.getInstance();
    var idUsuario = sharedPreferences.getInt("id_usuario");
    var result = await httpDelete(
        'eliminar_publicacion/eliminar_usuario/$idUsuario/$idComunidad');
    if (result.ok) {
      setState(() {
        response = result.data['status'];
        showDialog(
            context: context,
            builder: (_) => alerta(),
            barrierDismissible: false);
      });
    }
  }

  Widget alerta() {
    return AlertDialog(
      title: Text('Salir de Comunidad'),
      content: Text('Has salido de la comunidad'),
      actions: [
        FlatButton(
            child: Text("Volver al menú principal"),
            onPressed: () => Navigator.pushNamed(context, 'home-page-sv')),
      ],
    );
  }

  Widget alertaEliminar(idComunidad) {
    return AlertDialog(
      title: Text('Salir de Comunidad'),
      content: Text('¿Está seguro que desea salir de la comunidad?'),
      actions: [
        FlatButton(
            child: Text("Salir"), onPressed: () => salirComunidad(idComunidad)),
        FlatButton(
            child: Text("Cancelar"), onPressed: () => Navigator.pop(context)),
      ],
    );
  }
}

class BarraAppSelectComunidad extends StatefulWidget
    implements PreferredSizeWidget {
  final Comunidad comunidad;
  BarraAppSelectComunidad({@required this.comunidad});

  @override
  _BarraAppSelectComunidad createState() =>
      _BarraAppSelectComunidad(comunidad: comunidad);
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

class _BarraAppSelectComunidad extends State<BarraAppSelect> {
  List<SolUsuario> misVotos = [];
  Comunidad comunidad;
  _BarraAppSelectComunidad({@required this.comunidad});
  List<Solicitud> solicitud = [];
  List<Flyer> flyers = [];
  List<String> nombreFlyer = [];

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(comunidad.nombreComunidad),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [pink, hardPink, hardGrey])),
      ),
      actions: <Widget>[
        IconButton(
            onPressed: () => Navigator.pushNamed(
                context, 'usuarios-comunidad-page',
                arguments: comunidad),
            icon: Icon(Icons.supervised_user_circle),
            color: Colors.white),
        IconButton(
            onPressed: () {
              obtenerFlyerBusqueda(comunidad.idComunidad, flyers, nombreFlyer);
              showSearch(
                  context: context, delegate: SearchComu(flyers, nombreFlyer));
            },
            icon: Icon(Icons.search),
            color: Colors.white),
      ],
    );
  }

  Size get preferredSize => new Size.fromHeight(kToolbarHeight);

  String response = '';
  Future<void> salirComunidad(idComunidad) async {
    sharedPreferences = await SharedPreferences.getInstance();
    var idUsuario = sharedPreferences.getInt("id_usuario");
    var result = await httpDelete(
        'eliminar_publicacion/eliminar_usuario/$idUsuario/$idComunidad');
    if (result.ok) {
      setState(() {
        response = result.data['status'];
        showDialog(
            context: context,
            builder: (_) => alerta(),
            barrierDismissible: false);
      });
    }
  }

  Widget alerta() {
    return AlertDialog(
      title: Text('Salir de Comunidad'),
      content: Text('Has salido de la comunidad'),
      actions: [
        FlatButton(
            child: Text("Volver al menú principal"),
            onPressed: () => Navigator.pushNamed(context, 'home-page-sv')),
      ],
    );
  }

  Widget alertaEliminar(idComunidad) {
    return AlertDialog(
      title: Text('Salir de Comunidad'),
      content: Text('¿Está seguro que desea salir de la comunidad?'),
      actions: [
        FlatButton(
            child: Text("Salir"), onPressed: () => salirComunidad(idComunidad)),
        FlatButton(
            child: Text("Cancelar"), onPressed: () => Navigator.pop(context)),
      ],
    );
  }
}
