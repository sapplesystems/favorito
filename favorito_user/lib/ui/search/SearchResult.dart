import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/component/FilterRow.dart';
import 'package:favorito_user/component/ImageMaster.dart';
import 'package:favorito_user/component/PopupContent.dart';
import 'package:favorito_user/component/PopupLayout.dart';
import 'package:favorito_user/component/RoundButtonRightIcon.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/SearchFilterList.dart';
import 'package:favorito_user/model/appModel/search/BusinessProfileData.dart';
import 'package:favorito_user/model/appModel/search/SearchBusinessListModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/ClusterMap/ClusterMap.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:favorito_user/ui/search/SearchReqData.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/Extentions.dart';

class SearchResult extends StatefulWidget {
  SearchReqData data;

  SearchResult({this.data});

  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  var _mySearchEditTextController = TextEditingController();
  List<String> selectedFilters = [];
  List<ServiceFilterList> allFilters = [];
  SearchBusinessListModel searchResult;
  var servicesIs;

  @override
  void initState() {
    ServiceFilterList filter1 = ServiceFilterList("Restro", false);
    ServiceFilterList filter2 = ServiceFilterList("Cafe", false);
    allFilters.add(filter1);
    allFilters.add(filter2);
    _mySearchEditTextController.text = widget.data.text ?? '';
    // selectedFilters.add("Restro");
    // selectedFilters.add("Cafe");

    // _mySearchEditTextController.text = widget.searchedText;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      executeSearch(widget?.data);
    });
    super.initState();
  }

  void search(String searchString) async {
    await servicesIs.then((value) {
      if (value.status == "success") {
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
      
      child: Scaffold(
        key: RIKeys.josKeys4,
        body: ListView(children: [
          SizedBox(
            height: sm.h(10),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(
                          left: sm.w(5), right: sm.w(5), top: sm.h(1)),
                      child: EditTextComponent(
                          controller: _mySearchEditTextController,
                          title: "Search",
                          suffixTxt: '',
                          hint: 'Search',
                          security: false,
                          valid: true,
                          maxLines: 1,
                          maxlen: 100,
                          keyBoardAction: TextInputAction.search,
                          atSubmit: (_val) => executeSearch(SearchReqData(
                              text: _mySearchEditTextController.text)),
                          prefixIcon: 'search',
                          prefClick: () => executeSearch(SearchReqData(
                              text: _mySearchEditTextController.text)))),
                ),
                //Don't remove it is filter part for search

                // Padding(
                //   padding: EdgeInsets.only(right: sm.w(5), bottom: sm.h(2)),
                //   child: Card(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.all(Radius.circular(8)),
                //       ),
                //       elevation: 10,
                //       child: Padding(
                //           padding: const EdgeInsets.all(12.0),
                //           child: InkWell(
                //             onTap: () => showPopup(
                //                 sm, context, _popupBody(sm), 'Select Filters'),
                //             child: SvgPicture.asset('assets/icon/filter.svg',
                //                 height: sm.h(2), fit: BoxFit.fitHeight),
                //           ))),
                // ),
              ],
            ),
          ),
          Visibility(
            visible: selectedFilters.length > 0,
            child: Container(
              margin: EdgeInsets.only(left: sm.w(2), right: sm.w(2)),
              height: sm.h(7),
              width: sm.w(100),
              child: ListView(scrollDirection: Axis.horizontal, children: [
                for (var i = 0; i < selectedFilters.length; i++)
                  RoundButtonRightIcon(
                      borderColor: myRed,
                      title: selectedFilters[i],
                      clr: myRed,
                      icon: Icons.close,
                      function: () => setState(() {
                            for (var temp in allFilters)
                              if (temp.filter == selectedFilters[i])
                                temp.selected = false;

                            selectedFilters.removeAt(i);
                          }))
              ]),
            ),
          ),
          Container(
            height: selectedFilters.length > 0 ? sm.h(83) : sm.h(85),
            child: (searchResult?.data != null)
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchResult.data?.length ?? 0,
                    itemBuilder: (context, _index) {
                      return searchResultChild(sm, searchResult.data[_index]);
                    })
                : Center(
                    child: Container(
                    child: Text('Search result not found',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontSize: 12)),
                  )),
          ),
        ]),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
        backgroundColor: Color(0xffF4F6FC),
        onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>ClusterMap(
          list: searchResult.data
          )));},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.location_on,color: myRed,size: 28,),
        ),
      ),
      
      ),
    );
  }

  Widget searchResultChild(SizeManager sm, BusinessProfileData result) {
    int identifier = 0;

    String btnTxt;
    // for (var _v in result?.attributes) {
    //   if(_v.attributeName.trim() == 'Booking'){
    //     identifier = 0;
    //     btnTxt ='Book A Table';
    //   }else{
    //     identifier = 1;
    //     btnTxt ='Book An Appointment';
    //   }
    // }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () {
          Provider.of<BusinessProfileProvider>(context, listen: false)
            ..setBusinessId(result.businessId)
            ..refresh(1);

                          if(result.isPro=='1')context.read<BusinessProfileProvider>().funPromoClicks(result.proKey??'',result.isPro);
          Navigator.of(context).pushNamed('/businessProfile');
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top:6.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                elevation: 10,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: SizedBox(
                                  height: sm.h(16),
                                  width: sm.h(16),
                                  child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      child: ImageMaster(url: result?.photo ?? ''))),
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: sm.w(2), top: sm.h(1)),
                                      child: Text(result.businessName.capitalize(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500)),
                                    ),
                                    // Padding(
                                    // padding: EdgeInsets.only(left: sm.w(2), top: sm.h(1)),
                                    // child: Text(result.countryId ?? "",
                                    //     style: TextStyle(
                                    //         fontSize: 14, fontWeight: FontWeight.w300))),
                                    // Padding(
                                    //     padding: EdgeInsets.only(left: sm.w(2), top: sm.h(1)),
                                    //     child: Text(result.avgRating ?? "",
                                    //         style: TextStyle(
                                    //             fontSize: 14, fontWeight: FontWeight.w300))),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: sm.w(2), top: sm.h(1)),
                                        child: RatingBarIndicator(
                                            rating: double.parse(
                                                result.avgRating.toString()),
                                            itemBuilder: (context, index) =>
                                                Icon(Icons.star, color: myRed),
                                            itemCount: 5,
                                            itemSize: 12.0,
                                            direction: Axis.horizontal)),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: sm.w(2), top: sm.h(1)),
                                      child: Text(
                                          "${((double.parse(result?.distance?.toString() ?? '0.0')) / 1.6)?.toStringAsFixed(1)} km | ${result?.townCity ?? ''}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: sm.w(2), top: sm.h(1)),
                                      child: Text(result?.businessStatus ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                  color: result?.businessStatus
                                                              ?.toLowerCase() ==
                                                          'offline'
                                                      ? myRed
                                                      : Colors.green)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: sm.w(2), top: sm.h(1)),
                                      child: Text(
                                          "Opens | ${result?.startHours?.toString()?.substring(0, 5) ?? '00:00'}  Closes | ${result?.endHours?.toString()?.substring(0, 5) ?? "00:00"}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                  fontSize: sm.w(2.8),
                                                  fontWeight: FontWeight.w300)),
                                    ),
                                  ]),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: myRedLight0),
                                margin: EdgeInsets.only(top: sm.h(5), right: sm.h(0)),
                                child: IconButton(
                                    icon: Icon(Icons.call_outlined, color: myRed),
                                    onPressed: () => launch("tel://${result.phone}")),
                              ),
                            )
                          ]),
                      btnTxt != null
                          ? Padding(
                              padding: EdgeInsets.all(sm.h(2)),
                              child: NeumorphicButton(
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.convex,
                                    // depth: 4,
                                    lightSource: LightSource.topLeft,
                                    color: myRed,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.all(Radius.circular(26.0)))),
                                margin: EdgeInsets.symmetric(horizontal: sm.w(4)),
                                onPressed: () {
                                  print("tulluidentifier:$identifier");
                                  Provider.of<BusinessProfileProvider>(context,
                                      listen: false)
                                    ..setBusinessId(result.businessId)
                                    ..refresh(identifier == 1 ? 4 : 2);
                                  if (identifier == 1) {
                                    print("aaaaaaa1");
                                    Navigator.of(context)
                                        .pushNamed('/bookAppointment');
                                  } else {
                                    print("aaaaaaa2");
                                    Navigator.of(context).pushNamed('/bookTable');
                                  }
                                },
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: SvgPicture.asset(
                                            'assets/icon/callenders.svg'),
                                      ),
                                      Text(btnTxt, //bookAnAppointment
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white))
                                    ]),
                              ),
                            )
                          : SizedBox(),
                    ]),
              ),
            ),
          Visibility(
            visible:result.isPro=='1', 
          
            child: Positioned(
              right: sm.w(6),
              top:  sm.h(-.2),
              child:
            Text("Ad",style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(fontSize: 24,fontFamily: 'Gilroy-Bold',color:Colors.amber[900]),)),
          )

          ]),
      ),
    );
  }

  showPopup(SizeManager sm, BuildContext context, Widget widget, String title,
      {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: sm.h(18),
        left: sm.w(5),
        right: sm.w(5),
        bottom: sm.h(18),
        child: PopupContent(content: SafeArea(child: widget)),
      ),
    );
  }

  void searchForFilteredData() {
    setState(() {});
  }

  Widget _popupBody(SizeManager sm) {
    return FilterRow(allFilters, selectedFilters, searchForFilteredData);
  }

  void executeSearch(SearchReqData data) {
    print("asd:${data?.category}");
    switch (data?.category?.toLowerCase()?.trim()) {
      case ('food'):
        {
          servicesIs = APIManager.foodBusiness(context, data?.text ?? '');
          break;
        }
      case ('book a table'):
        {
          servicesIs = APIManager.bookTableBusiness(context, data?.text ?? '');
          break;
        }
      case ('book an\nappointment'):
        {
          servicesIs =
              APIManager.appointmentBusiness(context, data?.text ?? '');
          break;
        }
      case ('doctor'):
        {
          servicesIs = APIManager.doctorBusiness(context, data?.text ?? '');
          break;
        }
      case ('jobs'):
        {
          servicesIs = APIManager.jobBusiness(context, data?.text ?? '');
          break;
        }
      case ('freelancers'):
        {
          servicesIs =
              APIManager.freelanceBusiness(data?.text, RIKeys.josKeys4);
          break;
        }
      default:
        {
          servicesIs = APIManager.search(data?.text, RIKeys.josKeys4);
        }
    }
    search(widget.data.text);
  }
}
