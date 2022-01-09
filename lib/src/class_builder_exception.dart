class ClassBuilderException implements Exception {

  final String code;
  final String message;

  ClassBuilderException(this.code, this.message);

  factory ClassBuilderException.classAlreadyExists()
  => ClassBuilderException('100', 'Class already exists. You cannot have more than one classes in one ClassBuilder.');

  @override
  String toString() => '[$code] $message';
}