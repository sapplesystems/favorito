import 'package:Favorito/model/job/JobListRequestModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/jobs/JobProvider.dart';
import 'package:Favorito/utils/UtilProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:provider/provider.dart';
import '../../utils/Extentions.dart';

class JobList extends StatelessWidget {
  JobProvider vaTrue;
  JobProvider vaFalse;
  SizeManager sm;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    vaTrue = Provider.of<JobProvider>(context, listen: true);
    vaFalse = Provider.of<JobProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            iconTheme: IconThemeData(
                color: Colors.black, size: 30 //change your color here
                ),
            title: Text(
              "Jobs",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                  fontFamily: 'Gilroy-Bold',
                  letterSpacing: .2),
            ),
            actions: [
              IconButton(
                  icon: Icon(Icons.add_circle_outline, size: 30),
                  onPressed: () {
                    Provider.of<JobProvider>(context, listen: false)
                        .setSelectedJobId(0);
                    Navigator.of(context)
                        .pushNamed('/createJob', arguments: true);
                  })
            ]),
        body: RefreshIndicator(
          onRefresh: () async {
            await vaTrue.getPageData();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: ListView.builder(
                itemCount: vaTrue.jobList.data == null
                    ? 0
                    : vaTrue.jobList.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Provider.of<JobProvider>(context, listen: false)
                          .setSelectedJobId(vaTrue.jobList.data[index].id);
                      Navigator.of(context)
                          .pushNamed('/createJob', arguments: false);
                    },
                    child: Card(
                      child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 4.0),
                                    child: Text(
                                      vaTrue.jobList.data[index].title
                                          .capitalize(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Gilroy-Medium'),
                                    )),
                                SvgPicture.asset(
                                    'assets/icon/forward_arrow.svg')
                              ])),
                    ),
                  );
                }),
          ),
        ));
  }
}
