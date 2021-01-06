import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/job/JobListModel.dart';
import 'package:favorito_user/model/appModel/search/BusinessProfileData.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/MyString.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../utils/Extentions.dart';

// ignore: must_be_immutable
class JobTab extends StatefulWidget {
  BusinessProfileData data;
  JobTab({this.data});
  @override
  _CatlogTabState createState() => _CatlogTabState();
}

class _CatlogTabState extends State<JobTab> {
  SizeManager sm;
  var fut;
  JobListModel jobListModel = JobListModel();

  @override
  void initState() {
    super.initState();
    // fut = APIManager.joblist();
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return FutureBuilder<JobListModel>(
      future: APIManager.joblist(
          {'business_id': widget?.data?.businessId.toString()}),
      builder: (BuildContext context, AsyncSnapshot<JobListModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: Text(loading));
        else if (snapshot.hasError)
          return Center(child: Text('Error : ${snapshot.error}'));
        else if (jobListModel != snapshot.data) {
          jobListModel = snapshot.data;

          print("Job length: ${jobListModel.data?.length}");
          return Container(
              padding: EdgeInsets.all(2),
              child: ListView.builder(
                itemCount: jobListModel.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    // onTap: () => Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => ViewCatlog())),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: Container(
                          height: sm.h(10),
                          width: sm.w(80),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          margin: EdgeInsets.symmetric(vertical: 2.0),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: sm.w(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  jobListModel.data[index].title.capitalize(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Gilroy-Mediam'),
                                ),
                                Icon(FontAwesomeIcons.share, color: myGrey)
                                // SvgPicture.asset('assets/icon/moveToNext.svg'),
                              ],
                            ),
                          )),
                    ),
                  );
                },
              ));
        }
      },
    );
  }
}
