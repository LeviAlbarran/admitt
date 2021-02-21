import 'package:admitt/src/bloc/provider.dart';
import 'package:admitt/src/pages/navigator_page.dart';
import 'package:admitt/src/pages/subcomunidades_page.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:admitt/src/comunidad_class.dart';
import '../../constants.dart';
import '../../http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admitt/src/usuario_class.dart';

class AddSubComunidadPage extends StatefulWidget {
  static String tag = 'add-subcomunidad-page';
  @override
  SubComunidad subcomunidad;
  bool editar;
  AddSubComunidadPage({Key key, this.subcomunidad, this.editar})
      : super(key: key);
  _AddSubComunidadPageState createState() => _AddSubComunidadPageState();
}

class _AddSubComunidadPageState extends State<AddSubComunidadPage> {
  SharedPreferences sharedPreferences;

  var usuario = getUsuarioData(usuarios);

  TextEditingController nombreController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  String response = "";
  final _formKey = GlobalKey<FormState>();
  List<SubComunidad> subcomunidades = [];

  crearSubComunidad() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var result = await httpPost("crear_subcomunidad", {
      "nombre_subcomunidad": nombreController.text,
      "descripcion_subcomunidad": descripcionController.text,
      /*"fk_comunidad": widget.subcomunidad.idSubComunidad == '0'
          ? widget.subcomunidad.idComunidad
          : '0',*/
      "fk_comunidad": widget.subcomunidad.idComunidad,
      "id_subcomunidad_padre": widget.subcomunidad.idSubComunidad
    });
    if (result.ok) {
      var result2 = await httpGet('subcomunidad_usuario/ultima_subcomunidad');
      if (result2.ok) {
        var inSubcomunidades = result2.data as List<dynamic>;
        inSubcomunidades.forEach((inSubcomunidad) {
          subcomunidades.add(SubComunidad(
            inSubcomunidad['id_subcomunidad'].toString(),
            inSubcomunidad['nombre_subcomunidad'],
            inSubcomunidad['descripcion_subcomunidad'],
            inSubcomunidad['fk_comunidad'].toString(),
          ));
        });

        var result3 = await httpPost("crear_comuser", {
          "pk_subcomunidad": inSubcomunidades[0]["id_subcomunidad"],
          "pk_usuario": sharedPreferences.getInt("id_usuario"),
        });
        if (result3.ok) {
          setState(() {
            response = result.data['status'];
            Navigator.of(context).pop();
          });
        }
      }
    }
  }

  modificarSubComunidad(context) async {
    //String file = base64Encode(_image.readAsBytesSync());

    var result = await httpPut("modificar_subcomunidad", {
      "nombre_subcomunidad": nombreController.text,
      "descripcion_subcomunidad": descripcionController.text,
      "id_subcomunidad": widget.subcomunidad.idSubComunidad,
    });
    if (result.ok) {
      if (this.mounted) {
        var snackBar = SnackBar(content: Text('Guardado correctamente'));
        _scaffoldKey.currentState.showSnackBar(snackBar);

        //commonWidget.breadcrumbData.clear();
        new Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(
              context,
              SubComunidad(
                  widget.subcomunidad.idSubComunidad,
                  nombreController.text,
                  descripcionController.text,
                  widget.subcomunidad.idComunidad));
        });
      }
    }
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of3(context);
    if (widget.editar == true) {
      nombreController = new TextEditingController(
          text: widget.subcomunidad.nombreSubComunidad);
      descripcionController = new TextEditingController(
          text: widget.subcomunidad.descripcionSubComunidad);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: BarraApp(
          titulo: widget.editar == true
              ? widget.subcomunidad.nombreSubComunidad
              : 'Crear Grupo'.toUpperCase()),
      body: SingleChildScrollView(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              _getNombre(bloc),
              SizedBox(
                height: 20,
              ),
              _getDescripcion(bloc),
              SizedBox(
                height: 20,
              ),
              _confirmarButton(bloc),
            ],
          ),
        ),
      ),
    );
  }

  _subcomunidad(BuildContext context, Comunidadbloc bloc) {
    print('============================');
    print('Name      : ${bloc.name}');
    print('Last Name : ${bloc.description}');
    print('============================');
    crearSubComunidad();
  }

  _getNombre(Comunidadbloc bloc) {
    return StreamBuilder(
        stream: bloc.nameStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextFormField(
            controller: nombreController,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              errorText: snapshot.error,
              labelText: 'Nombre',
              labelStyle: TextStyle(color: Colors.grey[700]),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400], width: 2.0)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400], width: 2.0)),
            ),
            onChanged: bloc.changeName,
            textInputAction: TextInputAction.next,
          );
        });
  }

  _getDescripcion(Comunidadbloc bloc) {
    return StreamBuilder(
        stream: bloc.descriptionStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextFormField(
            controller: descripcionController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              errorText: snapshot.error,
              labelText: 'Descripción de la subcomunidad',
              labelStyle: TextStyle(color: Colors.grey[700]),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400], width: 2.0)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400], width: 2.0)),
            ),
            onChanged: bloc.changeDescription,
            textInputAction: TextInputAction.done,
          );
        });
  }

  _confirmarButton(Comunidadbloc bloc) {
    return Container(
      //margin: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
          stream: bloc.formValidStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0)),
                // onPressed: () => Navigator.pushNamed(context, 'validacion-page'),
                onPressed: snapshot.hasData
                    ? () => widget.editar == true
                        ? modificarSubComunidad(context)
                        : _subcomunidad(context, bloc)
                    : null,
                padding: EdgeInsets.all(12),
                color: Colors.black,
                child: Text('GUARDAR'.toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: 14.0)),
              ),
            );
          }),
    );
  }

  /*String validateName(String value) {
    if (value.length < 4)
      return 'El nombre debe tener al menos 3 letras';
    else
      return null;
  }
  */
}
