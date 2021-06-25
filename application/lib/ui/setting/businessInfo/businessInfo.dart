import 'package:Favorito/Functions/PopmyPage.dart';
import 'package:Favorito/component/MyOutlineButton.dart';
import 'package:Favorito/component/myTags.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/ui/setting/businessInfo/businessInfoProvider.dart';
import 'package:Favorito/utils/RIKeys.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:provider/provider.dart';

class businessInfo extends StatelessWidget {

  bool isFirst = true;
  SizeManager sm;

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    // data = Provider.of<businessInfoProvider>(context, listen: true);

    return

    Consumer<businessInfoProvider>(builder: (context,data,child){
      return   WillPopScope(
        onWillPop: ()=>poper(data),
        child: Scaffold(
          key: RIKeys.josKeys28,
          backgroundColor: Color(0xfffff4f4),
          appBar: AppBar(
            title: Text("Business Information",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2)),
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed:  ()=>poper(data),
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
                    for (int i = 0; i < data.photos.length; i++)
                      Stack(children: [
                        Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: CachedNetworkImage(
                                height: sm.h(24),
                                width: sm.h(32),
                                placeholder: (context, url) =>
                                    Center(child: CircularProgressIndicator()),
                                imageUrl: data.photos[i].photo.toString(),
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
                            onPressed: () => data.deleteImage(i, context),
                          ),
                        )
                      ])
                  ]),
                ),
                MyOutlineButton(
                  title: "Add more photo",
                  function: () => data.getImage(ImgSource.Gallery, context),
                ),
                Container(
                  decoration: bd1,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16.0),
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(children: [
                    TextFormField(
                      controller: data.controller[0],
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
                        sourceList: data.totalSubCategoriesName,
                        selectedList: data.selectedSubCategoriesName,
                        hint: "Please select Sub category",
                        border: true,
                        directionVeticle: false,
                        refresh: () => data.setNeedSave(true),
                        title: " Sub Category"),
                    MyTags(
                        sourceList: data.totalTagName,
                        selectedList: data.selectedTagName,
                        hint: "Please select Tags",
                        border: true,
                        directionVeticle: false,
                        refresh: () => data.setNeedSave(true),
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
                          itemCount: data.priceRangelist != null
                              ? data.priceRangelist.length
                              : 0,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  data.tapOnRupies(i);
                                },
                                child: Row(children: [
                                  Icon(
                                    data.priceRangelist[i] == data.priceRange
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_unchecked,
                                    color: data.priceRangelist[i] ==
                                        data.priceRange
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                  Text(data.priceRangelist[i],
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: data.priceRangelist[i] ==
                                              data.priceRange
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
                      for (int i = 0; i < data.totalpay.length; i++)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              data.selectPay.contains(data.totalpay[i])
                                  ? data.selectPay.remove(data.totalpay[i])
                                  : data.selectPay.add(data.totalpay[i]);
                              data.setNeedSave(true);
                            },
                            child: Row(children: [
                              Icon(
                                data.selectPay.contains(data.totalpay[i])
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color:
                                data.selectPay.contains(data.totalpay[i])
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                              Text(data.totalpay[i],
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: data.selectPay
                                          .contains(data.totalpay[i])
                                          ? Colors.red
                                          : Colors.grey))
                            ]),
                          ),
                        ),
                      MyTags(
                        sourceList: data.totalAttributeName,
                        selectedList: data.selectAttributeName,
                        hint: "Please select Attributes",
                        title: " Attributes",
                        border: false,
                        refresh: () {
                          data.setNeedSave(true);
                        },
                        directionVeticle: true,
                      ),
                    ]),
                  ]),
                ),
                Visibility(
                  visible: data.getNeedSave(),
                  child: Container(
                      margin: EdgeInsets.only(bottom: sm.w(30)),
                      padding: EdgeInsets.symmetric(
                          horizontal: sm.w(16), vertical: sm.h(2)),
                      child: RoundedButton(
                          clicker: () {
                            data.funSublim(context);
                          },
                          clr: Colors.red,
                          title: data.donetxt)),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  poper(data) {
    if (data.getNeedSave()) {
      PopmyPage(
          cancel: () {
            Navigator.pop(RIKeys.josKeys28.currentContext);
            Navigator.pop(RIKeys.josKeys28.currentContext);

          },
          key: RIKeys.josKeys28,
          save: () {
            data.funSublim(RIKeys.josKeys28.currentContext);
            Navigator.pop(RIKeys.josKeys28.currentContext);
          }).popMe();
    } else
      Navigator.pop(RIKeys.josKeys28.currentContext);


  }
}
