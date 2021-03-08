import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:flutter_svg/svg.dart';

class highlights extends StatefulWidget {
  @override
  _highlightsState createState() => _highlightsState();
}

class _highlightsState extends State<highlights> {
  List<TextEditingController> controller = [];

  List<File> imgFiles = List();
  List<String> imgUrls = List();
  List<int> imgUrlsId = List();
  TextEditingController ctrlTitle = TextEditingController();
  TextEditingController ctrlDisc = TextEditingController();
  bool _autovalidate = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void initState() {
    getPageData();
    super.initState();
    for (int i = 0; i < 6; i++) controller.add(TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: null,
        actions: [
          IconButton(
            icon: Icon(Icons.error_outline, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Builder(
          builder: (context) => Form(
            key: _formKey,
            autovalidate: _autovalidate,
            child: ListView(
              children: [
                Text("Highlights",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontFamily: 'Gilroy-Bold',
                        letterSpacing: 2)),
                Container(
                  height: sm.h(20),
                  margin: EdgeInsets.symmetric(vertical: sm.h(4)),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      InkWell(
                          onTap: () async {
                            FilePickerResult result = await FilePicker.platform
                                .pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['jpg'],
                                    allowMultiple: true);
                            if (result != null)
                              setState(() => imgFiles.addAll(result.paths
                                  .map((path) => File(path))
                                  .toList()));

                            if (result != null) {
                              PlatformFile file = result.files.first;
                              print(file.name);
                              print(file.bytes);
                              print(file.size);
                              print(file.extension);
                              print(file.path);
                              WebService.highlightImageUpdate(
                                      result.files, context)
                                  .then((value) {
                                if (value.status == "success") {
                                  for (int i = 0; i < value.data.length; i++) {
                                    if (!imgUrlsId.contains(value.data[i].id)) {
                                      imgUrls.add(value.data[i].photo);
                                      imgUrlsId.add(value.data[i].id);
                                    }
                                  }
                                }
                                setState(() {});
                              });
                            }
                          },
                          child: Container(
                            width: sm.h(18),
                            child: Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Padding(
                                    padding: EdgeInsets.all(sm.h(6)),
                                    child: SvgPicture.asset(
                                        'assets/icon/cloud.svg')
                                    // Icon(Icons.cloud_upload_outlined, size: 30)
                                    ),

                                // Padding(
                                //     padding: const EdgeInsets.all(18),
                                //     child: Icon(
                                //       Icons.cloud_upload_outlined,
                                //       size: 30,
                                //     )),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                elevation: 5,
                                margin: EdgeInsets.all(10)),
                          )),
                      for (int i = imgUrls.length - 1; i > 0; i--) //Network
                        Container(
                          width: sm.h(20),
                          child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Image.network(imgUrls[i].toString(),
                                  fit: BoxFit.fill),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              elevation: 5,
                              margin: EdgeInsets.all(10)),
                        )
                    ],
                  ),
                ),
                Container(
                    decoration: bd1,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 40.0),
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: Column(children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: sm.h(1)),
                        child: txtfieldboundry(
                          valid: true,
                          title: "Title",
                          hint: "Enter title of highlights",
                          controller: ctrlTitle,
                          security: false,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: sm.h(1)),
                        child: txtfieldboundry(
                          valid: true,
                          title: "Description",
                          maxLines: 4,
                          hint: "Enter Description highlights",
                          controller: ctrlDisc,
                          security: false,
                        ),
                      ),
                    ])),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: sm.w(16), vertical: sm.h(2)),
                    child: RoundedButton(
                        clicker: () {
                          if (_formKey.currentState.validate()) {
                            _autovalidate = false;
                            WebService.setHighlightData({
                              "highlight_title": ctrlTitle.text,
                              "highlight_desc": ctrlDisc.text
                            }, context)
                                .then((value) {
                              if (value.status == "success")
                                BotToast.showText(text: value.message);
                            });
                          } else {
                            _autovalidate = true;
                          }
                        },
                        clr: Colors.red,
                        title: "Done"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getPageData() async {
    int t = 1;
    BotToast.showLoading(duration: Duration(seconds: t));
    await WebService.getHighlightData(context).then((value) {
      setState(() {
        t = 0;
      });
      if (value.status == "success") {
        for (int i = 0; i < value.data.photos.length; i++) {
          if (!imgUrlsId.contains(value.data.photos[i].id)) {
            imgUrls.add(value.data.photos[i].photo);
            imgUrlsId.add(value.data.photos[i].id);
          }
        }
        ctrlTitle.text = value.data.highlightTitle;
        setState(() => ctrlDisc.text = value.data.highlightDesc);
      }
    });
  }
}
