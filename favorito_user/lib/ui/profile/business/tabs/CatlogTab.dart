import 'package:favorito_user/component/ImageMaster.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Catlog/CatlogModel.dart';
import 'package:favorito_user/model/appModel/search/BusinessProfileData.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/utils/MyString.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CatalogTab extends StatefulWidget {
  BusinessProfileData data;
  CatalogTab({this.data});
  @override
  _CatlogTabState createState() => _CatlogTabState();
}

class _CatlogTabState extends State<CatalogTab> {
  SizeManager sm;
  var fut;
  CatlogModel catlogModel = CatlogModel();

  @override
  void initState() {
    super.initState();
    if (widget?.data != null)
      fut = APIManager.baseUserProfileBusinessCatalogList(
          {"business_id": widget.data.businessId});
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return FutureBuilder<CatlogModel>(
      future: fut,
      builder: (BuildContext context, AsyncSnapshot<CatlogModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: Text(loading));
        else if (snapshot.hasError)
          return Center(child: Text('Error : ${snapshot.error}'));
        else if (catlogModel != snapshot.data) {
          catlogModel = snapshot.data;
          return Container(
              padding: EdgeInsets.all(2),
              child: ListView.builder(
                itemCount: catlogModel.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    // onTap: () => Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => ViewCatlog())),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: Container(
                          height: sm.h(10),
                          width: sm.w(80),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          margin: EdgeInsets.symmetric(vertical: 2.0),
                          child: Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    width: sm.w(20),
                                    height: sm.w(20),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: ImageMaster(
                                          url: catlogModel.data[index].photos
                                              ?.split(',')[0]),

                                      // FadeInImage.memoryNetwork(
                                      //   placeholder: kTransparentImage,
                                      //   image: catlogModel.data[index].photos ==
                                      //           null
                                      //       ? "https://source.unsplash.com/random/400*400"
                                      //       : catlogModel.data[index].photos
                                      //           .split(",")[0],
                                      //   width: sm.w(20),
                                      // ),
                                    )),
                                Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 4.0),
                                      child: Text(
                                        catlogModel.data[index].catalogTitle ??
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
                },
              ));
        }
      },
    );
  }
}
