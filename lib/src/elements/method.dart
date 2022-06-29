import 'package:class_generator/class_generator.dart';

class Method {

  /// The return type of the method. Eg. `String`, `int`, `void`.
  String returns;
  /// The name of the method. Eg. `myMethod` as in `void myMethod();`.
  String name;

  /// Arguments of the method represented as fields.
  /// 
  /// Eg. `myMethod(String myArg)`.
  List<Parameter> parameters = [];
  /// Whether this is a `get` method or not. A get method cannot have any parameter.
  /// 
  /// Eg. `String get myMethod {...}`.
  bool getter = false;
  /// The body of the method. Everything that is executable code goes here.
  String? body;
  /// Optional modifier of this method such as `async`, `async*` or `sync*`.
  /// 
  /// Eg. `String myMethod() async {...}`.
  String? modifier;
  /// Optional annotation of this method. Eg. `override`.
  String? annotations;
  /// Documentation comment of this method.
  String? docs;

  /// Create a new Dart method.
  Method(this.returns, this.name);

  bool get _hasUnnamedParameters => parameters.any((element) => !element.named);
  bool get _hasNamedParameters => parameters.any((element) => element.named);
  bool get _hasSinglelineBody => body?.split('\n').length == 1;

  String get _type => returns.isNotEmpty ? '$returns ' : '';
  String get _get => getter ? 'get ' : '';
  String get _modifier => modifier != null ? ' $modifier' : '';
  String get _body => body != null ? (_hasSinglelineBody ? ' => $body' : ' {\n  ${body!.split('\n').join('\n  ')}\n}') : ';';
  String get _annotations => annotations != null ? '@$annotations\n' : '';
  String get _docs => docs != null ? '/// $docs\n' : '';

  String get _unnamedParameters => parameters
    .where((parameter) => !parameter.named)
    .map((e) => e.build())
    .join(', ');

  String get _namedParameters => _hasNamedParameters 
  ? (_hasUnnamedParameters ? ', ' : '') + '{\n' + parameters
    .where((parameter) => parameter.named)
    .map((e) => '  ' + e.build() + ',')
    .join('\n')
    + '\n}'
  : '';

  String get _arguments => !getter ? '($_unnamedParameters$_namedParameters)' : '';

  String build() => _annotations + _docs + _type + _get + name + _arguments + _modifier + _body;

  @override
  String toString() => build();
}