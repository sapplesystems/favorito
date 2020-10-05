import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';

class NewItem extends StatefulWidget {
  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  bool _autoValidateForm = false;
  List<String> _categoryList;
  List<String> _typeList;

  final _myTitleEditTextController = TextEditingController();
  final _myPriceEditTextController = TextEditingController();
  final _myDescriptionEditTextController = TextEditingController();
  final _myQuantityEditTextController = TextEditingController();
  final _myMaxQuantityEditTextController = TextEditingController();

  String _selectedCategory;
  String _selectedType;

  bool _isFoodItem = true;

  void intitalizeValues() {
    _categoryList = ["a", "b", "c"];
    _typeList = ["Veg", "Non-veg"];
  }

  void initState() {
    intitalizeValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
      backgroundColor: myBackGround,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Highlights",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2)),
        actions: [
          IconButton(
            icon: Icon(Icons.error_outline, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: ListView(
          children: [
            Container(
              height: sm.scaledHeight(14),
              margin: EdgeInsets.symmetric(vertical: sm.scaledHeight(2)),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (int i = 0; i < 10; i++)
                    Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.network(
                        'https://eatforum.org/content/uploads/2018/05/table_with_food_top_view_900x700.jpg',
                        fit: BoxFit.fill,
                        width: sm.scaledHeight(10),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                    )
                ],
              ),
            ),
            Container(
                decoration: bd1,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40.0),
                margin: EdgeInsets.symmetric(horizontal: 12),
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: sm.scaledHeight(4)),
                    child: txtfieldboundry(
                      valid: true,
                      title: "Title",
                      hint: "Enter title",
                      ctrl: _myTitleEditTextController,
                      maxLines: 1,
                      security: false,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: sm.scaledHeight(4)),
                    child: DropdownSearch<String>(
                      validator: (v) => v == '' ? "required field" : null,
                      autoValidate: _autoValidateForm,
                      mode: Mode.MENU,
                      selectedItem: _selectedCategory,
                      items: _categoryList,
                      label: "Category",
                      hint: "Please Select Category",
                      showSearchBox: false,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: sm.scaledHeight(4)),
                    child: txtfieldboundry(
                      valid: true,
                      title: "Price",
                      hint: "Enter preice",
                      ctrl: _myPriceEditTextController,
                      maxLines: 1,
                      security: false,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: sm.scaledHeight(4)),
                    child: txtfieldboundry(
                      valid: true,
                      title: "Description",
                      hint: "Enter description",
                      ctrl: _myDescriptionEditTextController,
                      maxLines: 4,
                      security: false,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: sm.scaledHeight(4)),
                    child: txtfieldboundry(
                      valid: true,
                      title: "Quantity",
                      hint: "Enter quantity",
                      ctrl: _myQuantityEditTextController,
                      maxLines: 1,
                      security: false,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: sm.scaledHeight(4)),
                    child: Visibility(
                      visible: _isFoodItem,
                      child: DropdownSearch<String>(
                        validator: (v) => v == '' ? "required field" : null,
                        autoValidate: _autoValidateForm,
                        mode: Mode.MENU,
                        selectedItem: _selectedType,
                        items: _categoryList,
                        label: "Type",
                        hint: "Please Select Type",
                        showSearchBox: false,
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: sm.scaledHeight(4)),
                    child: txtfieldboundry(
                      valid: true,
                      title: "Max. quantity per order",
                      hint: "Enter maximum quantity",
                      ctrl: _myMaxQuantityEditTextController,
                      maxLines: 1,
                      security: false,
                    ),
                  ),
                ])),
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: sm.scaledWidth(16),
                    vertical: sm.scaledHeight(2)),
                child: roundedButton(
                    clicker: () {
                      // funSublim();
                    },
                    clr: Colors.red,
                    title: "Save"))
          ],
        ),
      ),
    );
  }
}
