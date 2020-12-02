const fs = require('fs');
const unique = array => [...new Set(array)];
const target = 2020;

const combinations = numbers => {
  return numbers.flatMap((number, index) =>
    numbers.slice(index + 1).map(other => {
      return { entries: [number, other], sum: number + other };
    })
  );
};

const solveWithCombinationsOfTwo = numbers => {
  return combinations(numbers)
    .find(combination => combination.sum === target)
    .entries.reduce((left, right) => left * right);
};

const solveWithCombinationsOfThree = numbers => {
  return numbers
    .flatMap((number, index) => {
      return combinations(numbers.slice(index + 1)).map(combination => ({
        entries: [...combination.entries, number],
        sum: combination.sum + number
      }));
    })
    .find(combination => combination.sum === target)
    .entries.reduce((left, right) => left * right);
};

module.exports = {
  solve() {
    const fileContent = fs.readFileSync('./day-1/input.txt', 'utf8');
    const numbers = unique(fileContent.split('\r\n').map(numberAsText => Number(numberAsText)));

    return { partOne: solveWithCombinationsOfTwo(numbers), partTwo: solveWithCombinationsOfThree(numbers) };
  }
};
