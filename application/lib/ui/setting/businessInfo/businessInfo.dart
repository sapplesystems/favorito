import 'package:Favorito/component/MyOutlineButton.dart';
import 'package:Favorito/component/myTags.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/ui/setting/businessInfo/businessInfoProvider.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:provider/provider.dart';

class businessInfo extends StatelessWidget {
  businessInfoProvider vaTrue;
  bool isFirst = true;
  SizeManager sm;
  @override
  Widget build(BuildContext context) {
    // print("${isFirst}");
    // if (isFirst) {
    sm = SizeManager(context);
    vaTrue = Provider.of<businessInfoProvider>(context, listen: true);
    // vaTrue.getPageData(context);
    // isFirst = false;
    // }

    return Scaffold(
      backgroundColor: Color(0xfffff4f4),
      appBar: AppBar(
        title: Text("Business Information", //businessInformation replace this
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.only(top: sm.h(2), bottom: sm.h(0)),
        child: ListView(
          children: [
            Container(
              height: sm.h(24),
              child: ListView(scrollDirection: Axis.horizontal, children: [
                for (int i = 0; i < vaTrue.photos.length; i++)
                  Stack(children: [
                    Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: CachedNetworkImage(
                            height: sm.h(24),
                            width: sm.h(32),
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            imageUrl: vaTrue.photos[i].photo.toString(),
                            fit: BoxFit.cover),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.all(10)),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        icon: Icon(Icons.delete, color: myRed),
                        onPressed: () => vaTrue.deleteImage(i, context),
                      ),
                    )
                  ])
              ]),
            ),
            MyOutlineButton(
              title: "Add more photo",
              function: () => vaTrue.getImage(ImgSource.Gallery, context),
            ),
            Container(
              decoration: bd1,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16.0),
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: Column(children: [
                TextFormField(
                  controller: vaTrue.controller[0],
                  decoration: InputDecoration(
                      labelText: "Category",
                      labelStyle: Theme.of(context).textTheme.body2,
                      counterText: "",
                      enabled: false,
                      hintText: "Enter Category",
                      hintStyle: Theme.of(context).textTheme.subhead,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: BorderSide())),
                ),

                //this is commented due to tester
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 8),
                //   child: DropdownSearch<String>(
                //     validator: (v) => v == '' ? "required field" : null,
                //     autoValidateMode: AutovalidateMode.onUserInteraction,
                //     mode: Mode.MENU,
                //     key: _keyCategory,
                //     showSelectedItem: true,
                //     selectedItem: controller[0].text,
                //     enabled: false,
                //     // items: catLst != null ? catLst.values.toList() : null,
                //     label: "Category",
                //     hint: "Please Select Category",
                //     onChanged: (value) {
                //       setState(() => controller[0].text = value);
                //     },
                //   ),
                // ),
                MyTags(
                    sourceList: vaTrue.totalSubCategoriesName,
                    selectedList: vaTrue.selectedSubCategoriesName,
                    hint: "Please select Sub category",
                    border: true,
                    directionVeticle: false,
                    refresh: () => vaTrue.setNeedSave(true),
                    title: " Sub Category"),
                MyTags(
                    sourceList: vaTrue.totalTagName,
                    selectedList: vaTrue.selectedTagName,
                    hint: "Please select Tags",
                    border: true,
                    directionVeticle: false,
                    refresh: () => vaTrue.setNeedSave(true),
                    title: "Tags"),
                Row(children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Text(
                        "Select price range",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      ))
                ]),
                SizedBox(
                  height: 52,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: vaTrue.priceRangelist != null
                          ? vaTrue.priceRangelist.length
                          : 0,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              vaTrue.tapOnRupies(i);
                            },
                            child: Row(children: [
                              Icon(
                                vaTrue.priceRangelist[i] == vaTrue.priceRange
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: vaTrue.priceRangelist[i] ==
                                        vaTrue.priceRange
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                              Text(vaTrue.priceRangelist[i],
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: vaTrue.priceRangelist[i] ==
                                              vaTrue.priceRange
                                          ? Colors.red
                                          : Colors.grey))
                            ]),
                          ),
                        );
                      }),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Text(
                        "Select payment method",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      )),
                ),
                Column(children: [
                  for (int i = 0; i < vaTrue.totalpay.length; i++)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          vaTrue.selectPay.contains(vaTrue.totalpay[i])
                              ? vaTrue.selectPay.remove(vaTrue.totalpay[i])
                              : vaTrue.selectPay.add(vaTrue.totalpay[i]);
                          vaTrue.setNeedSave(true);
                        },
                        child: Row(children: [
                          Icon(
                            vaTrue.selectPay.contains(vaTrue.totalpay[i])
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: vaTrue.selectPay.contains(vaTrue.totalpay[i])
                                ? Colors.red
                                : Colors.grey,
                          ),
                          Text(vaTrue.totalpay[i],
                              style: TextStyle(
                                  fontSize: 16,
                                  color: vaTrue.selectPay
                                          .contains(vaTrue.totalpay[i])
                                      ? Colors.red
                                      : Colors.grey))
                        ]),
                      ),
                    ),
                  MyTags(
                    sourceList: vaTrue.totalAttributeName,
                    selectedList: vaTrue.selectAttributeName,
                    hint: "Please select Attributes",
                    title: " Attributes",
                    border: false,
                    refresh: () {
                      vaTrue.setNeedSave(true);
                    },
                    directionVeticle: true,
                  ),
                ]),
              ]),
            ),
            Visibility(
              visible: vaTrue.getNeedSave(),
              child: Container(
                  margin: EdgeInsets.only(bottom: sm.w(30)),
                  padding: EdgeInsets.symmetric(
                      horizontal: sm.w(16), vertical: sm.h(2)),
                  child: RoundedButton(
                      clicker: () {
                        vaTrue.funSublim(context);
                      },
                      clr: Colors.red,
                      title: vaTrue.donetxt)),
            )
          ],
        ),
      ),
    );
  }
}
