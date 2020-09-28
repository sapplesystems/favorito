import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/ui/review/review.dart';
import 'package:flutter/material.dart';

class reviewList extends StatefulWidget {
  @override
  _reviewListState createState() => _reviewListState();
}

class _reviewListState extends State<reviewList> {
  SizeManager sm;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
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
      body: Column(children: [
        Padding(
          padding: EdgeInsets.all(12),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Text("4.5", style: TextStyle(fontSize: 24)),
              Icon(Icons.star, color: Color(0xffdd2626))
            ]),
            Text("100 Rating\n75 Reviews", style: TextStyle(fontSize: 14))
          ]),
        ),
        Container(
          height: sm.scaledHeight(64),
          child: Card(
            shape: rrb28,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.filter_alt,
                            color: Color(0xffdd2626), size: 30),
                        Row(
                          children: [
                            Text(
                              "Alphabetical",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Icon(Icons.sort, color: Color(0xffdd2626), size: 30)
                          ],
                        )
                      ]),
                  for (int i = 0; i < 2; i++)
                    rowCard("Olivia carr",
                        "Reach new audience searching for related services",
                        () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => review()));
                    }),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }

  Widget rowCard(String title, String subtitle, Function function) {
    return InkWell(
      onTap: function,
      child: Card(
        elevation: 4,
        shape: rrb,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            margin: EdgeInsets.symmetric(vertical: 12),
            decoration: bd3,
            child: ListTile(
                title: Text(title,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                subtitle: Text(subtitle),
                trailing: Container(
                  height: 40,
                  width: 40,
                  child: Row(children: [
                    Text("4.5", style: TextStyle(fontSize: 16)),
                    Icon(Icons.star, color: Color(0xffdd2626), size: 16)
                  ]),
                ))),
      ),
    );
  }
}
