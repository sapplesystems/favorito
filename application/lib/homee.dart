import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_svg/flutter_svg.dart';

class SampleWidget extends StatefulWidget {
  @override
  _SampleWidgetState createState() => _SampleWidgetState();
}

class _SampleWidgetState extends State<SampleWidget> {
  @override
  Widget build(BuildContext context) {

    return Container(
        width: 414,
        height: 896,

        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        child: Stack(children: <Widget>[
        
          Positioned(
              top: 219,
              left: 15,
              child: SvgPicture.asset('assets/vector.svg',
                  semanticsLabel: 'vector')),
          Positioned(
              top: 219,
              left: 68,
              child: Container(
                  width: 278,
                  height: 224,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                  child: Stack(children: <Widget>[
                    Positioned(
                        top: 202.53695678710938,
                        left: 3.301698684692383,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 192.04481506347656,
                        left: 249.59744262695312,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 63.728763580322266,
                        left: 205.8760986328125,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 192.04481506347656,
                        left: 227.71302795410156,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 102.7816162109375,
                        left: 216.41307067871094,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 198.91123962402344,
                        left: 221.9571990966797,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 198.91123962402344,
                        left: 246.97439575195312,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 7.510147571563721,
                        left: 213.55239868164062,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 22.530441284179688,
                        left: 220.84718322753906,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 28.99509048461914,
                        left: 210.5486602783203,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 46.13365173339844,
                        left: 209.5950927734375,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 0.000003354492264406872,
                        left: 212.44007873535156,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 93.39115142822266,
                        left: 48.26005172729492,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 139.09886169433594,
                        left: 62.61436080932617,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 143.5830535888672,
                        left: 70.53402709960938,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 143.5830535888672,
                        left: 85.97677612304688,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 158.2454833984375,
                        left: 70.53402709960938,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 158.2454833984375,
                        left: 85.97677612304688,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 178.782958984375,
                        left: 97.26255798339844,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 132.0031280517578,
                        left: 119.78388977050781,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 58.462196350097656,
                        left: 30.441024780273438,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 161.45712280273438,
                        left: 122.75369262695312,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 164.17977905273438,
                        left: 122.75369262695312,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 174.82269287109375,
                        left: 122.75369262695312,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 161.45712280273438,
                        left: 127.20846557617188,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 164.17977905273438,
                        left: 127.20846557617188,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 174.82269287109375,
                        left: 127.20846557617188,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 161.45712280273438,
                        left: 136.11801147460938,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 164.17977905273438,
                        left: 136.11801147460938,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 174.82269287109375,
                        left: 136.11801147460938,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 161.45712280273438,
                        left: 140.57281494140625,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 164.17977905273438,
                        left: 140.57281494140625,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 174.82269287109375,
                        left: 140.57281494140625,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 162.56959533691406,
                        left: 143.62551879882812,
                        child: Transform.rotate(
                          angle: 20.656149784542762 * (math.pi / 180),
                          child: SvgPicture.asset('assets/vector.svg',
                              semanticsLabel: 'vector'),
                        )),
                    Positioned(
                        top: 165.1172637939453,
                        left: 144.58575439453125,
                        child: Transform.rotate(
                          angle: 20.656333656283483 * (math.pi / 180),
                          child: SvgPicture.asset('assets/vector.svg',
                              semanticsLabel: 'vector'),
                        )),
                    Positioned(
                        top: 175.0761260986328,
                        left: 148.33941650390625,
                        child: Transform.rotate(
                          angle: 20.65613700233088 * (math.pi / 180),
                          child: SvgPicture.asset('assets/vector.svg',
                              semanticsLabel: 'vector'),
                        )),
                    Positioned(
                        top: 161.45712280273438,
                        left: 194.5249786376953,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 164.17977905273438,
                        left: 194.5249786376953,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 174.82269287109375,
                        left: 194.5249786376953,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 161.45712280273438,
                        left: 189.8227081298828,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 164.17977905273438,
                        left: 189.8227081298828,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 174.82269287109375,
                        left: 189.8227081298828,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 161.45712280273438,
                        left: 185.3679962158203,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 164.17977905273438,
                        left: 185.3679962158203,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 174.82269287109375,
                        left: 185.3679962158203,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 178.66064453125,
                        left: 176.0463409423828,
                        child: Transform.rotate(
                          angle: 69.34790084561534 * (math.pi / 180),
                          child: SvgPicture.asset('assets/vector.svg',
                              semanticsLabel: 'vector'),
                        )),
                    Positioned(
                        top: 166.1539764404297,
                        left: 180.76022338867188,
                        child: Transform.rotate(
                          angle: 69.34801436413503 * (math.pi / 180),
                          child: SvgPicture.asset('assets/vector.svg',
                              semanticsLabel: 'vector'),
                        )),
                    Positioned(
                        top: 176.11297607421875,
                        left: 177.0065155029297,
                        child: Transform.rotate(
                          angle: 69.3474847503013 * (math.pi / 180),
                          child: SvgPicture.asset('assets/vector.svg',
                              semanticsLabel: 'vector'),
                        )),
                    Positioned(
                        top: 179.77305603027344,
                        left: 119.78388977050781,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 161.45712280273438,
                        left: 156.65940856933594,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 165.41725158691406,
                        left: 160.49546813964844,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 132.0031280517578,
                        left: 161.36175537109375,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 145.3687744140625,
                        left: 159.62928771972656,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 65.91722869873047,
                        left: 51.28703689575195,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 80.76802825927734,
                        left: 44.18648147583008,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 49.995994567871094,
                        left: 204.4201202392578,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 32.400909423828125,
                        left: 244.8771209716797,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 94.56150817871094,
                        left: 0,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 99.18441009521484,
                        left: 4.622351169586182,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                    Positioned(
                        top: 110.74141693115234,
                        left: 26.145217895507812,
                        child: SvgPicture.asset('assets/vector.svg',
                            semanticsLabel: 'vector')),
                  ]))),
          Positioned(
              top: -43,
              left: 302,
              child: Container(
                  width: 207,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(35),
                    ),
                    color: Color.fromRGBO(221, 38, 38, 1),
                  ))),
          Positioned(
              top: 788,
              left: 75,
              child: Container(
                  width: 264,
                  height: 62,
                  child: Stack(children: <Widget>[
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: 264,
                            height: 62,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                              color: Color.fromRGBO(221, 38, 38, 1),
                            ))),
                    Positioned(
                        top: 20,
                        left: 109,
                        child: Text(
                          'LOGIN',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontFamily: 'Gilroy-Bold',
                              fontSize: 20,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        )),
                  ]))),
          Positioned(
              top: 506,
              left: 76,
              child: Text(
                'Welcome to Favorito',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Gilroy',
                    fontSize: 25,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 547,
              left: 43,
              child: Text(
                  'Now your business will be in your phone!. Now your business will be in your phone!.NYou can grow your business with this.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromRGBO(153, 150, 163, 1),
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.normal,
                      height: 1))),
          Positioned(
              top: 15,
              left: 344,
              child: Text(
                'Skip',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 678,
              left: 196,
              child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(218, 218, 218, 1),
                    borderRadius: BorderRadius.all(Radius.elliptical(14, 14)),
                  ))),
          Positioned(
              top: 678,
              left: 240,
              child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(218, 218, 218, 1),
                    borderRadius: BorderRadius.all(Radius.elliptical(14, 14)),
                  ))),
          Positioned(
              top: 678,
              left: 129,
              child: Container(
                  width: 37,
                  height: 14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Color.fromRGBO(221, 38, 38, 1),
                  ))),
        ]));
  }
}
