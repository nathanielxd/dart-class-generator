import 'package:class_generator/class_generator.dart';

class ClassCopyWith extends IBuilder {

  final String className;
  List<Field> fields;

  ClassCopyWith(this.className, {
    required this.fields
  });

  String get _parameters => fields
    .map((e) => '\n' + tab + '${e.type}? ${e.identifier}')
    .join(',');

  String get _fields => fields
    .map((e) => '\n' + tab + '${e.identifier}: ${e.identifier} ?? this.${e.identifier}')
    .join(',');

  @override
  String build() {
    add('$className copyWith({$_parameters');
    add('}) => $className($_fields');
    add(');');
    return super.build();
  }
}