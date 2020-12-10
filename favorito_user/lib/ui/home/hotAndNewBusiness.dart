import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Business/NewBusinessModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/home/myClipRRect.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class HotAndNewBusiness extends StatefulWidget {
  HotAndNewBusiness({Key key}) : super(key: key);

  @override
  _hotAndNewBusinessState createState() => _hotAndNewBusinessState();
}

class _hotAndNewBusinessState extends State<HotAndNewBusiness> {
  NewBusinessModel newBusinessData;
  SizeManager sm;

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return FutureBuilder<NewBusinessModel>(
        future: APIManager.hotAndNewBusiness(context),
        builder:
            (BuildContext context, AsyncSnapshot<NewBusinessModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: Text('Please wait its loading...'));
          else {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else {
              if (newBusinessData != snapshot.data)
                newBusinessData = snapshot.data;
              print(
                  "newBusinessData?.data?.length:${newBusinessData?.data?.length}");
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: newBusinessData?.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        elevation: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              children: [
                                myClipRRect(
                                    image: newBusinessData.data[index].photo,
                                    sm: sm),
                                Positioned(
                                  top: sm.scaledHeight(1),
                                  left: sm.scaledWidth(1),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xfffff6ea),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    width: sm.scaledWidth(18),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.star, color: myOrangeBase),
                                          //here id is used to show but rating need to be
                                          Text(
                                            newBusinessData.data[index].id
                                                .toString(),
                                            style:
                                                TextStyle(color: myOrangeBase),
                                          )
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: sm.scaledWidth(2)),
                              child: Text(
                                  newBusinessData.data[index].businessName,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400)),
                            ),
                            ServicesOfBusiness(sm: sm),
                            Padding(
                              padding: EdgeInsets.only(left: sm.scaledWidth(2)),
                              child: Text(
                                  "${newBusinessData.data[index].distance} km | ${newBusinessData.data[index].townCity}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: sm.scaledWidth(2)),
                              child: Text(
                                  newBusinessData.data[index].businessStatus,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.green)),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
          }
        });
  }
}

class ServicesOfBusiness extends StatelessWidget {
  const ServicesOfBusiness({
    Key key,
    @required this.sm,
  }) : super(key: key);

  final SizeManager sm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: sm.scaledWidth(2)),
      child: Text("Restaurant | Cafe",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
    );
  }
}
