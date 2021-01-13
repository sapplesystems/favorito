import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/ProfileData/ProfileData.dart';
import 'package:favorito_user/model/appModel/ProfileData/ProfileModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/services.dart';
import '../../../utils/MyString.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:progress_dialog/progress_dialog.dart';

class PersonalInfo extends StatefulWidget {
  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> title = ['Full Name', 'Email', 'Phone', 'Postal', 'Address'];
  List<String> prefix = ['name', 'mail', 'phone', 'postal', 'address'];
  List<bool> canEdit = [true, true, true, true, true];
  ProgressDialog pr;
  List controller = [];
  SizeManager sm;
  var fut;

  //delete
  String photoUrl = null;
  @override
  void initState() {
    super.initState();

    for (int i = 0; i < title.length; i++)
      controller.add(TextEditingController());

    fut = APIManager.userdetail({'api_type': 'get'});
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: myBackGround,
        appBar: AppBar(
          backgroundColor: myBackGround,
          elevation: 0,
          title: Text('Edit Profile'),
        ),
        body: FutureBuilder<ProfileModel>(
            future: fut,
            builder:
                (BuildContext context, AsyncSnapshot<ProfileModel> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Text(loading));
              } else if (snapshot.hasError) {
                return Center(child: Text(wentWrong));
              } else {
                return RefreshIndicator(
                  onRefresh: () {
                    fut = APIManager.userdetail({'api_type': 'get'});
                    print('refreshed');
                    setState(() {});
                  },
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: sm.w(6), vertical: sm.w(0)),
                      child: ListView(
                        children: [
                          Card(
                            elevation: 2,
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: sm.w(10),
                                backgroundImage: NetworkImage(
                                    'https://imagevars.gulfnews.com/2019/04/02/Mouni_Roy_2_resources1_16a450552e0_large.jpg'),
                              ),
                              title: Text(
                                snapshot.data.data.detail.fullName ??
                                    'please update your name',
                                style: TextStyle(
                                    wordSpacing: 2,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              subtitle: Text(
                                snapshot.data.data.detail.shortDescription ??
                                    '',
                                style: TextStyle(wordSpacing: 2, fontSize: 16),
                              ),
                            ),
                          ),
                          Divider(),
                          fields(snapshot.data.data)
                        ],
                      ),
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }

  Widget fields(ProfileData data) {
    // List list = [
    //   ,
    //   data.detail.email,
    //   data.detail.phone,
    //   data.detail.postal,
    //   data.address,
    // ];
    controller[0].text = data.detail.fullName;
    controller[1].text = data.detail.email;
    controller[2].text = data.detail.phone;
    controller[3].text = data.detail.postal;
    for (int i = 0; i < data.address.length; i++) {
      // print();
      if (data.address[i].defaultAddress == 1) {
        controller[4].text =
            '${data.address[i].address} ${data.address[i].landmark} ${data.address[i].city},${data.address[i].state},${data.address[i].pincode}.${data.address[i].country}';
      }
    }
    return Column(
      children: [
        for (int i = 0; i < title.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: EditTextComponent(
              ctrl: controller[i],
              hint: title[i],
              security: false,
              valid: true,
              isEnabled: (i == 1 || i == 2) ? false : true,
              maxLines: i == 4 ? 4 : 1,
              formate: FilteringTextInputFormatter.singleLineFormatter,
              maxlen: i == 1 ? 12 : 30,
              keyboardSet:
                  i == 0 ? TextInputType.emailAddress : TextInputType.text,
              prefixIcon: prefix[i],
            ),
          ),
      ],
    );
  }
}
