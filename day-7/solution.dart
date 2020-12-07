import 'dart:io';
import '../dart/extension-methods.dart';

Future<List<String>> readInput() async => (await new File('./day-7/input.txt').readAsString()).split('\r\n');

MapEntry<String, int> parseRequirement(String input) {
  final indexOf = input.indexOf(' ');
  final color = input.substring(indexOf + 1);
  final count = int.parse(input.substring(0, indexOf));
  return MapEntry(color, count);
}

class Rule {
  String color;
  Map<String, int> requirements;
  bool canContainShinyBag;

  Rule(this.color, this.requirements, this.canContainShinyBag);

  factory Rule.parse(String writtenRule) {
    var colorAndRequirements = writtenRule.split('bags contain').map((input) => input.trim()).toList();
    final color = colorAndRequirements.first;
    final unparsedRequirements = colorAndRequirements.last;

    if (unparsedRequirements == 'no other bags.') {
      return Rule(color, new Map(), false);
    }

    final parsedRequirements = unparsedRequirements
        .split(',')
        .map((input) => input.removeAll(['bags', 'bag', '.']).trim())
        .map(parseRequirement)
        .toList();

    final requirements = Map.fromEntries(parsedRequirements);
    return Rule(color, requirements, requirements.containsKey('shiny gold'));
  }
}

void updateShinyBagHoldingCapabilities(List<Rule> rules) {
  var foundAnyBagsThatCouldContainShinyGold = true;
  while (foundAnyBagsThatCouldContainShinyGold) {
    foundAnyBagsThatCouldContainShinyGold = false;

    rules.where((rule) => !rule.canContainShinyBag).forEach((rule) {
      final isAlsoAbleToHoldShinyGold = rule.requirements.keys.any((color) {
        return rules.any((element) => element.color == color && element.canContainShinyBag);
      });

      if (isAlsoAbleToHoldShinyGold) {
        rule.canContainShinyBag = isAlsoAbleToHoldShinyGold;
        foundAnyBagsThatCouldContainShinyGold = true;
      }
    });
  }
}

int getBagCount(Iterable<Rule> rules, Rule rule) {
  var amountOfBags = 0;

  rule.requirements.forEach((color, count) {
    amountOfBags += count;
    final relatedRule = rules.firstWhere((otherRule) => otherRule.color == color);
    if (relatedRule.requirements.length > 0) {
      amountOfBags += count * getBagCount(rules, relatedRule);
    }
  });

  return amountOfBags;
}

int getAmountOfBagsWhenUsingAShinyGoldBag(Iterable<Rule> rules) {
  final shinyGoldRule = rules.firstWhere((rule) => rule.color == 'shiny gold');
  return getBagCount(rules, shinyGoldRule);
}

void main() async {
  final fileContent = await readInput();

  final rules = fileContent.map((input) => Rule.parse(input)).toList();
  updateShinyBagHoldingCapabilities(rules);

  final rulesThatAllowAShinyGoldBag = rules.where((rule) => rule.canContainShinyBag).length;
  print('Solution part 1: ${rulesThatAllowAShinyGoldBag}');

  final amountOfBags = getAmountOfBagsWhenUsingAShinyGoldBag(rules);
  print('Solution part 2: ${amountOfBags}');
}
