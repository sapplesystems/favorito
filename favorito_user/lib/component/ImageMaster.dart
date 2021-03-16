import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ImageMaster extends StatefulWidget {
  String url;
  ImageMaster({this.url});
  @override
  _ImageMasterState createState() => _ImageMasterState();
}

class _ImageMasterState extends State<ImageMaster> {
  @override
  Widget build(BuildContext context) {
    print("urlm:${widget.url}");
    return Image.network(widget.url,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes
                  : null,
            ),
          );
        },
        errorBuilder: (BuildContext context, Object error, StackTrace st) =>
            Center(child: Icon(Icons.person, color: Colors.grey, size: 40)));
  }
}
