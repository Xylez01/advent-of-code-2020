import 'dart:io';

Future<List<String>> readInput() async => (await new File('./day-8/input.txt').readAsString()).split('\r\n');

enum Operation { acc, jmp, nop }

final instructionRegex = new RegExp(r'(acc|jmp|nop) ([-+]\d*)');

class Instruction {
  Operation operation;
  int argument;
  bool executed;

  Instruction(this.operation, this.argument, this.executed);

  factory Instruction.parse(String input) {
    final match = instructionRegex.allMatches(input).elementAt(0);
    final operation = Operation.values.firstWhere((value) => value.toString() == 'Operation.${match.group(1)}');
    final argument = int.parse(match.group(2).toString());
    return Instruction(operation, argument, false);
  }

  Instruction copy() {
    return new Instruction(operation, argument, false);
  }

  void invert() {
    if (this.operation == Operation.jmp) {
      this.operation = Operation.nop;
    } else if (this.operation == Operation.nop) {
      this.operation = Operation.jmp;
    }
  }
}

class OperationResult {
  int result;
  bool executedUntilEnd;

  OperationResult(this.result, this.executedUntilEnd);
}

void reset(List<Instruction> instructions) => instructions.forEach((instruction) => instruction.executed = false);

OperationResult execute(List<Instruction> instructions) {
  var accumulator = 0;

  for (var index = 0; index < instructions.length; index++) {
    final instruction = instructions[index];
    if (instruction.executed) {
      break;
    }

    if (instruction.operation == Operation.acc) {
      accumulator += instruction.argument;
    }
    if (instruction.operation == Operation.jmp) {
      index += instruction.argument - 1;
    }

    instruction.executed = true;
  }

  return OperationResult(accumulator, instructions.last.executed);
}

OperationResult executeWithInvertedInstruction(List<Instruction> instructions, Instruction instruction) {
  final clonedInstructions = instructions.map((originalInstruction) => originalInstruction.copy()).toList();
  final indexOfInstruction = instructions.indexOf(instruction);
  clonedInstructions[indexOfInstruction].invert();
  return execute(clonedInstructions);
}

OperationResult findAndExecuteNonInifiteLoopingInstructions(List<Instruction> instructions) {
  return instructions
      .where((instruction) => instruction.operation == Operation.jmp || instruction.operation == Operation.nop)
      .map((instruction) => executeWithInvertedInstruction(instructions, instruction))
      .firstWhere((execution) => execution.executedUntilEnd);
}

void main() async {
  final fileContent = await readInput();

  final instructions = fileContent.map((input) => Instruction.parse(input)).toList();

  final partOne = execute(instructions);
  print('Solution part 1: ${partOne.result}');

  reset(instructions);

  final partTwo = findAndExecuteNonInifiteLoopingInstructions(instructions);
  print('Solution part 2: ${partTwo.result}');
}
