// import 'package:Favorito/config/SizeManager.dart';
// import 'package:Favorito/model/store/OnlineStoreDisplayListModel.dart';
// import 'package:Favorito/ui/menu/MenuSetting.dart';
// import 'package:Favorito/ui/menu/item/NewMenuItem.dart';
// import 'package:Favorito/ui/menu/item/OnlineStoreItem.dart';
// import 'package:Favorito/utils/myColors.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class OnlineStore extends StatefulWidget {
//   @override
//   _OnlineStoreState createState() => _OnlineStoreState();
// }

// class _OnlineStoreState extends State<OnlineStore> {
//   final _mySearchEditController = TextEditingController();

//   Map _dataMap = Map();

//   @override
//   void initState() {
//     initializeValues();
//     super.initState();
//   }

//   void initializeValues() {
//     List<OnlineStoreDisplayListModel> clothingList = [];
//     OnlineStoreDisplayListModel model1 = OnlineStoreDisplayListModel();
//     model1.id = 1;
//     model1.name = "Masala Chana";
//     model1.price = "Rs. 180";
//     model1.isActive = true;
//     OnlineStoreDisplayListModel model2 = OnlineStoreDisplayListModel();
//     model2.id = 2;
//     model2.name = "Masala Chana";
//     model2.price = "Rs. 180";
//     model2.isActive = true;
//     OnlineStoreDisplayListModel model3 = OnlineStoreDisplayListModel();
//     model3.id = 3;
//     model3.name = "Masala Chana";
//     model3.price = "Rs. 180";
//     model3.isActive = true;
//     clothingList.add(model1);
//     clothingList.add(model2);
//     clothingList.add(model3);

//     List<OnlineStoreDisplayListModel> footwearList = [];
//     OnlineStoreDisplayListModel model4 = OnlineStoreDisplayListModel();
//     model4.id = 4;
//     model4.name = "Masala Chana";
//     model4.price = "Rs. 180";
//     model4.isActive = true;
//     OnlineStoreDisplayListModel model5 = OnlineStoreDisplayListModel();
//     model5.id = 5;
//     model5.name = "Masala Chana";
//     model5.price = "Rs. 180";
//     model5.isActive = true;
//     OnlineStoreDisplayListModel model6 = OnlineStoreDisplayListModel();
//     model6.id = 6;
//     model6.name = "Masala Chana";
//     model6.price = "Rs. 180";
//     model6.isActive = true;
//     footwearList.add(model4);
//     footwearList.add(model5);
//     footwearList.add(model6);

//     _dataMap["Clothing"] = clothingList;
//     _dataMap["Footwear"] = footwearList;
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeManager sm = SizeManager(context);
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         iconTheme: IconThemeData(
//           color: Colors.black, //change your color here
//         ),
//         title: Text(
//           "Menu",
//           style: TextStyle(color: Colors.black),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add_circle_outline),
//             onPressed: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => NewMenuItem(
//                             showVeg: snapshot.data.businessType == 3,
//                           )));
//             },
//           ),
//           IconButton(
//               icon: SvgPicture.asset('assets/icon/settingWaitlist.svg',
//                   height: 20),
//               onPressed: () => Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => MenuSetting())))
//         ],
//       ),
//       body: Container(
//         height: sm.h(100),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: TextFormField(
//                 controller: _mySearchEditController,
//                 decoration: InputDecoration(
//                   labelText: "Search Branch",
//                   suffixIcon:
//                       IconButton(icon: Icon(Icons.search), onPressed: () {}),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ListView(
//                 shrinkWrap: true,
//                 children: <Widget>[
//                   Column(children: [
//                     for (var key in _dataMap.keys) _header(key, _dataMap[key]),
//                   ]),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _header(String title, List<OnlineStoreDisplayListModel> childList) {
//     return Column(
//       children: [
//         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           Text(title,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               )),
//           InkWell(
//             child: Text(
//               "Edit",
//               style: TextStyle(color: Colors.red),
//             ),
//           )
//         ]),
//         for (var child in childList)
//           ListTile(
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) =>
//                           OnlineStoreItem(child.id, child.name)));
//             },
//             title: Text(child.name),
//             subtitle: Text(child.price),
//             trailing: Switch(
//               value: child.isActive,
//               onChanged: (value) {
//                 setState(() {
//                   child.isActive = value;
//                 });
//               },
//               activeTrackColor: Colors.grey,
//               activeColor: Colors.red,
//             ),
//           )
//       ],
//     );
//   }
// }
