import 'package:favorito_user/component/RoundedButton.dart';
import 'package:favorito_user/component/VegNonVegMarka.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Menu/Customization.dart/AttributeModel.dart';
import 'package:favorito_user/model/appModel/Menu/Customization.dart/CustomizationOptionModel.dart';
import 'package:favorito_user/model/appModel/Menu/MenuItemModel.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuHomeProvider.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../utils/myString.dart';
import '../../utils/Extentions.dart';

class MenuItems extends StatefulWidget {
  MenuItemModel data = MenuItemModel();
  Function callBack;
  bool isRefresh;
  MenuItems({this.data, this.callBack, this.isRefresh});
  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItems> {
  MenuHomeProvider vaTrue;
  String title = yourBasket;
  SizeManager sm;
  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    print('abc:${widget?.data?.quantity}');
    widget?.data?.quantity =
        widget.data.quantity == null ? 0 : widget?.data?.quantity;
    if (isFirst) {
      vaTrue = Provider.of<MenuHomeProvider>(context, listen: false);

      if (vaTrue.getMyObjectsList() != null)
        for (int _i = 0; _i < vaTrue?.getMyObjectsList()?.length; _i++)
          if (widget?.data?.id == vaTrue?.getMyObjectsList()[_i]?.id)
            widget?.data?.quantity =
                vaTrue?.getMyObjectsList()[_i]?.quantity ?? 0;
      sm = SizeManager(context);
      isFirst = false;
    }
    var _va = widget.data.quantity > 0 && widget.data.isCustomizable == 1;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(children: [
        VegNonVegMarka(isVeg: widget?.data?.type?.toLowerCase() == 'veg'),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: sm.w(4), top: sm.w(2)),
            height: 52,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget?.data?.title ?? "",
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        fontSize: 14,
                      )),
              Text(
                '${widget?.data?.price} \u{20B9}',
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontSize: 10, color: myGrey),
              ),
              Visibility(
                visible: _va,
                child: InkWell(
                  onTap: () => callCustomizetion(context, widget?.data?.id),
                  child: Text(
                    "Options",
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontSize: 10, color: Colors.blue[700]),
                  ),
                ),
              )
            ]),
          ),
        ),
        Visibility(
          visible: widget?.data?.quantity != 0,
          child: Container(
            padding:
                const EdgeInsets.only(left: 4.0, right: 4.0, top: 4, bottom: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: myGrey, width: 1)),
            child: Row(children: [
              InkWell(
                  onTap: () => updateBucket(false),
                  child: Icon(Icons.remove, color: myRedDark1)),
              Container(
                width: 50,
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text('${widget?.data?.quantity ?? 0}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontSize: 14)),
              ),
              InkWell(
                  onTap: () {
                    if((widget.data.quantity??0) <widget?.data?.maxQtyPerOrder)
                    updateBucket(true);
                    else{
                      vaTrue.ShowSnack('You reach maximum number of these item in single cart ');
                    }
                  }, 
                  child: Icon(Icons.add, color: myRedDark1))
            ]),
          ),
        ),
        Visibility(
          visible: widget?.data?.quantity == 0,
          child: InkWell(
            onTap: () {
              print('selectedItenId is :${widget?.data?.id}');
              if(widget.data.isCustomizable == 1)callCustomizetion(context, widget?.data?.id);
              updateBucket(true);
            },
            child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: myGrey, width: 1)),
                child: Icon(Icons.add, size: 28, color: myRedDark1)),
          ),
        )
      ]),
    );
  }

  void updateBucket(bool add) {
    List<MenuItemModel> _listItem = vaTrue?.getMyObjectsList();
    bool avail = false;
    setState(() {
      if (_listItem != null)
        for (int i = 0; i < _listItem?.length; i++) {
          if (_listItem[i].id == widget?.data?.id) {
            add
                ? ++widget?.data?.quantity
                : (widget.data.quantity != 0)
                    ? --widget.data.quantity
                    : 0;

            vaTrue.notifyListeners();

            if (!add && widget?.data?.quantity == 0) {
              vaTrue.removeMyObjectsList(i);
            }
            avail = true;
          }
        }

      if (!avail) {
        print('item id:${widget.data.id}');
        vaTrue.menuItemCust(widget.data.id);
        ++widget.data?.quantity;
        vaTrue.addItemToList(widget.data);
      }
      widget.callBack();
    });
    // vaTrue.notifyListeners();
  }

  void callCustomizetion(BuildContext context, int _id) {
    title = customizetion;
    showModalBottomSheet<void>(
        enableDrag: true,
        isScrollControlled: true,
        context: context,
        backgroundColor: Color.fromRGBO(255, 0, 0, 0),
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: sm.h(90),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: ListView(
                  physics: new NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    header(context),
                    body2(_id),
                    Container(
                      height: 80,
                      child: ListView(
                          physics: new NeverScrollableScrollPhysics(),
                          children: [
                            Divider(),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: sm.h(6)),
                              child: Consumer<MenuHomeProvider>(
                                  builder: (context, _data, child) {
                                return RoundedButton(
                                  clicker: () {
                                    vaTrue.updateMyObjectsList(_id);

                                    Navigator.pop(context);
                                  },
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: 1),
                                  title:
                                      'Total : ${_data?.allPrice()}\u{20B9}| Next',
                                );
                              }),
                            )
                          ]),
                    )
                  ]),
            );
          });
        });
  }

  body2(_id) {
    return Container(
      height: sm.h(60),
      child: Consumer<MenuHomeProvider>(
        builder: (context, data, child) {
          List<AttributeModel> _data =
              vaTrue?.getCustomizationItemModel(_id)?.data;
          return _data == null
              ? Center(child: CircularProgressIndicator())
              : ListView(children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: new NeverScrollableScrollPhysics(),
                      itemCount: _data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: sm.w(7.0)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _data[index]?.attributeName?.capitalize(),
                                      textScaleFactor: 1.4,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(fontSize: 14),
                                    ),
                                    Text(
                                        "\u{20B9}${_data[index].attributePrice}",
                                        textScaleFactor: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6)
                                  ],
                                ),
                                ListView.builder(
                                    physics: new NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: _data[index]
                                        ?.customizationOption
                                        ?.length,
                                    itemBuilder: (context, _i) {
                                      CustomizationOptionModel cop =
                                          _data[index]?.customizationOption[_i];
                                      return Container(
                                        height: 34,
                                        child: ListTile(
                                          leading: Icon(
                                              cop.isSelected
                                                  ? Icons.check_box_rounded
                                                  : Icons
                                                      .check_box_outline_blank,
                                              color: cop.isSelected
                                                  ? myRed
                                                  : null),
                                          title: Container(
                                              width: 100,
                                              child: Text(cop.name,
                                                  textScaleFactor: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5
                                                      .copyWith(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .w500))),
                                          onTap: () {
                                            cop.isSelected = !cop.isSelected;
                                            vaTrue.updateMyObjectsList(_id);
                                          },
                                        ),
                                      );
                                    }),
                                Divider()
                              ]),
                        );
                      }),
                ]);
        },
      ),
    );
  }

  header(BuildContext context) {
    return Container(
      child: Column(children: [
        Center(
          child: Container(
            margin: EdgeInsets.only(top: sm.w(4)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30), color: myGreyLight),
            width: sm.w(18),
            height: 6,
          ),
        ),
        Row(children: [
          SizedBox(width: sm.w(2)),
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: sm.w(5), horizontal: sm.w(2)),
            child: SvgPicture.asset(
              title == yourBasket
                  ? 'assets/icon/basket.svg'
                  : 'assets/icon/customize.svg',
              height: sm.h(4),
            ),
          ),
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(fontFamily: 'Gilroy-Medium', fontSize: 20)),
        ]),
        Divider(),
      ]),
    );
  }
}
