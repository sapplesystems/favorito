import 'package:Favorito/component/MyOutlineButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/myCss.dart';
import 'package:flutter/material.dart';

class review extends StatefulWidget {
  @override
  _reviewState createState() => _reviewState();
}

class _reviewState extends State<review> {
  TextEditingController ctrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffff4f4),
      appBar: AppBar(
        backgroundColor: Color(0xfffff4f4),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        centerTitle: true,
        title: Text(
          "Review List",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: ListView(
          children: [
            Column(children: [
              Card(
                elevation: 4,
                shape: rrb,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("It was very greate exprience!"),
                          Text(
                            "12 jun",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              for (int i = 0; i < 5; i++)
                                Icon(
                                  Icons.star,
                                  size: 16,
                                )
                            ],
                          ),
                          Text(
                            "John Hopkins",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "Overall it was great experience. There are some things i didn’t liked. So you have to change it as soon as possibile. So you have to change it as soon as possibile\n\n Thank you for ewview! We will fix it as soon as possible!"),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 12),
                child: txtfieldboundry(
                  valid: true,
                  title: "Reply",
                  ctrl: ctrl,
                  maxLines: 5,
                  hint: "Enter reply to user",
                  security: false,
                ),
              ),
              MyOutlineButton(
                title: "Submit",
                function: () {},
              )
            ]),
          ],
        ),
      ),
    );
  }
}
