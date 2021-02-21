import 'package:admitt/src/pages/create/add_comunidad_page.dart';
import 'package:admitt/src/pages/comunidad_select_page.dart';
import 'package:admitt/src/pages/comunidades_page.dart';
import 'package:admitt/src/pages/create/add_publicacion.dart';
import 'package:admitt/src/pages/create/add_subcomunidad_page.dart';
import 'package:admitt/src/pages/create/add_comentario.dart';
import 'package:admitt/src/pages/home_page.dart';
import 'package:admitt/src/pages/lista_solicitudes_page.dart';
import 'package:admitt/src/pages/mis_comunidades_page.dart';
import 'package:admitt/src/pages/mis_flyers_page.dart';
import 'package:admitt/src/pages/modificar_flyer_page.dart';
import 'package:admitt/src/pages/muro_page.dart';
import 'package:admitt/src/pages/nav_home_page.dart';
import 'package:admitt/src/pages/navigator_page.dart';
import 'package:admitt/src/pages/perfil_page.dart';
import 'package:admitt/src/pages/subcomunidad_select_page.dart';
import 'package:admitt/src/pages/subcomunidades_page.dart';
import 'package:admitt/src/pages/tabs/Contact_list.dart';
import 'package:admitt/src/pages/tabs/contacto_page.dart';
import 'package:admitt/src/pages/tabs/publicacion_page.dart';
import 'package:admitt/src/pages/usuarios_page.dart';
import 'package:admitt/src/pages/usuarios_subcomunidad_page.dart';
import 'package:admitt/src/pages/validacion_mail_page.dart';
import 'package:admitt/src/pages/grupos.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:flutter/material.dart';

import 'package:admitt/src/pages/create/add_flyer.dart';

import 'package:admitt/src/pages/login_page.dart';
import 'package:admitt/src/pages/create/registro_page.dart';
import 'package:admitt/src/pages/home_page_sv.dart';
import 'package:admitt/src/bloc/provider.dart';
import 'package:admitt/src/pages/usuarios_comunidad_page.dart';
import 'package:admitt/src/pages/ver_mas_flyer_page.dart';
import 'package:admitt/src/pages/ver_mas_flyer_detalle_page.dart';
import 'src/pages/flyer_detalle_page.dart';
import 'src/pages/solicitud_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    RegistroPage.tag: (context) => RegistroPage(),
    ValidacionMailPage.tag: (context) => ValidacionMailPage(),
    HomePage.tag: (context) => HomePage(),
    PerfilPage.tag: (context) => PerfilPage(),
    ComunidadPage.tag: (context) => ComunidadPage(),
    MisFlyerPage.tag: (context) => MisFlyerPage(),
    UsuariosPage.tag: (context) => UsuariosPage(),
    ComunidadMainPage.tag: (context) => ComunidadMainPage(),
    AddComunidadPage.tag: (context) => AddComunidadPage(),
    HomePageSv.tag: (context) => HomePageSv(),
    NavHomePage.tag: (context) => NavHomePage(
          subcomunidad: Grupo('0', 'TODOS', '', 'a', '0', '0'),
        ),
    BottomNavBar.tag: (context) => BottomNavBar(),
    AddFlyerPage.tag: (context) => AddFlyerPage(),
    MiComunidadPage.tag: (context) => MiComunidadPage(),
    UsuariosComunidadPage.tag: (context) => UsuariosComunidadPage(),
    SolicitudPage.tag: (context) => SolicitudPage(),
    Contactlist.tag: (context) => Contactlist(),
    FlyerDetallePage.tag: (context) => FlyerDetallePage(),
    VerMasFlyerPage.tag: (context) => VerMasFlyerPage(),
    VerMasFlyerDetallePage.tag: (context) => VerMasFlyerDetallePage(),
    ListaSolicitudPage.tag: (context) => ListaSolicitudPage(),
    ModificarFlyerPage.tag: (context) => ModificarFlyerPage(),
    SubcomunidadPage.tag: (context) => SubcomunidadPage(),
    AddSubComunidadPage.tag: (context) => AddSubComunidadPage(),
    SubComunidadMainPage.tag: (context) => SubComunidadMainPage(),
    UsuariosSubComunidadPage.tag: (context) => UsuariosSubComunidadPage(
          subcomunidad: null,
        ),
    MuroPage.tag: (context) => MuroPage(),
    AddPublicacionPage.tag: (context) => AddPublicacionPage(),
    AddComentarioPage.tag: (context) => AddComentarioPage(),
  };

  @override
  Widget build(BuildContext context) {
    return Provider(
        child: MaterialApp(
      title: 'Admitt App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      // home: LoginPage(),
      home: BottomNavBar(),
      // home: BodyWidget(),
      routes: routes,
    ));
  }
}
