import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/profile/business/waitlist/WaitListHeader.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/MyString.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class JoinWaitList extends StatefulWidget {
  // JoinWaitList({this.sm});
  @override
  _JoinWaitListState createState() => _JoinWaitListState();
}

class _JoinWaitListState extends State<JoinWaitList> {
  List<TextEditingController> controller = [];
  SizeManager sm;
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 3; i++) {
      controller.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            WaitListHeader(title: 'Join Waitlist'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: myBackGround,
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(sm.w(4)),
                    child: Icon(
                      Icons.remove,
                      color: myRed,
                    ),
                  ),
                ),
                Container(
                  width: sm.w(20),
                  margin: EdgeInsets.all(sm.w(6)),
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: EditTextComponent(
                    ctrl: controller[0],
                    title: '  ',
                    security: false,
                    valid: true,
                    maxLines: 1,
                    // formate: FilteringTextInputFormatter.singleLineFormatter,
                    // maxlen: i == 1 ? 12 : 30,
                    // keyboardSet:
                    //     i == 0 ? TextInputType.emailAddress : TextInputType.text,
                    // prefixIcon: prefix[i],
                  ),
                ),
                Card(
                  color: myBackGround,
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(sm.w(4)),
                    child: Icon(
                      Icons.add,
                      color: myRed,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: EditTextComponent(
                ctrl: controller[1],

                title: 'Tag people by adding @',
                security: false,
                valid: true,
                maxLines: 1,
                // formate: FilteringTextInputFormatter.singleLineFormatter,
                // maxlen: i == 1 ? 12 : 30,
                // keyboardSet:
                //     i == 0 ? TextInputType.emailAddress : TextInputType.text,
                // prefixIcon: prefix[i],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(sm.h(2)),
              child: EditTextComponent(
                ctrl: controller[2],
                title: 'Special notes',
                security: false,
                valid: true,
                maxLines: 8,
                // formate: FilteringTextInputFormatter.singleLineFormatter,
                // maxlen: i == 1 ? 12 : 30,
                // keyboardSet:
                //     i == 0 ? TextInputType.emailAddress : TextInputType.text,
                // prefixIcon: prefix[i],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sm.w(24)),
              child: Card(
                color: myBackGround,
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: sm.w(12), vertical: sm.w(4)),
                  child: Text(
                    'Submit',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: myRed,
                        fontFamily: 'Gilroy-Reguler',
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
