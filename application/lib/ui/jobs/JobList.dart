import 'package:application/component/roundedButton.dart';
import 'package:application/model/job/JobListRequestModel.dart';
import 'package:application/network/webservices.dart';
import 'package:application/ui/jobs/CreateJob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:velocity_x/velocity_x.dart';

class JobList extends StatefulWidget {
  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  JobListRequestModel _jobList = JobListRequestModel();

  @override
  void initState() {
    WebService.funGetJobs().then((value) {
      setState(() {
        _jobList = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfffff4f4),
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
        body: Container(
            decoration: BoxDecoration(
              color: Color(0xfffff4f4),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                height: context.percentHeight * 75,
                margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
                child: ListView.builder(
                    itemCount: _jobList.jobs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: Container(
                            height: context.percentHeight * 10,
                            width: context.percentWidth * 80,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            margin: EdgeInsets.symmetric(vertical: 2.0),
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              trailing: SvgPicture.asset(
                                  'assets/icon/forward_arrow.svg'),
                              title: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  _jobList.jobs[index].title,
                                ),
                              ),
                            )),
                      );
                    }),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: context.percentWidth * 50,
                  child: roundedButton(
                    clicker: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CreateJob()));
                    },
                    clr: Colors.red,
                    title: "Add New",
                  ),
                ),
              ),
            ])));
  }
}
