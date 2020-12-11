import 'dart:io';
import '../dart/extension-methods.dart';

Future<List<String>> readInput() async => (await new File('./day-11/input.txt').readAsString()).split('\r\n');

class Space {
  bool isOccupied;
  bool isFloor;

  Space(this.isOccupied, this.isFloor);

  @override
  String toString() {
    if (this.isFloor) {
      return '.';
    }

    return this.isOccupied ? '#' : 'L';
  }

  Space.occupied() {
    this.isOccupied = true;
    this.isFloor = false;
  }

  Space.empty() {
    this.isOccupied = false;
    this.isFloor = false;
  }

  factory Space.parse(String character) {
    return Space(character == '#', character == '.');
  }
}

class IterationResult {
  List<List<Space>> spaces;
  int changes;

  IterationResult(this.spaces, this.changes);
}

final directions = [
  [-1, -1],
  [-1, 0],
  [-1, 1],
  [0, -1],
  [0, 1],
  [1, -1],
  [1, 0],
  [1, 1]
];

int hasOccupiedSeatInDirectionAndRange(
    List<List<Space>> grid, int row, int column, int rowOffset, int columnOffset, int range) {
  var rowIndex = row;
  var columnIndex = column;

  for (var rangeCounter = 0; rangeCounter < range; rangeCounter++) {
    rowIndex += rowOffset;
    columnIndex += columnOffset;

    if (rowIndex < 0 || rowIndex >= grid.length || columnIndex < 0 || columnIndex >= grid[rowIndex].length) {
      return 0;
    }

    final space = grid[rowIndex][columnIndex];
    if (space.isFloor) {
      continue;
    }

    return space.isOccupied ? 1 : 0;
  }

  return 0;
}

int countOccupiedSeatsInRange(List<List<Space>> grid, int row, int column, int range) {
  var occupiedSeats = 0;

  for (var direction in directions) {
    occupiedSeats += hasOccupiedSeatInDirectionAndRange(grid, row, column, direction.first, direction.last, range);
  }

  return occupiedSeats;
}

IterationResult iterate(List<List<Space>> grid, int occupiedSeatTolerance, int occupancyRange) {
  List<List<Space>> next = List(grid.length);

  for (var row = 0; row < grid.length; row++) {
    next[row] = List(grid[row].length);

    for (var column = 0; column < grid[row].length; column++) {
      final space = grid[row][column];
      if (space.isFloor) {
        next[row][column] = grid[row][column];
        continue;
      }

      final occupiedSeatsInRange = countOccupiedSeatsInRange(grid, row, column, occupancyRange);
      if (!space.isOccupied && occupiedSeatsInRange == 0) {
        next[row][column] = Space.occupied();
      } else if (space.isOccupied && occupiedSeatsInRange >= occupiedSeatTolerance) {
        next[row][column] = Space.empty();
      } else {
        next[row][column] = grid[row][column];
      }
    }
  }

  final changes = compare(grid, next);
  return IterationResult(next, changes);
}

int compare(List<List<Space>> grid, List<List<Space>> next) {
  var changes = 0;
  for (var row = 0; row < grid.length; row++) {
    for (var column = 0; column < grid[row].length; column++) {
      if (grid[row][column].toString() != next[row][column].toString()) {
        changes++;
      }
    }
  }

  return changes;
}

void draw(List<List<Space>> grid) {
  for (var row = 0; row < grid.length; row++) {
    for (var column = 0; column < grid[row].length; column++) {
      final space = grid[row][column];
      stdout.write(space);
    }
    stdout.writeln();
  }
  stdout.writeln();
}

IterationResult runSeatsOfLifeUntilEquilibrium(List<List<Space>> grid,
    {int occupiedSeatTolerance, int occupancyRange}) {
  var generationsAreEqual = false;
  var iterationResult = iterate(grid, occupiedSeatTolerance, occupancyRange);

  while (!generationsAreEqual) {
    iterationResult = iterate(iterationResult.spaces, occupiedSeatTolerance, occupancyRange);
    if (iterationResult.changes == 0) {
      generationsAreEqual = true;
    }
  }

  return iterationResult;
}

int sumOccupiedSeats(List<List<Space>> spaces) {
  return spaces.map((row) => row.where((space) => space.isOccupied).length).sum();
}

void main() async {
  final fileContent = await readInput();

  final spaces = fileContent.map((line) {
    return line.characters().map((character) => Space.parse(character)).toList();
  }).toList();

  var partOneResult = runSeatsOfLifeUntilEquilibrium(spaces, occupiedSeatTolerance: 4, occupancyRange: 1);
  print('Solution part 1: ${sumOccupiedSeats(partOneResult.spaces)}');

  var partTwoResult = runSeatsOfLifeUntilEquilibrium(spaces, occupiedSeatTolerance: 5, occupancyRange: spaces.length);
  print('Solution part 2: ${sumOccupiedSeats(partTwoResult.spaces)}');
}
