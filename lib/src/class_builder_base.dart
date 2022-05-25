import 'package:class_builder/class_builder.dart';

class ClassBuilder extends IBuilder {

  final String className;

  final fields = <Field>[];
  final methods = <Method>[];
  final constructors = <ConstructorBuilder>[];
  final customLines = <String>[];

  /// Extension of the class. Default is an empty string therefore the class will not extend anything.
  /// 
  /// Eg. `class MyClass extends AnotherClass`.
  String? extension;
  /// The implementation of the class. Default is an empty string therefore the class will not implement anything.
  /// 
  /// Eg. `class MyClass implements AnotherClass`.
  String? implementation;

  bool _buildConstructor = false;
  bool _isAbstract = false;
  bool _buildEmpty = false;
  bool _buildCopyWith = false;
  bool _buildToMap = false;
  bool _buildFromMap = false;
  bool _buildFromFirebaseDocument = false;
  bool _buildEquatable = false;

  ClassBuilder(this.className, {
    this.extension,
    this.implementation,
    bool isAbstract = false,
    bool isEquatable = false,
  })
  : assert(extension == null || implementation == null) {
    _isAbstract = isAbstract;
    _buildEquatable = isEquatable;
    assert(!(_buildEquatable && extension != null));
  }

  /// Set the extension of the class. Default is an empty string therefore the class will not extend anything.
  /// 
  /// Eg. `..withExtension('Equatable') // class MyClass extends Equatable`
  void withExtension(String extension) => this.extension = extension;

  /// Set the implementation of the class. Default is an empty string therefore the class will not implement anything.
  /// 
  /// Eg. `..withImplementation('Exception') // class MyClass implements Exception`
  void withImplementation(String implementation) => this.implementation = implementation;

  /// Set this class is an abstract class. Default is false.
  void withAbstract() => _isAbstract = true;

  /// Set this class to build a constructor for it's fields.
  /// 
  /// Add fields by calling `addFields()`.
  void buildConstructor() => _buildConstructor = true;

  /// Set to build an "empty" property. Default is false.
  /// 
  /// Eg. An empty property is represented as such:
  /// ```
  /// static const empty = MyClass(field1: 0, field2: MyObject.empty);
  /// bool get isEmpty => this == empty;
  /// ```
  void buildEmpty() => _buildEmpty = true;

  /// Set to build a copyWith method. Default is false.
  /// 
  /// Eg. A standard copyWith method looks like the following:
  /// ```
  /// MyClass copyWith({
  ///   String? field1,
  ///   Object? field2
  /// }) => MyClass(
  ///   field1: field1 ?? this.field1,
  ///   field2: field2 ?? this.field2
  /// );
  /// ```
  void buildCopyWith() => _buildCopyWith = true;

  /// Set to build a toMap serialization method. Default is false.
  /// 
  /// Eg.
  /// ```
  /// Map<String, dynamic> toMap() => {
  ///   'field1': field1,
  ///   'field2': field2.toMap()
  /// };
  /// ```
  void buildToMap() => _buildToMap = true;

  /// Set to build a fromMap serialization constructor. Default is false.
  /// 
  /// Eg.
  /// ```
  /// factory MyClass.fromMap(Map<String, dynamic> map)
  /// => MyClass(
  ///   field1: map['field1'],
  ///   field2: Field2.fromMap(map['field2'])
  /// );
  /// ```
  void buildFromMap() => _buildFromMap = true;

  /// Set to build a fromFirebaseDocument serialization constructor. Default is false.
  /// 
  /// Eg.
  /// ```
  /// factory MyClass.fromDocument(DocumentSnapshot<Map<String, dynamic>> snapshot)
  /// => MyClass.fromMap(snapshot.data()!).copyWith(id: snapshot.id);
  /// ```
  void buildFromFirebaseDocument() => _buildFromFirebaseDocument = true;

  /// Set to treat this class as an Equatable class, overriding any current extension.
  /// 
  /// Eg. 
  /// ```
  /// MyClass extends Equatable {
  ///   @override
  ///   List<Object?> props => [field1, field2];
  /// }
  /// ```
  void withEquatable() => _buildEquatable = true;

  /// Add a new constructor that builds all current fields.
  /*void addConstructor(ClassConstructorBuilder constructor) {
    constructors.add(
      constructor..addFields(_fields)
    );
  }*/

  /// Add class fields to the class.
  void addFields(List<Field> fields) => this.fields.addAll(fields);

  /// Add methods to the class.
  void addMethods(List<Method> methods) => this.methods.addAll(methods);

  /// Add a custom constructor to the class.
  void addConstructor(ConstructorBuilder constructor) => constructors.add(constructor);

  String get _abstract => _isAbstract ? 'abstract' : '';
  String get _extension => extension != null && extension!.isNotEmpty ? ' extends $extension' : '';
  String get _implementation => implementation != null && implementation!.isNotEmpty ? ' implements $implementation' : '';
  String get _header => _abstract + 'class $className' + (_buildEquatable ? ' extends Equatable' : _extension + _implementation);
  
  String get _classFields => fields
    .map((e) => tab + e.toClassField())
    .join('\n');

  String get _constructors => constructors
  .map((e) {
    e.tabCount = 1;
    return '\n' + e.build();
  })
  .join('\n');

  String get _empty => '\n' 
  + tab 
  + 'static const $className empty = $className(${fields.map((e) => e.identifier + ': ' + Utils.getDefaultValueOf(e.type)).join(", ")});';
  String get _isEmpty => tab + 'bool get isEmpty => this == empty;';

  String get _methods => '\n' + methods
    .map((e) => e.toString().split('\n').map((e) => tab + e).join('\n'))
    .join('\n');

  String get _equatable => 
    '\n' + tab + '@override' 
  + '\n' + tab + 'List<Object?> get props => [${fields.map((e) => e.identifier).join(', ')}];';

  @override
  String build() {
    add(_header + ' {');
    newLine();
    add(_classFields);

    if(_buildConstructor) {
      final constructor = ConstructorBuilder(className);
      constructor.addClassFields(fields);
      constructor.tabCount = 1;
      add('\n' + constructor.build());
    }

    if(constructors.isNotEmpty) {
      add(_constructors);
    }

    if(_buildEmpty) {
      add(_empty);
      add(_isEmpty);
    }

    if(methods.isNotEmpty) {
      add(_methods);
    }

    if(_buildCopyWith) {
      final copyWith = ClassCopyWithBuilder(className, fields: fields);
      copyWith.tabCount = 1;
      add('\n' + copyWith.build());
    }

    if(_buildToMap) {
      final toMap = ClassSerializationBuilder(className, 
        fields: fields,
        buildFromMap: _buildFromMap,
        buildToMap: _buildToMap,
        buildFromFirebaseDocument: _buildFromFirebaseDocument
      );
      toMap.tabCount = 1;
      add('\n' + toMap.build());
    }

    if(_buildEquatable) {
      add(_equatable);
    } 

    add('}');
    return super.build();
  }
}