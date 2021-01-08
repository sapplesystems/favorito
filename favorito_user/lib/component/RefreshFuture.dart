// import 'package:flutter_neumorphic/flutter_neumorphic.dart';

// class RefreshFuture extends StatefulWidget {
//   Widget bodyy;
//   Future future;
//   RefreshFuture({this.bodyy, this.future});
//   @override
//   _RefreshFutureState createState() => _RefreshFutureState();
// }

// class _RefreshFutureState extends State<RefreshFuture> {
//   GlobalKey _refreshIndicatorKey = GlobalKey();

//   var _calculation;
//   @override
//   void initState() {
//     super.initState();
//     _calculation = getCalculation(widget.future);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _calculation, // a previously-obtained Future<String> or null
//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.none:
//             return Text('Press button to start.');
//           case ConnectionState.active:
//           case ConnectionState.waiting:
//             return Text('Awaiting result...');
//           case ConnectionState.done:
//             if (snapshot.hasError) return Text('Error: ${snapshot.error}');
//             return new RefreshIndicator(
//                 key: _refreshIndicatorKey,
//                 color: Colors.blue,
//                 onRefresh: () {
//                   return _calculation = getCalculation(widget.future); // EDITED
//                 },
//                 child: widget.bodyy);
//             break;
//           default:
//             return null;
//         }
//       },
//     );
//   }
// }

// Future getCalculation(Future future) async {
//   return future;
// }
