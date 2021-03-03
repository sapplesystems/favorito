import 'package:favorito_user/component/ImageMaster.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/profile/user/PersonalInfo/UserAddress.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class myClipRect extends StatelessWidget {
  SizeManager sm;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
            height: sm.h(8),
            width: sm.h(8),
            child: ImageMaster(
                url: Provider.of<UserAddressProvider>(context, listen: true)
                    .getProfileImage())));
  }
}
