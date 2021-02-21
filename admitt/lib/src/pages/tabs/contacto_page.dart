import 'package:admitt/src/bloc/provider.dart';
import 'package:admitt/src/pages/tabs/Contact_list.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';

import '../../comunidad_class.dart';
import '../../constants.dart';
import '../../http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Contacto {
  String idPublicacion;
  String nombreContacto;
  String numeroContacto;
  Contacto(this.idPublicacion, this.nombreContacto, this.numeroContacto);
}

class ContactoPage extends StatefulWidget {
  ContactoPage({@required this.subcomunidad});
  final SubComunidad subcomunidad;
  @override
  _ContactoPageState createState() =>
      _ContactoPageState(subcomunidad: subcomunidad);
}

class _ContactoPageState extends State<ContactoPage> {
  List<Contacto> contactos = [];

  _ContactoPageState({@required this.subcomunidad});
  SubComunidad subcomunidad;

  SharedPreferences sharedPreferences;
  String response = "";

  TextEditingController nombreController = TextEditingController();
  TextEditingController numeroController = TextEditingController();

  crearPublicacion(idSubComunidad) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var result = await httpPost("crear_publicacion", {
      "fk_tipo_publicacion": 3,
      "titulo_publicacion": nombreController.text,
      "descripcion_publicacion": numeroController.text,
      "fk_comunidad_publicacion": idSubComunidad,
      "fk_usuario_publicacion": sharedPreferences.getInt("id_usuario")
    });
    if (result.ok) {
      setState(() {
        response = result.data['status'];
      });
    }
  }

// comentario challa
  Future<void> getContactos(idSubComunidad) async {
    var result = await httpGet('publicaciones/subcomunidad/$idSubComunidad/3');
    if (result.ok) {
      if (this.mounted) {
        setState(() {
          contactos.clear();
          var inContactos = result.data as List<dynamic>;
          inContactos.forEach((inContacto) {
            contactos.add(Contacto(
              inContacto['fk_tipo_publicacion'].toString(),
              inContacto['titulo_publicacion'],
              inContacto['descripcion_publicacion'],
            ));
          });
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getContactos(null);
  }

  Widget build(BuildContext context) {
    final SubComunidad comunidad = ModalRoute.of(context).settings.arguments;
    final bloc = Provider.of5(context);
    final _screenSize = MediaQuery.of(context).size;
    var idSubComunidad = subcomunidad.idSubComunidad;
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        _nombreContacto(bloc),
        SizedBox(
          height: 5.0,
        ),
        _numeroContacto(bloc),
        SizedBox(
          height: 5.0,
        ),
        _butonBar(idSubComunidad, bloc),
        Divider(
          height: 20,
          thickness: 2.0,
          color: hardPink,
        ),
        futuro(idSubComunidad, _screenSize)
      ],
    ));
  }

  _nombreContacto(Contactobloc bloc) {
    return StreamBuilder(
        stream: bloc.nameStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextFormField(
            controller: nombreController,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              errorText: snapshot.error,
              labelText: 'Contacto',
              hintText: "Nombre del contacto",
              labelStyle: TextStyle(color: hardGrey),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: grey, width: 2.0)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: pink, width: 2.0)),
            ),
            onChanged: bloc.changeName,
            textInputAction: TextInputAction.done,
          );
        });
  }

  _numeroContacto(Contactobloc bloc) {
    return StreamBuilder(
        stream: bloc.phoneStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextFormField(
            controller: numeroController,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              errorText: snapshot.error,
              labelText: 'Número',
              hintText: "Teléfono del contacto",
              labelStyle: TextStyle(color: hardGrey),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: grey, width: 2.0)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: pink, width: 2.0)),
            ),
            onChanged: bloc.changePhone,
            textInputAction: TextInputAction.done,
          );
        });
  }

  _butonBar(idSubComunidad, Contactobloc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        _selectButton(bloc),
        SizedBox(
          width: 20.0,
        ),
        _publishButton(idSubComunidad),
      ],
    );
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }

  _navigateAndSelectContact(BuildContext context, Contactobloc bloc) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Contactlist()),
    );
    String infoContacto = result;
    if (result != null) {
      List<String> info = infoContacto?.split("+");
      String numero = info[1]?.replaceAll(' ', '');
      nombreController.text = info[0];
      numeroController.text = '+' + numero;
    } else {
      infoContacto = "";
    }
  }

  _selectButton(Contactobloc bloc) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      // onPressed: () => Navigator.pushNamed(context, 'validacion-page'),
      onPressed: () async {
        final PermissionStatus permissionStatus = await _getPermission();
        if (permissionStatus == PermissionStatus.granted) {
          //se accede a los contactos aqui
          //Navigator.pushNamed(context, 'contactolist-page',arguments: comunidad);
          _navigateAndSelectContact(context, bloc);
        } else {
          //Permisos han sido denegados, por lo que se muestra un dialogo de alerta
          showDialog(
              context: context,
              builder: (BuildContext context) => CupertinoAlertDialog(
                      title: Text('Error de permisos'),
                      content: Text('Por favor habilite el acceso a contactos'),
                      actions: <Widget>[
                        CupertinoDialogAction(
                            child: Text('OK'),
                            onPressed: () => Navigator.of(context).pop())
                      ]));
        }
      },
      padding: EdgeInsets.all(12),
      color: hardPink,
      child: Text('Selecciona un contacto',
          style: TextStyle(color: Colors.white, fontSize: 17.0)),
    );
  }

  _publishButton(idSubComunidad) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      // onPressed: () => Navigator.pushNamed(context, 'validacion-page'),
      onPressed: () {
        crearPublicacion(idSubComunidad);
        nombreController.text;
        numeroController.text;
      },
      padding: EdgeInsets.all(12),
      color: hardPink,
      child: Text('Publicar',
          style: TextStyle(color: Colors.white, fontSize: 17.0)),
    );
  }

  Widget futuro(idSubComunidad, _screenSize) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return SizedBox(
            height: _screenSize.height * 0.5,
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: contactos.length,
              itemBuilder: (context, i) => ListTile(
                  leading: Icon(
                    Icons.person,
                    color: hardPink,
                  ),
                  title: Text(contactos[i].nombreContacto),
                  subtitle: Text(contactos[i].numeroContacto)),
              separatorBuilder: (context, i) => Divider(
                height: 20,
                thickness: 2.0,
                color: hardPink,
              ),
            ));
      },
      future: getContactos(idSubComunidad),
    );
  }
}
