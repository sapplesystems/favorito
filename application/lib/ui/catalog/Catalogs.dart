import 'package:Favorito/ui/catalog/CatalogsProvider.dart';
import 'package:Favorito/ui/catalog/NewCatlog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:provider/provider.dart';

class Catalogs extends StatelessWidget {
  CatalogsProvider vaTrue;
  CatalogsProvider vaFalse;
  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    vaTrue = Provider.of<CatalogsProvider>(context, listen: true);
    vaFalse = Provider.of<CatalogsProvider>(context, listen: false);
    if (isFirst) {
      vaTrue.getCatelogList(true, context);
      isFirst = false;
    }
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            title: Text("Catalogs",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontFamily: 'Gilroy-Bold',
                    letterSpacing: .2)),
            // centerTitle: true,
            actions: [
              IconButton(
                  icon: Icon(Icons.add_circle_outline, size: 30),
                  onPressed: () {
                    vaTrue.newCatalogTxt = 'New Catalog';
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewCatlog())).whenComplete(
                        () => vaTrue.getCatelogList(true, context));
                  })
            ]),
        body: RefreshIndicator(
          onRefresh: () async {
            vaTrue.getCatelogList(true, context);
          },
          child: Container(
            margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 2.0),
            child: ListView.builder(
                itemCount: vaTrue.catalogListdata?.data?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      vaTrue.setSelectedCatalog(
                          vaTrue.catalogListdata?.data[index]?.id.toString());
                      vaTrue.newCatalogTxt = 'Edit Catalog';
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => NewCatlog()));
                    },
                    child: Card(
                      child: Container(
                          height: sm.h(10),
                          width: sm.w(80),
                          margin: EdgeInsets.symmetric(vertical: 2.0),
                          child: Center(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        image: DecorationImage(
                                            image: NetworkImage(vaTrue
                                                        .catalogListdata
                                                        ?.data[index]
                                                        ?.photos !=
                                                    null
                                                ? vaTrue.catalogListdata
                                                    ?.data[index]?.photos
                                                    ?.split(',')[0]
                                                : vaTrue.catalogListdata
                                                        ?.data[index]?.photos ??
                                                    ''
                                                        ''),
                                            fit: BoxFit.fill)),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 4.0),
                                          child: Text(vaTrue.catalogListdata
                                                  ?.data[index]?.catalogTitle ??
                                              ''))),
                                  Expanded(
                                      flex: 1,
                                      child: SvgPicture.asset(
                                          'assets/icon/moveToNext.svg')),
                                ]),
                          )),
                    ),
                  );
                }),
          ),
        ));
  }
}
