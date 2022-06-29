import 'package:class_generator/class_generator.dart';

class Constructor extends IBuilder {

  /// The name of the class that is being constructed.
  final String className;

  /// The parameters included in this constructor.
  List<Parameter> parameters = [];
  /// Whether the constructor should be prefixed with `const`.
  bool constant = false;
  /// Whether the constructor should be prefixed with `factory`.
  bool factory = false;
  /// Optional name of the constructor. Eg. `MyClass.name()`.
  String? name;
  /// Optional body of the constructor.
  String? body;
  /// The optional value of the super constructor that will be appended
  /// to this constructor. 
  /// 
  /// Eg. `: super(this.myCode)`.
  String? superCode;

  Constructor(this.className);

  String get _prefix => 
    (constant ? 'const ' : '') + 
    (factory ? 'factory ': '');
  String get _name => name != null ? '.${name!}' : '';
  String get _super => superCode != null ? ' : super ($superCode)' : '';
  String get _body => body != null ? ' {\n$body \n}' : ';';

  bool get _hasUnnamedParameters => parameters.any((element) => !element.named);
  bool get _hasNamedParameters => parameters.any((element) => element.named);

  String get _unnamedParameters => parameters
    .where((parameter) => !parameter.named)
    .map((e) => e.build())
    .join(', ');

  String get _namedParameters => _hasNamedParameters
  ? (_hasUnnamedParameters ? ', ' : '') + '{\n' + parameters
    .where((parameter) => parameter.named)
    .map((e) => tab + e.build() + ',')
    .join('\n')
    + '\n}'
  : '';

  @override
  String build() {
    add('$_prefix$className$_name($_unnamedParameters$_namedParameters)$_super$_body');
    return super.build();
  }
}