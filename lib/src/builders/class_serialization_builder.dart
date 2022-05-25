import 'package:code_generator/code_generator.dart';

class ClassSerializationBuilder extends IBuilder {

  final String className;
  final List<Field> fields;
  final bool buildToMap;
  final bool buildFromMap;
  final bool buildFromFirebaseDocument;

  ClassSerializationBuilder(this.className, {
    required this.fields,
    this.buildToMap = true,
    this.buildFromMap = true,
    this.buildFromFirebaseDocument = false
  });

  String get _toMapFields => fields
    .map((e) => '\n' + tab + "'${e.identifier}': ${e.toMapParameter()}")
    .join(',');

  String get _fromMapFields => fields
    .map((e) => '\n' + tab + """${e.identifier}: ${e.toFromMapParameter("map['${e.identifier}']")}""")
    .join(',');

  @override
  String build() {
    if(buildToMap) {
      add('Map<String, dynamic> toMap() => {$_toMapFields');
      add('};');
    }

    if(buildToMap && buildFromMap) {
      newLine();
    }

    if(buildFromMap) {
      add('factory $className.fromMap(Map<String, dynamic> map)');
      add('=> $className($_fromMapFields');
      add(');');

      if(buildFromFirebaseDocument) {
        newLine();
        add('factory $className.fromDocument(DocumentSnapshot<Map<String, dynamic>> snapshot)');
        add('=> $className.fromMap(snapshot.data()!).copyWith(id: snapshot.id);');
      }
    }

    return super.build();
  }
}