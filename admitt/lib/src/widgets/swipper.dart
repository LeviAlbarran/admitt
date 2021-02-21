import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../constants.dart';
import '../flyer_class.dart';

class CardSwiper extends StatelessWidget {
  final List<String> flyer;
  CardSwiper({@required this.flyer});
  @override
  Widget build(BuildContext context) {

    // _screenSize obtiene el tamano del dispositivo y trabaja en proporcion a la pantalla
    final _screenSize = MediaQuery.of(context).size; 
    return Container(
      width: double.infinity,
      height: _screenSize.height * 0.5,
      child: Swiper(
        itemBuilder: (BuildContext context, int i) {
          return ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.memory(
                base64Decode(flyer[i]),
                fit: BoxFit.cover,
              ));
        },
        itemCount: flyer.length,
        // pagination: SwiperPagination(),
        // control: SwiperControl(
        //   color: grey,
        // ),
        viewportFraction: 0.8,
        scale: 0.9,
        onTap: (i) {},
      ),
    );
  }
}
