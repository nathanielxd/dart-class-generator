class Variable {

  /// The data type of the variable. Eg. `String`, `int`, `Object`.
  final String type;
  /// The identifier of the variable. Eg. `myVar` as in `String myVar`.
  final String identifier;
  /// Whether this variable is nullable or not. A nullable variable will 
  /// be represented by appending a `?` at the end of its type.
  /// 
  /// Eg. `String? myVar`.
  final bool nullable;

  Variable(this.type, this.identifier, {
    this.nullable = false
  });

  /// Get a string representation of this variable.
  /// 
  /// Eg. `String? myVar`.
  @override
  String toString() => '$type${nullable ? '?' : ''} $identifier';
}