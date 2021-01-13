import 'package:favorito_user/component/VegNonVegMarka.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Menu/MenuItemModel.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class MenuItem extends StatefulWidget {
  MenuItemModel data;
  MenuItem({this.data});

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  SizeManager sm;

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          VegNonVegMarka(isVeg: widget.data.type.toLowerCase() == 'veg'),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: sm.w(4), top: sm.w(2)),
              height: 48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Gilroy-Regular',
                    ),
                  ),
                  Text(
                    '${widget.data.price} \u{20B9}',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12,
                      color: myGrey,
                      fontFamily: 'Gilroy-Regular',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: counter != 0,
            child: Container(
              padding: const EdgeInsets.only(
                  left: 4.0, right: 4.0, top: 4, bottom: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: myGrey,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        ++counter;
                      });
                    },
                    child: Icon(
                      Icons.add,
                      color: myRedDark1,
                    ),
                  ),
                  Container(
                    width: 50,
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Text(
                      '$counter',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Gilroy-Medium',
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        --counter;
                      });
                    },
                    child: Icon(
                      Icons.remove,
                      color: myRedDark1,
                    ),
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: counter == 0,
            child: InkWell(
              onTap: () {
                setState(() {
                  ++counter;
                });
              },
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: myGrey,
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.add,
                  size: 28,
                  color: myRedDark1,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
