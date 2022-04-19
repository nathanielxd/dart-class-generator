import 'package:class_builder/class_builder.dart';

/*class ClassBuilder extends IBuilder {

  final String className;
  ClassBuilder(this.className);

  final _fields = <ClassField>[];
  final constructors = <ClassConstructorBuilder>[];
  final methods = <ClassMethodBuilder>[];
  final _customLines = <String>[];

  String _extension = '';
  String _implementation = '';

  bool _isAbstract = false;
  bool _buildEmpty = false;
  bool _buildCopyWith = false;
  bool _buildToMap = false;
  bool _buildFromMap = false;
  bool _buildFromFirebaseDocument = false;
  bool _buildEquatable = false;

  /// Set the extension of the class. Default is an empty string therefore the class will not extend anything.
  /// 
  /// Eg. `..withExtension('Equatable') // class MyClass extends Equatable`
  void withExtension(String extension) {
    _extension = extension;
  }

  /// Set the implementation of the class. Default is an empty string therefore the class will not implement anything.
  /// 
  /// Eg. `..withImplementation('Exception') // class MyClass implements Exception`
  void withImplementation(String implementation) {
    _implementation = implementation;
  }

  void withAbstract() {
    _isAbstract = true;
  }

  /// Add a new property field to the class.
  void addField(ClassField field) => _fields.add(field);

  /// Add multiple property fields to the class.
  void addAllFields(List<ClassField> fields) => _fields.addAll(fields);

  void withEmpty() {
    _buildEmpty = true;
  }

  void withCopyWith() {
    _buildCopyWith = true;
  }

  void withToMap() {
    _buildToMap = true;
  }

  void withFromMap() {
    _buildFromMap = true;
  }

  void withFromFirebaseDocument() {
    _buildFromFirebaseDocument = true;
  }

  void withEquatable() {
    _buildEquatable = true;
  }

  /// Add a new constructor that builds all current fields.
  /*void addConstructor(ClassConstructorBuilder constructor) {
    constructors.add(
      constructor..addFields(_fields)
    );
  }*/

  void addMethod(ClassMethodBuilder methodBuilder) {
    methods.add(methodBuilder);
  }

  void addLine(String value) {
    _customLines.add(value);
  }

  @override
  String build() {
    // Add header.
    add('${_isAbstract ? 'abstract ' : ''}class $className ${_extension.isNotEmpty ? 'extends $_extension' : ''}${_implementation.isNotEmpty ? 'implements $_implementation' : ''} {' + (_fields.isNotEmpty ? nl : ''));

    for(var field in _fields) {
      add(tab + field.asClassField);
    }

    for(var constructor in constructors) {
      final build = constructor.build().withTabs();
      add(nl + build);
    }

    if(_buildEmpty) {
      add(nl + tab + 'static const empty = $className(${_fields.map((e) => e.identifier + ': ' + e.toEmptyValue).join(", ")});');
      add(tab + 'bool get isEmpty => this == empty;');
    }

    for(var line in _customLines) {
      add(nl + line);
    }

    for(var method in methods) {
      final build = method.build().withTabs();
      add(nl + build);
    }

    if(_buildCopyWith) {
      final copyWith = ClassCopyWithBuilder(className, _fields).build().withTabs();
      add(nl + copyWith);
    }

    if(_buildToMap) {
      final toMap = ClassSerializationBuilder(className, _fields)
        ..toMap();
      add(nl + toMap.build().withTabs());
    }

    if(_buildFromMap) {
      final fromMap = ClassSerializationBuilder(className, _fields)
        ..fromMap();
      add(nl + fromMap.build().withTabs());
    }

    if(_buildFromFirebaseDocument) {
      final fromFirebaseDocument = ClassSerializationBuilder(className, _fields)
        ..fromFirebaseDocument();
      add(nl + fromFirebaseDocument.build().withTabs());
    }

    if(_buildEquatable) {
      final equatable = 
        nl + tab + '@override'
      + nl + tab + 'List<Object?> get props => [${_fields.map((e) => e.identifier).join(', ')}];';
      add(equatable);
    }

    add('}');
    // End class definition.

    return super.build();
  }
}*/