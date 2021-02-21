import 'dart:convert';

import 'package:admitt/src/Animations/FadeAnimation.dart';
import 'package:admitt/src/flyer_class.dart';
import 'package:admitt/src/http.dart';
import 'package:admitt/src/pages/flyer_detalle_page.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:admitt/src/widgets/swipper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../comunidad_class.dart';
import '../constants.dart';
import 'comunidades_page.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:admitt/src/categoria_class.dart';

class CategoriaPublicacion {
  String idCategoria;
  String nombreCategoria;
  List<Flyer> publicaciones;
  CategoriaPublicacion(
      this.idCategoria, this.nombreCategoria, this.publicaciones);
}

class FlyerCategorias extends StatefulWidget {
  final SubComunidad subcomunidad;
  FlyerCategorias({@required this.subcomunidad});

  @override
  _FlyerCategoriasState createState() =>
      _FlyerCategoriasState(subcomunidad: subcomunidad);
} // comentario challa

class _FlyerCategoriasState extends State<FlyerCategorias> {
  final SubComunidad subcomunidad;
  _FlyerCategoriasState({@required this.subcomunidad});
  List<CategoriaPublicacion> categorias = [];
  List<Flyer> flyers = [];

  Future<void> getCategorias() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    var idUsuario = sharedPreferences.getInt("id_usuario");
    var result = await httpGet(
        'subcomunidad_usuario_service/publicacion/$idUsuario/1/' +
            widget.subcomunidad.idComunidad +
            '/' +
            widget.subcomunidad.idSubComunidad);
    if (result.ok) {
      if (this.mounted) {
        setState(() {
          categorias.clear();
          var inCategorias = result.data as List<dynamic>;

          final list =
              inCategorias.map((e) => e['nombre_categoria']).toSet().toList();

          list.forEach((inCategoria) {
            var x = inCategorias
                .firstWhere((y) => y['nombre_categoria'] == inCategoria);
            List<Flyer> _publicaciones = List<Flyer>();
            inCategorias.forEach((element) {
              if (element['nombre_categoria'] == inCategoria) {
                _publicaciones.add(Flyer(
                    element['id_publicacion'].toString(),
                    element['titulo_publicacion'],
                    element['flyer_publicacion'],
                    element['nombre_categoria'],
                    element['nombre_subcomunidad'],
                    element['descripcion_publicacion'],
                    null,
                    null,
                    null,
                    null));
              }
            });

            categorias.add(CategoriaPublicacion(x['id_categoria'].toString(),
                x['nombre_categoria'].toString(), _publicaciones));
          });
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    //obtenerFlyer(subcomunidad.idSubComunidad, flyers);
    getCategorias();
  }

  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        widget.subcomunidad.idSubComunidad == '0'
            ? Container()
            : FadeAnimation(
                0.2,
                Container(
                    padding: EdgeInsets.only(left: 15, right: 10),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            child: Text(
                          'FLYERS',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        )),
                        Container(
                            margin:
                                EdgeInsets.only(right: 10, top: 5, bottom: 5),
                            child: RaisedButton(
                                child: Text("AGREGAR FLYER",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10.0)),
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0)),
                                onPressed: () async {
                                  await Navigator.pushNamed(
                                      context, 'add-flyer-page',
                                      arguments: subcomunidad);
                                  setState(() {
                                    getCategorias();
                                  });
                                }))
                      ],
                    )),
              ),

        //futuro(idComunidad, _screenSize),
        Expanded(
          child: _mostrarSwipper(
              widget.subcomunidad.idSubComunidad, _screenSize, subcomunidad),
        ),
      ],
    );
  }

  _mostrarSwipper(idSubComunidad, _screenSize, subcomunidad) {
    return SizedBox(
        height: _screenSize.height,
        child: ListView.separated(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: categorias.length,
            itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.only(top: index == 0 ? 10 : 5, bottom: 5),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(categorias[index].nombreCategoria,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      mostrarFlyerCategoria(
                          index, _screenSize, categorias[index].publicaciones),
                      SizedBox(
                        height: 15,
                      ),
                      /*FlatButton(
                        child: Text(
                          'Ver todos +',
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () => Navigator.pushNamed(
                            context, 'ver-mas-flyer-page',
                            arguments: [categorias[index], subcomunidad]),
                        color: Colors.transparent,
                      ),*/
                    ],
                  ),
                ),
            separatorBuilder: (context, index) => Container()));
  }

  getCard(_screenSize, List<Flyer> list) {
    List<Widget> _arrayCard = new List<Widget>();

    if (list.length > 0) {
      _arrayCard.add(Container(width: 15));
      var i = 0.0;
      list.forEach((x) {
        var _data = FadeAnimation(
          0.2 + i,
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FlyerDetallePage(esEditable: false, flyer: x),
                    ));
                setState(() {});
              },
              child: Stack(children: <Widget>[
                Container(
                    height: _screenSize.height * 0.25,
                    width: _screenSize.height * 0.25,
                    margin: EdgeInsets.only(right: 10),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.network(
                          "$PROTOCOLIMAGE://$DOMAINIMAGE/upload/" +
                              x.imagenFlyer,
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                        ))),
                new Positioned(
                    right: 15.0,
                    top: 5.0,
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.grey, width: 0)),
                      color: Colors.grey[200],
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            left: 5, right: 5, top: 5, bottom: 5),
                        child: Text(
                          x.nombreSubComunidad.toString().toUpperCase(),
                          //maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              fontSize: 7, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )

                    /*RawMaterialButton(
                      constraints:
                          const BoxConstraints(minWidth: 30.0, minHeight: 30.0),
                      onPressed: () {},
                      elevation: 2.0,
                      fillColor: Colors.white,
                      child: Icon(
                        Icons.search,
                        size: 22.0,
                      ),
                      padding: EdgeInsets.all(0),
                      shape: CircleBorder(),
                    )*/
                    ),
                Container(
                  height: _screenSize.height * 0.25,
                  width: _screenSize.height * 0.25,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.8)
                      ],
                    ),
                  ),
                ),
                new Positioned(
                    left: 10.0,
                    bottom: 10.0,
                    child: Text(
                      x.nombreFlyer,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    )),
              ])),
        );
        i = i + 0.15;
        _arrayCard.add(_data);
      });
    }

    return _arrayCard;
  }

  Widget mostrarFlyerCategoria(int i, _screenSize, flyers) {
    //buscarFlyer(idSubComunidad);

    if (flyers.isNotEmpty) {
      return Container(
          width: double.infinity,
          height: _screenSize.height * 0.25,
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: getCard(_screenSize, flyers)));
    }
    return Container(
      width: double.infinity,
      height: _screenSize.height * 0.1,
      child: Align(child: Text('No hay flyer en esta categoría')),
    );
  }

  /*buscarFlyer(idSubComunidad) async {
    await obtenerFlyer(idSubComunidad, flyers);
  }*/
}
