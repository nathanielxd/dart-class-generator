# Dart Code Generator

A toolkit providing builder-based library for dart code generation such as classes, methods, properties and constructors.

*"I have used Dart to create Dart"*

## Features

- Generate classes, constructors, methods, properties with ease
- Pre-made generation of copyWith, serialization (toMap, fromMap) and Equatable
- Outputs everything as a simple string which you can then write to a file on your own;

Attention! This does not work with Dart's **build** package. This is a standalone library written in Dart that builds Dart code.

## Getting started

1. Add the dependency to your pubspec.yaml file
```yaml
code_generator: ^1.0.0
```

2. Import the dependecy in your code file
```dart
import 'package:code_generator/code_generator.dart';
```

## Usage

Build your first class
```dart
final name = Field('String', 'name', prefix: 'final');
final age = Field('int', 'age', prefix: 'final');
  
final builder = ClassBuilder('Human');
builder
    ..buildConstructor()
    ..buildCopyWith()
    ..addFields([name, age]);

  print(builder.build());
```

## Additional information