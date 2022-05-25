import 'dart:io';

import 'package:code_generator/code_generator.dart';

void main(List<String> args) {

  final firstName = Field('String', 'firstName', prefix: 'final');
  final lastName = Field('String', 'lastName', prefix: 'final');
  final status = Field('bool', 'loading', prefix: 'final');
  final errorMessage = Field('String', 'errorMessage', prefix: 'final', nullable: true);

  final fields = [firstName, lastName, status, errorMessage];
  
  final builder = ClassBuilder('ProfileCreationState');
  builder
    ..buildConstructor()
    ..buildCopyWith()
    ..addConstructor(
      ConstructorBuilder('ProfileCreationState')
        ..withName('pure')
        ..withPrefix('factory')
        ..withBody([
          'return ProfileCreationState(',
          ...fields
            .where((element) => !element.nullable)
            .map((e) => '    ' + e.toEmptyParameter() + ','),
          '  );'
        ].join('\n'))
    )
    ..addFields(fields);

  print(builder.build());
  File(Directory.current.path + '/example/output.dart').writeAsStringSync(builder.build());
}