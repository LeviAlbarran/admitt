import 'package:admitt/src/subcomunidad_class.dart';
import 'package:admitt/src/flyer_class.dart';
import 'package:admitt/src/http.dart';
import 'package:admitt/src/pages/comuser_class.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/busqueda.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:admitt/src/widgets/swipper.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admitt/src/pages/login_page.dart';
import 'dart:convert';
import 'package:admitt/src/usuario_class.dart';

class HomePageSv extends StatefulWidget {
  @override
  _HomePageSvState createState() => _HomePageSvState();
  static String tag = 'home-page-sv';
}

class _HomePageSvState extends State<HomePageSv> {
  List<Flyer2> flyers = [];
  List<Flyer2> flyer3 = [];
  List<SubComunidad> subcomunidades = [];
  List<String> nombresubComunidades = [];

  Future<void> refreshsubComunidad() async {
    var result = await httpGet('subcomunidades');
    if (result.ok) {
      if (this.mounted) {
        setState(() {
          subcomunidades.clear();
          nombresubComunidades.clear();
          var insubComunidades = result.data as List<dynamic>;
          insubComunidades.forEach((insubComunidad) {
            subcomunidades.add(SubComunidad(
              insubComunidad['id_subcomunidad'].toString(),
              insubComunidad['nombre_subcomunidad'],
              insubComunidad['descripcion_subcomunidad'],
              insubComunidad['fk_comunidad'].toString(),
            ));
            nombresubComunidades.add(insubComunidad['nombre_subcomunidad']);
          });
        });
      }
    }
  }

  SharedPreferences sharedPreferences;
  String email;
  List<Usuario> usuarios = [];
  List<Comuser> comusers = [];
  List<SubComunidad> comuser2 = [];
  List<List<Flyer2>> flyerList = [];
  var indice = 0;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    refreshsubComunidad();
    _obtenerCosas();
    // obtenerResultados();
  }

  checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 2));

    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return futuro();
  }

  Widget futuro() {
    return FutureBuilder(
      builder: (context, snapshot) {
        final size = MediaQuery.of(context).size;
        return Scaffold(
          appBar: usuarios.isNotEmpty
              ? AppBar(
                  title: usuarios.isNotEmpty ? Text('Inicio') : Text(''),
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                        gradient:
                            LinearGradient(colors: [pink, hardPink, hardGrey])),
                  ),
                  actions: <Widget>[
                      IconButton(
                          color: white,
                          icon: Icon(Icons.search),
                          onPressed: () {
                            showSearch(
                                context: context,
                                delegate: Search(nombresubComunidades,
                                    subcomunidades, comusers));
                          })
                    ])
              : null,
          drawer: MenuLateral(),
          body: usuarios.isNotEmpty
              ? SingleChildScrollView(
                  child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 15.0),
                      ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: usuarios.length,
                          itemBuilder: (context, i) => ListTile(
                                leading: Icon(
                                  Icons.person,
                                  color: hardPink,
                                ),
                                title: Text('Bienvenido: ' +
                                    usuarios[i].nombreUsuario +
                                    ' ' +
                                    usuarios[i].apellidoUsuario),
                              ),
                          separatorBuilder: (context, i) => Divider()),
                      Divider(thickness: 2.0, color: hardPink),
                      SizedBox(height: 20.0),
                      for (int i = 0; i < comuser2.length; i++)
                        _mostrarSubComunidadesFlyer(
                            comuser2[i].idSubComunidad, size),
                      SizedBox(height: 50.0),
                    ],
                  ),
                ))
              : Stack(
                  children: <Widget>[
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient:
                              LinearGradient(colors: <Color>[pink, hardPink])),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: size.height * 0.4),
                      child: Column(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.orange,
                            radius: 70.0,
                            child: CircleAvatar(
                              backgroundImage: AssetImage('assets/logo4.jpeg'),
                              backgroundColor: Colors.transparent,
                              radius: 65.0,
                            ),
                          ),
                          SizedBox(
                              height: size.height * 0.1, width: double.infinity)
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
      future: _obtenerCosas(),
    );
  }

  _mostrarSubComunidadesFlyer(idSubComunidad, _screenSize) {
    return SizedBox(
        height: _screenSize.height * 0.8,
        child: ListView.separated(
            itemCount: comuser2.length,
            itemBuilder: (context, index) => Column(
                  children: <Widget>[
                    _definitiva(_screenSize, idSubComunidad),
                  ],
                ),
            separatorBuilder: (context, index) => Divider()));
  }

  _definitiva(size, idSubComunidad) {
    if (comuser2.isNotEmpty) {
      List<SubComunidad> lista1 = [];
      comuser2.forEach((element) {
        lista1.add(element);
      });
      if (lista1.isNotEmpty) {
        return SizedBox(
            height: size.height * 0.7,
            child: ListView.separated(
                itemCount: lista1.length,
                itemBuilder: (context, index) => Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(lista1[index].nombreSubComunidad,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        mostrarFlyer(size, index, lista1),
                        SizedBox(
                          height: 10,
                        ),
                        FlatButton(
                          child: Text('Ir a la subcomunidad'),
                          onPressed: () => Navigator.pushNamed(
                              context, 'subcomunidad-main-page',
                              arguments: lista1[index]),
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
    } else {
      return Column(
        children: <Widget>[Text('Hola')],
      );
    }
    indice = 0;
    return Column(
      children: <Widget>[
        Text('no devuelvo na'),
        SizedBox(
          height: 1.0,
        )
      ],
    );
  }

  List<Widget> getCard(_screenSize, List<Flyer2> list) {
    List<Widget> _arrayCard = new List<Widget>();

    if (list.length > 0) {
      list.forEach((x) {
        var _data = Container(
            padding: EdgeInsets.only(left: 20),
            width: _screenSize.height * 0.25,
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

  Widget mostrarFlyer(_screenSize, i, lista1) {
    List<Flyer2> lista2 = [];

    if (flyers.isNotEmpty) {
      lista2.clear();
      flyers.forEach((element) {
        // element.forEach((element2) {
        if (lista1[i]?.nombreSubComunidad == element.nombreSubComunidad)
          lista2.add(element);
        // });
      });

      return lista2.isNotEmpty
          ? Container(
              width: double.infinity,
              height: _screenSize.height * 0.25,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: getCard(_screenSize, lista2)))
          : Container(
              width: double.infinity,
              height: _screenSize.height * 0.1,
              child: Align(child: Text('No hay flyer en esta subcomunidad')),
            );
    }
    return Container(
      width: double.infinity,
      height: _screenSize.height * 0.1,
      child: Align(child: Text('No hay flyer en esta subcomunidad')),
    );
  }

  _obtenerCosas() async {
    await getUsuarioData(usuarios);
    if (usuarios.isNotEmpty) {
      await getComuser(usuarios, comusers);
      await getSubComunidadUsuarioPertenece(comuser2);
      await obtenerListaFlyer(flyers);
    }
  }
}
