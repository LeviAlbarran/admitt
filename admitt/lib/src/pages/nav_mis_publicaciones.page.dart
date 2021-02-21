import 'dart:convert';
import 'dart:ui';

import 'package:admitt/src/http.dart';
import 'package:admitt/src/pages/create/add_comentario.dart';
import 'package:admitt/src/pages/flyers_categorias.dart';
import 'package:admitt/src/pages/flyers_subcomunidades.dart';
import 'package:admitt/src/pages/grupos.dart';
import 'package:admitt/src/pages/home_page_sv.dart';
import 'package:admitt/src/pages/lista_solicitudes_page.dart';
import 'package:admitt/src/pages/mis_flyers_page.dart';
import 'package:admitt/src/pages/muro_subcomunidad.dart';
import 'package:admitt/src/pages/tabs/flyers_usuario_page.dart';
import 'package:admitt/src/pages/usuarios_subcomunidad_page.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admitt/src/flyer_class.dart';

import '../constants.dart';

class NavMisPublicacionPage extends StatefulWidget {
  static String tag = 'nav-mis-publicaciones-page';
  @override
  _NavMisPublicacionPageState createState() => _NavMisPublicacionPageState();
}

class _NavMisPublicacionPageState extends State<NavMisPublicacionPage> {
  SharedPreferences sharedPreferences;
  List<Flyer> flyers = [];
  List subcomunidades = [];
  List<Widget> tabs = new List<Widget>();
  List<Widget> tabsView = new List<Widget>();

  int _lengthTabs = 3;

  @override
  void initState() {
    super.initState();
    List<Widget> arrayView = List<Widget>();
    List<Widget> arrayTab = List<Widget>();
    tabs.clear();
    tabsView.clear();

    arrayTab.add(Tab(
      text: 'MURO',
    ));
    arrayView.add(MisFlyerPage(tipoPublicacion: '2'));

    arrayTab.add(Tab(
      text: 'FLYERS',
    ));

    arrayView.add(MisFlyerPage(tipoPublicacion: '1'));

    tabs = arrayTab;
    tabsView = arrayView;
    _lengthTabs = arrayTab.length;
  }

  @override
  Widget build(BuildContext context) {
    TabController _controller;
    return DefaultTabController(
        length: _lengthTabs,
        child: Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              centerTitle: false,
              elevation: 1,
              backgroundColor: Colors.white,
              bottom: TabBar(
                controller: _controller,
                indicatorColor: Colors.white,
                isScrollable: true,
                tabs: tabs,
                unselectedLabelColor: Colors.black54,
                labelColor: Colors.blue,
              ),
              title: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'MIS PUBLICACIONES',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  )),
            ),
            //  drawer: MenuLateral(),
            /*drawer: Drawer(
                child: Container(
              child: Text('data'),
            )),*/
            body: TabBarView(controller: _controller, children: tabsView)));
  }
}
