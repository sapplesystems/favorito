import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Business/Category.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ServicesOfBusiness extends StatefulWidget {
  List<Category> data;
  ServicesOfBusiness({Key key, @required this.sm, this.data}) : super(key: key);

  final SizeManager sm;

  @override
  _ServicesOfBusinessState createState() => _ServicesOfBusinessState();
}

class _ServicesOfBusinessState extends State<ServicesOfBusiness> {
  @override
  Widget build(BuildContext context) {
    String categoryName = "";
    for (var _v in widget.data) {
      categoryName = categoryName + _v.categoryName + " | ";
    }
    return Text(categoryName.substring(0, 16),
        style: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(fontSize: 14, fontWeight: FontWeight.w300));
  }
}
