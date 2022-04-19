
import 'package:class_builder/class_builder.dart';

class ClassConstructorBuilder extends IBuilder {

  final String className;

  ClassConstructorBuilder(this.className);

  var prefix = 'const';
  var name = '';
  var superValue = '';
  var body = '';
  var fields = <Field>[];
  var parameters = <Field>[];

  /// Change the prefix of the constructor. Default is `const`.
  /// 
  /// Eg. `..withPrefix('const') // const MyClass();`
  void withPrefix(String value) => prefix = value;

  /// Change the name of the constructor. Default is an empty name, therefore is building an unnamed constructor.
  /// 
  /// Eg. `..withName('pure') // MyClass.pure();`
  void withName(String value) => name = value;

  /// Change the super value of the constructor. Default is an empty value.
  /// 
  /// Eg. `..withSuper('key: key') // MyClass() : super(key: key)`
  void withSuper(String value) => superValue = value;

  /// Change the body value of the constructor. Default is an empty value, therefore the
  /// constructor will have no body.
  /// 
  /// Eg. 
  /// ```
  /// ..withBody('// something')
  /// Constructor() {
  ///   // something
  /// }
  /// ```
  void withBody(String value) => body = value;

  /// Add class fields to the constructor.
  /// 
  /// A class field is represented as `this.field`.
  void addClassFields(List<Field> fields) => this.fields.addAll(fields);

  /// Add parameter fields to the constructor.
  /// 
  /// A parameter field is represented as `Type field`.
  void addParameters(List<Field> parameters) => this.parameters.addAll(parameters);

  String get _prefix => prefix.isNotEmpty ? '$prefix ' : '';
  String get _name => name.isNotEmpty ? '.$name' : '';
  String get _super => superValue.isNotEmpty ? ' : super ($superValue)' : '';
  String get _body => body.isNotEmpty ? ' {\n $tab$body \n}' : '';

  bool get _hasUnnamedFields => fields.any((element) => !element.named);
  bool get _hasNamedFields => fields.any((element) => element.named);

  String get _unnamedFields => fields
    .where((field) => !field.named)
    .map((e) => e.toConstructorParameter())
    .followedBy(parameters
      .where((parameter) => !parameter.named)
      .map((e) => e.toString())
    )
    .join(', ');

  String get _namedFields => _hasNamedFields 
  ? (_hasUnnamedFields ? ', ' : '') + '{\n' + fields
    .where((field) => field.named)
    .map((e) => tab + e.toConstructorParameter() + ',')
    .followedBy(parameters
      .where((parameter) => parameter.named)
      .map((e) => tab + e.toString() + ',')
    )
    .join('\n')
    + '\n}'
  : '';

  @override
  String build() {
    add('$_prefix$className$_name($_unnamedFields$_namedFields)$_super$_body;');
    return super.build();
  }
}