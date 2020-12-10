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
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        widget.image,
        height: widget.sm.scaledHeight(11),
        fit: BoxFit.cover,
        width: widget.sm.scaledWidth(38),
      ),
    );
  }
}
