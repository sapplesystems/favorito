// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:flutter/material.dart';

// class Example extends StatefulWidget {
//   @override
//   _ExampleState createState() => _ExampleState();
// }

// class _ExampleState extends State<Example> {
//   final TextEditingController _controller = TextEditingController();
//   final _channel = WebSocketChannel.connect(
//     Uri.parse('http://demos.sappleserve.com:3000/api/business-user/get-chats'),
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("sddfs"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Form(
//                 child: TextFormField(
//                   controller: _controller,
//                   decoration: InputDecoration(labelText: 'Send a message'),
//                 ),
//               ),
//               SizedBox(height: 24),
//               StreamBuilder(
//                 stream: _channel.stream,
//                 builder: (context, snapshot) {
//                   return Text(
//                       snapshot.hasData ? '${snapshot.data.length}' : '');
//                 },
//               )
//             ]),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _sendMessage,
//         tooltip: 'Send message',
//         child: Icon(Icons.send),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }

//   void _sendMessage() {
//     if (_controller.text.isNotEmpty) {
//       _channel.sink.add(_controller.text);
//     }
//   }

//   @override
//   void dispose() {
//     _channel.sink.close();
//     super.dispose();
//   }
// }
