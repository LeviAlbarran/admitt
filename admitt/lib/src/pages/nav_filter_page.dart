import 'dart:convert';
import 'dart:io';
import 'package:admitt/src/Animations/FadeAnimation.dart';
import 'package:admitt/src/bloc/provider.dart';
import 'package:admitt/src/bloc/validators.dart';
import 'package:admitt/src/flyer_class.dart';
import 'package:admitt/src/pages/lista_filter_page.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../comunidad_class.dart';
import '../constants.dart';
import '../http.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class Categoria {
  String idCategoria;
  String nombreCategoria;
  Categoria(this.idCategoria, this.nombreCategoria);
}

class NavFilterPage extends StatefulWidget {
  SubComunidad subComunidad;
  NavFilterPage({Key key, this.subComunidad}) : super(key: key);

  static String tag = 'nav-filter-page';
  @override
  _NavFilterPageState createState() => _NavFilterPageState();
}

class _NavFilterPageState extends State<NavFilterPage> {
  SharedPreferences sharedPreferences;
  List<Categoria> categorias = [];
  var selectTagMuro = false;
  var selectTagFlyer = false;
  var selectTagGrupo = false;
  File _image;
  String dropdownValueCategoria;
  String dropdownValueComunidad;
  String dropdownValueSubComunidad1;
  String dropdownValueSubComunidad2;
  String dropdownValueSubComunidad3;

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

  List<SubComunidad> subcomunidades = [];
  List<SubComunidad> listSubcomunidades1 = [];
  List<SubComunidad> listSubcomunidades2 = [];
  List<SubComunidad> listSubcomunidades3 = [];
  List<Comunidad> listcomunidades = [];

  Future<void> getcomunidades() async {
    listcomunidades.clear();
    var sharedPreferences = await SharedPreferences.getInstance();
    List<String> tokenList = sharedPreferences.getString("token").split(' ');
    List<String> token = tokenList[1].split(',');
    var idUsuario = sharedPreferences.getInt("id_usuario");
    String correo = token[0];
    var result =
        await httpGet('comunidad_service-v2/comunidad_usuario/correo/$correo/');
    if (result.ok) {
      if (this.mounted) {
        listcomunidades.clear();
        var incomunidades = result.data['data'] as List<dynamic>;
        if (incomunidades.length > 0) {
          incomunidades.forEach((comunidad) async {
            listcomunidades.add(Comunidad(
                comunidad['id_comunidad'].toString(),
                comunidad['nombre_comunidad'],
                comunidad['descripcion_comunidad']));
          });

          setState(() {});
        }
      }
    }
  }

  Future<void> getsubcomunidades(subcomunidadPadre, nivel) async {
    var sharedPreferences = await SharedPreferences.getInstance();

    var idUsuario = sharedPreferences.getInt("id_usuario");
    var result = await httpGet(
        'subcomunidad_service-v2/comunidad_usuario/$idUsuario/' +
            dropdownValueComunidad +
            '/' +
            subcomunidadPadre);
    if (result.ok && result.data['subcomunidades'].length > 0) {
      if (this.mounted) {
        setState(() {
          subcomunidades.clear();
          var insubcomunidades = result.data['subcomunidades'][0]
              ['subcomunidades'] as List<dynamic>;
          if (insubcomunidades.length > 0) {
            insubcomunidades.forEach((inSubcomunidad) {
              var list = inSubcomunidad['subcomunidades'] as List<dynamic>;
              List<SubComunidad> _list = List<SubComunidad>();
              if (list.length > 0) {
                list.forEach((element) {
                  var _sub = SubComunidad(
                      element['id_subcomunidad'].toString(),
                      element['nombre_subcomunidad'],
                      element['descripcion_subcomunidad'],
                      element['fk_comunidad'].toString());

                  _list.add(_sub);
                });
                setState(() {
                  if (nivel == 1) {
                    listSubcomunidades1 = _list;
                  }
                  if (nivel == 2) {
                    listSubcomunidades2 = _list;
                  }
                  if (nivel == 3) {
                    listSubcomunidades3 = _list;
                  }
                });
              }
            });
          }
        });
      }
    }
  }

  Widget alerta() {
    return AlertDialog(
      content: Text('Seleccione donde desea buscar'),
      actions: [
        FlatButton(
            child: Text("Aceptar"), onPressed: () => Navigator.pop(context)),
      ],
    );
  }

  _buscar(idSubComunidad, subcomunidad) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var idUsuario = sharedPreferences.getInt("id_usuario");
    //String file = base64Encode(_image.readAsBytesSync());

    if (selectTagMuro == false && selectTagFlyer == false) {
      showDialog(
          context: context, builder: (_) => alerta(), barrierDismissible: true);

      return;
    }

    var result = await httpPost('subcomunidad_usuario-v2/publicacion', {
      'id_usuario': idUsuario,
      'text_busqueda': descripcionController.text,
      'id_categoria': dropdownValueCategoria,
      'conimagenes': false,
      'muro': selectTagMuro ? '1' : '0',
      'flyer': selectTagFlyer ? '1' : '0',
      'id_subcomunidad': dropdownValueSubComunidad3 != null
          ? dropdownValueSubComunidad3
          : dropdownValueSubComunidad2 != null
              ? dropdownValueSubComunidad2
              : dropdownValueSubComunidad3 != null
                  ? dropdownValueSubComunidad3
                  : '0'
    });

    if (result.ok) {
      if (this.mounted) {
        new Future.delayed(const Duration(seconds: 1), () {
          setState(() async {
            response = result.data['status'];
            List<Flyer> _publicaciones = List<Flyer>();
            List<Flyer> _flyers = List<Flyer>();
            result.data['muro'].forEach((x) {
              _publicaciones.add(Flyer(
                x['id_publicacion'].toString(),
                x['titulo_publicacion'],
                x['flyer_publicacion'],
                x['nombre_categoria'],
                x['nombre_subcomunidad'],
                x['descripcion_publicacion'],
                x['cantidad_comentarios'].toString(),
                x['nombre_usuario'],
                x['apellido_usuario'],
                x['id_usuario'].toString(),
              ));
            });

            result.data['flyer'].forEach((x) {
              _flyers.add(Flyer(
                x['id_publicacion'].toString(),
                x['titulo_publicacion'],
                x['flyer_publicacion'],
                x['nombre_categoria'],
                x['nombre_subcomunidad'],
                x['descripcion_publicacion'],
                x['cantidad_comentarios'].toString(),
                x['nombre_usuario'],
                x['apellido_usuario'],
                x['id_usuario'].toString(),
              ));
            });

            // ListadoFiltro listado = new ListadoFiltro(publicaciones, flyers)
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ListaFilterPage(
                      listado: ListadoFiltro(_publicaciones, _flyers))),
            );
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
    getcomunidades();
  }

  Widget build(BuildContext context) {
    // final Comunidad comunidad = ModalRoute.of(context).settings.arguments;
    final bloc = Provider.of7(context);

    return Scaffold(
      //backgroundColor: Colors.w,
      appBar: AppBar(
        elevation: 1,
        centerTitle: false,
        backgroundColor: Colors.white,
        title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              'BUSCAR',
              style: TextStyle(fontWeight: FontWeight.w800),
            )),
      ),

      body: SingleChildScrollView(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FadeAnimation(0.1, _descripcionInput(bloc)),
            FadeAnimation(0.2, futuroCategoria()),
            FadeAnimation(0.3, futurocomunidad()),
            dropdownValueComunidad == null ||
                    dropdownValueComunidad == '0' ||
                    listSubcomunidades1 == null ||
                    listSubcomunidades1.length == 0
                ? Container()
                : FadeAnimation(0.3, futurosubcomunidad1()),
            dropdownValueSubComunidad1 == null ||
                    dropdownValueSubComunidad1 == '0' ||
                    listSubcomunidades2 == null ||
                    listSubcomunidades2.length == 0
                ? Container()
                : FadeAnimation(0.3, futurosubcomunidad2()),
            dropdownValueSubComunidad2 == null ||
                    dropdownValueSubComunidad2 == '0' ||
                    listSubcomunidades3 == null ||
                    listSubcomunidades3.length == 0
                ? Container()
                : FadeAnimation(0.3, futurosubcomunidad3()),
            FadeAnimation(0.3, boxSeleccionar()),
            FadeAnimation(
                0.4,
                _publish(bloc, widget.subComunidad.subcomunidades,
                    widget.subComunidad))
          ],
        ),
      )),
    );
  }

  _publicar(BuildContext context, Buscarbloc bloc) {
    print('============================');

    print('Last Name : ${bloc.description}');
    print('============================');
  }

  boxSeleccionar() {
    return Container(
        margin: EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
        child: Column(children: [
          Container(
            margin: EdgeInsets.only(bottom: 5),
            alignment: Alignment.bottomLeft,
            child: Text(
              '¿Donde desea buscar?',
              style: TextStyle(color: Colors.grey[800]),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _itemBox('MURO'),
              _itemBox('FLYERS'),
              //_itemBox('GRUPOS')
            ],
          ),
        ]));
  }

  _itemBox(titulo) {
    var selectItem = (titulo == 'MURO' && selectTagMuro) ||
        (titulo == 'FLYERS' && selectTagFlyer) ||
        (titulo == 'GRUPOS' && selectTagGrupo);
    return InkWell(
      onTap: () {
        setState(() {
          if (titulo == 'MURO') {
            selectTagMuro = !selectTagMuro;
          }
          if (titulo == 'FLYERS') {
            selectTagFlyer = !selectTagFlyer;
          }
          if (titulo == 'GRUPOS') {
            selectTagGrupo = !selectTagGrupo;
          }
        });
      },
      child: Container(
        width: 130,
        height: 35,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selectItem ? Colors.black : Colors.black54,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: selectItem ? Colors.greenAccent : Colors.white,
              size: 15,
            ),
            Text(titulo + ' ',
                style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        )),
      ),
    );
  }

  Widget futuroCategoria() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      child: DropdownButton(
        isExpanded: true,
        onChanged: (String newValue) {
          setState(() {
            dropdownValueCategoria = newValue;
          });
        },
        value: dropdownValueCategoria,
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

  Widget futurocomunidad() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      child: DropdownButton(
        isExpanded: true,
        onChanged: (String newValue) {
          setState(() {
            dropdownValueComunidad = newValue;
            listSubcomunidades1.clear();
            listSubcomunidades2.clear();
            listSubcomunidades3.clear();
            dropdownValueSubComunidad1 = null;
            dropdownValueSubComunidad2 = null;
            dropdownValueSubComunidad3 = null;
            getsubcomunidades('0', 1);
          });
        },
        value: dropdownValueComunidad,
        hint: Text('Selecciona una comunidad'),
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.grey[700]),
        underline: Container(
          height: 2,
          color: Colors.grey[400],
        ),
        items: listcomunidades.map<DropdownMenuItem<String>>((Comunidad value) {
          return DropdownMenuItem<String>(
            value: value.idComunidad,
            child: Text(value.nombreComunidad),
          );
        }).toList(),
      ),
    );
  }

  Widget futurosubcomunidad1() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      child: DropdownButton(
        isExpanded: true,
        onChanged: (String newValue) {
          setState(() {
            dropdownValueSubComunidad1 = newValue;
            listSubcomunidades2.clear();
            listSubcomunidades3.clear();
            dropdownValueSubComunidad2 = null;
            dropdownValueSubComunidad3 = null;
            getsubcomunidades(dropdownValueSubComunidad1, 2);
          });
        },
        value: dropdownValueSubComunidad1,
        hint: Text('Todas las subcomunidades'),
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.grey[700]),
        underline: Container(
          height: 2,
          color: Colors.grey[400],
        ),
        items: listSubcomunidades1
            .map<DropdownMenuItem<String>>((SubComunidad value) {
          return DropdownMenuItem<String>(
            value: value.idSubComunidad,
            child: Text(value.nombreSubComunidad),
          );
        }).toList(),
      ),
    );
  }

  Widget futurosubcomunidad2() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      child: DropdownButton(
        isExpanded: true,
        onChanged: (String newValue) {
          setState(() {
            dropdownValueSubComunidad2 = newValue;
            listSubcomunidades3.clear();
            dropdownValueSubComunidad3 = null;
            getsubcomunidades(dropdownValueSubComunidad2, 3);
          });
        },
        value: dropdownValueSubComunidad2,
        hint: Text('Todas las subcomunidades'),
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.grey[700]),
        underline: Container(
          height: 2,
          color: Colors.grey[400],
        ),
        items: listSubcomunidades2
            .map<DropdownMenuItem<String>>((SubComunidad value) {
          return DropdownMenuItem<String>(
            value: value.idSubComunidad,
            child: Text(value.nombreSubComunidad),
          );
        }).toList(),
      ),
    );
  }

  Widget futurosubcomunidad3() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      child: DropdownButton(
        isExpanded: true,
        onChanged: (String newValue) {
          setState(() {
            dropdownValueSubComunidad3 = newValue;
            getsubcomunidades(dropdownValueSubComunidad3, 3);
          });
        },
        value: dropdownValueSubComunidad3,
        hint: Text('Todas las subcomunidades'),
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.grey[700]),
        underline: Container(
          height: 2,
          color: Colors.grey[400],
        ),
        items: listSubcomunidades3
            .map<DropdownMenuItem<String>>((SubComunidad value) {
          return DropdownMenuItem<String>(
            value: value.idSubComunidad,
            child: Text(value.nombreSubComunidad),
          );
        }).toList(),
      ),
    );
  }

  _descripcionInput(Buscarbloc bloc) {
    return Container(
        margin: EdgeInsets.only(top: 30, bottom: 10, left: 20, right: 20),
        child: TextFormField(
          controller: descripcionController,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: 'Buscar por palabra clave',
            hintText: "Buscar por palabra clave",
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
        ));
  }

  _publish(Buscarbloc bloc, idSubComunidad, subcomunidad) {
    return Container(
        margin: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          color: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
          onPressed: () => _buscar(idSubComunidad, subcomunidad),
          padding: EdgeInsets.all(12),
          child: Text('BUSCAR'.toUpperCase(),
              style: TextStyle(color: Colors.white, fontSize: 14.0)),
        ));
  }
}
