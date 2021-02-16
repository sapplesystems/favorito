import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Acces {
  String error = null;
  TextEditingController controller = TextEditingController();

  String toString() => 'Error:$error,value:${controller.text},';
}
