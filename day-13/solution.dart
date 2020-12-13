import 'dart:io';
import 'dart:math';

Future<List<String>> readInput() async => (await new File('./day-13/input.txt').readAsString()).split('\r\n');

class Bus {
  int interval;
  int closestTime;

  Bus(this.interval, this.closestTime);

  @override
  String toString() {
    return '${interval}-${closestTime}';
  }
}

int findEarliestBus(int arrivalTime, List<int> busTimes) {
  final busses = busTimes.map((time) => Bus(time, (arrivalTime / time).ceil() * time)).toList()
    ..sort((left, right) => left.closestTime - right.closestTime);

  int difference = busses.first.closestTime - arrivalTime;
  return difference * busses.first.interval;
}

void main() async {
  final fileContent = await readInput();
  final arrivalTime = int.parse(fileContent[0].trim());

  final busSchedule = fileContent[1].split(',').toList();
  final busTimes = busSchedule.where((character) => character != 'x').map((number) => int.parse(number)).toList();

  final partOne = findEarliestBus(arrivalTime, busTimes);
  print('Solution part 1: ${partOne}');
}
