import 'package:intl/intl.dart';

final DateFormat dateFormat1 =
    DateFormat('yyyy-MM-dd'); // something like 2013-04-20

final DateFormat dateFormat2 = DateFormat('dd-MM-yyyy'); // something like

final DateFormat dateFormat3 =
    DateFormat('dd-MM-yyyy'); // something like 2013-04-20

final DateFormat dateFormat4 = DateFormat('dd MMM'); // something like 12 Jan

final DateFormat dateFormat5 =
    DateFormat('dd MMMM yyyy'); // something like 12 January 2021

final DateFormat dateFormat6 = DateFormat('dd MMMM yyyy jm');
final DateFormat dateFormat7 = DateFormat('MM/dd'); // something like 8:00 am
final DateFormat dateFormat8 = DateFormat('dd/MM/yyyy'); // something like

final DateFormat dateFormat9 =
    DateFormat('dd MMMM yyyy HH:mm'); // something like 12 January 2021
