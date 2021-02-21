import 'package:admitt/src/bloc/provider.dart';
import 'package:admitt/src/bloc/registro_bloc.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:admitt/src/constants.dart';
import 'package:admitt/src/http.dart';

class RegistroPage extends StatefulWidget {
  static String tag = 'registro-page';
  @override
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  random(min, max) {
    var rn = new Random();
    return min + rn.nextInt(max - min);
  }

  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController correoController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController contrasenaController = TextEditingController();

  String response = "";

  var codigoUsuario;
  crearUsuario() async {
    codigoUsuario = random(1000, 9999).toString();
    var result = await httpPost("crear_usuario", {
      "nombre_usuario": nombreController.text,
      "apellido_usuario": apellidoController.text,
      "correo_usuario": correoController.text,
      "telefono_usuario": telefonoController.text,
      "contrasena_usuario": contrasenaController.text,
      "codigo_usuario": codigoUsuario
    });
    print(result);
    if (result.ok) {
      mandarCorreo();
      setState(() {
        response = result.data['status'];
        Navigator.pushNamed(context, 'validacion-page');
      });
    }
  }

  mandarCorreo() async {
    var result = await httpPost(
        "send_email/$codigoUsuario", {"correo_usuario": correoController.text});
    if (result.ok) {
      setState(() {
        response = result.data['status'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of2(context);

    return Scaffold(
      appBar: BarraApp(titulo: 'Formulario de Registro'),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            child: Column(
              children: <Widget>[
                _lema1(),
                SizedBox(height: 5.0),
                _lema2(),
                SizedBox(height: 20.0),
                _crearNombre(bloc),
                SizedBox(height: 20.0),
                _crearApellido(bloc),
                SizedBox(height: 20.0),
                _crearEmail(bloc),
                SizedBox(height: 20.0),
                _crearTelefono(bloc),
                SizedBox(height: 20.0),
                _crearContrasenna(bloc),
                SizedBox(height: 20.0),
                //_crearConfirmacion(bloc),
                Divider(),
                _enviarRegistro(bloc)
              ],
            ),
          ),
        ),
      ),
    );
  }

  _registro(BuildContext context, Registrobloc bloc) {
    print('============================');
    print('Name      : ${bloc.name}');
    print('Last Name : ${bloc.lastName}');
    print('Email     : ${bloc.email}');
    print('Phone     : ${bloc.phone}');
    print('Password  : ${bloc.password}');
    print('Password  : ${bloc.password}');
    print('============================');

    crearUsuario();
  }

  _lema1() {
    return Container(
        child: Align(
      alignment: Alignment.topLeft,
      child: Text('Regístrate en ADMITT',
          style: TextStyle(
            fontSize: 25.0,
          )),
    ));
  }

  _lema2() {
    return Container(
        child: Align(
      alignment: Alignment.topLeft,
      child: Text('Es rápido y Fácil',
          style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic)),
    ));
  }

  _crearNombre(Registrobloc bloc) {
    return StreamBuilder(
        stream: bloc.nameStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextFormField(
            controller: nombreController,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              errorText: snapshot.error,
              labelText: 'Nombre',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              labelStyle: TextStyle(color: hardGrey),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: grey, width: 2.0)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: pink, width: 2.0)),
            ),
            onChanged: bloc.changeName,
          );
        });
  }

  _crearApellido(Registrobloc bloc) {
    return StreamBuilder(
      stream: bloc.lastNameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return TextFormField(
          controller: apellidoController,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            errorText: snapshot.error,
            labelText: 'Apellido',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            labelStyle: TextStyle(color: hardGrey),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: grey, width: 2.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: pink, width: 2.0)),
          ),
          onChanged: bloc.changeLastName,
        );
      },
    );
  }

  _crearEmail(Registrobloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return TextFormField(
          controller: correoController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            errorText: snapshot.error,
            labelText: 'Email',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            labelStyle: TextStyle(color: hardGrey),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: grey, width: 2.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: pink, width: 2.0)),
          ),
          onChanged: bloc.changeEmail,
        );
      },
    );
  }

  _crearTelefono(Registrobloc bloc) {
    return StreamBuilder(
      stream: bloc.phoneStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return TextFormField(
          controller: telefonoController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            errorText: snapshot.error,
            labelText: 'Número de teléfono',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            labelStyle: TextStyle(color: hardGrey),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: grey, width: 2.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: pink, width: 2.0)),
          ),
          onChanged: bloc.changePhone,
        );
      },
    );
  }

  _crearContrasenna(Registrobloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return TextFormField(
          controller: contrasenaController,
          obscureText: true,
          decoration: InputDecoration(
            errorText: snapshot.error,
            labelText: 'Contraseña',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            labelStyle: TextStyle(color: hardGrey),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: grey, width: 2.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: pink, width: 2.0)),
          ),
          onChanged: bloc.changePassword,
        );
      },
    );
  }

  /* _crearConfirmacion(Registrobloc bloc) {

    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Repita contraseña',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        labelStyle: TextStyle(color: hardGrey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: grey, width: 2.0)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: pink, width: 2.0)),
      ),
    );
  }
  
*/
  _enviarRegistro(Registrobloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            // onPressed: () => Navigator.pushNamed(context, 'validacion-page'),
            onPressed: snapshot.hasData ? () => _registro(context, bloc) : null,
            padding: EdgeInsets.all(12),
            color: hardPink,
            child: Text('Registrarse',
                style: TextStyle(color: Colors.white, fontSize: 17.0)),
          ),
        );
      },
    );
  }
}
