import 'package:admitt/src/constants.dart';
import 'package:admitt/src/pages/comuser_class.dart';
import 'package:admitt/src/pages/create/add_subcomunidad_page.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:admitt/src/comunidad_class.dart';
import '../http.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

class SubcomunidadPage extends StatefulWidget {
  Comunidad comunidad;
  SubcomunidadPage({Key key, this.comunidad}) : super(key: key);
  static String tag = 'subcomunidad-page';
  @override
  _SubcomunidadPage createState() => _SubcomunidadPage();
}

class _SubcomunidadPage extends State<SubcomunidadPage> {
  List<SubComunidad> subcomunidades = [];

  Future<void> refreshSubComunidad() async {
    var result =
        await httpGet('subcomunidades/' + widget.comunidad.idComunidad);
    if (result.ok) {
      setState(() {
        subcomunidades.clear();
        var insubComunidades = result.data as List<dynamic>;
        insubComunidades.forEach((inSubcomunidad) {
          subcomunidades.add(SubComunidad(
            inSubcomunidad['id_subcomunidad'].toString(),
            inSubcomunidad['nombre_subcomunidad'],
            inSubcomunidad['descripcion_subcomunidad'],
            inSubcomunidad['fk_comunidad'].toString(),
          ));
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();

    refreshSubComunidad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Subcomunidades"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [pink, hardPink, hardGrey])),
        ),
        actions: <Widget>[
          IconButton(
              color: white,
              icon: Icon(Icons.group_add),
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddSubComunidadPage(subcomunidad: null),
                    ));
                refreshSubComunidad();
              })
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

            // dentro de _mostrarsubComunidades, darle la lista de communidades
            for (var i = 0; i < subcomunidades.length; i++)
              _mostrarsubComunidades(refreshSubComunidad, subcomunidades[i])
          ],
        ),
      ),
    );
  }

  _mostrarsubComunidades(Function nombre, SubComunidad strings) {
    return Column(
      children: <Widget>[
        RefreshIndicator(
          onRefresh: nombre,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListTile(
              title: Text(strings.nombreSubComunidad),
              subtitle: Text(
                strings.descripcionSubComunidad,
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

  verificarMiembro(SubComunidad strings) async {
    List<Comuser> comusers = [];
    await getComuserPertenece(strings.idSubComunidad, comusers);
    if (comusers.isNotEmpty && comusers[0].miembroSubComunidad == 's') {
      Navigator.pushNamed(context, 'subcomunidad-main-page',
          arguments: strings);
    } else {
      Navigator.pushNamed(context, 'solicitud-page', arguments: strings);
    }
  }
}
