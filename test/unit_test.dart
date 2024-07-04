import 'package:test/test.dart';
import 'package:my_app/main.dart';

void main() {
  group('Unit tests', () {
    test('Testing default state of the grid', () {
      var defaultGrid = getDefault();

      expect(defaultGrid, [
        ['', ''],
        ['', ''],
        ['', ''],
        ['', ''],
        ['', ''],
        ['', ''],
        ['', ''],
        ['', ''],
        ['', ''],
      ]);
    });
  });
}
