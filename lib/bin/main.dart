import 'package:class_builder/class_builder.dart';

void main(List<String> args) {

  final builder = ClassConstructorBuilder('Constructor')
    ..withSuper('key: key')
    ..withBody('// Hello There')
    ..addClassFields([
      Field('String', 'foo', named: false),
      Field('String', 'bar', value: "'jeg'")
    ])
    ..addParameters([
      Field('num', 'bro', named: false),
      Field('num', 'cox')
    ]);

  print(builder.build());
}