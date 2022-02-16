import 'package:class_builder/class_builder.dart';

void main(List<String> args) {
  final name = ClassField('String', 'name');
  final age = ClassField('DateTime', 'age', nullable: true);

  final builder = ClassBuilder('MyClass');
    builder
        ..withExtension('Equatable') // Extend the Equatable class
        ..withCopyWith() // Build a copyWith method
        ..addField(ClassField('String', 'name'))
        ..addField(ClassField('int', 'age'))
        ..withEquatable(); // Build override equatable props

    final code = builder.build();
    print(code);
}