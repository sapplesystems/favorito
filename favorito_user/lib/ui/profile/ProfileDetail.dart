import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProfileDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      theme: NeumorphicThemeData(
          defaultTextColor: myRed,
          accentColor: Colors.grey,
          variantColor: Colors.black38,
          depth: 8,
          intensity: 0.65),
      themeMode: ThemeMode.system,
      child: Material(
        child: NeumorphicBackground(
          child: _ProfileDetail(),
        ),
      ),
    );
  }
}

class _ProfileDetail extends StatefulWidget {
  _ProfileDetailState createState() => _ProfileDetailState();
  Color selectedTab = Colors.black;
  Color deselectedTab = myGrey;
  bool reviewsSelected = false;
  bool photosSelected = true;
  bool favouritesSelected = false;
}

class _ProfileDetailState extends State<_ProfileDetail> {
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
      backgroundColor: myButtonBackground,
      appBar: AppBar(
        toolbarHeight: sm.scaledHeight(5),
        backgroundColor: myAppBarBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black //change your color here
            ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_outline_outlined, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: sm.scaledHeight(33),
            width: sm.scaledWidth(100),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                    width: sm.scaledWidth(25),
                    height: sm.scaledWidth(25),
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(
                                "https://source.unsplash.com/1NiNq7S4-AA/40*40")))),
                Padding(
                  padding: EdgeInsets.only(top: sm.scaledHeight(1)),
                  child: Text(
                    "Jessica Saint",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: sm.scaledWidth(8),
                      vertical: sm.scaledHeight(1)),
                  child: Text(
                    "Business manager at Avadh group of companies and always open for collaborations",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: myGrey,
                    ),
                  ),
                ),
                Text("Surat, Gujrat",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: myGrey)),
                Padding(
                  padding: EdgeInsets.only(top: sm.scaledHeight(1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text("Friends",
                              style: TextStyle(fontSize: 10, color: myGrey)),
                          Text("650",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
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
                    padding: EdgeInsets.only(top: sm.scaledHeight(1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        NeumorphicButton(
                          style: NeumorphicStyle(
                              shape: NeumorphicShape.convex,
                              depth: 4,
                              lightSource: LightSource.topLeft,
                              color: myButtonBackground,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.all(Radius.circular(4)))),
                          margin: EdgeInsets.only(left: sm.scaledWidth(4)),
                          onPressed: () {},
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                          child: Container(
                            width: sm.scaledWidth(24),
                            child: Text(
                              "Add as friend",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, color: myRed),
                            ),
                          ),
                        ),
                        NeumorphicButton(
                          style: NeumorphicStyle(
                              shape: NeumorphicShape.convex,
                              depth: 4,
                              lightSource: LightSource.topLeft,
                              color: myButtonBackground,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.all(Radius.circular(4)))),
                          margin: EdgeInsets.only(left: sm.scaledWidth(4)),
                          onPressed: () {},
                          padding:
                              EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          child: Container(
                            width: sm.scaledWidth(24),
                            child: Text(
                              "Follow",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, color: myRed),
                            ),
                          ),
                        ),
                        NeumorphicButton(
                          style: NeumorphicStyle(
                              shape: NeumorphicShape.convex,
                              depth: 4,
                              lightSource: LightSource.topLeft,
                              color: myButtonBackground,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.all(Radius.circular(4)))),
                          margin: EdgeInsets.only(
                              left: sm.scaledWidth(4),
                              right: sm.scaledWidth(4)),
                          onPressed: () {},
                          padding:
                              EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          child: Container(
                            width: sm.scaledWidth(25),
                            child: Text(
                              "Message",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, color: myRed),
                            ),
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: sm.scaledWidth(2), vertical: sm.scaledHeight(2)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                    onTap: () {
                      widget.reviewsSelected = true;
                      widget.photosSelected = false;
                      widget.favouritesSelected = false;
                      setState(() {});
                    },
                    child: Text("Reviews",
                        style: TextStyle(
                            fontSize: 18,
                            color: widget.reviewsSelected
                                ? widget.selectedTab
                                : widget.deselectedTab))),
                InkWell(
                    onTap: () {
                      widget.reviewsSelected = false;
                      widget.photosSelected = true;
                      widget.favouritesSelected = false;
                      setState(() {});
                    },
                    child: Text("Photos",
                        style: TextStyle(
                            fontSize: 18,
                            color: widget.photosSelected
                                ? widget.selectedTab
                                : widget.deselectedTab))),
                InkWell(
                    onTap: () {
                      widget.reviewsSelected = false;
                      widget.photosSelected = false;
                      widget.favouritesSelected = true;
                      setState(() {});
                    },
                    child: Text("Favourites",
                        style: TextStyle(
                            fontSize: 18,
                            color: widget.favouritesSelected
                                ? widget.selectedTab
                                : widget.deselectedTab)))
              ],
            ),
          ),
          widget.reviewsSelected
              ? getReviewsWidget(sm)
              : widget.photosSelected
                  ? getPhotosWidget(sm, 51, 6, 3.0, 1.5)
                  : getFavouritesWidget(sm),
        ],
      ),
    );
  }

  Widget getPhotosWidget(SizeManager sm, double viewHeight, int noOfItems,
      double tileHeight, double tileWidth) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: sm.scaledWidth(2)),
      height: sm.scaledHeight(viewHeight),
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        itemCount: noOfItems,
        itemBuilder: (BuildContext context, int index) => Container(
            width: sm.scaledWidth(30),
            height: sm.scaledWidth(30),
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
      margin: EdgeInsets.symmetric(horizontal: sm.scaledWidth(2)),
      height: sm.scaledHeight(51),
      child: ListView(
        children: [
          for (int i = 0; i < 2; i++)
            Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                elevation: 10,
                child: Padding(
                  padding: EdgeInsets.all(sm.scaledWidth(2)),
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
                              height: sm.scaledHeight(8),
                              fit: BoxFit.cover,
                              width: sm.scaledHeight(8),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: sm.scaledWidth(2)),
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
                        padding: EdgeInsets.only(top: sm.scaledHeight(1)),
                        child: Row(
                          children: [
                            for (int i = 0; i < 4; i++) Icon(Icons.star),
                            Padding(
                              padding: EdgeInsets.only(left: sm.scaledWidth(1)),
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
                        padding: EdgeInsets.only(top: sm.scaledHeight(1)),
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
                        padding: EdgeInsets.only(top: sm.scaledHeight(1)),
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
                              padding: EdgeInsets.only(left: sm.scaledWidth(4)),
                              child: Icon(Icons.share_outlined),
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.only(left: sm.scaledWidth(2)),
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
        margin: EdgeInsets.symmetric(horizontal: sm.scaledWidth(2)),
        height: sm.scaledHeight(51),
        child: ListView(children: [
          for (int i = 0; i < 2; i++)
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              elevation: 10,
              child: Padding(
                padding: EdgeInsets.all(sm.scaledWidth(2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        "https://source.unsplash.com//40*40",
                        height: sm.scaledHeight(8),
                        fit: BoxFit.cover,
                        width: sm.scaledHeight(8),
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
                              padding: EdgeInsets.only(left: sm.scaledWidth(1)),
                              child: Text(
                                "4.0",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    NeumorphicButton(
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                          depth: 4,
                          lightSource: LightSource.topLeft,
                          color: myButtonBackground,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.all(Radius.circular(4)))),
                      margin: EdgeInsets.only(
                          left: sm.scaledWidth(4), right: sm.scaledWidth(4)),
                      onPressed: () {},
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Container(
                        width: sm.scaledWidth(25),
                        child: Text(
                          "Follow",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, color: myRed),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
        ]));
  }
}
