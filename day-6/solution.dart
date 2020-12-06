import 'dart:io';

Future<List<String>> readInput() async => (await new File('./day-6/input.txt').readAsString()).split('\r\n\r\n');

extension Characters on String {
  List<String> characters() => this.split('');
}

extension Distinct on Iterable<String> {
  List<String> distinct() => this.toSet().toList();
}

extension Sum on Iterable<int> {
  int sum() => this.reduce((int a, int b) => a + b);
}

final characterRegex = new RegExp('[a-z]');

List<String> uniqueAnswers(String answers) =>
    answers.characters().where((answer) => characterRegex.hasMatch(answer)).distinct();

int sumOfUniqueAnswers(List<String> input) =>
    input.map((answers) => uniqueAnswers(answers)).map((answers) => answers.length).sum();

int sumOfAnswerUnanimity(List<String> input) {
  return input.map((answers) {
    final individualAnswers = answers.split('\r\n');

    return uniqueAnswers(answers).where((character) {
      return individualAnswers.every((element) => element.indexOf(character) >= 0);
    }).length;
  }).sum();
}

void main() async {
  final fileContent = await readInput();

  final sumOfAnswers = sumOfUniqueAnswers(fileContent);
  print(sumOfAnswers);

  final sumOfUnanimousAnswers = sumOfAnswerUnanimity(fileContent);
  print(sumOfUnanimousAnswers);
}
