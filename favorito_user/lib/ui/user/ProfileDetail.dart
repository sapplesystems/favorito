import 'package:favorito_user/component/FollowBtn.dart';
import 'package:favorito_user/component/ImageMaster.dart';
import 'package:favorito_user/component/Message.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/user/PersonalInfo/PersonalInfoProvider.dart';
import 'package:favorito_user/ui/user/PersonalInfo/UserAddressProvider.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:provider/provider.dart';

class ProfileMaster extends StatelessWidget {
  Color selectedTab = Colors.black;
  Color deselectedTab = myGrey;
  bool reviewsSelected = false;
  bool photosSelected = true;
  bool favouritesSelected = false;

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
      backgroundColor: Color(0xffF4F6FC),
      appBar: AppBar(
          toolbarHeight: sm.h(5),
          backgroundColor: myAppBarBackground,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop()),
          actions: [
            IconButton(
              icon: Icon(Icons.favorite_outline_outlined, color: Colors.black),
              onPressed: () {},
            )
          ]),
      body: ListView(children: [
        Container(
          height: sm.h(36),
          width: sm.w(100),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Provider.of<UserAddressProvider>(context, listen: false)
                      .getImage(ImgSource.Gallery, RIKeys.josKeys10);
                },
                child: ClipOval(
                  child: Container(
                      height: sm.h(14),
                      width: sm.h(14),
                      decoration: new BoxDecoration(
                          color: Colors.orange, shape: BoxShape.circle),
                      child: ImageMaster(
                          url: Provider.of<UserAddressProvider>(context,
                                  listen: true)
                              .getProfileImage())),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: sm.h(1)),
                child: Text(
                  Provider.of<PersonalInfoProvider>(context, listen: true)
                          .profileModel
                          ?.data
                          ?.detail
                          ?.fullName ??
                      '',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: sm.w(8), vertical: sm.h(1)),
                child: Text(
                  Provider.of<PersonalInfoProvider>(context, listen: true)
                          .profileModel
                          ?.data
                          ?.detail
                          ?.shortDescription ??
                      '',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: myGrey),
                ),
              ),
              Text(
                  Provider.of<UserAddressProvider>(context, listen: true)
                          .getSelectedAddress() ??
                      '',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: myGrey)),
              Padding(
                padding: EdgeInsets.only(top: sm.h(1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Column(
                    //   children: [
                    //     Text("Friends",
                    //         style: TextStyle(fontSize: 10, color: myGrey)),
                    //     Text("650",
                    //         style: TextStyle(
                    //             fontSize: 10,
                    //             color: Colors.black,
                    //             fontWeight: FontWeight.w600))
                    //   ]
                    // ),
                    Column(
                      children: [
                        Text("Followers",
                            style: TextStyle(fontSize: 10, color: myGrey)),
                        Text("380",
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                                fontWeight: FontWeight.w600))
                      ],
                    ),
                    Column(
                      children: [
                        Text("Following",
                            style: TextStyle(fontSize: 10, color: myGrey)),
                        Text("900",
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                                fontWeight: FontWeight.w600))
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: sm.h(1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //FriendBtn(),
                      MessageBtn(txt: 'Follow'),
                      MessageBtn(txt: 'Message')
                    ],
                  ))
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: sm.w(2), vertical: sm.h(2)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                  onTap: () {
                    reviewsSelected = true;
                    photosSelected = false;
                    favouritesSelected = false;
                  },
                  child: Text("Reviews",
                      style: TextStyle(
                          fontSize: 18,
                          color:
                              reviewsSelected ? selectedTab : deselectedTab))),
              InkWell(
                  onTap: () {
                    reviewsSelected = false;
                    photosSelected = true;
                    favouritesSelected = false;
                  },
                  child: Text("Photos",
                      style: TextStyle(
                          fontSize: 18,
                          color:
                              photosSelected ? selectedTab : deselectedTab))),
              InkWell(
                  onTap: () {
                    reviewsSelected = false;
                    photosSelected = false;
                    favouritesSelected = true;
                  },
                  child: Text("Favourites",
                      style: TextStyle(
                          fontSize: 18,
                          color: favouritesSelected
                              ? selectedTab
                              : deselectedTab)))
            ],
          ),
        ),
        reviewsSelected
            ? getReviewsWidget(sm)
            : photosSelected
                ? getPhotosWidget(sm, 51, 6, 3.0, 1.5)
                : getFavouritesWidget(sm)
      ]),
    );
  }

  Widget getPhotosWidget(SizeManager sm, double viewHeight, int noOfItems,
      double tileHeight, double tileWidth) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: sm.w(2)),
      height: sm.h(viewHeight),
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        itemCount: noOfItems,
        itemBuilder: (BuildContext context, int index) => Container(
            width: sm.w(30),
            height: sm.w(30),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        "https://source.unsplash.com/random/600*400")))),
        staggeredTileBuilder: (int index) =>
            StaggeredTile.count(2, index.isEven ? tileHeight : tileWidth),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
    );
  }

  Widget getReviewsWidget(SizeManager sm) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: sm.w(2)),
      height: sm.h(51),
      child: ListView(
        children: [
          for (int i = 0; i < 2; i++)
            Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                elevation: 10,
                child: Padding(
                  padding: EdgeInsets.all(sm.w(2)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              "https://source.unsplash.com/random/40*40",
                              height: sm.h(8),
                              fit: BoxFit.cover,
                              width: sm.h(8),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: sm.w(2)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Cream & Crust",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                Text("Varachha, Surat",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300)),
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: sm.h(1)),
                        child: Row(
                          children: [
                            for (int i = 0; i < 4; i++) Icon(Icons.star),
                            Padding(
                              padding: EdgeInsets.only(left: sm.w(1)),
                              child: Text(
                                "4.0",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "They served best quality food",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w300),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: sm.h(1)),
                        child: getPhotosWidget(sm, 32, 4, 2, 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "12 Jan 2020",
                            style: TextStyle(
                                color: myGrey,
                                fontWeight: FontWeight.w200,
                                fontSize: 12),
                          ),
                          Text(
                            "5 Likes",
                            style: TextStyle(
                                color: myGrey,
                                fontWeight: FontWeight.w200,
                                fontSize: 12),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: sm.h(1)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.thumb_up_outlined),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Like",
                                style: TextStyle(
                                    color: myGrey,
                                    fontWeight: FontWeight.w200,
                                    fontSize: 12),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: sm.w(4)),
                              child: Icon(Icons.share_outlined),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: sm.w(2)),
                                child: Text(
                                  "Share",
                                  style: TextStyle(
                                      color: myGrey,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 12),
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                )),
        ],
      ),
    );
  }

  Widget getFavouritesWidget(SizeManager sm) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: sm.w(2)),
        height: sm.h(51),
        child: ListView(children: [
          for (int i = 0; i < 2; i++)
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              elevation: 10,
              child: Padding(
                padding: EdgeInsets.all(sm.w(2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        "https://source.unsplash.com//40*40",
                        height: sm.h(8),
                        fit: BoxFit.cover,
                        width: sm.h(8),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Cream & Crust",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        Text("Varachha, Surat",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w300)),
                        Row(
                          children: [
                            for (int i = 0; i < 4; i++) Icon(Icons.star),
                            Padding(
                              padding: EdgeInsets.only(left: sm.w(1)),
                              child: Text(
                                "4.0",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    FollowBtn()
                  ],
                ),
              ),
            )
        ]));
  }
}
