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

2. Build your first class
```dart
final name = Field('String', 'name', prefix: 'final');
final age = Field('int', 'age', prefix: 'final');
  
final builder = ClassBuilder('Human');
builder
    ..buildConstructor()
    ..buildCopyWith()
    ..addFields(fields);

  print(builder.build());
```

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
