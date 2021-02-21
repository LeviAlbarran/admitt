import 'package:admitt/src/comunidad_class.dart';
import 'package:admitt/src/constants.dart';
import 'package:admitt/src/flyer_class.dart';
import 'package:admitt/src/http.dart';
import 'package:admitt/src/pages/comuser_class.dart';
import 'package:admitt/src/pages/flyer_detalle_page.dart';
import 'package:admitt/src/solicitu_usuario_class.dart';
import 'package:admitt/src/solicitud_class.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:admitt/src/widgets/appbar.dart';
import 'package:admitt/src/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListadoFiltro {
  List<Flyer> publicaciones;
  List<Flyer> flyers;
  ListadoFiltro(this.publicaciones, this.flyers);
}

class ListaFilterPage extends StatefulWidget {
  ListadoFiltro listado;
  ListaFilterPage({Key key, this.listado}) : super(key: key);

  static String tag = 'lista-filter-page';

  @override
  _ListaFilterPage createState() => _ListaFilterPage();
}

class _ListaFilterPage extends State<ListaFilterPage> {
  Widget build(BuildContext context) {
    ListadoFiltro listado = widget.listado;

    return Scaffold(
      appBar: BarraApp(titulo: "Filtrado"),
      //drawer: MenuLateral(),
      body: listado.publicaciones.length > 0 || listado.flyers.length > 0
          ? SingleChildScrollView(
              //physics: NeverScrollableScrollPhysics(),
              child: Flexible(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(bottom: 10),
                color: Colors.grey[300],
                child: Text('Publicaciones'.toUpperCase()),
              ),
              contenedorlistado(listado.publicaciones),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(bottom: 10),
                color: Colors.grey[300],
                child: Text('FLYERS'.toUpperCase()),
              ),
              contenedorlistado(listado.flyers)
            ])))
          : Container(),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  contenedorlistado(listado) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: listado?.length,
      itemBuilder: (context, i) => ListTile(
          trailing: Container(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FlyerDetallePage(
                          esEditable: false, flyer: listado[i]),
                    ));
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FlyerDetallePage(
                                  esEditable: false, flyer: listado[i]),
                            ));
                      }),
                ],
              ),
            ),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FlyerDetallePage(esEditable: false, flyer: listado[i]),
                  ));
            },
            child: Container(
                width: 60,
                height: 60,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: listado[i].imagenFlyer != null
                        ? Image.network(
                            "$PROTOCOL://$DOMAIN/upload/" +
                                listado[i].imagenFlyer,
                            fit: BoxFit.cover,
                            gaplessPlayback: true,
                          )
                        : Container())),
          ),
          title: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FlyerDetallePage(
                          esEditable: false, flyer: listado[i]),
                    ));
              },
              child: Text(listado[i].nombreFlyer)),
          subtitle: Text(listado[i].descripcionFlyer)),
      separatorBuilder: (context, i) => Divider(
        height: 20,
        thickness: 2.0,
        color: Colors.grey[200],
      ),
    );
  }
}
