import 'package:class_generator/class_generator.dart';

class ClassSerialization extends IBuilder {

  final String className;

  List<Field> fields = [];
  bool toMap = true;
  bool fromMap = true;
  bool fromFirebaseDocument = false;

  ClassSerialization(this.className, {required this.fields});

  String get _toMapFields => fields
    .map((e) => '\n' + tab + "'${e.identifier}': ${e.buildToMap()}")
    .join(',');

  String get _fromMapFields => fields
    .map((e) => '\n' + tab + """${e.identifier}: ${e.buildFromMap("map['${e.identifier}']")}""")
    .join(',');

  @override
  String build() {
    if(toMap) {
      add('Map<String, dynamic> toMap() => {$_toMapFields');
      add('};');
    }

    if(toMap && fromMap) {
      newLine();
    }

    if(fromMap) {
      add('factory $className.fromMap(Map<String, dynamic> map)');
      add('=> $className($_fromMapFields');
      add(');');

      if(fromFirebaseDocument) {
        newLine();
        add('factory $className.fromDocument(DocumentSnapshot<Map<String, dynamic>> snapshot)');
        add('=> $className.fromMap(snapshot.data()!).copyWith(id: snapshot.id);');
      }
    }

    return super.build();
  }
}