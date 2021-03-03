import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/model/job/SkillListRequiredDataModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/jobs/JobProvider.dart';
import 'package:Favorito/utils/Regexer.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tagging/flutter_tagging.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:provider/provider.dart';

class CreateJob extends StatelessWidget {
  JobProvider vaTrue;
  JobProvider vaFalse;
  bool firstload = true;

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    vaTrue = Provider.of<JobProvider>(context, listen: true);
    vaFalse = Provider.of<JobProvider>(context, listen: false);
    vaFalse.setContext(context);
    if (firstload) {
      vaTrue.allClear();
      firstload = false;
    }
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black, size: 26),
                onPressed: () => Navigator.of(context).pop()),
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(vaTrue.appBarHeading,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Gilroy-Bold',
                    letterSpacing: 2))),
        body: Padding(
          padding: EdgeInsets.all(sm.w(4)),
          child: ListView(children: [
            Card(
                child: Builder(
              builder: (context) => Form(
                key: vaTrue.formKey,
                autovalidate: vaTrue.autoValidateForm,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    txtfieldboundry(
                        controller: vaTrue.controller[0],
                        title: "Title",
                        security: false,
                        valid: true),
                    Padding(
                        padding: EdgeInsets.only(top: sm.w(1)),
                        child: txtfieldboundry(
                            controller: vaTrue.controller[1],
                            title: "Description",
                            security: false,
                            maxLines: 5,
                            valid: true)),
                    Padding(
                      padding: EdgeInsets.all(sm.w(2)),
                      child: FlutterTagging<SkillListRequiredDataModel>(
                        initialItems: vaTrue.selectedSkillList,
                        textFieldConfiguration: TextFieldConfiguration(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide()),
                              filled: true,
                              fillColor: Colors.transparent,
                              hintText: 'Search Skill',
                              labelText: 'Select Skill'),
                        ),
                        findSuggestions: WebService.getLanguages,
                        additionCallback: (value) {
                          print("aaa4:$value");
                          return SkillListRequiredDataModel(value, 0);
                        },
                        onAdded: (skill) {
                          print("aaa3:$skill"); //here
                          // can call a service to add new skill
                          return SkillListRequiredDataModel(
                              skill.skillName, skill.id);
                        },
                        configureSuggestion: (skill) {
                          print("aaa2:$skill");
                          return SuggestionConfiguration(
                            title: Text(skill.skillName),
                            additionWidget: Chip(
                                avatar: Icon(
                                  Icons.add_circle,
                                  color: Colors.white,
                                ),
                                label: Text('Add New Tag'),
                                labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w300),
                                backgroundColor: Colors.green),
                          );
                        },
                        configureChip: (skill) {
                          print("aaa1:$skill");
                          return ChipConfiguration(
                            label: Text(skill.skillName),
                            backgroundColor: Colors.green,
                            labelStyle: TextStyle(color: Colors.white),
                            deleteIconColor: Colors.white,
                          );
                        },
                        onChanged: () {
                          print("aaa5");
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(sm.w(2)),
                      child: DropdownSearch<String>(
                        key: vaTrue.contactKey,
                        validator: (v) => v == '' ? "required field" : null,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        mode: Mode.MENU,
                        maxHeight:
                            (vaTrue.contactOptionsList.length ?? 0.0) * 52.0,
                        selectedItem: vaTrue.selectedContactOption,
                        items: vaTrue.contactOptionsList,
                        label: "Contact Via",
                        hint: "Please Select Option",
                        showSearchBox: false,
                        onChanged: (value) => vaTrue.contactVia(value),
                      ),
                    ),
                    txtfieldboundry(
                      controller: vaTrue.controller[2],
                      title: vaTrue.contactTitle,
                      security: false,
                      myregex: emailAndMobileRegex,
                      keyboardSet: vaTrue.contactTitle == 'Contact'
                          ? TextInputType.number
                          : TextInputType.emailAddress,
                      maxlen: vaTrue.contactTitle == 'Contact' ? 10 : 200,
                      hint: vaTrue.contactHint,
                      maxLines: 1,
                      valid: true,
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: sm.w(.5)),
                        child: txtfieldboundry(
                            controller: vaTrue.controller[3],
                            title: "Pincode",
                            security: false,
                            hint: 'Please enter pincode',
                            maxLines: 1,
                            error: vaTrue.error[3],
                            keyboardSet: TextInputType.number,
                            valid: true,
                            maxlen: 6,
                            myOnChanged: (val) => vaTrue.funPincode(val))),
                    Padding(
                        padding: EdgeInsets.only(top: sm.w(.5)),
                        child: txtfieldboundry(
                            controller: vaTrue.controller[4],
                            title: "City",
                            security: false,
                            hint: 'Please enter City',
                            maxLines: 1,
                            isEnabled: false,
                            error: vaTrue.error[4],
                            keyboardSet: TextInputType.number,
                            valid: true,
                            maxlen: 6,
                            myOnChanged: (val) => vaTrue.funPincode(val))),
                    // Padding(
                    //   padding: EdgeInsets.all(sm.w(2)),
                    //   child: DropdownSearch<CityList>(
                    //     key: vaTrue.cityKey,
                    //     validator: (v) => v == null ? "required field" : null,
                    //     autoValidateMode: AutovalidateMode.onUserInteraction,
                    //     mode: Mode.MENU,
                    //     // showSelectedItem: true,
                    //     compareFn: (CityList i, CityList s) => i.isEqual(s),
                    //     itemAsString: (CityList u) => u.userAsString(),
                    //     selectedItem: vaTrue.selectedCity,
                    //     items: vaTrue.cityList,
                    //     label: "City",
                    //     hint: "Please Select City",
                    //     showSearchBox: false,
                    //     onChanged: (value) {},
                    //   ),
                    // ),
                  ]),
                ),
              ),
            )),
            SizedBox(
              height: sm.h(6),
            ),
            Align(
                alignment: Alignment.center,
                child: Container(
                    width: sm.w(50),
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: RoundedButton(
                        clicker: () => vaTrue.submit(),
                        clr: Colors.red,
                        title: "Done")))
          ]),
        ));
  }
}
