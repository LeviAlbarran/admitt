import 'package:flutter/material.dart';

import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:admitt/src/http.dart';
import 'package:admitt/src/usuario_class.dart';
 
class UsuariosPage extends StatefulWidget {
  UsuariosPage({Key key}) : super(key: key);
  static String tag = 'usuarios-page';
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}
class _UsuariosPageState extends State<UsuariosPage> {

  List<Usuario> usuarios = [];
  
  Future<void> refreshUsuarios() async{
    var result = await httpGet('usuarios');
    if(result.ok)
    {
      setState(() {
        usuarios.clear();
        var inUsuarios = result.data as List<dynamic>;
        inUsuarios.forEach((inUsuario){
          usuarios.add(Usuario(
            inUsuario['id_usuario'].toString(),
            inUsuario['nombre_usuario'],
            inUsuario['apellido_usuario'],
            inUsuario['correo_usuario'],
            inUsuario['telefono_usuario'],
            inUsuario['premium_usuario'].toString(),
            inUsuario['usuario_confirmado'].toString(),
            inUsuario['contrasena_usuario'],
            inUsuario['codigo_usuario']
          ));
        });
      });
    }
  }

  @override
  void initState(){
    super.initState();
    refreshUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BarraApp(titulo: "Usuarios"),
      drawer: MenuLateral(),
      body: _refrescar(refreshUsuarios, usuarios), 
      );  
  }
}

Widget _refrescar(Function nombre, List<Usuario> usuarios){
  return RefreshIndicator(
    onRefresh: nombre,
    child: ListView.separated(
      itemCount: usuarios.length,
      itemBuilder: (context, i) => ListTile(
        leading: Icon(Icons.person),
        title: Text(usuarios[i].nombreUsuario),
      ),
    separatorBuilder: (context, i) => Divider())
  );
}
