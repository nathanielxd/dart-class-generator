import 'package:class_generator/class_generator.dart';

void main(List<String> args) {

  var fields = [
    Field('String', 'firstName'),
    Field('int', 'age'),
    Field('List<String>', 'address')
  ];

  final model = ClassBuilder('Human')
    ..constructor = true
    ..copyWith = true
    ..toMap = true
    ..fromMap = true
    ..empty = true
    ..equatable = true
    ..fields.addAll(fields.map((e) => e
      ..modifier = 'final'
    ));

  print(model.build());
}