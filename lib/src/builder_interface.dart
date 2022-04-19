abstract class IBuilder {

  /// How many spaces does a [tab] occupies.
  int tabSize = 2;
  /// A tab, equivalent of ```' ' * tabSize```.
  String get tab => ' ' * tabSize;
  /// A new line, equivalent of `\n`.
  String get nl => '\n';

  /// The buffer of the builder. Each element of the buffer is a different line.
  final buffer = <String>[];

  /// The current index of the cursor.
  int index = 0;

  /// Adds a new line of [value] at the current index and increments the index by one.
  void add(String value) {
    buffer.insert(index, value);
    index++;
  }

  /// Get the full output string of the builder by joining all buffer's elements.
  String build() => buffer.join('\n');
}