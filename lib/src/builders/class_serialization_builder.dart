import 'package:class_builder/class_builder.dart';

class ClassSerializationBuilder extends IBuilder {

  final String className;
  final List<Field> fields;
  final bool fromFirebaseDocument;

  ClassSerializationBuilder(this.className, {
    required this.fields,
    this.fromFirebaseDocument = false
  });

  String get _toMapFields => fields
    .map((e) => '\n' + tab + "'${e.identifier}': ${e.toMapParameter()}")
    .join(',');

  String get _fromMapFields => fields
    .map((e) => '\n' + tab + """${e.identifier}: ${e.toFromMapParameter("map['${e.identifier}']")}""")
    .join(',');

  @override
  String build() {
    add('Map<String, dynamic> toMap() => {$_toMapFields');
    add('};');
    add('');

    add('factory $className.fromMap(Map<String, dynamic> map)');
    add('=> $className($_fromMapFields');
    add(');');

    if(fromFirebaseDocument) {
      add('');
      add('factory $className.fromDocument(DocumentSnapshot<Map<String, dynamic>> snapshot)');
      add('=> $className.fromMap(snapshot.data()!).copyWith(id: snapshot.id);');
    }

    return super.build();
  }
}