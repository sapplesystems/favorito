import 'package:flutter/cupertino.dart';

class RequestModel {
  BuildContext _context;
  String _url;
  var _data;
  bool _isRaw = false;

  bool get isRaw => _isRaw;

  set isRaw(bool value) {
    _isRaw = value;
  }

  BuildContext get context => _context;

  set context(BuildContext value) {
    _context = value;
  }

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  get data => _data;

  set data(value) {
    _data = value;
  }
}
