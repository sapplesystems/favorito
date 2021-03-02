import 'package:flutter_tagging/flutter_tagging.dart';

class SkillListRequiredDataModel extends Taggable {
  final String skillName;
  final int id;

  SkillListRequiredDataModel(this.skillName, this.id);

  @override
  List<Object> get props => [skillName];

  String toString() => '{id:$id,skillName:$skillName}';
}
