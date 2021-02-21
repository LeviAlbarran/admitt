import 'package:admitt/src/constants.dart';
import 'package:admitt/src/pages/mis_comunidades_page.dart';
import 'package:admitt/src/comunidad_class.dart';
import 'package:admitt/src/pages/tabs/contacto_page.dart';
import 'package:admitt/src/pages/tabs/flyers_usuario_page.dart';
import 'package:admitt/src/pages/tabs/publicacion_page.dart';
import 'package:admitt/src/solicitud_class.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';

class ComunidadMainPage extends StatefulWidget {
  static String tag = 'comunidad-main-page';

  @override
  _ComunidadMainPage createState() => _ComunidadMainPage();
}

class _ComunidadMainPage extends State<ComunidadMainPage> {
  @override
  Widget build(BuildContext context) {
    final Comunidad comunidad = ModalRoute.of(context).settings.arguments;
    return futuro(comunidad);
  }

  Widget futuro(Comunidad comunidad) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: BarraAppSelectComunidad(
              comunidad: comunidad,
            ),
            drawer: MenuLateral(),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TabBarView(children: [
                //FlyerPage(comunidad: comunidad),
                PublicacionPage(),
                //ContactoPage(comunidad: comunidad),
              ]),
            ),
            bottomNavigationBar:
                TabBar(labelColor: hardPink, indicatorColor: hardPink, tabs: [
              Tab(icon: Icon(Icons.store_mall_directory)),
              Tab(icon: Icon(Icons.list)),
              Tab(icon: Icon(Icons.contacts))
            ]),
          ),
        );
      },
      future: futuroDelay(),
    );
  }

  futuroDelay() {
    Future.delayed(Duration(milliseconds: 2500));
  }
}
