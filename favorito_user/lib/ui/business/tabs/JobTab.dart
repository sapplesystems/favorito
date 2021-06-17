import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../utils/Extentions.dart';

class JobTab extends StatelessWidget {
  SizeManager sm;
  BusinessProfileProvider vaTrue;
  BusinessProfileProvider vaFalse;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    vaTrue = Provider.of<BusinessProfileProvider>(context, listen: true);
    vaFalse = Provider.of<BusinessProfileProvider>(context, listen: false);
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(2),
          child: ListView.builder(
              itemCount: vaTrue.jobListModel?.data?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onTap: () {
                      vaTrue.jobDetail(vaTrue?.jobListModel?.data[index]?.id);
                      Navigator.pushNamed(context, '/JobDetail');
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: Container(
                          height: sm.h(10),
                          width: sm.w(80),
                          decoration: BoxDecoration(
                              // color: Colors.white,
                              // border: Border.all(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          margin: EdgeInsets.symmetric(horizontal: 14),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    '${vaTrue?.jobListModel?.data[index]?.title ?? ''}'
                                        .capitalize(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .copyWith(
                                            fontSize: 15,
                                            fontFamily: 'Gilroy-Mediam')),
                                SizedBox(
                                    width: 20,
                                    child: SvgPicture.asset(
                                        'assets/icon/reply.svg'))
                              ])),
                    ));
              })),
    );
  }
}
