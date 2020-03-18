import 'package:dartyaml/main.dart';
import 'package:test/test.dart';

void main() {
  test('String.split() splits the string on the delimiter', () async {
    var string = 'name: dartyaml';
    TreeNode temp = await readFromString(string);
    expect(temp.value, equals('root'));
  });

  test('String.trim() removes surrounding whitespace', () {
    var string = '  foo ';
    expect(string.trim(), equals('foo'));
  });
}