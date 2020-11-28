import 'package:Favorito/model/catalog/CatlogListModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/catalog/NewCatlog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:transparent_image/transparent_image.dart';

class Catalogs extends StatefulWidget {
  @override
  _CatalogState createState() => _CatalogState();
}

class _CatalogState extends State<Catalogs> {
  CatlogListModel _catalogListdata;

  @override
  void initState() {
    getPageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
        backgroundColor: myBackGround,
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
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: Colors.black),
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewCatlog(null)))
                    .whenComplete(() => getPageData());
              },
            )
          ],
        ),
        body: FutureBuilder<CatlogListModel>(
          future: WebService.funGetCatalogs(context),
          builder:
              (BuildContext context, AsyncSnapshot<CatlogListModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: Text('Please wait its loading...'));
            else {
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));
              else {
                _catalogListdata = snapshot.data;
                return Container(
                  decoration: BoxDecoration(
                    color: myBackGround,
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: sm.scaledHeight(75),
                          margin: EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 32.0),
                          child: ListView.builder(
                              itemCount: _catalogListdata == null
                                  ? 0
                                  : _catalogListdata.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => NewCatlog(
                                                  _catalogListdata
                                                      .data[index])))
                                      .whenComplete(() => getPageData()),
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0))),
                                    child: Container(
                                        height: sm.scaledHeight(10),
                                        width: sm.scaledWidth(80),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border:
                                                Border.all(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0))),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 2.0),
                                        child: Center(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                  child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 16.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child:
                                                      FadeInImage.memoryNetwork(
                                                    placeholder:
                                                        kTransparentImage,
                                                    image: _catalogListdata
                                                                .data[index]
                                                                .photos ==
                                                            null
                                                        ? "https://source.unsplash.com/random/400*400"
                                                        : _catalogListdata
                                                            .data[index].photos
                                                            .split(",")[0],
                                                    width: sm.scaledWidth(20),
                                                  ),
                                                ),
                                              )),
                                              Expanded(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 4.0),
                                                    child: Text(
                                                      _catalogListdata
                                                              .data[index]
                                                              .catalogTitle ??
                                                          "",
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
                                  ),
                                );
                              }),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: sm.scaledWidth(50),
                            child: roundedButton(
                              clicker: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NewCatlog(null)))
                                    .whenComplete(() => getPageData());
                              },
                              clr: Colors.red,
                              title: "Create New",
                            ),
                          ),
                        ),
                      ]),
                );
              }
            }
          },
        ));
  }

  void getPageData() {
    WebService.funGetCatalogs(context)
        .then((value) => setState(() => _catalogListdata = value));
  }
}
