import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/component/FilterRow.dart';
import 'package:favorito_user/component/PopupContent.dart';
import 'package:favorito_user/component/PopupLayout.dart';
import 'package:favorito_user/component/RoundButtonRightIcon.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/SearchFilterList.dart';
import 'package:favorito_user/model/serviceModel/search/SearchBusinessListModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/Booking/BookTable.dart';
import 'package:favorito_user/ui/Booking/NewAppointment.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SearchResult extends StatelessWidget {
  String searchedText;

  SearchResult(this.searchedText);

  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      theme: NeumorphicThemeData(
          defaultTextColor: myRed,
          accentColor: Colors.grey,
          variantColor: Colors.black38,
          depth: 8,
          intensity: 0.65),
      themeMode: ThemeMode.system,
      child: Material(
        child: NeumorphicBackground(
          child: _SearchResult(searchedText),
        ),
      ),
    );
  }
}

class _SearchResult extends StatefulWidget {
  String searchedText;

  _SearchResult(this.searchedText);

  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<_SearchResult> {
  var _mySearchEditTextController = TextEditingController();
  List<String> selectedFilters = [];
  List<ServiceFilterList> allFilters = List<ServiceFilterList>();
  SearchBusinessListModel searchResult;

  @override
  void initState() {
    ServiceFilterList filter1 = ServiceFilterList("Restro", false);
    ServiceFilterList filter2 = ServiceFilterList("Cafe", false);
    allFilters.add(filter1);
    allFilters.add(filter2);
    // selectedFilters.add("Restro");
    // selectedFilters.add("Cafe");

    //_mySearchEditTextController.text = widget.searchedText;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      search(widget.searchedText);
    });

    super.initState();
  }

  void search(String searchString) async {
    ProgressDialog pr =
        ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Fetching Data, please wait');
    pr.show();
    await APIManager.search(context, searchString).then((value) {
      if (value.status == "success") {
        pr.hide();
        setState(() {
          searchResult = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return SafeArea(
      child: Container(
        height: sm.scaledHeight(100),
        decoration: BoxDecoration(color: myBackGround),
        child: Column(
          children: [
            Container(
              height: sm.scaledHeight(8),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: sm.scaledWidth(5),
                          right: sm.scaledWidth(5),
                          top: sm.scaledHeight(1)),
                      child: EditTextComponent(
                        ctrl: _mySearchEditTextController,
                        title: "Search",
                        security: false,
                        valid: true,
                        prefixIcon: 'search',
                        prefClick: () {
                          search(_mySearchEditTextController.text);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: sm.scaledWidth(5), top: sm.scaledHeight(1)),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      elevation: 10,
                      child: IconButton(
                          icon: Icon(FontAwesomeIcons.filter),
                          onPressed: () {
                            showPopup(
                                sm, context, _popupBody(sm), 'Select Filters');
                          }),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: selectedFilters.length > 0,
              child: Container(
                margin: EdgeInsets.only(
                    left: sm.scaledWidth(2), right: sm.scaledWidth(2)),
                height: sm.scaledHeight(7),
                width: sm.scaledWidth(100),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (var i = 0; i < selectedFilters.length; i++)
                      RoundButtonRightIcon(
                          borderColor: myRed,
                          title: selectedFilters[i],
                          clr: myRed,
                          icon: Icons.close,
                          function: () => setState(() {
                                for (var temp in allFilters) {
                                  if (temp.filter == selectedFilters[i]) {
                                    temp.selected = false;
                                  }
                                }
                                selectedFilters.removeAt(i);
                              }))
                  ],
                ),
              ),
            ),
            Container(
              height: selectedFilters.length > 0
                  ? sm.scaledHeight(80)
                  : sm.scaledHeight(88),
              child: ListView(
                shrinkWrap: true,
                children: [
                  if (searchResult != null && searchResult.data != null)
                    for (var i = 0; i < searchResult.data.length; i++)
                      searchResultChild(sm, searchResult.data[i], 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchResultChild(
      SizeManager sm, SearchResultModel result, int identifier) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        elevation: 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                    child: Image.network(
                      result.photo,
                      height: sm.scaledHeight(18),
                      fit: BoxFit.cover,
                      width: sm.scaledWidth(28),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: sm.scaledWidth(2), top: sm.scaledHeight(1)),
                        child: Text(result.businessName,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: sm.scaledWidth(2), top: sm.scaledHeight(1)),
                        child: Text(result.shortDescription ?? "",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w300)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: sm.scaledWidth(2), top: sm.scaledHeight(1)),
                        child: Row(
                          children: [
                            for (var i = 0; i < 5; i++)
                              Icon(
                                Icons.star,
                                size: sm.scaledHeight(1.5),
                              )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: sm.scaledWidth(2), top: sm.scaledHeight(1)),
                        child: Text("1.2 km | Varaccha",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w300)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: sm.scaledWidth(2), top: sm.scaledHeight(1)),
                        child: Text("Open Now",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Colors.green)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: sm.scaledWidth(2), top: sm.scaledHeight(1)),
                        child: Text("Opens | 12:00  Closes | 09:00",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w300)),
                      ),
                    ],
                  ),
                  IconButton(icon: Icon(Icons.call_outlined), onPressed: () {})
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(sm.scaledHeight(2)),
              child: NeumorphicButton(
                style: NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    depth: 4,
                    lightSource: LightSource.topLeft,
                    color: myButtonBackground,
                    boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.all(Radius.circular(24.0)))),
                margin: EdgeInsets.symmetric(horizontal: sm.scaledWidth(10)),
                onPressed: () {
                  identifier == 1
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewAppointment(0, null)))
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookTable(0, null)));
                },
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Center(
                  child: identifier == 1
                      ? Text(
                          "Book An Appointment",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, color: myRed),
                        )
                      : Text(
                          "Book A Table",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, color: myRed),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showPopup(SizeManager sm, BuildContext context, Widget widget, String title,
      {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: sm.scaledHeight(18),
        left: sm.scaledWidth(5),
        right: sm.scaledWidth(5),
        bottom: sm.scaledHeight(18),
        child: PopupContent(
          content: SafeArea(
            child: widget,
          ),
        ),
      ),
    );
  }

  void searchForFilteredData() {
    setState(() {});
  }

  Widget _popupBody(SizeManager sm) {
    return FilterRow(allFilters, selectedFilters, searchForFilteredData);
  }
}
