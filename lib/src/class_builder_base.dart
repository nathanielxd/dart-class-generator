import 'package:class_builder/class_builder.dart';

class ClassBuilder extends IBuilder {

  final String className;
  ClassBuilder(this.className);

  String _extension = '';
  final _fields = <ClassField>[];
  final _constructors = <ClassConstructorBuilder>[];
  final _methods = <ClassMethodBuilder>[];
  bool _buildCopyWith = false;
  bool _buildEquatable = false;

  /// Set the extension of the class. Default is an empty string therefore the class will not extend anything.
  /// 
  /// Eg. `..withExtension('Equatable') // class MyClass extends Equatable`
  void withExtension(String extension) {
    _extension = extension;
  }

  /// Add a new property field to the class.
  void addField(ClassField field) => _fields.add(field);

  /// Add multiple property fields to the class.
  void addAllFields(List<ClassField> fields) => _fields.addAll(fields);

  void withCopyWith() {
    _buildCopyWith = true;
  }

  void withEquatable() {
    _buildEquatable = true;
  }

  /// Add a new constructor that builds all current fields.
  void addConstructor(ClassConstructorBuilder constructor) {
    _constructors.add(
      constructor..addAllClassFields(_fields)
    );
  }

  void addMethod(ClassMethodBuilder methodBuilder) {
    _methods.add(methodBuilder);
  }

  @override
  String build() {
    // Add header and extension.
    add('class $className ${_extension.isNotEmpty ? 'extends $_extension' : ''} {' + (_fields.isNotEmpty ? nl : ''));

    for(var field in _fields) {
      add(tab + field.asClassField);
    }

    for(var constructor in _constructors) {
      final build = constructor.build().withTabs();
      add(nl + build);
    }

    for(var method in _methods) {
      final build = method.build().withTabs();
      add(nl + build);
    }

    if(_buildCopyWith) {
      final copyWith = ClassCopyWithBuilder(className, _fields).build().withTabs();
      add(nl + copyWith);
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
}