import 'dart:convert';
import 'dart:io';

import 'package:admitt/src/bloc/flyer_bloc.dart';
import 'package:admitt/src/bloc/provider.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../comunidad_class.dart';
import '../../constants.dart';
import '../../http.dart';
import 'package:image_picker/image_picker.dart';
import '../comunidades_page.dart';
import 'dart:convert';

class Categoria {
  String idCategoria;
  String nombreCategoria;
  Categoria(this.idCategoria, this.nombreCategoria);
}

class AddFlyerPage extends StatefulWidget {
  static String tag = 'add-flyer-page';
  @override
  _AddFlyerPageState createState() => _AddFlyerPageState();
}

class _AddFlyerPageState extends State<AddFlyerPage> {
  SharedPreferences sharedPreferences;
  List<Categoria> categorias = [];
  File _image;
  String dropdownValue;
  Future<void> getCategorias() async {
    var result = await httpGet('categorias');
    if (result.ok) {
      if (this.mounted) {
        setState(() {
          categorias.clear();
          var inCategorias = result.data as List<dynamic>;
          inCategorias.forEach((inCategoria) {
            categorias.add(Categoria(inCategoria['id_categoria'].toString(),
                inCategoria['nombre_categoria']));
          });
        });
      }
    }
  }

  var bytes;
  TextEditingController nombreController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  Widget alertaCategoria() {
    return AlertDialog(
      //title: Text(''),
      content: Text('Seleccione una categoria'),
      actions: [
        FlatButton(
            child: Text("Aceptar"), onPressed: () => Navigator.pop(context)),
      ],
    );
  }

  Widget alertaImagen() {
    return AlertDialog(
      //title: Text(''),
      content: Text('Seleccione una imagen'),
      actions: [
        FlatButton(
            child: Text("Aceptar"), onPressed: () => Navigator.pop(context)),
      ],
    );
  }

  crearFlyer(idSubComunidad, subcomunidad) async {
    if (dropdownValue == null) {
      showDialog(
          context: context,
          builder: (_) => alertaCategoria(),
          barrierDismissible: false);
      return;
    }

    if (_image == null) {
      showDialog(
          context: context,
          builder: (_) => alertaImagen(),
          barrierDismissible: false);
      return;
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var idUsuario = sharedPreferences.getInt("id_usuario");
    //String file = base64Encode(_image.readAsBytesSync());

    var result = await httpPost("crear_publicacion", {
      "fk_tipo_publicacion": 1,
      "titulo_publicacion": nombreController.text,
      "descripcion_publicacion": descripcionController.text,
      "flyer_publicacion": null,
      "fk_subcomunidad_publicacion": idSubComunidad,
      "fk_usuario_publicacion": idUsuario,
      "fk_categoria": dropdownValue
    });
    if (result.ok) {
      if (this.mounted) {
        if (_image != null) {
          var result2 = await httpFile(
              'subir_archivo',
              _image.path,
              result.data['id'].toString(),
              'flyer-' + result.data['id'].toString());
        }
        new Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            response = result.data['status'];
            Navigator.pop(context);
          });
        });
      }
    }
  }

  String response = "";

  @override
  void initState() {
    super.initState();
    getCategorias();
  }

  Widget build(BuildContext context) {
    // final Comunidad comunidad = ModalRoute.of(context).settings.arguments;
    final bloc = Provider.of4(context);

    final SubComunidad subComunidad = ModalRoute.of(context).settings.arguments;
    var idSubComunidad = subComunidad.idSubComunidad;
    return Scaffold(
      appBar: BarraApp(titulo: "Publica tu flyer"),
      //drawer: MenuLateral(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _flyerName(bloc),
            _descripcionFlyer(bloc),
            futuroCategoria(),
            _addFile(),
            _publish(bloc, idSubComunidad, subComunidad)
          ],
        ),
      ),
    );
  }

  _publicar(BuildContext context, Flyerbloc bloc) {
    print('============================');
    print('Name      : ${bloc.name}');
    print('Last Name : ${bloc.description}');
    print('============================');
  }

  _flyerName(Flyerbloc bloc) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
      child: StreamBuilder(
          stream: bloc.nameStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return TextFormField(
              controller: nombreController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                errorText: snapshot.error,
                labelText: 'Título',
                hintText: "Título",
                labelStyle: TextStyle(color: Colors.grey[700]),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[400], width: 2.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[400], width: 2.0)),
              ),
              onChanged: bloc.changeName,
            );
          }),
    );
  }

  Widget futuroCategoria() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      child: DropdownButton(
        isExpanded: true,
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
          });
        },
        value: dropdownValue,
        hint: Text('Selecciona una categoría'),
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.grey[700]),
        underline: Container(
          height: 2,
          color: Colors.grey[400],
        ),
        items: categorias.map<DropdownMenuItem<String>>((Categoria value) {
          return DropdownMenuItem<String>(
            value: value.idCategoria,
            child: Text(value.nombreCategoria),
          );
        }).toList(),
      ),
    );
  }

  _descripcionFlyer(Flyerbloc bloc) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      child: StreamBuilder(
          stream: bloc.descriptionStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return TextFormField(
              controller: descripcionController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                errorText: snapshot.error,
                labelText: 'Descripción',
                hintText: "Describe",
                labelStyle: TextStyle(color: Colors.grey[700]),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[400], width: 2.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[400], width: 2.0)),
              ),
              onChanged: bloc.changeDescription,
              textInputAction: TextInputAction.done,
            );
          }),
    );
  }

  _addFile() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: <Widget>[
          RaisedButton.icon(
            color: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            onPressed: () {
              setState(() {
                _pickFile();
              });
            },
            icon: Icon(Icons.image, color: Colors.white),
            label: Text("Archivo...",
                style: TextStyle(color: Colors.white, fontSize: 17.0)),
          ),
        ],
      ),
    );
  }

  Future _pickFile() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 480, maxWidth: 640);

    setState(() {
      _image = image;
    });
  }

  _publish(Flyerbloc bloc, idSubComunidad, subcomunidad) {
    return Container(
        margin: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
            stream: bloc.formValidStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return RaisedButton(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0)),
                onPressed: snapshot.hasData
                    ? () => crearFlyer(idSubComunidad, subcomunidad)
                    : null,
                padding: EdgeInsets.all(12),
                child: Text('Publicar'.toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: 14.0)),
              );
            }));
  }
}
