import 'dart:io';

Future<List<String>> readInput() async => (await new File('./day-4/input.txt').readAsString()).split('\r\n\r\n');

bool hasLength(String input, int length) => input.length == length;
bool isInRange(int value, int min, int max) => value >= min && value <= max;
bool isLengthExpression(String input) => new RegExp(r'(\d*)(cm|in)').hasMatch(input);
bool isHexColor(String input) => new RegExp(r'#([0-9a-z])').hasMatch(input);
bool isNumber(String input) => new RegExp(r'(\d*)').hasMatch(input);

bool isValidLength(String input) {
  final unit = input.substring(input.length - 2);
  final value = int.parse(input.substring(0, input.length - 2));
  return unit == 'cm' ? isInRange(value, 150, 193) : isInRange(value, 59, 76);
}

final requiredFields = ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid'];
final validEyeColors = ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'];

final fieldValidators = {
  'byr': (String input) => hasLength(input, 4) && isInRange(int.parse(input), 1920, 2002),
  'iyr': (String input) => hasLength(input, 4) && isInRange(int.parse(input), 2010, 2020),
  'eyr': (String input) => hasLength(input, 4) && isInRange(int.parse(input), 2020, 2030),
  'hcl': (String input) => hasLength(input, 7) && isHexColor(input),
  'ecl': (String input) => hasLength(input, 3) && validEyeColors.any((color) => color == input),
  'pid': (String input) => hasLength(input, 9) && isNumber(input),
  'hgt': (String input) => isLengthExpression(input) && isValidLength(input)
};

class Passport {
  Map<String, String> fields;

  bool get hasRequiredFields => requiredFields.every((key) => fields.containsKey(key));

  Passport(this.fields) {}

  bool validate() {
    if (!this.hasRequiredFields) {
      return false;
    }

    return fieldValidators.keys.every((key) {
      var validator = fieldValidators[key];
      var input = this.fields[key] ?? '';
      return validator?.call(input) ?? false;
    });
  }
}

void main() async {
  final fileContent = await readInput();

  var passports = fileContent.map((element) {
    final fields = element.split('\r\n').join(' ').split(' ').map((value) {
      var keyValue = value.split(':');
      return new MapEntry(keyValue[0], keyValue[1]);
    });

    return new Passport(new Map.fromEntries(fields));
  });

  var passportsWithAllRequiredFields = passports.where((passport) => passport.hasRequiredFields).length;

  print('Passports with all required fields: ${passportsWithAllRequiredFields}');

  var validPassports = passports.where((passport) => passport.validate()).length;

  print('Passports that are 100% valid: ${validPassports}');
}
