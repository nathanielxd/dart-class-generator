import 'package:class_builder/class_builder.dart';
import 'package:recase/recase.dart';

class Field {

  /// The data type of the variable. Eg. `String`, `int`, `Object`.
  final String type;
  /// The identifier of the variable. Eg. `myVar` as in `String myVar`.
  final String identifier;
  /// Whether this variable is nullable or not. A nullable variable will 
  /// be represented by appending a `?` at the end of its type.
  /// 
  /// Eg. `String? myVar`.
  final bool nullable;
  /// Whether this field must be treated as a named or unnamed parameter when
  /// representing it in a constructor.
  /// 
  /// `Constructor(this.unnamed, {this.named});```
  final bool named;
  /// Prefix of the field. Eg. `final`, `static const`.
  final String? prefix;
  /// The default value of the field. A field with a default value will be
  /// represented as such `myVar = defaultValue`.
  final String? value;

  /// Create a new field. A field is a property of a class.
  /// 
  /// Eg. `static const myVar = 5` is a field, `String myVar` is a field.
  const Field(this.type, this.identifier, {
    this.nullable = false,
    this.named = true,
    this.prefix,
    this.value,
  });
  
  /// Retrieve a field from a key-value pair. This allows you to get fields from 
  /// configuration .yaml files.
  /// 
  /// In a yaml file, a field is represented as such: `identifier: type`.
  /// 
  /// ```
  /// final field = Field.fromEntry(MapEntry('myVar', 'String?'));
  /// print(field.type); // "String"
  /// print(field.identifier); // "myVar"
  /// print(field.nullable) // true
  /// ```
  /// 
  /// If the type is exactly "**input**" then we will treat it as an input form (useful for the Formz package)
  /// and the resulting Field's type will be `IdentifierInput`.
  factory Field.fromEntry(MapEntry<String, String> entry) {
    /// Field's identifier is the key of the key-value entry.
    final identifier = entry.key;

    // If an entry value ends with '?' it means it is nullable.
    final nullable = entry.value.endsWith('?');

    // If an entry value is nullable, it means the actual type is the entry value without the '?'.
    final actualType = nullable 
    ? entry.value.substring(0, entry.value.length - 1) 
    : entry.value;

    // If the entry value is 'input', we have to transform the type into 'IdentifierInput'.
    final type = actualType == 'input' 
    ? ReCase(entry.key).pascalCase + 'Input' 
    : actualType;

    // The default value is '.pure()' if the field is an input.
    final defaultValue = actualType == 'input'
    ? '$type.pure()'
    : (!nullable ? Utils.getDefaultValueOf(type) : '');

    return Field(type, identifier, 
      nullable: nullable,
      value: defaultValue
    );
  }

  String get _null => nullable ? '?' : '';
  String get _identifier => identifier + _null;
  String get _prefix => prefix != null ? '$prefix ' : '';
  String get _equalsToValue => value != null ? ' = $value' : '';

  @override
  String toString() => type + _null + ' ' + identifier + _equalsToValue;

  String get emptyValue {
    if(type.startsWith('List')) {
      return '[]';
    }
    switch(type) {
      case 'bool':    return 'false';
      case 'int':     return '0';
      case 'double':  return '0';
      case 'num':     return '0';
      case 'String':  return "''";
      default:        return '$type.empty';
    }
  }

  String toEmptyParameter() => identifier + ': ' + emptyValue;

  /// Get this field as a class property representation.
  /// 
  /// Eg. `final String name;` or `static const String name = 'Mark';`
  String toClassField()
  => _prefix + type + _null + ' ' + identifier + _equalsToValue + ';';

  /// Get this field as a class constructor parameter representation. 
  /// 
  /// Eg. `this.field`.
  /// 
  /// If field has a [value], it will be the default value the paramater takes: `this.field = defaultValue`.
  /// 
  /// If field is nullable and named, it will not be marked as `required`.
  /// ```
  /// // Usage in a ClassConstructorBuilder.
  /// Constructor(this.myField);
  /// Constructor([this.myField = defaultValue]);
  /// Constructor({
  ///   required this.myField,
  ///   this.myField = defaultValue,
  ///   this.myField
  /// });
  /// ```
  String toConstructorParameter() {
    if(named) {
      return (!nullable && value == null ? 'required ' : '')
        + 'this.$identifier'
        +  _equalsToValue;
    }
    else {
      return 'this.$identifier' + _equalsToValue;
    }
  }

  /// Get this field as a "to map" parameter representation.
  /// 
  /// Eg. field `DateTime? x` will be represented as `x?.millisecondsSinceEpoch`.
  /// 
  /// Eg. field `String x` will be represented as `x`.
  String toMapParameter() {
    if(type.startsWith('Map')) {
      return identifier;
    }

    if(type.startsWith('List')) {
      final child = Field.fromEntry(
        MapEntry('x', type.substring(5, type.length - 1))
      ).toMapParameter();

      return _identifier + '.map(($identifier) => $child).toList()';
    }

    switch(type) {
      case 'bool':
      case 'int':
      case 'double':
      case 'num':
      case 'String':
        return identifier;
      case 'DateTime':
        return _identifier + '.millisecondsSinceEpoch';
      case 'Duration':
        return _identifier + '.inMilliseconds';
      default:
        return _identifier + '.toMap()';
    }
  }

  /// Get this field as a "to map" parameter representation.
  /// 
  /// Eg. field `DateTime? x` will be represented as `DateTime.fromMillisecondsSinceEpoch($value)`.
  /// 
  /// Eg. field `String x` will be represented as [value].
  /// 
  /// Eg. field `String? x` will be represented as `[value] != null ? [value] : null`.
  /// 
  /// Where [value] is usually `map['foo']`.
  String toFromMapParameter(String value) {
    if(type.startsWith('List')) {
      final child = Field.fromEntry(
        MapEntry('x', type.substring(5, type.length - 1))
      ).toFromMapParameter('x');

      return "$type.from(map['$identifier']?.map((x) => $child))";
    }

    switch(type) {
      case 'bool':
      case 'int':
      case 'double':
      case 'num':
      case 'String':
        return nullable
        ? '$value != null ? $value : null'
        : value;
      case 'DateTime':
        return nullable
        ? '$value != null ? DateTime.fromMillisecondsSinceEpoch($value) : null'
        : 'DateTime.fromMillisecondsSinceEpoch($value)';
      case 'Duration':
        return nullable 
        ? '$value != null ? Duration(milliseconds: $value) : null'
        : 'Duration(milliseconds: $value)';
      default:
        return "$type.fromMap($value)";
    }
  }
}