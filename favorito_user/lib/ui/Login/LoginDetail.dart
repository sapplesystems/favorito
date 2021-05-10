import 'package:favorito_user/ui/Login/LoginController.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class LoginDetail extends StatelessWidget {
  LoginProvider vaTrue;
  LoginProvider vaFalse;
  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    vaTrue = Provider.of<LoginProvider>(context, listen: true);
    vaFalse = Provider.of<LoginProvider>(context, listen: false);
    if (isFirst) {
      vaTrue.getUserDetails(RIKeys.josKeys14);
      isFirst = false;
    }
    return Scaffold(
        key: RIKeys.josKeys14,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Icon(
            Icons.keyboard_backspace,
          ),
          elevation: 0,
          title: Text('Login Details',
              style: Theme.of(context).textTheme.headline3.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: .4,
                  fontSize: 20)),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 48.0),
          child: ListView.builder(
              itemCount: vaTrue.loginDetailsList.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return Column(children: [
                  InkWell(
                    onTap: () => vaTrue.onSelect(index, RIKeys.josKeys14),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(vaTrue.loginDetailsList[index],
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                              fontSize: 15,
                                              letterSpacing: .40,
                                              fontWeight: FontWeight.w600)),
                                  Text(vaTrue.loginDetailsList2[index],
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          .copyWith(
                                              fontSize: 14,
                                              letterSpacing: .40,
                                              fontWeight: FontWeight.w600,
                                              color: myGrey))
                                ]),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(Icons.arrow_forward_ios,
                                  color: myGreyDark))
                        ]),
                  ),
                  Padding(padding: const EdgeInsets.all(4), child: Divider())
                ]);
              }),
        ));
  }
}
