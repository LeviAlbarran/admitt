import 'package:admitt/src/constants.dart';
import 'package:admitt/src/pages/mis_comunidades_page.dart';
import 'package:admitt/src/comunidad_class.dart';
import 'package:admitt/src/pages/tabs/contacto_page.dart';
import 'package:admitt/src/pages/tabs/flyers_usuario_page.dart';
import 'package:admitt/src/pages/tabs/publicacion_page.dart';
import 'package:admitt/src/solicitud_class.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';

class SubComunidadMainPage extends StatefulWidget {
  static String tag = 'subcomunidad-main-page';

  @override
  _SubComunidadMainPage createState() => _SubComunidadMainPage();
}

class _SubComunidadMainPage extends State<SubComunidadMainPage> {
  @override
  Widget build(BuildContext context) {
    final SubComunidad subComunidad = ModalRoute.of(context).settings.arguments;
    return futuro(subComunidad);
  }

  Widget futuro(SubComunidad subcomunidad) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: BarraAppSelect(
              subcomunidad: subcomunidad,
            ),
            drawer: MenuLateral(),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TabBarView(children: [
                FlyerPage(subcomunidad: subcomunidad),
                PublicacionPage(),
                ContactoPage(subcomunidad: subcomunidad),
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
