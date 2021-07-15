import 'package:favorito_user/component/ImageMaster.dart';
import 'package:favorito_user/services/function.dart';
import 'package:favorito_user/ui/notification/NofificationProvider.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/config/SizeManager.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: myBackGround2,
          elevation: 1,
          title: Text("Notification",
              style: Theme.of(context).textTheme.headline4),
          centerTitle: true,
        ),
        body: Consumer<NotificationProvider>(
          builder: (context, data, child) {
            return ListView.builder(
                itemCount: data.offersListData.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: sm.w(4), vertical: 4),
                    child: Card(
                      elevation: 8,
                      shadowColor: Colors.grey.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                height: sm.h(10),
                                width: sm.h(10),
                                child: ImageMaster(
                                  url: data.offersListData[index].photo ?? "",
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: sm.w(2),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.offersListData[index].offerTitle,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Text(
                                data.offersListData[index].businessName,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: InkWell(
                                  onTap: () => data.updateOfferstatus(index),
                                  child: Text(
                                    data.offersListData[index].offerStatus ==
                                            '1'
                                        ? "Activated"
                                        : "Active",
                                    style:
                                        TextStyle(color: myRed, fontSize: 20),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                });
          },
        ));
  }
}
