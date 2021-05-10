import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/search/BusinessProfileData.dart';
import 'package:favorito_user/model/appModel/search/TrendingBusinessModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:favorito_user/ui/home/ServicesOfBusiness.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import '../../utils/MyString.dart';

class TopRated extends StatefulWidget {
  SizeManager sm;
  TopRated({this.sm});
  @override
  _TopRatedState createState() => _TopRatedState();
}

class _TopRatedState extends State<TopRated> {
  List<BusinessProfileData> data;
  var br = BorderRadius.all(Radius.circular(12));
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: APIManager.topRatedBusiness(context),
      builder: (BuildContext context,
          AsyncSnapshot<TrendingBusinessModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
              child: Text(loading,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 12)));
        else {
          if (snapshot.hasError)
            return Center(child: Text('Error : ${snapshot.error}'));
          else {
            if (data != snapshot.data.data) data = snapshot.data.data;

            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Provider.of<BusinessProfileProvider>(context,
                                  listen: false)
                                ..setBusinessId(data[index].businessId)
                                ..refresh(1);
                              Navigator.of(context)
                                  .pushNamed('/businessProfile');
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: br,
                              ),
                              elevation: 10,
                              child: ClipRRect(
                                borderRadius: br,
                                child: Image.network(
                                  data[index].photo,
                                  height: widget.sm.h(20),
                                  fit: BoxFit.cover,
                                  width: widget.sm.w(28),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: widget.sm.w(2), top: widget.sm.h(1)),
                            child: Text(
                                data[index].businessName.length <= 12
                                    ? data[index].businessName
                                    : data[index]
                                            .businessName
                                            .substring(0, 12) +
                                        '..',
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: widget.sm.w(2)),
                            child: ServicesOfBusiness(
                                sm: widget.sm, data: data[index].subCategory),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: widget.sm.w(1)),
                            child: Row(children: [
                              for (var i = 0; i < data[index].avgRating; i++)
                                Icon(
                                  Icons.star,
                                  color: myRed,
                                  size: widget.sm.h(1.8),
                                )
                            ]),
                          ),
                        ]),
                  );
                });
          }
        }
      },
    );
  }
}
