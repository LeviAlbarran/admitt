import 'package:admitt/src/comunidad_class.dart';
import 'package:admitt/src/pages/comuser_class.dart';
import 'package:admitt/src/usuario_class.dart';
import 'package:flutter/material.dart';
import 'package:admitt/src/flyer_class.dart';
import 'package:admitt/src/categoria_class.dart';

class SearchComu extends SearchDelegate {
  // final List<String> nombreComunidad;
  // final List<Comunidad> comunidades;
  // final List<Comuser> comusers;
  final List<Flyer> flyers;
  final List<String> nombreFlyer;
  // final List<String> nombreCategoria;
  // final List<Categoria> categoria;
  SearchComu(this.flyers, this.nombreFlyer);

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  String selectedResult = "";

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResult),
      ),
    );
  }

  List<String> recentList = [];

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionList = [];
    query.isEmpty
        ? suggestionList = recentList
        : suggestionList.addAll(
            nombreFlyer.where(
              (element) => element.toLowerCase().contains(query.toLowerCase())
            ),
          );

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            suggestionList[index],
          ),
          leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
          onTap: () {
            selectedResult = suggestionList[index];
            recentList.add(selectedResult);
            //var indice1 = nombreCategoria.indexOf(selectedResult);
            var indice2 = nombreFlyer.indexOf(selectedResult);

            // var idCategoria = categoria[indice].idCategoria;
            // var idComunidad = comunidades[indice].idComunidad;

            // comusers.forEach((element) {
            //   if (element.pkComunidad == idComunidad) {
            //     //si existe la columna de comuser se ve el estado de la publicacion
            //     if (element.miembroComunidad == 's') {
            //       find = true;
            //     }
            //   } else
            //     find = false;
            // });

              Navigator.pushNamed(context, 'ver-mas-flyer-detalle-page',
                  arguments: flyers[indice2]);
            
            // else {
            //   Navigator.pushNamed(context, 'solicitud-page',
            //       arguments: comunidades[indice]);
            // }

            showResults(context);
          },
        );
      },
    );
  }
}
