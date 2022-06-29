import 'package:recase/recase.dart';

class Field {

  /// The data type of the variable. Eg. `String`, `int`, `Object`.
  String type;
  /// The identifier of the variable. Eg. `myVar` as in `String myVar`.
  String identifier;

  /// Whether this variable is nullable or not. A nullable variable will 
  /// be represented by appending a `?` at the end of its type.
  /// 
  /// Eg. `String? myVar`.
  bool nullable = false;
  /// Whether this field should be prefixed with `static`.
  bool static = false;
  /// Whether this field should be prefixed with `late`.
  bool late = false;
  /// The modifier of this field. Eg. `final`, `var`, 'const`.
  String? modifier;
  /// The default value of the field. A field with an assignment will be
  /// represented as such `myVar = defaultValue`.
  String? assignment;
  /// The annotations of the field. Eg. `override` will be represented as `@override`
  /// inserted above the field declaration.
  String? annotations;

  /*
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
  */

  /// Create a new field. A field is a property of a class.
  /// 
  /// Eg. `static const myVar = 5` is a field, `String myVar` is a field.
  Field(this.type, this.identifier);
  
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
  /// If the type is exactly "**input**" then it will treat it as an input form (useful for the Formz package)
  /// and the resulting Field's type will be of form ``$IdentifierInput`.
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

    final field = Field(type, identifier);
    field
      ..nullable = nullable
      ..modifier = 'final';

    return field;
  }

  String get _null => nullable ? '?' : '';
  String get _type => type.isNotEmpty ? '$type$_null ' : '';
  String get _identifier => identifier + _null;
  String get _prefix => 
    (static ? 'static ' : '') + 
    (late ? 'late ' : '') + 
    (modifier != null ? '$modifier ' : '');
  String get _equalsToValue => assignment != null ? ' = $assignment' : '';
  String get _annotations => annotations != null ? '@$annotations\n' : '';

  /// Get this field as a class property representation.
  /// 
  /// Eg. `final String name;`.
  String build() {
    return _annotations + _prefix + _type + identifier + _equalsToValue + ';';
  }

  /// Get an empty representation of this field.
  /// 
  /// If the field is a [List], this will return `[]`. 
  /// booleans return `false`, number types return `0` and 
  /// custom objects return `$object.empty`.
  String get empty {
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

  /// Get this field as a "to map" parameter representation.
  /// 
  /// Eg. field `DateTime? x` will be represented as `x?.millisecondsSinceEpoch`.
  /// 
  /// Eg. field `String x` will be represented as `x`.
  String buildToMap() {
    if(type.startsWith('Map')) {
      return identifier;
    }

    if(type.startsWith('List')) {
      final child = Field.fromEntry(
        MapEntry('x', type.substring(5, type.length - 1))
      ).buildToMap();

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
  String buildFromMap(String value) {
    if(type.startsWith('List')) {
      final child = Field.fromEntry(
        MapEntry('x', type.substring(5, type.length - 1))
      ).buildFromMap('x');

      return "$type.from(map['$identifier']?.map((x) => $child))";
    }

    switch(type) {
      case 'bool':
      case 'int':
      case 'double':
      case 'num':
      case 'String':
        return nullable ? '$value != null ? $value : null' : value;
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

  @override
  String toString() => build();
}