const fs = require('fs');

function solvePartOne(numbers) {
  const solution = numbers
    .flatMap((number, index) =>
      numbers.slice(index + 1).map(other => {
        return {left: number, right: other, sum: number + other}
      })
    )
    .find(combination => combination.sum === 2020);

  return solution.left * solution.right;
}

module.exports = {
  solve() {
    const fileContent = fs.readFileSync('./day-1/input.txt', 'utf8').trimEnd()
    const numbers = fileContent.split('\r\n').map(numberAsText => Number(numberAsText))

    return {partOne: solvePartOne(numbers)}
  }
}