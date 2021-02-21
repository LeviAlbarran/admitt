import 'dart:convert';

import 'package:admitt/src/flyer_class.dart';
import 'package:admitt/src/http.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:admitt/src/widgets/swipper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../comunidad_class.dart';
import '../../constants.dart';
import '../comunidades_page.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:admitt/src/categoria_class.dart';

class FlyerPage extends StatefulWidget {
  final SubComunidad subcomunidad;
  FlyerPage({@required this.subcomunidad});

  @override
  _FlyerPageState createState() => _FlyerPageState(subcomunidad: subcomunidad);
} // comentario challa

class _FlyerPageState extends State<FlyerPage> {
  final SubComunidad subcomunidad;
  _FlyerPageState({@required this.subcomunidad});
  List<Categoria> categorias = [];
  List<Flyer2> flyers = [];

  Future<void> getCategorias() async {
    var result = await httpGet(
        'categorias/subcomunidad/' + widget.subcomunidad.idSubComunidad);
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

  @override
  void initState() {
    super.initState();
    obtenerFlyer(subcomunidad.idSubComunidad, flyers);
    getCategorias();
  }

  Widget build(BuildContext context) {
    final SubComunidad subcomunidad = ModalRoute.of(context).settings.arguments;
    var idSubComunidad = subcomunidad.idSubComunidad;

    final _screenSize = MediaQuery.of(context).size;
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            RaisedButton(
                child: Text("Agregar",
                    style: TextStyle(color: Colors.white, fontSize: 17.0)),
                color: hardPink,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0)),
                onPressed: () async {
                  await Navigator.pushNamed(context, 'add-flyer-page',
                      arguments: subcomunidad);
                  setState(() {
                    getCategorias();
                  });
                }),
            Divider(
              thickness: 2,
              color: pink,
            ),
            //futuro(idComunidad, _screenSize),
            _mostrarSwipper(idSubComunidad, _screenSize, subcomunidad)
          ],
        ),
      ),
    );
  }

  _mostrarSwipper(idSubComunidad, _screenSize, subcomunidad) {
    return SizedBox(
        height: _screenSize.height * 0.8,
        child: ListView.separated(
            itemCount: categorias.length,
            itemBuilder: (context, index) => Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(categorias[index].nombreCategoria,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    mostrarFlyerCategoria(index, _screenSize, idSubComunidad),
                    SizedBox(
                      height: 10,
                    ),
                    FlatButton(
                      child: Text('Ver todos los flyers'),
                      onPressed: () => Navigator.pushNamed(
                          context, 'ver-mas-flyer-page',
                          arguments: [categorias[index], subcomunidad]),
                      color: hardPink,
                    ),
                    Divider(
                      thickness: 2,
                      color: pink,
                    ),
                  ],
                ),
            separatorBuilder: (context, index) => Divider()));
  }

  List<Widget> getCard(_screenSize, List<Flyer2> list) {
    List<Widget> _arrayCard = new List<Widget>();

    if (list.length > 0) {
      list.forEach((x) {
        var _data = Container(
            width: _screenSize.height * 0.25,
            margin: EdgeInsets.only(right: 10),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  "$PROTOCOL://$DOMAIN/upload/" + x.imagenFlyer,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                )));

        _arrayCard.add(_data);
      });
    }

    return _arrayCard;
  }

  Widget mostrarFlyerCategoria(int i, _screenSize, idSubComunidad) {
    buscarFlyer(idSubComunidad);
    List<Flyer2> lista1 = [];
    if (flyers.isNotEmpty) {
      lista1.clear();
      flyers.forEach((element) {
        if (categorias[i]?.nombreCategoria == element.nombreCategoria) {
          lista1.add(element);
        }
      });
      if (lista1.isNotEmpty) {
        return Container(
            width: double.infinity,
            height: _screenSize.height * 0.25,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: getCard(_screenSize, lista1))

            /*Swiper(
              itemBuilder: (BuildContext context, index) {
                var imagenFlyer = lista1[index].imagenFlyer;
                return ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.memory(
                      imagenFlyer,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    ));
              },
              itemCount: lista1.length,
              pagination: SwiperPagination(),
              control: SwiperControl(
                color: Colors.deepOrange,
              ),
              viewportFraction: 0.8,
              scale: 0.9,
              layout: SwiperLayout.DEFAULT),*/
            );
      }
      return Container(
        width: double.infinity,
        height: _screenSize.height * 0.1,
        child: Align(child: Text('No hay flyer en esta categoría')),
      );
    }

    return Container(
      width: double.infinity,
      height: _screenSize.height * 0.1,
      child: Align(child: Text('No hay flyer en esta categoría')),
    );
  }

  buscarFlyer(idSubComunidad) async {
    await obtenerFlyer(idSubComunidad, flyers);
  }
}
