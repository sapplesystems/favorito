import 'package:favorito_user/Function/PopmyPage.dart';
import 'package:favorito_user/component/ImageMaster.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Catlog/CatlogData.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher.dart';

import '../../../utils/Extentions.dart';
class ViewCatlog extends StatefulWidget {
  CatlogData catlogData;
  ViewCatlog({this.catlogData});
  @override
  _ViewCatlogState createState() => _ViewCatlogState();
}

class _ViewCatlogState extends State<ViewCatlog> {
  SizeManager sm;
  List images=[];
  int i=0;
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    images.addAll(widget.catlogData.photos?.split(',')??[""]);
    return Scaffold(

      key: RIKeys.josKeys28,
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
            Stack(
              children: [
                Container(
                    width: sm.w(100),
                    height: sm.h(52),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child:
                          ImageMaster(url: images[i]),
                    )),
                    Positioned(
                      top: sm.h(18),
                      left:0,
                      child: IconButton(icon:Icon(Icons.keyboard_arrow_left,color: myRed,size: 52,),onPressed: (){
                        
                        if(i!=0)
                        setState(() =>--i);
                      },)),
                    Positioned(
                      top: sm.h(18),
                      right: 0,
                      child: IconButton(icon:Icon(Icons.keyboard_arrow_right,color: myRed,size: 52,),onPressed: (){
                        if(i<images.length-1)
                        setState(() =>++i);
                      },)),
              ],
            ),
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
                      "${widget.catlogData?.productUrl??""}",
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
            child: Text('VISIT',style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontWeight: FontWeight.w800,fontSize: 14,letterSpacing: 1.2),),
          ),
        ),
      
        onPressed: ()async {
          String url = widget.catlogData?.productUrl;
          PopmyPage(
            key: RIKeys.josKeys28,
            cancelTxt: 'Discard',
            okayTxt: 'Okay',
            funCancel: ()=>Navigator.pop(context),
            message: "This will lead you to an external website You want to proceed?",
            funOkay: ()async{
              Navigator.pop(context);
await canLaunch(widget.catlogData?.productUrl) 
? await launch(widget.catlogData?.productUrl) : throw 'Could not launch ${widget.catlogData?.productUrl}';
            }
          ).popMe();
           
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
