import 'package:Favorito/model/catalog/CatlogListModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/catalog/NewCatlog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/utils/myColors.dart';

class Catalogs extends StatefulWidget {
  @override
  _CatalogState createState() => _CatalogState();
}

class _CatalogState extends State<Catalogs> {
  CatlogListModel _catalogListdata;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
        appBar: AppBar(
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
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: Colors.black),
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewCatlog(null)))
                    .whenComplete(() {
                  setState(() {});
                });
              },
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await WebService.funGetCatalogs(context)
                .then((value) => setState(() => _catalogListdata = value));
          },
          child: FutureBuilder<CatlogListModel>(
            future: WebService.funGetCatalogs(context),
            builder: (BuildContext context,
                AsyncSnapshot<CatlogListModel> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: Text('Please wait its loading...'));
              else {
                if (snapshot.hasError)
                  return Center(child: Text('Error: ${snapshot.error}'));
                else {
                  _catalogListdata = snapshot.data;
                  return Container(
                    // height: sm.h(90),
                    margin:
                        EdgeInsets.only(left: 16.0, right: 16.0, bottom: 2.0),
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
                                            _catalogListdata.data[index])))
                                .whenComplete(() {
                              setState(() {});
                            }),
                            child: Card(
                              child: Container(
                                  height: sm.h(10),
                                  width: sm.w(80),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0))),
                                  margin: EdgeInsets.symmetric(vertical: 2.0),
                                  child: Center(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 60,
                                          width: 60,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    _catalogListdata.data[index]
                                                            .photos =
                                                        _catalogListdata
                                                                .data[index]
                                                                .photos
                                                                .split(
                                                                    ",")[0] ??
                                                            ''),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 4.0),
                                              child: Text(
                                                _catalogListdata.data[index]
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
                  );
                }
              }
            },
          ),
        ));
  }
}
