import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Business/RelationModel.dart';
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
  Relation relation = Relation();
  var fut;
  @override
  void initState() {
    super.initState();
    fut = APIManager.businessRelationGet(
        {'api_type': 'get', 'business_id': widget.id, 'relation_type': '4'});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
              return Center(child: null);
            else {
              relation = snapshot.data.data[0];
              return InkWell(
                onTap: () {
                  if (relation.isRelation != 1) {
                    //  set
                    changeRelation('set');
                  } else {
                    //end
                    changeRelation('end');
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(left: sm.w(4)),
                  child: Icon(
                    relation.isRelation == 1
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: sm.w(8),
                    color: myRed,
                  ),
                ),
              );
            }
          }
        });
  }

  void changeRelation(String method) async {
    Map _map = {
      'api_type': method,
      'business_id': widget.id,
      'relation_type': '4',
      'relation_id': relation.relationId
    };
    print('relation request Data:${_map.toString()}');
    await APIManager.businessRelationGet(_map).then((value) => setState(() {}));
  }
}
