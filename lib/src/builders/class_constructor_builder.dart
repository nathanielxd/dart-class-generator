
import 'package:class_builder/class_builder.dart';

class ClassConstructorBuilder extends IBuilder {

  final String className;
  ClassConstructorBuilder(this.className);

  var _prefix = '';
  var _name = '';
  var _super = '';
  final _classFields = <ClassField>[];
  final _privateFields = <ClassField>[];

  /// Change the prefix of the constructor. Default is an empty prefix.
  /// 
  /// Eg. `..withPrefix('const') // const MyClass();`
  void withPrefix(String value) {
    _prefix = value;
  }

  /// Change the name of the constructor. Default is an empty name, therefore building an unnamed constructor.
  /// 
  /// Eg. `..withName('pure') // MyClass.pure();`
  void withName(String value) {
    _name = value;
  }

  /// Change the super value of the constructor. Default is an empty super, therefore building a default constructor.
  /// 
  /// Eg. `..withSuper('key: key') // MyClass() : super(key: key)`
  void withSuper(String value) {
    _super = value;
  }

  /// Adds a new field to the constructor.
  void addClassField(ClassField field) => _classFields.add(field);

  /// Adds multiple fields to the constructor.
  void addAllClassFields(List<ClassField> fields) => _classFields.addAll(fields);

  /// Adds a new private field to the constructor.
  void addPrivateField(ClassField field) => _privateFields.add(field);

  String get endIfSuperIsEmpty => (_super.isEmpty ? ';' : '');

  @override
  String build() {
    final header = StringBuffer()
      ..write(_prefix.isNotEmpty ? _prefix + ' ' : '')
      ..write(className);

    if(_name.isNotEmpty) {
      header.write('.$_name');
    }

    if(_classFields.isNotEmpty || _privateFields.isNotEmpty) {
      // Handle unnamed constructor.
      if(_name.isEmpty) {
        header.write('({');
        add(header.toString());
        for(var field in _privateFields) {
          add(tab + field.asConstructorPrivateParam);
        }
        for (var field in _classFields) { 
          add(tab + field.asConstructorParam);
        }
        add('})' + endIfSuperIsEmpty);
      }
      // Handle named constructors.
      else {
        header.write('(');
        for (var field in _privateFields) {
          header.write(field.asConstructorPrivateParam);
        }
        header.write(')');
        add(header.toString());
        add('=> const ' + className + '(');
        for (var field in _classFields) {
          if(field.factoryValue != null) {
            add(tab + field.asNamedConstructorParam);
          }
        }
        add(')' + endIfSuperIsEmpty);
      }
    }
    else {
      header.write('()' + endIfSuperIsEmpty);
      add(header.toString());
    }

    if(_super.isNotEmpty) {
      add(': super($_super);');
    }

    return super.build();
  }
}