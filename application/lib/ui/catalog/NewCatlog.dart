import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/ui/catalog/CatalogsProvider.dart';
import 'package:Favorito/utils/Regexer.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class NewCatlog extends StatelessWidget {
  CatalogsProvider vaTrue;
  CatalogsProvider vaFalse;
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    vaTrue = Provider.of<CatalogsProvider>(context, listen: true);
    vaFalse = Provider.of<CatalogsProvider>(context, listen: false);
    vaFalse.setContext(context);
    return WillPopScope(
      onWillPop: () {
        vaTrue.clearAll();
        vaTrue.getCatelogList(false);
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(vaTrue.newCatalogTxt,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Gilroy-Bold',
                  letterSpacing: 2)),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              vaTrue.clearAll();
              vaTrue.getCatelogList(false);
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: ListView(children: [
            Container(
              height: sm.h(20),
              margin: EdgeInsets.symmetric(vertical: sm.h(4)),
              child: ListView(scrollDirection: Axis.horizontal, children: [
                InkWell(
                    onTap: () => vaFalse.attachImages(),
                    child: Container(
                      width: sm.h(18),
                      child: Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Padding(
                              padding: const EdgeInsets.all(18),
                              child:
                                  Icon(Icons.cloud_upload_outlined, size: 30)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          elevation: 5,
                          margin: EdgeInsets.all(10)),
                    )),
                if (vaTrue.imgUrls != null)
                  for (int i = vaTrue.imgUrls.length - 1; i >= 0; i--)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: vaTrue.imgUrls[i] != null
                          ? Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: FadeInImage.memoryNetwork(
                                  fit: BoxFit.cover,
                                  width: sm.h(17),
                                  placeholder: kTransparentImage,
                                  image: vaTrue.imgUrls[i]),
                              margin: EdgeInsets.all(0))
                          : null,
                    )
              ]),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Builder(
                    builder: (context) => Form(
                        key: vaTrue.formKey,
                        autovalidate: vaTrue.autovalidate,
                        child: Column(children: [
                          for (int i = 0; i < 5; i++)
                            Padding(
                              padding: EdgeInsets.only(bottom: sm.h(1)),
                              child: txtfieldboundry(
                                valid: true,
                                title: vaTrue.title[i],
                                hint:
                                    "Enter Catalog ${vaTrue.title[i].toString().toLowerCase()}",
                                controller: vaTrue.controller[i],
                                maxLines: i == 2 ? 4 : 1,
                                myregex: i == 3 ? urlRegex : null,
                                myOnChanged: (_) {
                                  vaTrue.needSubmit(true);
                                },
                                keyboardSet: i == 3
                                    ? TextInputType.emailAddress
                                    : (i == 1 || i == 4)
                                        ? TextInputType.number
                                        : TextInputType.text,
                                security: false,
                              ),
                            ),
                        ]))),
              ),
            ),
            Visibility(
              visible: vaTrue.getNeedSubmit(),
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: sm.w(16), vertical: sm.h(2)),
                  child: RoundedButton(
                      clicker: () => vaTrue.funSublim(),
                      clr: Colors.red,
                      title: vaTrue.submitBtnTxt)),
            )
          ]),
        ),
      ),
    );
  }
}
