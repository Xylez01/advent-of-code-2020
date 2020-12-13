import 'dart:io';

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

int findEarliestTimeStampOfConsecutiveDeparture(List<String> busSchedule) {
  var timeStamp = 0;
  var multiplier = 1;

  for (var offset = 0; offset < busSchedule.length; offset++) {
    if (busSchedule[offset] == 'x') {
      continue;
    }

    final id = int.parse(busSchedule[offset]);
    timeStamp = findNextTimeStamp(timeStamp, multiplier, id, offset);
    multiplier *= id;
  }

  return timeStamp;
}

bool fitsSchedule(int timeStamp, int offset, int id) => (timeStamp + offset) % id == 0;

int findNextTimeStamp(int result, int multiplier, int id, int offset) {
  bool foundNextTimeStamp = false;
  
  while(!foundNextTimeStamp) {
    final timeStamp = (result += multiplier);
    foundNextTimeStamp = fitsSchedule(timeStamp, offset, id);
  }

  return result;
}

void main() async {
  final fileContent = await readInput();
  final arrivalTime = int.parse(fileContent[0].trim());

  final busSchedule = fileContent[1].split(',').toList();
  final busTimes = busSchedule.where((character) => character != 'x').map((number) => int.parse(number)).toList();

  final partOne = findEarliestBus(arrivalTime, busTimes);
  print('Solution part 1: ${partOne}');

  final partTwo = findEarliestTimeStampOfConsecutiveDeparture(busSchedule);
  print('Solution part 1: ${partTwo}');
}
