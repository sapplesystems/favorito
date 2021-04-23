import 'package:favorito_user/model/appModel/appointment/AppSerModel.dart';
import 'package:favorito_user/model/appModel/appointment/ServiceModel.dart';
import 'package:favorito_user/model/appModel/appointment/SettingModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
class AppointmentProvider extends ChangeNotifier{

  TextEditingController myNotesEditTextController = TextEditingController();
  AppSerModel _appSerModel = AppSerModel();
  String _selectedService;
  String _selectedServicePerson;
  List<ServiceModel> _servicesList=[];
  List<String> _servicesNameList=[];
  AppointmentProvider(){

  }
  AppSerModel getAppSerModel()=>_appSerModel;
   
   setAppSerModel(AppSerModel _val){
    _appSerModel =_val;
    _servicesList.addAll(_val.data[0].service);
    
    for(var _a in _val.data[0].service){
      _servicesNameList.add(_a.serviceName);
    }
    notifyListeners();
  }
getServicesNameList()=>_servicesNameList;
  getSelectedService()=>_selectedService;
  setSelectedService(String _val){
    _selectedService =_val;
    notifyListeners();
  }


  getSelectedServicePerson()=>_selectedServicePerson;
  setSelectedServicePerson(String _val){
    _selectedServicePerson =_val;
    notifyListeners();
  }
void baseUserAppointmentVerboseService(context)async{
  var _businessId = 
          Provider.of<BusinessProfileProvider>(context, listen: false)
                  .getBusinessId();
print("_businessId:${_businessId}");                  
  await APIManager.baseUserAppointmentVerboseService({'business_id':_businessId}).then((value) {
if(value.status == 'success'){
  _servicesNameList.clear();
  setAppSerModel(value);
}
  });
}

}