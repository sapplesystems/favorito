import 'package:Favorito/ui/menu/MenuProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CallSwitcher extends StatelessWidget {
  MenuProvider vaTrue;
  @override
  Widget build(BuildContext context) {
    vaTrue = Provider.of<MenuProvider>(context, listen: true);
    return Switch(
      value: vaTrue.getCatData()?.outOfStock == 1,
      onChanged: (value) => vaTrue.funMenuCatEdit(),
      activeTrackColor: Color(0x56dd2525),
      activeColor: Colors.red,
    );
  }
}
