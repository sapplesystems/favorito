import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import '../../../utils/Extentions.dart';
class JobDetail extends StatelessWidget {
  JobDetail({Key key}) : super(key: key);
  bool isFirst = true;
  SizeManager sm;
  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      sm = SizeManager(context);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myBackGround,
        elevation: 0,
        title: Text(
         (context.read<BusinessProfileProvider>().jobData.title ?? '').capitalize(),
          style: Theme.of(context)
              .textTheme
              .headline2
              .copyWith(fontSize: 18),
        ),
      ),
      body: 
      
      Consumer<BusinessProfileProvider>(builder: (context,data,child){
        return   Padding(
          padding: const EdgeInsets.all(6.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                
                children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical:6),
                  child: Text(
                    'Title',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(fontSize: 16),
                  ),
                ),
                Text(
                  (data.jobData.title ?? '').capitalize(),
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:18.0,bottom: 6),
                  child: Text(
                    'Skils',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(fontSize: 16),
                  ),
                ),
                Text(
                  (data.jobData.skills ?? '').capitalize(),
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:18.0,bottom: 6),
                  child: Text(
                    'Description',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(fontSize: 15),
                  ),
                ),
                Text(
                  data.jobData.description ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              Row(children: [
                // Text(
                //   'Positions',
                //   style: Theme.of(context)
                //       .textTheme
                //       .headline4
                //       .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                // ),
                // Text(
                //   data.jobData.skills ?? '',
                //   style: Theme.of(context)
                //       .textTheme
                //       .headline4
                //       .copyWith(fontSize: 15, fontFamily: 'Gilroy-Mediam'),
                // ),
              ])
                  ]),
            ),
          ),
        );
    
      },)
    );
  }
}
