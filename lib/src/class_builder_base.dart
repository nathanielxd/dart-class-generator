import 'package:class_generator/class_generator.dart';

class ClassBuilder extends IBuilder {

  final String className;

  List<Field> fields = [];
  List<Method> methods = [];
  List<Constructor> constructors = [];

  bool abstract = false;
  bool empty = false;
  bool constructor = false;
  bool copyWith = false;
  bool toMap = false;
  bool fromMap = false;
  bool fromFirebaseDocument = false;
  bool equatable = false;

  /// Extension of the class.
  /// 
  /// Eg. `class MyClass extends AnotherClass`.
  String? extend;
  /// The implementation of the class.
  /// 
  /// Eg. `class MyClass implements AnotherClass`.
  String? implements;

  ClassBuilder(this.className);

  String get _abstract => abstract ? 'abstract' : '';
  String get _extension => extend != null ? ' extends $extend' : '';
  String get _implementation => implements != null ? ' implements $implements' : '';
  String get _header => _abstract + 'class $className' + (equatable ? ' extends Equatable' : _extension + _implementation);
  
  String get _classFields => fields
    .map((e) => tab + e.build())
    .join('\n');

  String get _constructors => constructors
  .map((e) {
    e.tabCount = 1;
    return '\n' + e.build();
  })
  .join('\n');

  String get _empty => '\n' 
  + tab 
  + 'static const $className empty = $className(${fields.map((e) => e.identifier + ': ' + e.empty).join(", ")});';
  String get _isEmpty => tab + 'bool get isEmpty => this == empty;';

  String get _methods => '\n' + methods
    .map((e) => e.toString().split('\n').map((e) => tab + e).join('\n'))
    .join('\n');

  String get _equatable 
  => '\n' + tab + '@override' 
  + '\n' + tab + 'List<Object?> get props => [${fields.map((e) => e.identifier).join(', ')}];';

  @override
  String build() {
    add(_header + ' {');
    newLine();
    add(_classFields);

    if(constructor) {
      constructors.add(
        Constructor(className)
          ..parameters = fields.map((e) => Parameter.fromField(e)).toList()
          ..constant = true
      );
    }

    if(constructors.isNotEmpty) {
      add(_constructors);
    }

    if(empty) {
      add(_empty);
      add(_isEmpty);
    }

    if(methods.isNotEmpty) {
      add(_methods);
    }

    if(copyWith) {
      final copyWith = ClassCopyWith(className, fields: fields);
      copyWith.tabCount = 1;
      add('\n' + copyWith.build());
    }

    if(toMap || fromMap) {
      final mapper = ClassSerialization(className, fields: fields)
        ..fromMap = fromMap
        ..toMap = toMap
        ..fromFirebaseDocument = fromFirebaseDocument;
      mapper.tabCount = 1;
      add('\n' + mapper.build());
    }

    if(equatable) {
      add(_equatable);
    } 

    add('}');
    return super.build();
  }
}