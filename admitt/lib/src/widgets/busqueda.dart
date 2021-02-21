import 'package:admitt/src/comunidad_class.dart';
import 'package:admitt/src/pages/comuser_class.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:admitt/src/usuario_class.dart';
import 'package:flutter/material.dart';

class Search extends SearchDelegate {
  final List<String> nombreSubComunidad;
  final List<SubComunidad> subcomunidades;
  final List<Comuser> comusers;
  Search(this.nombreSubComunidad, this.subcomunidades, this.comusers);

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
        : suggestionList.addAll(nombreSubComunidad.where(
            (element) => element.toLowerCase().contains(query.toLowerCase()),
          ));

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
            var indice = nombreSubComunidad.indexOf(selectedResult);

            var idSubComunidad = subcomunidades[indice].idSubComunidad;
            bool find = false;
            comusers.forEach((element) {
              if (element.pkSubComunidad == idSubComunidad) {
                //si existe la columna de comuser se ve el estado de la publicacion
                if (element.miembroSubComunidad == 's') {
                  find = true;
                }
              } else
                find = false;
            });

            if (find) {
              Navigator.pushNamed(context, 'subcomunidad-main-page',
                  arguments: subcomunidades[indice]);
            } else {
              Navigator.pushNamed(context, 'solicitud-page',
                  arguments: subcomunidades[indice]);
            }

            showResults(context);
          },
        );
      },
    );
  }
}
