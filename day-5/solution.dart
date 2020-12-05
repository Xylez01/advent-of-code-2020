import 'dart:io';
import 'dart:math';

Future<List<String>> readInput() async => (await new File('./day-5/input.txt').readAsString()).split('\r\n');

List<String> characters(String input) => input.split('');
Range lowerHalf(Range range) => Range(range.min, ((range.min + range.max) / 2).floor());
Range upperHalf(Range range) => Range(((range.min + range.max) / 2).ceil(), range.max);

final commands = {
  'F': (Range range) => lowerHalf(range),
  'B': (Range range) => upperHalf(range),
  'L': (Range range) => lowerHalf(range),
  'R': (Range range) => upperHalf(range)
};

class Range {
  int min;
  int max;

  Range(this.min, this.max);
}

class BoardingPass {
  int row;
  int column;

  int get seatId => (row * 8) + column;

  BoardingPass(this.row, this.column);

  factory BoardingPass.fromInput(String input) {
    var rowCommands = input.substring(0, input.lastIndexOf('F'));
    var columnCommands = input.substring(input.lastIndexOf('F') + 1);

    var rowRange = Range(0, 127);
    characters(rowCommands).forEach((command) {
      rowRange = commands[command]?.call(rowRange) ?? rowRange;
    });

    var columnRange = Range(0, 7);
    characters(columnCommands).forEach((command) {
      columnRange = commands[command]?.call(columnRange) ?? columnRange;
    });

    return BoardingPass(rowRange.min, columnRange.max);
  }
}

void main() async {
  final fileContent =
      (await readInput()).map((input) => BoardingPass.fromInput(input)).map((pass) => pass.seatId).reduce(max);

  print(fileContent);
}
