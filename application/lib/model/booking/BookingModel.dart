class BookingModel {
  String day;
  List<Slots> slotList = [];
  List<User> userList = [];
}

class Slots {
  String slot;
  String slotOccupancy;
  String isFull;
}

class User {
  String name;
  String userNotes;
  String date;
  String slot;
  String noOfPeople;
  String mobileNo;
}
