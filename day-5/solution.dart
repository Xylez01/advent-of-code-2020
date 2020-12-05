import 'dart:io';

Future<List<String>> readInput() async => (await new File('./day-5/input.txt').readAsString()).split('\r\n');

List<String> characters(String input) => input.split('');

class Range {
  int min;
  int max;

  Range(this.min, this.max);
}

class BoardingPass {

  BoardingPass.fromInput(String input) {
    var rowCommands = input.substring(0, input.lastIndexOf('F'));
    var columnCommands = input.substring(input.lastIndexOf('F') + 1);
    
    characters(rowCommands).forEach((command) { 
      print(command);
    });

    print(columnCommands);
  }
}

void main() async {
  final fileContent = (await readInput()).map((input) => BoardingPass.fromInput(input));

  print(fileContent);
}
