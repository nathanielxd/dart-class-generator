import 'package:class_builder/class_builder.dart';

class ClassCopyWithBuilder extends IBuilder {

  final String className;
  final List<ClassField> fields;

  ClassCopyWithBuilder(this.className, this.fields);

  @override
  String build() {
    // Add header.
    add(className + ' copyWith({');

    for (var element in fields) { 
      add(tab + element.type + '? ' + element.identifier + ',');
    }

    add('}) => $className(');

    for(var element in fields) {
      add(
        tab 
        + element.identifier 
        + ': '
        + element.identifier 
        + ' ?? this.' 
        + element.identifier
        + ','
      );
    }

    add(');');
    
    return super.build();
  }
}