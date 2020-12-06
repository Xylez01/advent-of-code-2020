extension Characters on String {
  List<String> characters() => this.split('');
}

extension Distinct on Iterable<String> {
  List<String> distinct() => this.toSet().toList();
}

extension Sum on Iterable<int> {
  int sum() => this.reduce((int a, int b) => a + b);
}
