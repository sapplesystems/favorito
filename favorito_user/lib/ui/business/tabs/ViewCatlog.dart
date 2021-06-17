import 'package:favorito_user/component/ImageMaster.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Catlog/CatlogData.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../../utils/Extentions.dart';
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
        title: Text("${widget.catlogData?.catalogTitle?.capitalize()??''}"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: sm.w(100),
                height: sm.w(100),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child:
                      ImageMaster(url: widget.catlogData.photos?.split(',')?.first??"https://lh3.googleusercontent.com/rQENYi1jRel23C9HlxIP9hK_Efjnl4gRqPYEyHOVdMxOLfMhjsuheu1bMgTZfRjqZ6u4=s85"),
                )),
            Divider(),
            
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22,vertical: 6),
                child: Text(
                  "${widget.catlogData?.catalogTitle.capitalize()}",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.w500, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22,vertical: 6),
                child: Text(
                  "\u{20B9}${widget.catlogData?.catalogPrice}",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.w500, fontSize: 20),
                ),
              ),
           
          Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22,vertical: 6),
            child: Text(
                      "${widget.catlogData?.productUrl}",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontWeight: FontWeight.w400, fontSize: 16),
                    ),
          ),
           
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22,vertical: 6),
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
 Padding(
   padding: const EdgeInsets.all(12.0),
   child: Center(
     child: OutlinedButton(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('BACK',style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontWeight: FontWeight.w800,fontSize: 14,letterSpacing: 1.2),),
          ),
        ),
      
        onPressed: () {
          // sdfsdfs
        },
      ),
   ),
 )
          ],
        ),
      ),
    );
  }
}
