import 'package:class_builder/class_builder.dart';
import 'package:recase/recase.dart';

class ClassField {

  final String prefix;
  final String type;
  final bool nullable;
  final String identifier;
  final String? defaultValue;
  final String? factoryValue;

  const ClassField(
    this.type,
    this.identifier, {
    this.prefix = 'final', 
    this.nullable = false,
    this.defaultValue,
    this.factoryValue
  });

  factory ClassField.fromEntry(MapEntry<String, String> entry) {
    // If an entry value ends with '?' it means it is nullable.
    final nullable = entry.value.endsWith('?');
    // If an entry value is nullable, it means the actual type is the entry value without the '?'.
    final actualValue = nullable 
    ? entry.value.substring(0, entry.value.length) 
    : entry.value;
    // If the entry value is 'input', we have to transform the type into 'IdentifierInput'.
    final type = actualValue == 'input' 
    ? ReCase(entry.key).pascalCase + 'Input' 
    : actualValue;
    // The factory value is '.pure()' if the field is an input.
    final factoryValue = actualValue == 'input'
    ? '$type.pure()'
    : (!nullable ? Utils.getFactoryValueOf(type) : '');

    return ClassField(
      type,
      ReCase(entry.key).camelCase,
      nullable: nullable,
      factoryValue: factoryValue
    );
  }

  /// Get this field as a class field.
  /// 
  /// Eg. `final String name;` or `static const String name = 'Mark';`
  String get asClassField 
  => prefix 
  + ' ' 
  + type 
  + (nullable ? '?' : '') 
  + ' '
  + identifier
  + (defaultValue != null ? ' = $defaultValue;' : ';');

  /// Get this field as a private class field.
  /// 
  /// Eg. `Key? key,`
  String get asConstructorPrivateParam
  => type 
  + (nullable ? '?' : '') 
  + ' '
  + identifier
  + (defaultValue != null ? ' = $defaultValue;' : ',');

  /// Get this field as a unnamed constructor parameter.
  /// 
  /// Eg. `required this.name,` or `this.name = 'abc',`
  String get asConstructorParam
  => (!nullable ? 'required ' : '')
  + 'this.$identifier'
  + (nullable && defaultValue != null ? ' = $defaultValue' : '')
  + ',';

  /// Get this field as a named constructor parameter. Uses [factoryValue] instead of [defaultValue]. If [factoryValue] is null, will return an empty string.
  /// 
  /// Eg. `name: 'value',`
  String get asNamedConstructorParam
  => factoryValue == null ? '' : identifier
  + ': $factoryValue,';
}