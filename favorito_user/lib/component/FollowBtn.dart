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

  Relation relation = Relation();

  String btnTxt;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RelationBase>(
        future: APIManager.businessRelationGet({
          'api_type': 'get',
          'business_id': widget.id,
          'relation_type': '3'
        }),
        builder: (BuildContext context, AsyncSnapshot<RelationBase> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Container();
          else {
            if (snapshot.hasError)
              return Center(child: Text(btnTxt ?? (btnTxt = 'Follow')));
            else {
              relation = snapshot.data.data[0];
              btnTxt = relation.isRelation == 1 ? 'Following' : 'Follow';
              return NeumorphicButton(
                style: NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    depth: 4,
                    lightSource: LightSource.topLeft,
                    color: relation.isRelation == 1 ? myBlueBase : Colors.white,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.all(Radius.circular(8)),
                    ),
                    border: NeumorphicBorder(
                      color: myBlueBase,
                      width: 0.8,
                    )),
                onPressed: () async {
                  if (btnTxt == 'Follow') {
                    //  set
                    changeRelation('set');
                  } else {
                    //end
                    changeRelation('end');
                  }
                  print("btnTxt${btnTxt}");
                },
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Text(
                    btnTxt,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: relation.isRelation == 1
                            ? Colors.white
                            : myBlueBase),
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
      'relation_type': '3',
      'relation_id': relation.relationId
    };
    print('relation request Data:${_map.toString()}');
    await APIManager.businessRelationGet(_map).then((value) => setState(() {}));
  }
}
