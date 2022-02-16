import 'package:class_builder/class_builder.dart';

class ClassSerializationBuilder extends IBuilder {

  final String className;
  final List<ClassField> fields;

  ClassSerializationBuilder(this.className, this.fields);

  bool _serialize = true;
  bool _fromFirebaseDocument = false;

  void toMap() {
    _serialize = true;
  }

  void fromMap() {
    _serialize = false;
  }

  void fromFirebaseDocument() {
    _fromFirebaseDocument = true;
  }

  @override
  String build() {
    if(_serialize && !_fromFirebaseDocument) {
      // Add header.
      add('Map<String, dynamic> toMap() => {');

      for(var field in fields) {
        add(tab + "'${field.identifier}': " + field.toMap + ',');
      }

      // Add footer.
      add('};');
    }
    else {
      if(!_fromFirebaseDocument) {
        // Add headers.
        add('factory $className.fromMap(Map<String, dynamic> map)');
        add('=> $className(');

        for(var field in fields) {
          add(tab + field.identifier + ': ' + field.fromMap("map['${field.identifier}']") + ',');
        }

        add(');');
      }
      else {
        // Add headers.
        add('factory $className.fromDocument(DocumentSnapshot<Map<String, dynamic>> snapshot)');
        add('=> $className.fromMap(snapshot.data()!).copyWith(id: snapshot.id);');
      }
    }

    return super.build();
  }
}