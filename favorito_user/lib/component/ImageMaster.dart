import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ImageMaster extends StatefulWidget {
  String url;
  ImageMaster({this.url});
  @override
  _ImageMasterState createState() => _ImageMasterState();
}

class _ImageMasterState extends State<ImageMaster> {
  @override
  Widget build(BuildContext context) => Image.network(widget.url,
      fit: BoxFit.fill,
      loadingBuilder: (BuildContext context, Widget widget,
              ImageChunkEvent loadingProgress) =>
          Center(child: Text('Loading..')),
      errorBuilder: (BuildContext context, Object error, StackTrace st) =>
          Center(child: Icon(Icons.person, color: Colors.grey, size: 40)));
}
