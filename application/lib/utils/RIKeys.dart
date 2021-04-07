import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class RIKeys {
  static final GlobalKey<ScaffoldState> key1 = GlobalKey();
  static final riKey2 = const Key('__RIKEY2__');
  static final riKey3 = const Key('__RIKEY3__');
  static final josKeys1 = GlobalKey<ScaffoldState>();
  static final josKeys2 = GlobalKey<ScaffoldState>(); //Waitlist

  static final josKeys3 =
      GlobalKey<DropdownSearchState<String>>(); //booking setting page slot key
  static final josKeys4 = GlobalKey<ScaffoldState>(); //booking popup
}
