import 'package:favorito_user/model/appModel/Business/RelationModel.dart';
import 'package:favorito_user/model/appModel/Relation.dart/relationBase.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class FollowBtn extends StatefulWidget {
  String id;
  Function callback;
  FollowBtn({this.id, this.callback});

  @override
  _FollowBtnState createState() => _FollowBtnState();
}

class _FollowBtnState extends State<FollowBtn> {
  Relation relation = Relation();
  String btnTxt;
  var fut;

  @override
  void initState() {
    super.initState();
    fut = APIManager.businessRelationGet(
        {'api_type': 'get', 'business_id': widget.id, 'relation_type': '3'});
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
              return Center(child: Text(btnTxt ?? (btnTxt = 'Follow')));
            else {
              relation = snapshot.data.data[0];
              btnTxt = relation.isRelation == 1 ? 'Following' : 'Follow';
              print(relation.isRelation);
              return InkWell(
                onTap: () => btnTxt == 'Follow'
                    ? changeRelation('set')
                    : changeRelation('end'),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: myBlueBase, width: 1),
                      color: Colors.white),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Text(
                    btnTxt,
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: myBlueBase),
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
    await APIManager.businessRelationGet(_map).then((value) {
      print("inner");
      widget.callback();
      // setState(() {});
    });
  }
}
