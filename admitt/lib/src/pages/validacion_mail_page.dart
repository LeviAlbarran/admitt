import 'package:admitt/src/usuario_class.dart';
import 'package:flutter/material.dart';
import 'package:admitt/src/http.dart';

import '../constants.dart';

class ValidacionMailPage extends StatefulWidget {
  static String tag = 'validacion-page';
  @override
  _ValidacionMailPageState createState() => _ValidacionMailPageState();
}

var correoUsuario;
var codigoUsuario;
class _ValidacionMailPageState extends State<ValidacionMailPage> {
  String response = "";
  TextEditingController codigoController = TextEditingController();
  List<Usuario> usuarios = [];
  refreshUsuarios() async{
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
        correoUsuario = inUsuarios.last['correo_usuario'];
        codigoUsuario = inUsuarios.last['codigo_usuario'];
      });
    }
  }

  Future<void> actualizarUsuario(correoUsuario) async{
    if (codigoController.text == codigoUsuario){
      var result = await httpPut('modificar_usuario/$correoUsuario',{
        "usuario_confirmado": 's'
      });
      if (result.ok) {
        setState(() {
          response = result.data['status'];
          showDialog(
            context: context,
            builder: (_) => alerta(),
            barrierDismissible: false
          );
        });
      }
    } else {
      setState(() {
          showDialog(
            context: context,
            builder: (_) => alertaError(),
            barrierDismissible: false
          );
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
      appBar: AppBar(
        title: Text('Confirmación de Usuario', style: TextStyle(color: Colors.black)),
        backgroundColor: pink,
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0), 
          child: Column(
              children: <Widget>[
                _lema1(),
                SizedBox(height: 5.0),
                _lema2(),
                SizedBox(height: 50.0),
                Text('Se ha enviado un código de verificación a su correo: ', style: TextStyle(fontSize: 15.0)),
                SizedBox(height: 10.0),
                // Text(correoUsuario),
                SizedBox(height: 20.0),
                _ingresoCodigo(),
                SizedBox(height: 20.0),
                _confirmarcodigo(correoUsuario)
              ],
            ),
          ),
        ),
    );
  }


   Widget alerta(){
    return AlertDialog(
      title: Text('Usuario Confirmado'),
      content: Text('El usuario fue confirmado!'),
      actions: [
         FlatButton(
           child: Text("Volver al Login"),
           onPressed: () => Navigator.pushNamed(context, 'login-page')
         ),
      ],
    );
  }

  Widget alertaError(){
    return AlertDialog(
      title: Text('Código incorrecto'),
      content: Text('El código ingresado no coincide con el código que fue enviado a su correo!'),
      actions: [
         FlatButton(
           child: Text("Volver"),
           onPressed: () => Navigator.pop(context)
         ),
      ],
    );
  }
  
  _ingresoCodigo() {
    return TextFormField(
      controller: codigoController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
          labelText: 'Código de verificación',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        labelStyle: TextStyle(color: hardGrey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: grey, width: 2.0)
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: pink, width: 2.0)
        ),),
    );
  }

  _confirmarcodigo(correoUsuario) {
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        onPressed: () => actualizarUsuario(correoUsuario),
        padding: EdgeInsets.all(12),
        color: hardPink,
        child: Text('Confirmar Registro', style: TextStyle(color: Colors.white, fontSize: 17.0)),
      )
    );
   
  }

  _lema1(){
    return Container(
      child: Align(
        alignment: Alignment.topLeft,
        child: Text ('Regístrate en ADMITT', style: TextStyle(fontSize: 25.0, )),
      )
    );

  }

  _lema2(){
    return Container(
      child: Align(
        alignment: Alignment.topLeft,
        child: Text ('Es rápido y Fácil', style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic)),
      )
    );

  }
}