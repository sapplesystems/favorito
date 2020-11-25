import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/model/job/JobListRequestModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/jobs/CreateJob.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Favorito/config/SizeManager.dart';

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
        backgroundColor: myBackGround,
        appBar: AppBar(
          backgroundColor: myBackGround,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Jobs",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: FutureBuilder<JobListRequestModel>(
          future: WebService.funGetJobs(context),
          builder: (BuildContext context,
              AsyncSnapshot<JobListRequestModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text('Please wait its loading...'));
            } else {
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));
              else {
                return Container(
                  decoration: BoxDecoration(
                    color: myBackGround,
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: sm.scaledHeight(75),
                          margin: EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 32.0),
                          child: ListView.builder(
                              itemCount: _jobList.data == null
                                  ? 0
                                  : _jobList.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => CreateJob(
                                                    _jobList.data[index].id)))
                                        .whenComplete(() => getPageData());
                                  },
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                    child: Container(
                                        height: sm.scaledHeight(10),
                                        width: sm.scaledWidth(80),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(40))),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 2.0),
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: ListTile(
                                            trailing: SvgPicture.asset(
                                                'assets/icon/forward_arrow.svg'),
                                            title: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4.0),
                                              child: Text(
                                                _jobList.data[index].title,
                                              ),
                                            ),
                                          ),
                                        )),
                                  ),
                                );
                              }),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: sm.scaledWidth(50),
                            child: roundedButton(
                              clicker: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CreateJob(null)));
                              },
                              clr: Colors.red,
                              title: "Add New",
                            ),
                          ),
                        ),
                      ]),
                );
              }
            }
          },
        ));
  }

  void getPageData() async {
    await WebService.funGetJobs(context)
        .then((value) => setState(() => _jobList = value));
  }
}
