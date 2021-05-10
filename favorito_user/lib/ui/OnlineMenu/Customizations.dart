// import 'package:favorito_user/model/appModel/Menu/Customization.dart/CustomizationModel.dart';
// import 'package:favorito_user/ui/OnlineMenu/MenuHomeProvider.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:provider/provider.dart';
// import '../../utils/Extentions.dart';

// class Customizationd extends StatelessWidget {
//   bool isFirst = true;
//   MenuHomeProvider vaTrue;
//   @override
//   Widget build(BuildContext context) {
//     if (isFirst) {
//       vaTrue = Provider.of<MenuHomeProvider>(context, listen: true);
//       vaTrue.menuTabItemGetCustomization('3');
//     }
//     var va = vaTrue.getCustomizations();
//     return Container(
//         height: 500,
//         margin: EdgeInsets.all(20),
//         child: ListView.builder(
//             shrinkWrap: true,
//             itemCount: va?.length ?? 0,
//             itemBuilder: (context, index) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     va[index].attributeName.toString().capitalize(),
//                     textScaleFactor: 1.2,
//                     style: TextStyle(fontFamily: 'Gilroy-Medium'),
//                   ),
//                   for (int _a = 0;
//                       _a < va[index].customizationOption.length;
//                       _a++)
//                     InkWell(
//                       onTap: () {
//                         vaTrue.cutiomizationSelection(index, _a);
//                       },
//                       child: Container(
//                         height: 34,
//                         padding: const EdgeInsets.only(left: 20),
//                         child: Row(children: [
//                           // Checkbox(
//                           //     value: vaTrue.selectedCustomizetionId.contains(
//                           //         va[index].customizationOption[_a].optionId),
//                           //     onChanged: (_) {}),
//                           Text(va[index].customizationOption[_a].name),
//                         ]),
//                       ),
//                     ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 24),
//                     child: Divider(),
//                   )
//                 ],
//               );
//             }));
//   }
// }
