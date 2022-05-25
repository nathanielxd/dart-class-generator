abstract class IBuilder {

  /// How many spaces does a [tab] contains. Default is 2.
  int tabSize = 2;
  /// How many tabs to append after each line. Default is 0.
  int tabCount = 0;

  /// The current index of the cursor.
  int get index => _index;
  /// A tab used in this builder. Equivalent of ```' ' * tabSize```.
  String get tab => ' ' * tabSize;

  int _index = 0;
  String get _indentation => tab * tabCount;
  
  /// The buffer of the builder. Each element of the buffer is a different line.
  final _buffer = <String>[];

  /// Adds a new line of [value] at the current index and increments the index by one.
  void add(String value) {
    _buffer.insert(index, value);
    _index++;
  }

  /// Adds a new empty line and increments the index by one.
  void newLine() => add('');

  /// Clear the buffer and reset the index.
  void clear() {
    _buffer.clear();
    _index = 0;
  }

  /// Get the complete output string of the builder by joining all buffer's elements with a newline.
  String build() {
    final newBuffer = _buffer.join('\n').split('\n');
    final build = newBuffer.map((e) => _indentation + e).join('\n');
    clear();
    return build;
  }
}