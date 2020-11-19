import 'package:flutter/material.dart';

void fieldFocusChange(BuildContext _context, FocusNode _from, FocusNode _to) {
  try {
    _from.unfocus();
  } catch (e) {}

  try {
    FocusScope.of(_context).requestFocus(_to);
  } catch (e) {}
}
