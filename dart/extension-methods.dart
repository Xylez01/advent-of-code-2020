extension StringExtensions on String {
  List<String> characters() => this.split('');

  String removeAll(Iterable<String> textsToRemove) {
    var result = this;

    textsToRemove.forEach((text) {
      result = result.replaceAll(text, '');
    });

    return result;
  }
}

extension Distinct on Iterable<String> {
  List<String> distinct() => this.toSet().toList();
}

extension Sum on Iterable<int> {
  int sum() => this.reduce((int a, int b) => a + b);
}
