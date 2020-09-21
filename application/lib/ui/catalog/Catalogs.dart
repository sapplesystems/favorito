import 'package:application/model/catalog/CatalogListRequestModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:application/component/roundedButton.dart';
import 'package:transparent_image/transparent_image.dart';

class Catalogs extends StatefulWidget {
  @override
  _CatalogState createState() => _CatalogState();
}

class _CatalogState extends State<Catalogs> {
  List<CatalogListRequestModel> _catalogListdata = [];

  @override
  void initState() {
    CatalogListRequestModel model1 = CatalogListRequestModel();
    model1.title = 'Exteriors';
    model1.imageUrl = 'https://source.unsplash.com/random/400*400';
    _catalogListdata.add(model1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfffff4f4),
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
              color: Color(0xfffff4f4),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                height: context.percentHeight * 75,
                margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
                child: ListView.builder(
                    itemCount: _catalogListdata.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: Container(
                            height: context.percentHeight * 10,
                            width: context.percentWidth * 80,
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
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                            _catalogListdata[index].imageUrl,
                                            height: context.percentHeight * 8,
                                            fit: BoxFit.fill,
                                            width: context.percentHeight * 8),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          _catalogListdata[index].title,
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
                  width: context.percentWidth * 50,
                  child: roundedButton(
                    clicker: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => CreateNotification()));
                    },
                    clr: Colors.red,
                    title: "Create New",
                  ),
                ),
              ),
            ])));
  }
}
