# Dart Class Builder

A suite of tools that provide generation of dart code such as classes, methods, properties and constructors.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

- Generate classes, constructors, methods, properties with ease;
- Quick generation of copyWith methods, serialization (toMap, fromMap) and Equatable;
- Outputs everything as a simple string which you can then write to a file on your own;

Attention! This does not work with Dart's **build** package. This is a standalone package written in Dart that builds Dart code.

## Getting started

1. Add the dependency to your pubspec.yaml file
`class_builder: any`

2. Build your first class
```dart
void main() {
    final builder = ClassBuilder('MyClass');
    builder
        ..withExtension('Equatable') // Extend the Equatable class
        ..withCopyWith() // Build a copyWith method
        ..addField(ClassField('String', 'name'))
        ..addField(ClassField('int', 'age'))
        ..withEquatable(); // Build override equatable props

    final code = builder.build();
    print(code);

    /** Output:

    class MyClass extends Equatable {

        final String name;
        final int age;

        MyClass copyWith({
            String? name,
            int? age,
        }) => MyClass(
            name: name ?? this.name,
            age: age ?? this.age,
        );

        @override
        List<Object?> get props => [name, age];
    }
    */
}
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
