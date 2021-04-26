import 'package:favorito_user/model/appModel/appointment/AppSerModel.dart';
import 'package:favorito_user/model/appModel/appointment/Person.dart';
import 'package:favorito_user/model/appModel/appointment/ServiceModel.dart';
import 'package:favorito_user/model/appModel/appointment/SettingModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class AppointmentProvider extends ChangeNotifier{

  TextEditingController myNotesEditTextController = TextEditingController();
  AppSerModel _appSerModel = AppSerModel();
  //all Services list 
  List<ServiceModel> _servicesList=[];
  List<String> _servicesNameList=[];
  String _selectedService ;
  int _selectedServiceId ;
List<SettingModel> settingList =[];
Person selectedPerson = Person();
List<Person> personList =[Person(id:0,personName: 'No data')];
List<String> _personNameList =[];
int selectesPersonId=0;
Person selectesPersonName;

  AppSerModel getAppSerModel()=>_appSerModel;
   
   setAppSerModel(AppSerModel _val){
    _appSerModel =_val;
    _servicesList.clear();
    _servicesList.addAll(_val.data[0]?.service);
    _servicesNameList.clear();
    for(var _a in _val.data[0].service)
      _servicesNameList.add(_a.serviceName);
   notifyListeners();
  }
getServicesNameList()=>_servicesNameList;
List<ServiceModel> getServicesList()=>_servicesList;

  String getSelectedService()=>_selectedService;

  setSelectedService(String _val,BuildContext context){
    _selectedService =_val;
    for(int _i=0;_i<_servicesList.length;_i++){
      if(_selectedService == _servicesList[_i].serviceName){
        _selectedServiceId = _servicesList[_i].id;
    selectesPersonId =0;
    //services are selected now call person as per services
    baseUserAppointmentPersonByServiceid(context);
      }
    }
  }


void baseUserAppointmentVerboseService(context)async{            
  await APIManager.baseUserAppointmentVerboseService({'business_id':getBusinessId(context)}).then((value) {
if(value.status == 'success')
  setAppSerModel(value);
  });
}


void baseUserAppointmentPersonByServiceid(context)async{         
  Map _map ={'business_id':getBusinessId(context),'service_id':_selectedServiceId};
  print("_map:${_map}");
    personList.clear();
    _personNameList.clear();
    personList.add(Person(id:0,personName: 'No data'));
  await APIManager.baseUserAppointmentPersonByServiceid(_map).then((value) {
if(value.status == 'success'){
  if(value.data.isNotEmpty){
    personList.clear();
    personList.addAll(value.data);
  }
  print("dddddd:${value?.data?.length}");
  for(int _i=0;_i<value?.data?.length;_i++){
    if(!_personNameList.contains(value.data[_i].personName)){
      _personNameList.add(value.data[_i].personName);
    }
  
  }
    notifyListeners();
}
  });
}

//personlist gettter setter
List<String> getPersonNameList()=>_personNameList;
List<Person> getPersonList()=>personList;
setSelectedServicePerson(Person _val){
  selectedPerson =_val;
  for(int _i=0;_i<personList.length;_i++){
   if(_val.personName == personList[_i].personName){
     selectesPersonId = personList[_i].id;
     selectesPersonName = personList[_i];
     
   }else{
     selectesPersonName = Person();
   }
  }
  notifyListeners();
}

int selectedPersonSet(){
  int _v=0;
  if(selectesPersonId!=0){
 _v=personList.indexWhere((element) => element.id==selectesPersonId);
  }
  return _v;
}

getBusinessId(context)=>Provider.of<BusinessProfileProvider>(context, listen: false).getBusinessId();

}