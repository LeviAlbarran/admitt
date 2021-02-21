import 'package:admitt/src/bloc/provider.dart';
import 'package:admitt/src/pages/usuarios_page.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admitt/src/flyer_class.dart';
import '../../comunidad_class.dart';
import '../../constants.dart';
import '../../http.dart';

// comentario challa
class Publicacion {
  String nombrePublicacion;
  String descripcionPublicacion;
  // String ide_flyer;
  Publicacion(
      // this.ide_flyer,
      this.nombrePublicacion,
      this.descripcionPublicacion);
}

class PublicacionPage extends StatefulWidget {
  PublicacionPage({Key key}) : super(key: key);

  @override
  _PublicacionPageState createState() => _PublicacionPageState();
}

class _PublicacionPageState extends State<PublicacionPage> {
  TextEditingController descripcionController = TextEditingController();
  List<Flyer> flyers = [];
  List<Publicacion> publicaciones = [];
  SharedPreferences sharedPreferences;

  List<String> nombreFlyers = [];

  String dropdownValue;

  Future<void> getFlyer(idSubComunidad) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var idUsuario = sharedPreferences.getInt("id_usuario");
    var result =
        await httpGet('publicaciones/flyer/$idSubComunidad/$idUsuario/1');
    if (result.ok) {
      if (this.mounted) {
        setState(() {
          flyers.clear();
          nombreFlyers.clear();
          var inflyers = result.data as List<dynamic>;
          inflyers.forEach((inflyer) {
            flyers.add(Flyer(
              inflyer['id_publicacion'].toString(),
              inflyer['titulo_publicacion'],
              inflyer['flyer_publicacion'],
              inflyer['nombre_categoria'],
              inflyer['nombre_comunidad'],
              inflyer['descripcion_publicacion'],
              inflyer['cantidad_comentarios'].toString(),
              inflyer['nombre_usuario'],
              inflyer['apellido_usuario'],
              inflyer['id_usuario'].toString(),
            ));
            nombreFlyers.add(inflyer['titulo_publicacion']);
          });
        });
      }
    }
  }

  String response = "";

  crearPublicacion(idSubComunidad) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var idUsuario = sharedPreferences.getInt("id_usuario");
    var result = await httpPost("crear_publicacion", {
      "fk_tipo_publicacion": 2,
      "titulo_publicacion": dropdownValue,
      "descripcion_publicacion": descripcionController.text,
      "fk_subcomunidad_publicacion": idSubComunidad,
      "fk_usuario_publicacion": idUsuario
    });
    if (result.ok) {
      setState(() {
        response = result.data['status'];
      });
    }
  }

  Future<void> getPublicaciones(idSubComunidad) async {
    var result = await httpGet('publicaciones/subcomunidad/$idSubComunidad/2');
    if (result.ok) {
      if (this.mounted) {
        setState(() {
          publicaciones.clear();
          var inPublicaciones = result.data as List<dynamic>;
          inPublicaciones.forEach((inPublicacion) {
            publicaciones.add(Publicacion(
              inPublicacion['titulo_publicacion'],
              inPublicacion['descripcion_publicacion'],
              // inPublicacion['ide_flyer'],
            ));
          });
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getFlyer(null);
    getPublicaciones(null);
  }

  Widget build(BuildContext context) {
    final SubComunidad subComunidad = ModalRoute.of(context).settings.arguments;
    var idSubComunidad = subComunidad.idSubComunidad;
    final _screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          _nombrePublicacion(),
          SizedBox(
            height: 5.0,
          ),
          _butonBar(idSubComunidad),
          Divider(
            height: 20,
            thickness: 2.0,
            color: hardPink,
          ),
          futuroPublicaciones(idSubComunidad, _screenSize)
        ],
      ),
    );
  }

  _nombrePublicacion() {
    return TextFormField(
      controller: descripcionController,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
        labelText: 'Crea tu publicación',
        hintText: "Comenta tu publicacion",
        labelStyle: TextStyle(color: hardGrey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: grey, width: 2.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: hardPink, width: 2.0)),
      ),
      textInputAction: TextInputAction.done,
    );
  }

  _butonBar(idSubComunidad) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        futuroFlyer(idSubComunidad),
        SizedBox(
          width: 20.0,
        ),
        _button(idSubComunidad),
      ],
    );
  }

  _button(idSubComunidad) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      onPressed: () {
        crearPublicacion(idSubComunidad);
        // getPublicaciones();
      },
      padding: EdgeInsets.all(12),
      color: hardPink,
      child: Text('Publicar',
          style: TextStyle(color: Colors.white, fontSize: 17.0)),
    );
  }

  Widget futuroPublicaciones(idSubComunidad, _screenSize) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return SizedBox(
            height: _screenSize.height * 0.5,
            child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: publicaciones.length,
                itemBuilder: (context, i) => ListTile(
                    leading: Icon(
                      Icons.person,
                      color: hardPink,
                    ),
                    title: Text(publicaciones[i].nombrePublicacion),
                    subtitle: Text(publicaciones[i].descripcionPublicacion)),
                separatorBuilder: (context, i) => Divider(
                      height: 20,
                      thickness: 2.0,
                      color: hardPink,
                    )));
      },
      future: getPublicaciones(idSubComunidad),
    );
  }

  Widget futuroFlyer(idSubComunidad) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return DropdownButton<String>(
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          value: dropdownValue,
          hint: Text('Selecciona un flyer'),
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: hardGrey),
          underline: Container(height: 2, color: hardPink),
          items: nombreFlyers.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        );
      },
      future: getFlyer(idSubComunidad),
    );
  }
}
