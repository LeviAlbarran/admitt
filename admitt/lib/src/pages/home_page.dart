import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:admitt/src/widgets/swipper.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../constants.dart';

class HomePage extends StatelessWidget {
  final List<String> imgList = [
    "assets/images/auto1.png",
    "assets/images/auto2.png",
    "assets/images/auto3.png",
    "assets/images/bici.png",
  ];
  // Future para la barra de busqueda

  final _nombre = 'Pepito Rey';

  static String tag = 'home-page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BarraApp(titulo: _nombre),
      drawer: MenuLateral(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              for (var i = 0; i < 1; i++) _mostrarCategorias(),
            ],
          ),
        ),
      ),
    );
  }

  _mostrarCategorias() {
    return Column(children: <Widget>[
      ListTile(
        title: Text("Nombre Comunidad"),
      ),
      CardSwiper(
        flyer: imgList,
      ),
      Divider(
        thickness: 2,
        color: pink,
      ),
    ]);
  }

  // _obtenerCategorias() {}
}
