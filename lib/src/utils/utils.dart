class Utils {

  static String getFactoryValueOf(String type) {
    switch(type) {
      case 'bool': return 'false';
      case 'String': return "''";
      default: return '';
    }
  }
}