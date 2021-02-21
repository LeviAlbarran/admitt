import 'package:admitt/src/pages/comunidades_page.dart';
import 'package:flutter/material.dart';

import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:admitt/src/http.dart';
import 'package:admitt/src/usuario_class.dart';
import 'package:admitt/src/comunidad_class.dart';
import '../constants.dart';
import 'package:admitt/src/pages/comuser_class.dart';

class UsuariosComunidadPage extends StatefulWidget {
  UsuariosComunidadPage({Key key}) : super(key: key);
  static String tag = 'usuarios-comunidad-page';
  @override
  _UsuariosComunidadPageState createState() => _UsuariosComunidadPageState();
}

class _UsuariosComunidadPageState extends State<UsuariosComunidadPage> {
  List<Usuario> usuarios = [];

  Future<void> refreshUsuariosComunidad(idComunidad) async {
    var result = await httpGet('subcomunidad_usuario/comunidad/$idComunidad');
    if (result.ok) {
      if (this.mounted) {
        setState(() {
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
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    refreshUsuariosComunidad(null);
  }

  @override
  Widget build(BuildContext context) {
    final Comunidad comunidad = ModalRoute.of(context).settings.arguments;
    var idComunidad = comunidad.idComunidad;
    var nombreComunidad = comunidad.nombreComunidad;
    return futuro(idComunidad, nombreComunidad);
  }

  Widget futuro(idComunidad, nombreComunidad) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return Scaffold(
          appBar: BarraApp(titulo: nombreComunidad),
          drawer: MenuLateral(),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: usuarios.length,
                      itemBuilder: (context, i) => ListTile(
                            leading: Icon(
                              Icons.person,
                              color: hardPink,
                            ),
                            title: Text(usuarios[i].nombreUsuario +
                                ' ' +
                                usuarios[i].apellidoUsuario),
                          ),
                      separatorBuilder: (context, i) => Divider())
                ],
              ),
            ),
          ),
        );
      },
      future: refreshUsuariosComunidad(idComunidad),
    );
  }
}
