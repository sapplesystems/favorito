import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/model/offer/CreateOfferRequestModel.dart';
import 'package:Favorito/model/offer/CreateOfferRequiredDataModel.dart';
import 'package:Favorito/model/offer/OfferListDataModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Favorito/config/SizeManager.dart';

class CreateOffer extends StatefulWidget {
  final OfferDataModel offerData;

  CreateOffer({this.offerData});

  @override
  _CreateOfferState createState() => _CreateOfferState();
}

class _CreateOfferState extends State<CreateOffer> {
  String _selectedOfferState = '';
  String _selectedOfferType = '';
  CreateOfferRequiredDataModel _offerRequiredData =
      CreateOfferRequiredDataModel();

  bool _autoValidateForm = false;

  final _myTitleEditController = TextEditingController();
  final _myDescriptionEditController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    initializeDefaultValues();
    super.initState();
  }

  initializeDefaultValues() {
    WebService.funGetCreateOfferDefaultData(context).then((value) {
      setState(() {
        _offerRequiredData = value;
        if (widget.offerData == null) {
          _selectedOfferState = '';
          _selectedOfferType = '';
          _myTitleEditController.text = '';
          _myDescriptionEditController.text = '';
        } else {
          _selectedOfferState = widget.offerData.offerStatus;
          _selectedOfferType = widget.offerData.offerType;
          _myTitleEditController.text = widget.offerData.offerTitle;
          _myDescriptionEditController.text = widget.offerData.offerDescription;
        }
        _autoValidateForm = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: myBackGround,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Create Offer",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
              color: myBackGround,
            ),
            child: ListView(children: [
              Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
                child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    child: Builder(
                      builder: (context) => Form(
                        key: _formKey,
                        autovalidate: _autoValidateForm,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: txtfieldboundry(
                                controller: _myTitleEditController,
                                title: "Title",
                                security: false,
                                valid: true,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: txtfieldboundry(
                                controller: _myDescriptionEditController,
                                title: "Description",
                                security: false,
                                maxLines: 5,
                                valid: true,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: DropdownSearch<String>(
                                validator: (v) =>
                                    v == '' ? "required field" : null,
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                mode: Mode.MENU,
                                showSelectedItem: true,
                                selectedItem: _selectedOfferState,
                                items: _offerRequiredData.data != null
                                    ? _offerRequiredData
                                        .data.offerStatusDropDown
                                    : null,
                                label: "Offer State",
                                hint: "Please Select Offer State",
                                showSearchBox: false,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedOfferState = value;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: DropdownSearch<String>(
                                validator: (v) =>
                                    v == '' ? "required field" : null,
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                mode: Mode.MENU,
                                showSelectedItem: true,
                                selectedItem: _selectedOfferType,
                                items: _offerRequiredData.data != null
                                    ? _offerRequiredData.data.offerTypeDropDown
                                    : null,
                                label: "Offer Type",
                                hint: "Please Select Offer Type",
                                showSearchBox: false,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedOfferType = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: sm.w(50),
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: roundedButton(
                    clicker: () {
                      if (_formKey.currentState.validate()) {
                        var requestData = CreateOfferRequestModel();
                        requestData.title = _myTitleEditController.text;
                        requestData.description =
                            _myDescriptionEditController.text;
                        requestData.selectedOfferState = _selectedOfferState;
                        requestData.selectedOfferType = _selectedOfferType;
                        if (widget.offerData == null) {
                          WebService.funCreateOffer(requestData, context)
                              .then((value) {
                            if (value.status == 'success') {
                              setState(() {
                                initializeDefaultValues();
                                BotToast.showText(text: value.message);
                              });
                            } else {
                              BotToast.showText(text: value.message);
                            }
                          });
                        } else {
                          requestData.id = widget.offerData.id.toString();
                          WebService.funEditOffer(requestData, context)
                              .then((value) {
                            if (value.status == 'success') {
                              setState(() {
                                BotToast.showText(text: value.message);
                              });
                            } else {
                              BotToast.showText(text: value.message);
                            }
                          });
                        }
                      } else {
                        _autoValidateForm = true;
                      }
                    },
                    clr: Colors.red,
                    title: "Post Offer",
                  ),
                ),
              ),
            ])));
  }
}
