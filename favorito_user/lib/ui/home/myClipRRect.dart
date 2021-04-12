import 'package:favorito_user/component/ImageMaster.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class myClipRRect extends StatefulWidget {
  final String image;
  final SizeManager sm;
  const myClipRRect({
    Key key,
    @required this.image,
    @required this.sm,
  }) : super(key: key);

  @override
  _myClipRRectState createState() => _myClipRRectState();
}

class _myClipRRectState extends State<myClipRRect> {
  @override
  Widget build(BuildContext context) {
    print("Image url is :${widget.image}");
    return SizedBox(
      height: widget.sm.h(11),
      width: widget.sm.w(38),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ImageMaster(url: widget.image)
          // height: widget.sm.h(11),
          // fit: BoxFit.cover,
          // width: widget.sm.w(38),
          // ),
          ),
    );
  }
}
