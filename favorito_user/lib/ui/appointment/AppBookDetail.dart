import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class AppBookDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
              appBar: AppBar(
            backgroundColor: myBackGround,
            elevation: 0,
            title: Text('Details'),
            
          ),
            backgroundColor: myBackGround,
            body: Column(
              children: [
                Card(
                  child:Column(children: [
                    Text("dfgdfg")
                  ],) ),
              ],
            ),
        
      ),
    );
  }
}