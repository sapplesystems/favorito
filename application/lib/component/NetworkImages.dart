import 'package:flutter/material.dart';

class NetworkImages extends StatefulWidget {
  String url;
  NetworkImages({this.url});
  @override
  _ImageMasterState createState() => _ImageMasterState();
}

class _ImageMasterState extends State<NetworkImages> {
  @override
  Widget build(BuildContext context) => Image.network(widget.url,
      fit: BoxFit.fill,
      frameBuilder:
          (BuildContext context, Widget child, int frame, bool isAsynchLoaded) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        );
      },
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        return Center(child: Text('Loading..'));
      },
      errorBuilder: (BuildContext context, Object error, StackTrace st) =>
          Center(child: Icon(Icons.person, color: Colors.grey, size: 40)));
}
