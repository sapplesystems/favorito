import 'package:favorito_user/component/VegNonVegMarka.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Menu/MenuItemModel.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/Providers/BasketControllers.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class MenuItems extends StatefulWidget {
  MenuItemModel data;
  Function callBack;
  bool isRefresh;
  MenuItems({this.data, this.callBack, this.isRefresh});
  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItems> {
  var providerBasketTrue;
  var providerBasketFalse;

  SizeManager sm;

  BasketControllers basket = BasketControllers();
  @override
  Widget build(BuildContext context) {
    providerBasketTrue = Provider.of<BasketControllers>(context, listen: false);
    providerBasketFalse = Provider.of<BasketControllers>(context, listen: true);

    widget?.data?.quantity =
        widget.data.quantity == null ? 0 : widget?.data?.quantity;

    if (basket.getMyObjectsList() != null)
      for (int _i = 0;
          _i < providerBasketTrue?.getMyObjectsList()?.length;
          _i++)
        if (widget.data.id == providerBasketTrue?.getMyObjectsList()[_i].id)
          widget.data.quantity =
              providerBasketTrue?.getMyObjectsList()[_i]?.quantity ?? 0;
    sm = SizeManager(context);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          VegNonVegMarka(isVeg: widget?.data?.type.toLowerCase() == 'veg'),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: sm.w(4), top: sm.w(2)),
              height: 48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget?.data?.title ?? "",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Gilroy-Regular',
                    ),
                  ),
                  Text(
                    '${widget?.data?.price} \u{20B9}',
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
            visible: widget?.data?.quantity != 0,
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
                    onTap: () => updateBucket(false),
                    child: Icon(
                      Icons.remove,
                      color: myRedDark1,
                    ),
                  ),
                  Container(
                    width: 50,
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Text(
                      '${widget?.data?.quantity ?? 0}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Gilroy-Medium',
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      updateBucket(true);
                    },
                    child: Icon(
                      Icons.add,
                      color: myRedDark1,
                    ),
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: widget?.data?.quantity == 0,
            child: InkWell(
              onTap: () => updateBucket(true),
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

  void updateBucket(bool add) {
    bool avail = false;
    setState(() {
      if (providerBasketTrue.getMyObjectsList() != null)
        for (int i = 0;
            i < providerBasketTrue?.getMyObjectsList()?.length;
            i++) {
          if (providerBasketTrue.getMyObjectsList()[i].id == widget?.data?.id) {
            if (add) {
              widget?.data?.quantity = ++widget?.data?.quantity;
            } else {
              widget.data.quantity =
                  widget.data.quantity > 0 ? (--widget.data.quantity) : 0;
            }
            providerBasketTrue.getMyObjectsList()[i] = widget?.data;
            if (!add && widget.data.quantity == 0)
              providerBasketTrue.getMyObjectsList().removeAt(i);

            avail = true;
          }
        }

      if (!avail) {
        ++widget.data.quantity;
        providerBasketTrue.addItemToList(widget.data);
      }
      providerBasketFalse.notifyListeners();
      widget.callBack();
    });
  }
}
