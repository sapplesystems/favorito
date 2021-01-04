import 'package:favorito_user/model/appModel/Business/RelationModel.dart';
import 'package:favorito_user/model/appModel/Relation.dart/relationBase.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class FollowBtn extends StatefulWidget {
  String id;
  FollowBtn({this.id});
  @override
  _FollowBtnState createState() => _FollowBtnState();
}

class _FollowBtnState extends State<FollowBtn> {
  var fut;
  Map _map = {};
  String btnTxt = 'Follow';
  Relation relation = Relation();
  @override
  void initState() {
    super.initState();
    if (widget.id != null)
      _map = {
        'api_type': 'get',
        'business_id': widget.id,
        'relation_type': '3'
      };
    fut = APIManager.businessRelationGet(_map);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RelationBase>(
        future: fut,
        builder: (BuildContext context, AsyncSnapshot<RelationBase> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Container();
          else {
            if (snapshot.hasError)
              return Center(child: Text(btnTxt));
            else {
              relation = snapshot.data.data[0];
              btnTxt = relation.isRelation == 1 ? 'Following' : 'Follow';
              return NeumorphicButton(
                style: NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    depth: 4,
                    lightSource: LightSource.topLeft,
                    color: myRed,
                    boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.all(Radius.circular(8)))),
                onPressed: () async {
                  if (btnTxt == 'Follow') {
                    //set
                    changeRelation('set');
                  } else {
                    //end
                    changeRelation('end');
                  }
                },
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Text(
                    btnTxt,
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.white),
                  ),
                ),
              );
            }
          }
        });
  }

  void changeRelation(String method) async {
    _map = {
      'api_type': method,
      'business_id': widget.id,
      'relation_type': '3',
      'relation_id': relation.relationId
    };
    print('relation request Data:${_map.toString()}');
    await APIManager.businessRelationGet(_map).then((value) {
      if (value.status == 'success')
        setState(() => btnTxt = (btnTxt == 'Follow' ? 'Following' : 'Follow'));
    });
  }
}
