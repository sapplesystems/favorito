import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class JobDetail extends StatelessWidget {
  JobDetail({Key key}) : super(key: key);
  BusinessProfileProvider vaTrue;
  bool isFirst = true;
  SizeManager sm;
  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      sm = SizeManager(context);
      vaTrue = Provider.of<BusinessProfileProvider>(context, listen: true);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myBackGround,
        elevation: 0,
        title: Text(
          vaTrue.jobData.title ?? '',
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(fontSize: 15, fontFamily: 'Gilroy-Mediam'),
        ),
      ),
      body: ListView(children: [
        Row(children: [
          Text(
            'Location : ',
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            vaTrue.jobData.city ?? '',
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(fontSize: 15, fontFamily: 'Gilroy-Mediam'),
          ),
        ]),
        Row(children: [
          Text(
            'State : ',
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            vaTrue.jobData.skills ?? '',
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(fontSize: 15, fontFamily: 'Gilroy-Mediam'),
          ),
        ]),
        Row(children: [
          Text(
            'Skils : ',
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            vaTrue.jobData.skills ?? '',
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(fontSize: 15, fontFamily: 'Gilroy-Mediam'),
          ),
        ]),
        Row(children: [
          Text(
            'Positions : ',
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            vaTrue.jobData.skills ?? '',
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(fontSize: 15, fontFamily: 'Gilroy-Mediam'),
          ),
        ])
      ]),
    );
  }
}
