import 'package:class_builder/class_builder.dart';

class Method {

  /// The return type of the method. Eg. `String`, `int`, `void`.
  final String type;
  /// The name of the method. Eg. `myMethod` as in `void myMethod();`.
  final String name;
  /// The body of the method. Everything that is executable code goes here.
  /// 
  /// Eg. 
  /// ```
  /// var myVar = 'hey';
  /// // This is just some code.
  /// myVar.doSomething();
  /// return myVar;
  /// ```
  final String body;
  /// Arguments of the method represented as fields.
  /// 
  /// Eg. `myMethod(String myArg)`.
  final List<Field> arguments;
  /// Whether this is a `get` method or not. A get method cannot have any argument.
  /// 
  /// Eg. `String get myMethod {...}`.
  final bool isGetter;
  /// Whether this is an `async` method or not.
  /// 
  /// Eg. `String myMethod() async {...}`.
  final bool isAsync;
  /// Documentation comment of this method. Default is empty therefore representation of this method
  /// will not have a comment above it.
  /// 
  /// Eg.
  /// ```
  /// /// This is a comment of a method.
  /// String myMethod();
  /// ```
  final String? comment;

  Method(this.type, this.name, {
    this.arguments = const[],
    this.body = '',
    this.isGetter = false,
    this.isAsync = false,
    this.comment
  }) : assert(!isGetter || arguments.isEmpty);

  bool get _hasUnnamedFields => arguments.any((element) => !element.named);
  bool get _hasNamedFields => arguments.any((element) => element.named);
  bool get _hasSinglelineBody => body.split('\n').length == 1;

  String get _type => type.isNotEmpty ? '$type ' : '';
  String get _get => isGetter ? 'get ' : '';
  String get _async => isAsync ? ' async' : '';
  String get _body => body.isNotEmpty ? (_hasSinglelineBody ? ' => $body' : ' {\n  ${body.split('\n').join('\n  ')}\n}') : ';';
  String get _comment => comment != null ? '/// $comment \n' : '';

  String get _unnamedFields => arguments
    .where((field) => !field.named)
    .map((e) => e.toString())
    .join(', ');

  String get _namedFields => _hasNamedFields 
  ? (_hasUnnamedFields ? ', ' : '') + '{\n' + arguments
    .where((field) => field.named)
    .map((e) => '  ' + e.toString() + ',')
    .join('\n')
    + '\n}'
  : '';

  String get _arguments => !isGetter ? '($_unnamedFields$_namedFields)' : '';

  @override
  String toString()
  => _comment + _type + _get + name + _arguments + _async + _body;
}