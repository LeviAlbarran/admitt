import 'dart:convert';
import 'dart:io';

import 'package:admitt/src/bloc/publicacion_bloc.dart';
import 'package:admitt/src/bloc/provider.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/common_widget.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../comunidad_class.dart';
import 'package:image/image.dart' as imageDecode;
import '../../constants.dart';
import '../../http.dart';
import 'package:image_picker/image_picker.dart';
import '../comunidades_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Categoria {
  String idCategoria;
  String nombreCategoria;
  Categoria(this.idCategoria, this.nombreCategoria);
}

class AddPublicacionPage extends StatefulWidget {
  SubComunidad subComunidad;
  AddPublicacionPage({Key key, this.subComunidad}) : super(key: key);
  static String tag = 'add-publicacion-page';
  @override
  _AddPublicacionPageState createState() => _AddPublicacionPageState();
}

class _AddPublicacionPageState extends State<AddPublicacionPage> {
  SharedPreferences sharedPreferences;
  List<Categoria> categorias = [];
  List<SubComunidad> subcomunidad = [];
  var disableButton = false;
  File _image;
  String dropdownValue;
  String dropdownValue2;
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

  Future<void> getSubcomunidades() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var idUsuario = sharedPreferences.getInt('id_usuario');
    var result = await httpGet('subcomunidad_usuario/id/$idUsuario');

    if (result.ok) {
      if (this.mounted) {
        setState(() {
          subcomunidad.clear();
          var insubcomunidad = result.data as List<dynamic>;
          insubcomunidad.forEach((_subcomunidad) {
            subcomunidad.add(SubComunidad(
              _subcomunidad['id_subcomunidad'].toString(),
              _subcomunidad['nombre_subcomunidad'].toString(),
              _subcomunidad['descricion_subcomunidad'].toString(),
              _subcomunidad['fk_subcomunidad'].toString(),
            ));
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

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(
        source: source, maxHeight: 480, maxWidth: 640);

    setState(() {
      _image = selected;
    });
  }

  crearFlyer() async {
    if (dropdownValue == null) {
      showDialog(
          context: context,
          builder: (_) => alertaCategoria(),
          barrierDismissible: false);
      return;
    }

    setState(() {
      disableButton = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var idUsuario = sharedPreferences.getInt("id_usuario");

    var result = await httpPost("crear_publicacion", {
      "fk_tipo_publicacion": 2,
      "titulo_publicacion": nombreController.text,
      "descripcion_publicacion": descripcionController.text,
      "flyer_publicacion": null,
      "fk_subcomunidad_publicacion": widget.subComunidad == null
          ? dropdownValue2
          : widget.subComunidad.idSubComunidad,
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
            disableButton = false;
          });
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
    getSubcomunidades();
  }

  Widget build(BuildContext context) {
    // final Comunidad comunidad = ModalRoute.of(context).settings.arguments;
    final bloc = Provider.of8(context);

    //final SubComunidad subComunidad = ModalRoute.of(context).settings.arguments;
    //var idSubComunidad = subComunidad.idSubComunidad;
    return Scaffold(
        appBar: BarraApp(titulo: "Publicar"),
        //drawer: MenuLateral(),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                //_flyerName(bloc),
                SizedBox(
                  height: 20,
                ),
                _descripcionFlyer(bloc),
                //futuroBuscar(),
                futuroCategoria(),
                widget.subComunidad == null
                    ? futuroSubComunidades()
                    : Container(),
                _addFile(),
                _publish(bloc)
              ],
            ),
          ),
        ));
  }

  _publicar(BuildContext context, Publicacionbloc bloc) {
    print('============================');
    print('Last Name : ${bloc.description}');
    print('============================');
  }

/*
  _flyerName(Publicacionbloc bloc) {
    return Container(
      height: 10,
      //margin: EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
      child: StreamBuilder(
          stream: bloc.nameStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return TextFormField(
              controller: nombreController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                errorText: snapshot.error,
                labelText: 'Titulo',
                hintText: "Título",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0)),
              ),
              onChanged: bloc.changeName,
            );
          }),
    );
  }
*/
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

  Widget futuroSubComunidades() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      child: DropdownButton(
        isExpanded: true,
        onChanged: (String newValue) {
          setState(() {
            dropdownValue2 = newValue;
          });
        },
        value: dropdownValue2,
        hint: Text('Selecciona una subcomunidad'),
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.grey[700]),
        underline: Container(
          height: 2,
          color: Colors.grey[400],
        ),
        items: subcomunidad.map<DropdownMenuItem<String>>((SubComunidad value) {
          return DropdownMenuItem<String>(
            value: value.idSubComunidad,
            child: Text(value.nombreSubComunidad),
          );
        }).toList(),
      ),
    );
  }

  Widget futuroBuscar() {
    return DropdownButton(
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      value: dropdownValue,
      hint: Text('Que desea buscar'),
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: hardPink),
      underline: Container(
        height: 2,
        color: hardPink,
      ),
      items: categorias.map<DropdownMenuItem<String>>((Categoria value) {
        return DropdownMenuItem<String>(
          value: value.idCategoria,
          child: Text(value.nombreCategoria),
        );
      }).toList(),
    );
  }

  _descripcionFlyer(Publicacionbloc bloc) {
    return Container(
      margin: EdgeInsets.only(top: 0, bottom: 10, left: 20, right: 20),
      child: StreamBuilder(
          stream: bloc.descriptionStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return TextFormField(
              controller: descripcionController,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 2,
              maxLength: 150,
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
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 480, maxWidth: 640);

    setState(() {
      _image = image;
    });
  }

  _publish(Publicacionbloc bloc) {
    return Container(
      margin: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
          stream: bloc.formValidStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0)),
                onPressed: snapshot.hasData || disableButton == false
                    ? () => crearFlyer()
                    : null,
                padding: EdgeInsets.all(12),
                color: Colors.black,
                child: disableButton == true
                    ? commonWidget.loadingButton()
                    : Text('Publicar'.toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 14.0)),
              ),
            );
          }),
    );
  }
}
