extension ClassBuilderStringExtension on String {

  /// Splits a string using a newline separator, adds a a tab worth of 2 spaces to each line and joins back the string.
  String withTabs([int count = 1, int tabSize = 2]) => split('\n').map((e) => ' ' * 2 + e).toList().join('\n');
}