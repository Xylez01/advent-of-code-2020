import 'dart:io';

Future<List<String>> readInput() async => (await new File('./day-10/input.txt').readAsString()).split('\r\n');

int ascending(int left, int right) => left - right;

Map<int, int> findJoltageDifferences(List<int> jolts) {
  Map<int, int> differences = {1: 0, 2: 0, 3: 0};

  for (var index = 0; index < jolts.length - 1; index++) {
    final difference = jolts[index + 1] - jolts[index];
    differences.update(difference, (value) => ++value);
  }

  return differences;
}

int countArrangements(List<int> jolts, Map<int, int> adapterPaths, {int joltIndex = -1}) {
  if (joltIndex == jolts.length - 1) {
    return 1;
  } else if (adapterPaths.containsKey(joltIndex)) {
    return adapterPaths[joltIndex];
  }

  var arrangements = 0;

  for (var lookupIndex = joltIndex + 1; lookupIndex < jolts.length; lookupIndex++) {
    var difference = joltIndex >= 0 ? jolts[lookupIndex] - jolts[joltIndex] : jolts[lookupIndex];
    if (difference <= 3) {
      arrangements += countArrangements(jolts, adapterPaths, joltIndex: lookupIndex);
    } else {
      break;
    }
  }

  adapterPaths[joltIndex] = arrangements;
  return arrangements;
}

void main() async {
  final fileContent = await readInput();

  final jolts = fileContent.map((input) => int.parse(input.trim())).toList()..sort(ascending);

  final differences = findJoltageDifferences([0, ...jolts, jolts.last + 3]);
  print('Solution part 1: ${(differences[1] ?? 0) * (differences[3] ?? 0)}');

  final arrangements = countArrangements(jolts, Map<int, int>());
  print('Solution part 1: ${arrangements}');
}
