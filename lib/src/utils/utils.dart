import 'package:class_builder/class_builder.dart';

class Utils {

  static String getDefaultValueOf(String type) {
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
}