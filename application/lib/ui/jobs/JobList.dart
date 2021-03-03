import 'package:Favorito/model/job/JobListRequestModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/jobs/JobProvider.dart';
import 'package:Favorito/utils/UtilProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:provider/provider.dart';
import '../../utils/Extentions.dart';

class JobList extends StatefulWidget {
  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  JobListRequestModel _jobList = JobListRequestModel();

  @override
  void initState() {
    getPageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
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
        body: FutureBuilder<JobListRequestModel>(
          future: WebService.funGetJobs(context),
          builder: (BuildContext context,
              AsyncSnapshot<JobListRequestModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text('Please wait its loading...'));
            } else {
              if (snapshot.hasError)
                return Center(child: Text('Error: something went wrong..'));
              else {
                return
                    // ListView(
                    //   children: [
                    Container(
                  height: sm.h(100),
                  margin:
                      EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
                  child: ListView.builder(
                      itemCount:
                          _jobList.data == null ? 0 : _jobList.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Provider.of<JobProvider>(context, listen: false)
                                .setSelectedJobId(_jobList.data[index].id);
                            Navigator.of(context)
                                .pushNamed('/createJob', arguments: false)
                                .whenComplete(() => getPageData());
                          },
                          child: Card(
                            child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          child: Text(
                                            _jobList.data[index].title
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
                );
              }
            }
          },
        ));
  }

  getPageData() async {
    if (await Provider.of<UtilProvider>(context, listen: false).checkInternet())
      await WebService.funGetJobs(context)
          .then((value) => setState(() => _jobList = value));
  }
}
