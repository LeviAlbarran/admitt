import 'dart:convert';
import 'dart:io';

import 'package:admitt/src/bloc/flyer_bloc.dart';
import 'package:admitt/src/bloc/provider.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admitt/src/constants.dart';
import 'package:admitt/src/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:admitt/src/flyer_class.dart';

import 'dart:convert';

class Categoria {
  String idCategoria;
  String nombreCategoria;
  Categoria(this.idCategoria, this.nombreCategoria);
}

class ModificarFlyerPage extends StatefulWidget {
  static String tag = 'modificar-flyer-page';
  @override
  _ModificarFlyerPageState createState() => _ModificarFlyerPageState();
}

class _ModificarFlyerPageState extends State<ModificarFlyerPage> {
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

  modificarFlyer(idFlyer) async {
    //String file = base64Encode(_image.readAsBytesSync());

    var result = await httpPut("modificar_publicacion/$idFlyer", {
      "titulo_publicacion": nombreController.text,
      "descripcion_publicacion": descripcionController.text,
      //"flyer_publicacion": null,
    });
    if (result.ok) {
      if (this.mounted) {
        /*if (_image != null) {
          var result2 = await httpFile('subir_archivo', _image.path,
              idFlyer.toString(), 'flyer-' + idFlyer.toString());
        }*/

        showDialog(
            context: context,
            builder: (_) => alerta(),
            barrierDismissible: false);
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

    final Flyer flyer = ModalRoute.of(context).settings.arguments;
    var idFlyer = flyer.idFlyer;
    var nombreFlyer = flyer.nombreFlyer;
    var descripcionFlyer = flyer.descripcionFlyer;
    descripcionController.text = flyer.descripcionFlyer;
    nombreController.text = flyer.nombreFlyer;
    return Scaffold(
        appBar: BarraApp(titulo: "Modifica tu flyer"),
        //drawer: MenuLateral(),
        body: SingleChildScrollView(
          child: Container(
            //margin: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _flyerName(bloc, nombreFlyer),
                _descripcionFlyer(bloc, descripcionFlyer),
                //_addFile(),
                _publish(bloc, idFlyer)
              ],
            ),
          ),
        ));
  }

  _flyerName(Flyerbloc bloc, nombreFlyer) {
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
                labelText: 'Modifica tu Flyer',
                hintText: nombreFlyer,
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

  _descripcionFlyer(Flyerbloc bloc, descripcionFlyer) {
    return Container(
      margin: EdgeInsets.only(top: 0, bottom: 10, left: 20, right: 20),
      child: StreamBuilder(
          stream: bloc.descriptionStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return TextFormField(
              controller: descripcionController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                errorText: snapshot.error,
                labelText: 'Descripción del flyer',
                hintText: descripcionFlyer,
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
      margin: EdgeInsets.only(top: 0, bottom: 10, left: 20, right: 20),
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
            icon: Icon(
              Icons.image,
              color: Colors.white,
            ),
            label: Text("Archivo...",
                style: TextStyle(color: Colors.white, fontSize: 17.0)),
          ),
          Text('   Suba nuevamente su foto...     '),
          SizedBox(
            height: 20.0,
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

  _publish(Flyerbloc bloc, idFlyer) {
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
                onPressed: snapshot.hasData ||
                        (descripcionController.text != '' &&
                            nombreController.text != '')
                    ? () => showDialog(
                        context: context,
                        builder: (_) => alertaEliminar(idFlyer),
                        barrierDismissible: false)
                    : null,
                padding: EdgeInsets.all(12),
                color: Colors.black,
                child: Text('PUBLICAR',
                    style: TextStyle(color: Colors.white, fontSize: 14.0)),
              ),
            );
          }),
    );
  }

  Widget alerta() {
    return AlertDialog(
      title: Text('Ha sido modificado correctamente'),
      //content: Text('El Flyer fue modificado!'),
      actions: [
        FlatButton(
            child: Text("Aceptar"),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            }),
      ],
    );
  }

  Widget alertaEliminar(idPublicacion) {
    return AlertDialog(
      title: Text('Modificar Flyer'),
      content: Text('¿Está seguro que desea modificar su flyer?'),
      actions: [
        FlatButton(
            child: Text("Modificar"),
            onPressed: () => modificarFlyer(idPublicacion)),
        FlatButton(
            child: Text("Cancelar"), onPressed: () => Navigator.pop(context)),
      ],
    );
  }
}
