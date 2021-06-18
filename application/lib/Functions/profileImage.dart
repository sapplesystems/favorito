import 'package:Favorito/network/webservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

void getProfileImage() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await WebService.funUserPhoto().then((value) {
    if (value.status == 'success')
      preferences.setString('photoUrl', value.result[0].photo ?? '');
    print("photoUrl:${preferences.getString('photoUrl')}");
  });
}



