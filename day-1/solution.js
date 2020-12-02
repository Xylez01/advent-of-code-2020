const fs = require('fs');

function combinations(numbers, number, index) {
  return numbers.slice(index + 1).map(other => {
    return { result: [number, other], sum: number + other };
  });
}

function solvePartOne(numbers) {
  return numbers
    .flatMap((number, index) => combinations(numbers, number, index))
    .find(combination => combination.sum === 2020)
    .result.reduce((left, right) => left * right);
}

function solvePartTwo(numbers) {
  return numbers
    .flatMap((number, index) => {
      const remainingNumbers = numbers.slice(index + 1);
      return remainingNumbers
        .flatMap((remainingNumber, indexOfRemainingNumber) =>
          combinations(remainingNumbers, remainingNumber, indexOfRemainingNumber)
        )
        .map(combination => {
          combination.result.push(number);
          return { result: combination.result, sum: combination.sum + number };
        });
    })
    .find(combination => combination.sum === 2020)
    .result.reduce((left, right) => left * right);
}

module.exports = {
  solve() {
    const fileContent = fs.readFileSync('./day-1/input.txt', 'utf8');
    const numbers = fileContent.split('\r\n').map(numberAsText => Number(numberAsText));

    return { partOne: solvePartOne(numbers), partTwo: solvePartTwo(numbers) };
  }
};
