import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/ProfileImageModel.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class myClipRect extends StatefulWidget {
  const myClipRect({
    Key key,
    @required this.profileImage,
    @required this.sm,
  }) : super(key: key);

  final ProfileImageModel profileImage;
  final SizeManager sm;

  @override
  _myClipRectState createState() => _myClipRectState();
}

class _myClipRectState extends State<myClipRect> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        widget.profileImage == null
            ? "https://source.unsplash.com/random/40*40"
            : widget.profileImage.data.length == 0
                ? "https://source.unsplash.com/random/40*40"
                : widget.profileImage.data[0].photo,
        height: widget.sm.scaledHeight(8),
        fit: BoxFit.cover,
        width: widget.sm.scaledHeight(8),
      ),
    );
  }
}
