import 'dart:io';
import 'dart:math';
import '../dart/extension-methods.dart';

Future<List<String>> readInput() async => (await new File('./day-9/input.txt').readAsString()).split('\r\n');

class Combination {
  int left;
  int right;

  Combination(this.left, this.right);
}

List<Combination> combinations(List<int> numbers) {
  var result = List<Combination>.empty(growable: true);

  for (var index = 0; index < numbers.length; index++) {
    final combinationCandidates = [...numbers]..removeAt(index);
    result.addAll(combinationCandidates.map((number) => Combination(numbers[index], number)));
  }

  return result;
}

int findInvalidNumber(List<int> numbers, {int preambleCount = 25}) {
  int step = 0;
  return numbers.skip(preambleCount).firstWhere((number) {
    final preamble = numbers.skip(step++).take(preambleCount).toList();
    return !combinations(preamble).any((combination) => combination.left + combination.right == number);
  });
}

Combination findEncryptionWeakness(List<int> numbers, int invalidNumber) {
  for (var index = 0; index < numbers.length; index++) {
    var take = 2;
    var sum = numbers[index];

    while (sum < invalidNumber) {
      final range = numbers.skip(index).take(take++);
      sum = range.sum();

      if (sum == invalidNumber) {
        return Combination(range.reduce(min), range.reduce(max));
      }
    }
  }

  return Combination(-1, -1);
}

void main() async {
  final fileContent = await readInput();

  final numbers = fileContent.map((input) => int.parse(input.trim())).toList();

  final invalidNumber = findInvalidNumber(numbers);
  print('Solution part 1: ${invalidNumber}');

  final encryptionWeakness = findEncryptionWeakness(numbers, invalidNumber);
  print('Solution part 2: ${encryptionWeakness.left + encryptionWeakness.right}');
}
