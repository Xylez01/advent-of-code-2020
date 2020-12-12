import 'dart:io';
import 'dart:math';

Future<List<String>> readInput() async => (await new File('./day-12/input.txt').readAsString()).split('\r\n');

final instructionRegex = new RegExp(r'([NSEWFRL])([\d]*)');

enum Direction { East, South, West, North }

class Instruction {
  String command;
  int value;

  Instruction(this.command, this.value);

  factory Instruction.parse(String input) {
    final match = instructionRegex.allMatches(input).elementAt(0);
    return Instruction(match.group(1), int.parse(match.group(2)));
  }
}

class Position {
  int x;
  int y;

  Position(this.x, this.y);

  int manhattenDistance() {
    return x.abs() + y.abs();
  }
}

final directionToCommand = {Direction.East: 'E', Direction.North: 'N', Direction.West: 'W', Direction.South: 'S'};

final commands = {
  'N': (Position position, int value) => Position(position.x, position.y + value),
  'S': (Position position, int value) => Position(position.x, position.y - value),
  'E': (Position position, int value) => Position(position.x + value, position.y),
  'W': (Position position, int value) => Position(position.x - value, position.y)
};

Direction changeDirection(Direction current, int degrees) {
  final steps = degrees / 90;
  final next = (Direction.values.indexOf(current) + steps) % Direction.values.length;
  return Direction.values[next.round()];
}

Position rotate(Position position, int degrees) {
  final radians = degrees * pi / 180;
  final sine = sin(radians);
  final cosine = cos(radians);

  final x = (cosine * position.x) + (sine * position.y);
  final y = (cosine * position.y) - (sine * position.x);

  return Position(x.round(), y.round());
}

void executeInstructions(List<Instruction> instructions,
    {Function(Instruction) forward,
    Function(Instruction) turnLeft,
    Function(Instruction) turnRight,
    Function(Instruction, Function(Position, int)) navigate}) {
  instructions.forEach((instruction) {
    if (instruction.command == 'F') {
      forward(instruction);
    } else if (instruction.command == 'L') {
      turnLeft(instruction);
    } else if (instruction.command == 'R') {
      turnRight(instruction);
    } else {
      final command = commands[instruction.command];
      navigate(instruction, command);
    }
  });
}

int followInstructions(List<Instruction> instructions) {
  var ship = Position(0, 0);
  var direction = Direction.East;

  executeInstructions(instructions,
      forward: (instruction) => ship = commands[directionToCommand[direction]].call(ship, instruction.value),
      turnLeft: (instruction) => direction = changeDirection(direction, -instruction.value),
      turnRight: (instruction) => direction = changeDirection(direction, instruction.value),
      navigate: (instruction, navigate) => ship = navigate(ship, instruction.value));

  return ship.manhattenDistance();
}

int followWaypoint(List<Instruction> instructions) {
  var ship = Position(0, 0);
  var waypoint = Position(10, 1);

  executeInstructions(instructions,
      forward: (instruction) =>
          ship = Position(ship.x + waypoint.x * instruction.value, ship.y + waypoint.y * instruction.value),
      turnLeft: (instruction) => waypoint = rotate(waypoint, -instruction.value),
      turnRight: (instruction) => waypoint = rotate(waypoint, instruction.value),
      navigate: (instruction, navigate) => waypoint = navigate(waypoint, instruction.value));

  return ship.manhattenDistance();
}

void main() async {
  final fileContent = await readInput();
  final instructions = fileContent.map((input) => Instruction.parse(input)).toList();

  final partOne = followInstructions(instructions);
  print('Solution part 1: ${partOne}');

  final partTwo = followWaypoint(instructions);
  print('Solution part 2: ${partTwo}');
}
