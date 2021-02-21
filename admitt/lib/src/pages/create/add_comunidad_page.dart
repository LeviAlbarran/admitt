import 'package:admitt/src/bloc/provider.dart';
import 'package:admitt/src/pages/comunidades_page.dart';
import 'package:admitt/src/pages/navigator_page.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:admitt/src/comunidad_class.dart';
import '../../constants.dart';
import '../../http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admitt/src/usuario_class.dart';

class AddComunidadPage extends StatefulWidget {
  static String tag = 'add-comunidad-page';
  @override
  Comunidad comunidad;
  bool editar;
  AddComunidadPage({Key key, this.comunidad, this.editar}) : super(key: key);

  _AddComunidadPageState createState() => _AddComunidadPageState();
}

class _AddComunidadPageState extends State<AddComunidadPage> {
  SharedPreferences sharedPreferences;

  var usuario = getUsuarioData(usuarios);

  TextEditingController nombreController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  String response = "";
  final _formKey = GlobalKey<FormState>();
  List<Comunidad> comunidades = [];

  crearComunidad() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var result = await httpPost("crear_comunidad", {
      "nombre_comunidad": nombreController.text,
      "descripcion_comunidad": descripcionController.text,
      "usuario_creador": sharedPreferences.getInt("id_usuario")
    });
    if (result.ok) {
      var result2 = await httpGet('comunidad_usuario/ultima_comunidad');
      if (result2.ok) {
        var inComunidades = result2.data as List<dynamic>;
        inComunidades.forEach((inComunidad) {
          comunidades.add(Comunidad(
            inComunidad['id_comunidad'].toString(),
            inComunidad['nombre_comunidad'],
            inComunidad['descripcion_comunidad'],
          ));
        });

        setState(() {
          response = result.data['status'];
          Navigator.pop(context);
        });
      }
    }
  }

  modificarComunidad(context) async {
    //String file = base64Encode(_image.readAsBytesSync());

    var result = await httpPut("modificar_comunidad", {
      "nombre_comunidad": nombreController.text,
      "descripcion_comunidad": descripcionController.text,
      "id_comunidad": widget.comunidad.idComunidad,
    });
    if (result.ok) {
      if (this.mounted) {
        var snackBar = SnackBar(content: Text('Guardado correctamente'));
        _scaffoldKey.currentState.showSnackBar(snackBar);

        commonWidget.breadcrumbData.clear();
        new Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => BottomNavBar()),
              (Route<dynamic> route) => false);
        });
      }
    }
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of3(context);
    if (widget.editar == true) {
      nombreController =
          new TextEditingController(text: widget.comunidad.nombreComunidad);
      descripcionController = new TextEditingController(
          text: widget.comunidad.descripcionComunidad);
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: BarraApp(
          titulo: widget.editar == true
              ? widget.comunidad.nombreComunidad
              : 'Crear Comunidad'.toUpperCase()),
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

  _comunidad(BuildContext context, Comunidadbloc bloc) {
    print('============================');
    print('Name      : ${bloc.name}');
    print('Last Name : ${bloc.description}');
    print('============================');
    crearComunidad();
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
              labelText: 'Descripción de la comunidad',
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
    return StreamBuilder(
        stream: bloc.formValidStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            width: MediaQuery.of(context).size.width,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0)),
              // onPressed: () => Navigator.pushNamed(context, 'validacion-page'),
              onPressed: snapshot.hasData
                  ? () => widget.editar == true
                      ? modificarComunidad(context)
                      : _comunidad(context, bloc)
                  : null,
              padding: EdgeInsets.all(12),
              color: Colors.black,
              child: Text('Guardar'.toUpperCase(),
                  style: TextStyle(color: Colors.white, fontSize: 14.0)),
            ),
          );
        });
  }

  /*String validateName(String value) {
    if (value.length < 4)
      return 'El nombre debe tener al menos 3 letras';
    else
      return null;
  }
  */
}
