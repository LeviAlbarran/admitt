import 'package:admitt/src/Animations/FadeAnimation.dart';
import 'package:admitt/src/pages/grupos2.dart';
import 'package:admitt/src/subcomunidad_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

class _CommonWidget {
  _CommonWidget() {
//    getData();
  }

  List<SubComunidad> breadcrumbData = List<SubComunidad>();

  loadingButton() {
    return Container(
        height: 25,
        width: 25,
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 3.0,
        ));
  }

  List<Widget> listTags(list) {
    List<Widget> response = new List<Widget>();
    if (list.length > 0) {
      var index = 0;
      list.forEach((x) {
        var _data = Container(
            margin: EdgeInsets.only(left: index != 0 ? 3 : 0),
            child: tag(x['titulo'], Colors.redAccent));
        index = index + 1;
        response.add(_data);
      });
    }
    return response;
  }

  Widget messageInfoCard(context, text) {
    return Container(
        margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: Card(
          elevation: 20,
          child: Container(
            height: 90,
            decoration: BoxDecoration(
                border: new Border(
                    left: BorderSide(
              color: Colors.black,
              width: 3.0,
            ))),
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.info_outline),
                Text(
                  '   ' + text,
                  style: TextStyle(fontWeight: FontWeight.w700),
                )
              ],
            ),
          ),
        ));
  }

  Widget tag(text, color) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(50), color: color),
      padding: EdgeInsets.only(right: 7, left: 7, top: 2, bottom: 2),
      child: Text(
        text.toString().toUpperCase(),
        style: TextStyle(
            fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget noData(title) {
    return Container(
      height: 110,
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.info_outline,
              size: 40,
              color: Colors.black,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                alignment: Alignment.center,
                width: 200,
                child: Text(
                  title,
                  maxLines: 5,
                  textAlign: TextAlign.center,
                ))
          ],
        ),
      ),
    );
  }

  Widget inputText(label, placeholder, nombreController, validar, textValidar,
      max, icon, maxLinea) {
    return Container(
      //    padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[200]))),
      child: TextField(
        controller: nombreController,
        keyboardType: TextInputType.text,
        cursorColor: Colors.black,
        maxLength: max,
        maxLines: maxLinea,
        decoration: InputDecoration(
            hintText: placeholder,
            hoverColor: Colors.black,
            fillColor: Colors.black,
            counterText: "",
            errorText: validar ? textValidar : null,
            border: InputBorder.none,
            focusColor: Colors.black,
            labelText: label,
            prefixIcon: Icon(
              icon,
              color: Colors.black,
            ),
            suffixStyle: TextStyle(color: Colors.black),
            hintStyle: TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget button(text, icon, color) {
    return RaisedButton(
      padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
      textColor: Colors.white,
      color: color,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          text.toUpperCase(),
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          width: 10,
        ),
        Icon(
          icon,
          size: 18,
        )
      ]),
      onPressed: () async {
        return;
      },
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
    );
  }

  gradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.black,
        Colors.black,
      ],
    );
  }

  Widget breadcrumb() {
    return Container(
      child: breadcrumbData.length == 0
          ? Container()
          : BreadCrumb(
              items: listadoBreadcrumb(),
              overflow: ScrollableOverflow(
                keepLastDivider: false,
                reverse: false,
                direction: Axis.horizontal,
              ),
              divider: Icon(Icons.chevron_right),
            ),
    );
  }

  List<BreadCrumbItem> listadoBreadcrumb() {
    List<BreadCrumbItem> list = List<BreadCrumbItem>();
    breadcrumbData.forEach((item) {
      list.add(BreadCrumbItem(
          content: Text(
        item.nombreSubComunidad.toUpperCase(),
        style: TextStyle(fontSize: 10),
      )));
    });
    return list;
  }

  Widget title(text, top) {
    return FlexibleSpaceBar(
        centerTitle: false,
        title: Text(
            //top > 85 ?  'LEVI ANDERSON ALBARRAN' : 'Mis Datos',
            top > 120 ? '' : 'Proyectos',
            style: TextStyle(
              color: Colors.white,
              fontSize: top > 85 ? 20 : 20,
            )),
        background: Container(
            decoration: BoxDecoration(gradient: gradient()),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              FadeAnimation(
                0.6,
                Container(
                  margin: EdgeInsets.only(top: 80, left: 20, bottom: 20),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ])));
  }

  Widget inputTextDate(label, placeholder, nombreController, validar,
      textValidar, max, icon, maxLinea) {
    return Container(
      //  padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[200]))),
      child: TextField(
        controller: nombreController,
        keyboardType: TextInputType.text,
        cursorColor: Colors.black,
        maxLength: max,
        maxLines: maxLinea,
        enabled: false,
        decoration: InputDecoration(
            hintText: placeholder,
            hoverColor: Colors.black,
            fillColor: Colors.black,
            counterText: "",
            errorText: validar ? textValidar : null,
            border: InputBorder.none,
            focusColor: Colors.black,
            labelText: label,
            prefixIcon: Icon(
              icon,
              color: Colors.black,
            ),
            suffixStyle: TextStyle(color: Colors.black),
            hintStyle: TextStyle(color: Colors.grey)),
      ),
    );
  }
}

final commonWidget = new _CommonWidget();
