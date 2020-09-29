import 'package:Favorito/model/catalog/CatalogListRequestModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/catalog/NewCatlog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/utils/myColors.dart';

class Catalogs extends StatefulWidget {
  @override
  _CatalogState createState() => _CatalogState();
}

class _CatalogState extends State<Catalogs> {
  CatalogListRequestModel _catalogListdata;

  @override
  void initState() {
    WebService.funGetCatalogs().then((value) {
      setState(() {
        _catalogListdata = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: myBackGround,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Catalogs",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
              color: myBackGround,
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                height: sm.scaledHeight(75),
                margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
                child: ListView.builder(
                    itemCount: _catalogListdata.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: Container(
                            height: sm.scaledHeight(10),
                            width: sm.scaledWidth(80),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            margin: EdgeInsets.symmetric(vertical: 2.0),
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      child: Padding(
                                    padding: EdgeInsets.only(left: 16.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        _catalogListdata.data[index].photo ==
                                                null
                                            ? "https://source.unsplash.com/random/400*400"
                                            : _catalogListdata
                                                .data[index].photo,
                                        height: sm.scaledHeight(8),
                                        fit: BoxFit.fill,
                                        width: sm.scaledHeight(8),
                                      ),
                                    ),
                                  )),
                                  Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          _catalogListdata
                                              .data[index].catalogTitle,
                                        ),
                                      )),
                                  Expanded(
                                    flex: 1,
                                    child: SvgPicture.asset(
                                        'assets/icon/moveToNext.svg'),
                                  ),
                                ],
                              ),
                            )),
                      );
                    }),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: sm.scaledWidth(50),
                  child: roundedButton(
                    clicker: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => NewCatlog()));
                    },
                    clr: Colors.red,
                    title: "Create New",
                  ),
                ),
              ),
            ])));
  }
}
