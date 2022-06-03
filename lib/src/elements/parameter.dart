import 'package:class_generator/class_generator.dart';
import 'package:recase/recase.dart';

class Parameter {
  /// The data type of the parameter. Eg. `String`, `int`, `Object`.
  String type;
  /// The identifier of the parameter. Eg. `myVar` as in `String myVar`.
  String identifier;

  /// Whether this parameter is nullable or not. A nullable parameter will 
  /// be represented by appending a `?` at the end of its type.
  /// 
  /// Eg. `String? myVar`.
  bool nullable = false;
  /// Whether this parameter is optional or not.
  bool optional = false;
  /// Whether this parameter should be named, if optional.
  bool named = false;
  /// Whether this parameter should be annotated with the required keyword.
  /// 
  /// This is only valid on named parameters.
  bool required = false;
  /// Whether this parameter should be field formal. Eg. `this.`.
  ///
  /// This is only valid on constructors.
  bool toThis = false;
  /// A default assign for this parameter. Eg. `String myVar = 'myValue'`.
  String? defaultTo;

  /// Create a new parameter. Used in constructors and methods.
  Parameter(this.type, this.identifier);

  Parameter.named(this.type, this.identifier) {
    optional = true;
    named = true;
    toThis = true;
  }

  Parameter.required(this.type, this.identifier) {
    optional = true;
    named = true;
    toThis = true;
    required = true;
  }

  factory Parameter.fromEntry(MapEntry<String, String> entry) {
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

    final parameter = Parameter.required(type, identifier)
      ..nullable = nullable;

    return parameter;
  }

  factory Parameter.fromField(Field field) {
    final parameter = Parameter(field.type, field.identifier);
    parameter
      ..optional = true
      ..named = true
      ..required = true
      ..toThis = true
      ..nullable = field.nullable
      ..defaultTo = field.assignment;
    return parameter;
  }
  
  String get _null => nullable ? '?' : '';
  String get _identifier => identifier + _null;
  String get _required => required ? 'required ' : '';
  String get _this => toThis ? 'this.' : '$type ';
  String get _default => defaultTo != null ? ' = $defaultTo' : '';

  String build() {
    if(optional) {
      if(named) {
        return _required + _this + identifier + _default;
      }
      else {
        return '$type $identifier$_default';
      }
    }
    else {
      return _this + identifier;
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
      final child = Parameter.fromEntry(
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
      final child = Parameter.fromEntry(
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