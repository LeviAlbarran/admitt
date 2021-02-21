import 'package:admitt/src/constants.dart';
import 'package:admitt/src/pages/comuser_class.dart';
import 'package:admitt/src/pages/subcomunidades_page.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:admitt/src/comunidad_class.dart';
import '../http.dart';

class ComunidadPage extends StatefulWidget {
  const ComunidadPage({Key key}) : super(key: key);
  static String tag = 'comunidad-page';
  @override
  _ComunidadPage createState() => _ComunidadPage();
}

class _ComunidadPage extends State<ComunidadPage> {
  List<Comunidad> comunidades = [];

  Future<void> refreshComunidad() async {
    var result = await httpGet('comunidades');
    if (result.ok) {
      setState(() {
        comunidades.clear();
        var inComunidades = result.data as List<dynamic>;
        inComunidades.forEach((inComunidad) {
          comunidades.add(Comunidad(
            inComunidad['id_comunidad'].toString(),
            inComunidad['nombre_comunidad'],
            inComunidad['descripcion_comunidad'],
          ));
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    refreshComunidad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comunidades"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [pink, hardPink, hardGrey])),
        ),
        actions: <Widget>[
          IconButton(
            color: white,
            icon: Icon(Icons.group_add),
            onPressed: () => Navigator.pushNamed(context, 'add-comunidad-page'),
          )
        ],
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
              _mostrarComunidades(refreshComunidad, comunidades[i])
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
              onTap: () => {verificarMiembro(strings)},
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

  verificarMiembro(Comunidad strings) async {
    List<Comuser> comusers = [];
    await getComuserPertenece(strings.idComunidad, comusers);
    //if (comusers.isNotEmpty && comusers[0].miembroSubComunidad == 's') {
    //Navigator.pushNamed(context, 'subcomunidad-page', arguments: strings);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubcomunidadPage(comunidad: strings),
        ));
    /*} else {
      //Navigator.pushNamed(context, 'subcomunidad-page', arguments: strings);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubcomunidadPage(comunidad: strings),
          ));
    }*/
  }
}
