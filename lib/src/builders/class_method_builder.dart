import 'package:class_builder/class_builder.dart';

class ClassMethodBuilder extends IBuilder {

  final String methodName;
  ClassMethodBuilder(this.methodName);

  final _arguments = <ClassField>[];
  var _return = 'void';
  var _tag = '';
  bool _isGet = false;
  bool _isAsync = false;
  var _body = <String>[];
  int _lineTabs = 0;
  var _comments = <String>[];

  /// Change the return type of the method. Default is `void`.
  /// 
  /// Eg. `..withReturn('String') // String myMethod() {...}`
  void withReturn(String value) {
    _return = value;
  }

  /// Change the tag of the method. Default is empty.
  /// 
  /// Eg. `..withTag('override')`
  /// ```
  /// @override
  /// void myMethod() {...}
  /// ```
  void withTag(String value) {
    _tag = value;
  }
  
  /// Make the method use the `get` keyword when building. Default is set to false.
  /// 
  /// Eg. `..withGet() // String get myMethod {...}`
  void withGet() {
    _isGet = true;
  }

  void withAsync() {
    _isAsync = true;
  }

  /// Add a new argument field to the method.
  void addArgument(ClassField field) => _arguments.add(field);

  /// Add multiple argument fields to the constructor.
  void addAllArguments(List<ClassField> fields) => _arguments.addAll(fields);

  /// Change the body code of the method to [value].
  void withBody(String value) => _body = value.split('\n');

  /// Change the doc comment of the method to [value].
  void withComment(String value) => _comments = value.split('\n');

  /// Add a line of code to the body of the method.
  void addLine(String line) => _body.add((tab * _lineTabs) + line);

  /// Increase the tab size of the next lines.
  void increaseTab() => _lineTabs++;

  /// Decrease the tab size of the next lines.
  void decreaseTab() {
    if(_lineTabs > 0) {
      _lineTabs--;
    }
  }

  @override
  String build() {

    for(var comment in _comments) {
      add('/// $comment');
    }

    if(_tag.isNotEmpty) {
      add('@$_tag');
    }
    
    final header = StringBuffer()
      ..write(
        (_return.isNotEmpty ? _return + ' ' : '') 
        + (_isGet ? 'get ' : '')
        )
      ..write(methodName);

    if(_arguments.isNotEmpty) {
      header.write('(');
      header.write(_arguments.map((e) => e.type + ' ' + e.identifier).join(', '));
      header.write(')');
    }
    else {
      if(!_isGet) {
        header.write('()');
      }
    }

    if(_isAsync) {
      header.write(' async ');
    }
    
    if(_body.isEmpty) {
      header.write(';');
      add(header.toString());
    }
    else {
      header.write(' {');
      add(header.toString());

      for(var bodyLine in _body) {
        add(tab + bodyLine);
      }
      add('}');
    }

    return super.build();
  }
}