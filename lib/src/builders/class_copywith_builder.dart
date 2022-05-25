import 'package:code_generator/code_generator.dart';

class ClassCopyWithBuilder extends IBuilder {

  final String className;
  final List<Field> fields;

  ClassCopyWithBuilder(this.className, {
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