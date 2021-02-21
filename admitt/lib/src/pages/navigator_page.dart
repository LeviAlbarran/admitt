import 'package:admitt/src/pages/home_page_sv.dart';
import 'package:admitt/src/pages/nav_filter_page.dart';
import 'package:admitt/src/pages/nav_home_page.dart';
import 'package:admitt/src/pages/nav_mis_publicaciones.page.dart';
import 'package:admitt/src/pages/nav_mis_solicitudes_page.dart';
import 'package:admitt/src/pages/perfil_page.dart';
import 'package:admitt/src/pages/solicitud_page.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:admitt/src/pages/grupos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';

class BottomNavBar extends StatefulWidget {
  static String tag = 'navigator-page';

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentTab = 0;
  List<Widget> screens = [
    NavHomePage(
      subcomunidad: Grupo('0', 'TODOS', '', 'a', '0', '0'),
    ),
    NavMisPublicacionPage(),
    NavFilterPage(subComunidad: SubComunidad('0', 'TODOS', '', '0')),
    NavMisSolicitudesPage(),
    PerfilPage(),
  ];

  List<FFNavigationBarItem> itemsPages = [
    FFNavigationBarItem(
      iconData: Icons.home,
      label: 'HOME',
    ),
    FFNavigationBarItem(
      iconData: Icons.create_new_folder,
      label: 'PUBLICADOS',
    ),
    FFNavigationBarItem(
      iconData: Icons.search,
      label: 'BUSCAR',
    ),
    FFNavigationBarItem(
      iconData: Icons.add_circle_outline,
      label: 'SOLICITUDES',
    ),
    FFNavigationBarItem(
      iconData: Icons.person_outline,
      label: 'MI PERFIL',
    ),
  ];

  Widget currentScreen = NavHomePage(
    subcomunidad: Grupo('0', 'TODOS', '', 'a', '0', '0'),
  );
  final PageStorageBucket bucket = PageStorageBucket();
  var selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageStorage(child: currentScreen, bucket: bucket),
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          showSelectedItemShadow: false,
          unselectedItemTextStyle: TextStyle(fontSize: 9),
          selectedItemTextStyle: TextStyle(color: Colors.blue, fontSize: 9),
          barBackgroundColor: Colors.white70,
          selectedItemBorderColor: Colors.black12,
          selectedItemBackgroundColor: Colors.black,
          selectedItemIconColor: Colors.white,
          selectedItemLabelColor: Colors.black,
        ),
        selectedIndex: currentTab,
        onSelectTab: (i) {
          setState(() {
            currentTab = i;
            currentScreen = screens[i];
          });
        },
        items: itemsPages,
      ),
    );
  }
}
