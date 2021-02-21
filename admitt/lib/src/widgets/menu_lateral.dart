import 'package:admitt/src/constants.dart';
import 'package:admitt/src/http.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuLateral extends StatefulWidget {
  MenuLateral({Key key}) : super(key: key);

  @override
  _MenuLateralState createState() => _MenuLateralState();
}

class _MenuLateralState extends State<MenuLateral> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: white,
      child: ListView(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 40.0,
            child: Image.asset('assets/logo4.jpeg'),
          ),
          ListTile(
            title: Text('Inicio'),
            onTap: () => Navigator.pushNamed(context, 'home-page-sv'),
            leading: Icon(Icons.home),
          ),
          ListTile(
            title: Text('Muro'),
            onTap: () => Navigator.pushNamed(context, 'muro-page'),
            leading: Icon(Icons.comment),
          ),
          ListTile(
            title: Text('Mi Perfil'),
            onTap: () => Navigator.pushNamed(context, 'perfil-page'),
            leading: Icon(Icons.person_pin),
          ),
          ExpansionTile(
            trailing: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: isExpanded ? hardPink : hardGrey,
            ),
            leading: Icon(Icons.supervised_user_circle,
                color: isExpanded ? hardPink : hardGrey),
            title: Text("Comunidades",
                style: TextStyle(color: isExpanded ? hardPink : hardGrey)),
            children: <Widget>[
              ListTile(
                title: Text('Todas las comunidades'),
                onTap: () => Navigator.pushNamed(context, 'comunidad-page'),
                leading: Icon(Icons.people),
              ),
              ListTile(
                title: Text('Mis comunidades'),
                onTap: () => Navigator.pushNamed(context, 'mi-comunidad-page'),
                leading: Icon(Icons.person, color: hardPink),
              ),
            ],
            onExpansionChanged: (bool expanding) =>
                setState(() => this.isExpanded = expanding),
          ),
          ListTile(
            title: Text('Flyers'),
            onTap: () => Navigator.pushNamed(context, 'flyer-page'),
            leading: Icon(Icons.flag),
          ),
          ListTile(
            title: Text('Cerrar Sesión'),
            onTap: () => logout(context),
            leading: Icon(Icons.exit_to_app),
          ),
        ],
      ),
    ));
  }

  logout(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    await httpGet("logout");
    Navigator.pushNamed(context, 'login-page');
  }
}
