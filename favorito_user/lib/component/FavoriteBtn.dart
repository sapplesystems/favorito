import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Relation.dart/relationBase.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class FavoriteBtn extends StatefulWidget {
  String id;
  FavoriteBtn({this.id});
  @override
  _FavoriteBtnState createState() => _FavoriteBtnState();
}

class _FavoriteBtnState extends State<FavoriteBtn> {
  SizeManager sm;
  var fut;
  Map _map = {};
  @override
  void initState() {
    super.initState();
    if (widget.id != null)
      _map = {
        'api_type': 'get',
        'business_id': widget.id,
        'relation_type': '4'
      };
    fut = APIManager.businessRelationGet(_map);
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return FutureBuilder<RelationBase>(
        future: fut,
        builder: (BuildContext context, AsyncSnapshot<RelationBase> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Container();
          else {
            if (snapshot.hasError)
              return Center(child: Text('Follow'));
            else {
              return Padding(
                padding: EdgeInsets.only(left: sm.w(4)),
                child: Icon(
                  snapshot.data.data[0].isRelation == 1
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: sm.w(8),
                  color: myRed,
                ),
              );
            }
          }
        });
  }
}
