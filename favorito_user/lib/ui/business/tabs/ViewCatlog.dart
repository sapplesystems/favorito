import 'package:favorito_user/component/ImageMaster.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Catlog/CatlogData.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';

class ViewCatlog extends StatefulWidget {
  CatlogData catlogData;
  ViewCatlog({this.catlogData});
  @override
  _ViewCatlogState createState() => _ViewCatlogState();
}

class _ViewCatlogState extends State<ViewCatlog> {
  SizeManager sm;
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myBackGround,
        elevation: 0,
        title: Text("${widget.catlogData.catalogTitle}"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: sm.w(100),
              height: sm.w(70),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child:
                    ImageMaster(url: widget.catlogData.photos?.split(',')[0]),
              )),
          Divider(),
          Padding(
            padding: EdgeInsets.only(left: 4.0),
            child: Row(children: [
              Text(
                "Price: ",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              Text(
                "\u{20B9}${widget.catlogData?.catalogPrice}",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.w400, fontSize: 16),
              ),
            ]),
          ),
          Padding(
            padding: EdgeInsets.only(left: 4.0),
            child: Row(
              children: [
                Text(
                  "Product Id: ",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                Text(
                  "${widget.catlogData?.productId}",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.w400, fontSize: 16),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 4.0),
            child: Row(
              children: [
                Text(
                  "Url: ",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                Text(
                  "${widget.catlogData?.productUrl}",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.w400, fontSize: 16),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 4.0),
            child: Row(
              children: [
                Text(
                  "Note: ",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                Text(
                  "${widget.catlogData?.catalogDesc}",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.w400, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
