import 'package:favorito_user/component/ImageMaster.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/profile/user/PersonalInfo/UserAddress.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';

class myClipRect extends StatelessWidget {
  SizeManager sm;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () async {
            //   File image;
            //   image = await ImagePickerGC.pickImage(
            //       context: context,
            //       source: ImgSource.Gallery,
            //       imageQuality: 10,
            //       cameraIcon: Icon(Icons.add, color: Colors.red));

            //   File croppedFile = await ImageCropper.cropImage(
            //           sourcePath: image.path,
            //           aspectRatioPresets: [
            //             CropAspectRatioPreset.square,
            //             CropAspectRatioPreset.ratio3x2,
            //             CropAspectRatioPreset.original,
            //             CropAspectRatioPreset.ratio4x3,
            //             CropAspectRatioPreset.ratio16x9
            //           ],
            //           androidUiSettings: AndroidUiSettings(
            //               toolbarTitle: 'Cropper',
            //               toolbarColor: myRed,
            //               toolbarWidgetColor: Colors.white,
            //               initAspectRatio: CropAspectRatioPreset.original,
            //               lockAspectRatio: false),
            //           iosUiSettings: IOSUiSettings(minimumAspectRatio: 1.0))
            //       .then((value) {
            //     // image = croppedFile;
            //     image = value;
            //     // await WebService.profileImageUpdate(image, context)
            //     //     .then((value) {
            //     //   if (value.status == "success") {
            //     //     controller[0].text = value.data[0].photo;
            //     //     addOrChangePhoto = 'Change Photo';
            //     //     notifyListeners();
            //     //     Provider.of<SettingProvider>(context, listen: false)
            //     //         .getProfileImage();
            //     //   }
            //     // });
            //   });

            //   // notifyListeners();
          },
          child: Container(
              height: sm.h(8),
              width: sm.h(8),
              child: ImageMaster(
                  url: Provider.of<UserAddressProvider>(context, listen: true)
                      .getProfileImage())),
        ));
  }
}
