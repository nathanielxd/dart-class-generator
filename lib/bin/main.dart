import 'package:class_builder/class_builder.dart';

void main(List<String> args) {

  final foo = Field('String', 'foo', named: false);
  final bar = Field('String', 'bar', value: "'jeg'");

  final builder = ClassSerializationBuilder('MyClass', 
    fields: [foo, bar],
    fromFirebaseDocument: true
  );

  print(builder.build());
}
