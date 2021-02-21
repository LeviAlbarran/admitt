import 'package:admitt/src/constants.dart';
import 'package:admitt/src/pages/comuser_class.dart';
import 'package:admitt/src/pages/subcomunidades_page.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/busqueda.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:admitt/src/comunidad_class.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../http.dart';

class MiComunidadPage extends StatefulWidget {
  const MiComunidadPage({Key key}) : super(key: key);
  static String tag = 'mi-comunidad-page';
  @override
  _MiComunidadPage createState() => _MiComunidadPage();
}

class _MiComunidadPage extends State<MiComunidadPage> {
  SharedPreferences sharedPreferences;
  List<Comunidad> comunidades = [];

  List<Comuser> comusers = [];
  List<String> nombreComunidades = [];

  Future<void> refreshMisComunidades() async {
    sharedPreferences = await SharedPreferences.getInstance();
    List<String> tokenList = sharedPreferences.getString("token").split(' ');
    List<String> token = tokenList[1].split(',');
    String correo = token[0];

    var result = await httpGet('comunidad_usuario/correo/$correo/s');
    if (result.ok) {
      setState(() {
        comunidades.clear();
        nombreComunidades.clear();
        var inComunidades = result.data as List<dynamic>;
        inComunidades.forEach((inComunidad) {
          comunidades.add(Comunidad(
            inComunidad['id_comunidad'].toString(),
            inComunidad['nombre_comunidad'],
            inComunidad['descripcion_comunidad'],
          ));

          nombreComunidades.add(inComunidad['nombre_comunidad']);
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    refreshMisComunidades();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BarraAppComunidad(
        titulo: "Mis comunidades",
      ),
      drawer: MenuLateral(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(height: 10.0),
            Divider(
              thickness: 2,
              color: pink,
            ),

            // dentro de _mostrarComunidades, darle la lista de communidades
            for (var i = 0; i < comunidades.length; i++)
              _mostrarComunidades(refreshMisComunidades, comunidades[i])
          ],
        ),
      ),
    );
  }

  _mostrarComunidades(Function nombre, Comunidad strings) {
    return Column(
      children: <Widget>[
        RefreshIndicator(
          onRefresh: nombre,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListTile(
              title: Text(strings.nombreComunidad),
              subtitle: Text(
                strings.descripcionComunidad,
                textAlign: TextAlign.justify,
              ),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubcomunidadPage(comunidad: strings),
                  )),
              //Navigator.pushNamed(context, 'comunidad-main-page',
              //    arguments: strings),
            ),
          ),
        ),
        Divider(
          thickness: 2,
          color: pink,
        )
      ],
    );
  }
}
