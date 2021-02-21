import 'dart:convert';
import 'dart:io';

import 'package:admitt/src/bloc/flyer_bloc.dart';
import 'package:admitt/src/bloc/provider.dart';
import 'package:admitt/src/flyer_class.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../comunidad_class.dart';
import '../../constants.dart';
import '../../http.dart';
import 'package:image_picker/image_picker.dart';
import '../comunidades_page.dart';
import 'dart:convert';

class Contacto {
  String telefono;
  String email;
  String mostrar;
  Contacto(this.telefono, this.email, this.mostrar);
}

class Comentario {
  String idComentario;
  String comentario;
  String idUsuario;
  String nombreUsuario;
  String apellidoUsuario;
  String mostrarContacto;
  Comentario(this.idComentario, this.comentario, this.idUsuario,
      this.nombreUsuario, this.apellidoUsuario, this.mostrarContacto);
}

class AddComentarioPage extends StatefulWidget {
  static String tag = 'add-comentario-page';
  @override
  Flyer flyer;
  String idUsuario;
  AddComentarioPage({Key key, this.flyer, this.idUsuario}) : super(key: key);
  _AddComentarioPageState createState() => _AddComentarioPageState();
}

class _AddComentarioPageState extends State<AddComentarioPage> {
  SharedPreferences sharedPreferences;
  List<Comentario> comentarios = [];
  Contacto contacto = null;
  File _image;
  String dropdownValue;
  String idUsuario;
  String emailUsuario;
  Future<void> getComentarios() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    idUsuario = sharedPreferences.getInt("id_usuario").toString();
    emailUsuario = sharedPreferences.getInt("email_usuario").toString();
    var id = widget.flyer.idFlyer;
    var result = await httpGet('comentarios/publicacion/' + id);
    if (result.ok) {
      if (this.mounted) {
        setState(() {
          comentarios.clear();
          var incomentarios = result.data as List<dynamic>;
          incomentarios.forEach((_item) {
            comentarios.add(Comentario(
                _item['id_comentario'].toString(),
                _item['comentario'],
                _item['id_usuario'].toString(),
                _item['nombre_usuario'].toString(),
                _item['apellido_usuario'].toString(),
                _item['mostrar_contacto'].toString()));
          });
        });
      }
    }
  }

  Future<void> getSolicitudContacto() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    idUsuario = sharedPreferences.getInt("id_usuario").toString();
    var id = widget.flyer.idFlyer;
    var result = await httpGet(
        'solicitud_contacto/publicacion/' + id + '/usuario/' + idUsuario);
    if (result.ok) {
      if (this.mounted) {
        setState(() {
          var _contacto = result.data as List<dynamic>;
          if (_contacto.length > 0) {
            contacto = Contacto(
              _contacto[0]['telefono_usuario'].toString(),
              _contacto[0]['email_usuario'],
              _contacto[0]['mostrar'].toString(),
            );
          }
        });
      }
    }
  }

  var bytes;
  TextEditingController comentarioController = TextEditingController();

  crearComentario() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var idUsuario = sharedPreferences.getInt("id_usuario");
    if (comentarioController.text == null || comentarioController.text == '') {
      return;
    }

    var idflyer = widget.flyer.idFlyer;

    var result = await httpPost("crear_comentarios", {
      "fk_usuario": idUsuario,
      "fk_publicacion": idflyer,
      "comentario": comentarioController.text
    });
    if (result.ok) {
      if (this.mounted) {
        setState(() {
          comentarioController.text = '';
          response = result.data['status'];
          comentarios.clear();
          getComentarios();
          FocusScope.of(context).requestFocus(FocusNode());
        });
      }
    }
  }

  crearSolicitudTelefono() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var idUsuario = sharedPreferences.getInt("id_usuario");
    var idflyer = widget.flyer.idFlyer;

    var result = await httpPost("crear_solicitud_contacto", {
      "fk_usuario_solicitante": idUsuario,
      "fk_publicacion": idflyer,
    });
    if (result.ok) {
      if (this.mounted) {
        setState(() {
          response = result.data['status'];
        });
      }
    }
  }

  modificarSolicitudTelefono(_idUsuario) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var idflyer = widget.flyer.idFlyer;

    var result = await httpPost("modificar_solicitud_contacto", {
      "fk_usuario_solicitante": _idUsuario,
      "fk_publicacion": idflyer,
      "mostrar": '1'
    });
    if (result.ok) {
      if (this.mounted) {
        setState(() {
          getComentarios();
          response = result.data['status'];
        });
      }
    }
  }

  eliminarComentario(idComentario) async {
    var result = await httpDelete("eliminar_comentarios/" + idComentario, {});
    if (result.ok) {
      if (this.mounted) {
        setState(() {
          comentarios.clear();
          getComentarios();
          response = result.data['status'];
        });
      }
    }
  }

  String response = "";
  SlidableController slidableController;
  @override
  void initState() {
    super.initState();
    getComentarios();
    //getSolicitudContacto();
  }

  Widget build(BuildContext context) {
    // final Comunidad comunidad = ModalRoute.of(context).settings.arguments;
    Flyer flyer = widget.flyer;
    //final bloc = Provider.of4(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.grey[200],
          title: Text(
            'Agregar comentario'.toUpperCase(),
            style: TextStyle(fontSize: 15),
          ),
        ),
        //drawer: MenuLateral(),
        body: FooterLayout(
          footer: botonesAccion(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Material(
                          color: Colors.orange,
                          child: Container(
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.person_outline,
                                size: 25,
                                color: Colors.orange[800],
                              )),
                          shape: CircleBorder(),
                        )),
                    Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          (flyer.nombreUsuario + ' ' + flyer.apellidoUsuario)
                              .toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                          overflow: TextOverflow.clip,
                          maxLines: 5,
                        )),
                  ],
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.white, width: 1.0))),
                    padding: EdgeInsets.all(10),
                    child: Text(flyer.descripcionFlyer,
                        overflow: TextOverflow.clip, maxLines: 5)),
                for (var i = 0; i < comentarios.length; i++)
                  _mostrarcomentarios(context, getComentarios, comentarios[i])
              ],
            ),
          ),
        )

        //bottomNavigationBar: botonesAccion(),
        );
  }

  _inputText() {
    return TextField(
      controller: comentarioController,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.send,
      onSubmitted: (value) {
        crearComentario();
      },
      decoration: InputDecoration(
        enabled: true,
        helperMaxLines: 5,

        labelText: 'Agregar comentario',
        //hintText: "Agregar comentario..",
        contentPadding: EdgeInsets.all(10),
        labelStyle: TextStyle(color: Colors.grey[500]),
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[100], width: 2.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
      ),
    );
  }

  botonesAccion() {
    return Container(
        height: 85,
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            border:
                Border(top: BorderSide(color: Colors.grey[200], width: 1.0))),
        padding: EdgeInsets.only(bottom: 20, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Material(
                      color: Colors.lightBlue,
                      child: Container(
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.person_outline,
                            size: 20,
                            color: Colors.white,
                          )),
                      shape: CircleBorder(),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: _inputText(),
                ),
                InkWell(
                  onTap: () {
                    crearComentario();
                  },
                  child: Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.send,
                        color: Colors.grey,
                      )),
                ),
              ],
            ),
          ],
        ));
  }

  _publicar(BuildContext context, Flyerbloc bloc) {
    print('============================');
    print('Name      : ${bloc.name}');
    print('Last Name : ${bloc.description}');
    print('============================');
  }

  Widget _mostrarcomentarios(context, Function nombre, Comentario comentario) {
    return Container(
      margin: EdgeInsets.all(3),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Card(
          color: Colors.grey[200],
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.white, width: 0)),
          child: Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Material(
                        color: widget.flyer.idUsuario == comentario.idUsuario
                            ? Colors.orange
                            : comentario.idUsuario == idUsuario.toString()
                                ? Colors.blue
                                : Colors.grey,
                        child: Container(
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.person_outline,
                              size: 20,
                              color: widget.flyer.idUsuario ==
                                      comentario.idUsuario
                                  ? Colors.orange[800]
                                  : comentario.idUsuario == idUsuario.toString()
                                      ? Colors.blue[800]
                                      : Colors.grey[800],
                            )),
                        shape: CircleBorder(),
                      )),
                  Container(
                    child: Text(
                        '   ' +
                            comentario.nombreUsuario.toUpperCase() +
                            ' ' +
                            comentario.apellidoUsuario.toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(comentario.comentario),
              ),
              comentario.mostrarContacto == '0' &&
                      comentario.idUsuario == idUsuario
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black87,
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Este usuario ha solicitado su contacto',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                            InkWell(
                                onTap: () {
                                  modificarSolicitudTelefono(
                                      comentario.idUsuario);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.only(
                                      left: 5, right: 5, top: 3, bottom: 3),
                                  child: Text(
                                    'ENVIAR',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 11),
                                  ),
                                ))
                          ]))
                  : Container()
            ],
          )),
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Eliminar',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () =>
                _showSnackBar(context, 'Eliminar', comentario.idComentario),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String text, idComentario) {
    eliminarComentario(idComentario);
    print(context);
  }
}
