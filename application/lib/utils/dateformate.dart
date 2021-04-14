import 'package:intl/intl.dart';

final DateFormat dateFormat1 =
    DateFormat('yyyy-MM-dd'); // something like 2013-04-20

final DateFormat dateFormat2 = DateFormat('dd-MM-yyyy'); // something like

final DateFormat dateFormat3 =
    DateFormat('dd-MM-yyyy'); // something like 2013-04-20

final DateFormat dateFormat4 = DateFormat('dd MMM');

final DateFormat dateFormat5 =
    DateFormat('dd MMM yyyy'); // something like 2013-04-20
final DateFormat formatter = DateFormat('yyyy-MM-dd');

final DateFormat dateFormat6 = DateFormat('d MMM'); //12 Apr
final DateFormat dateFormat7 = DateFormat('d MMM yy'); //12 Apr
