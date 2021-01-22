import 'package:flutter/material.dart';

class MyTextStyle extends TextStyle {
  final Color color;
  final FontWeight fontWeight;
  final double size;
  final String fontFamily;

  const MyTextStyle({
    this.color,
    this.fontWeight,
    this.size,
    this.fontFamily,
  }) : super(
          color: color ?? Colors.black,
          fontWeight: fontWeight ?? FontWeight.normal,
          fontSize: size ?? 14,
          fontFamily: fontFamily ?? 'Gilroy-Regular',
        );
}
// import 'package:flutter/material.dart';

// class Styles {
//   Color clr;
//   Styles([this.clr]);

//   TextStyle stl = TextStyle();
//   stl.color(this.clr);
//   //Bold
//   TextStyle boldS = TextStyle(
//       fontFamily: 'Gilroy-Bold', fontSize: 10, color: clr ?? Colors.black);
//   TextStyle boldM =
//       TextStyle(fontFamily: 'Gilroy-Bold', fontSize: 12, color: Colors.black);
//   TextStyle boldL =
//       TextStyle(fontFamily: 'Gilroy-Bold', fontSize: 14, color: Colors.black);
//   TextStyle boldXL =
//       TextStyle(fontFamily: 'Gilroy-Bold', fontSize: 16, color: Colors.black);
//   TextStyle boldXXL =
//       TextStyle(fontFamily: 'Gilroy-Bold', fontSize: 18, color: Colors.black);
//   TextStyle boldXXXL =
//       TextStyle(fontFamily: 'Gilroy-Bold', fontSize: 20, color: Colors.black);

//   //exBold
//   TextStyle exBoldS = TextStyle(fontFamily: 'Gilroy-ExtraBold', fontSize: 10);
//   TextStyle exBoldM = TextStyle(fontFamily: 'Gilroy-ExtraBold', fontSize: 12);
//   TextStyle exBoldL = TextStyle(fontFamily: 'Gilroy-ExtraBold', fontSize: 14);
//   TextStyle exBoldXL = TextStyle(fontFamily: 'Gilroy-ExtraBold', fontSize: 16);
//   TextStyle exBoldXXL = TextStyle(fontFamily: 'Gilroy-ExtraBold', fontSize: 18);
//   TextStyle exBoldXXXL =
//       TextStyle(fontFamily: 'Gilroy-ExtraBold', fontSize: 20);

//   //Heavy
//   TextStyle heavyS = TextStyle(fontFamily: 'Gilroy-Heavy', fontSize: 10);
//   TextStyle heavyM = TextStyle(fontFamily: 'Gilroy-Heavy', fontSize: 12);
//   TextStyle heavyL = TextStyle(fontFamily: 'Gilroy-Heavy', fontSize: 14);
//   TextStyle heavyXL = TextStyle(fontFamily: 'Gilroy-Heavy', fontSize: 16);
//   TextStyle heavyXXL = TextStyle(fontFamily: 'Gilroy-Heavy', fontSize: 18);
//   TextStyle heavyXXXL = TextStyle(fontFamily: 'Gilroy-Heavy', fontSize: 20);

//   //light
//   TextStyle lightS = TextStyle(fontFamily: 'Gilroy-Light', fontSize: 10);
//   TextStyle lightM = TextStyle(fontFamily: 'Gilroy-Light', fontSize: 12);
//   TextStyle lightL = TextStyle(fontFamily: 'Gilroy-Light', fontSize: 14);
//   TextStyle lightXL = TextStyle(fontFamily: 'Gilroy-Light', fontSize: 16);
//   TextStyle lightXXL = TextStyle(fontFamily: 'Gilroy-Light', fontSize: 18);
//   TextStyle lightXXXL = TextStyle(fontFamily: 'Gilroy-Light', fontSize: 20);

//   //medium
//   TextStyle bmediumS = TextStyle(fontFamily: 'Gilroy-medium', fontSize: 10);
//   TextStyle mediumM = TextStyle(fontFamily: 'Gilroy-medium', fontSize: 12);
//   TextStyle mediumL = TextStyle(fontFamily: 'Gilroy-medium', fontSize: 14);
//   TextStyle mediumXL = TextStyle(fontFamily: 'Gilroy-medium', fontSize: 16);
//   TextStyle mediumXXL = TextStyle(fontFamily: 'Gilroy-medium', fontSize: 18);
//   TextStyle mediumXXXL = TextStyle(fontFamily: 'Gilroy-medium', fontSize: 20);

//   //Regular
//   TextStyle regularS = TextStyle(fontFamily: 'Gilroy-Regular', fontSize: 10);
//   TextStyle regularM = TextStyle(fontFamily: 'Gilroy-Regular', fontSize: 12);
//   TextStyle regularL = TextStyle(fontFamily: 'Gilroy-Regular', fontSize: 14);
//   TextStyle regularXL = TextStyle(fontFamily: 'Gilroy-Regular', fontSize: 16);
//   TextStyle regularXXL = TextStyle(fontFamily: 'Gilroy-Regular', fontSize: 18);
//   TextStyle regularXXXL = TextStyle(fontFamily: 'Gilroy-Regular', fontSize: 20);
// }
