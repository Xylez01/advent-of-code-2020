const dayOne = require('./day-1/solution');

const arguments = process.argv.slice(2);

const adventOfCode = {
  dayOne: function () {
    return dayOne.solve();
  }
};

if (arguments.length === 0) {
  const solutions = {};
  Object.keys(adventOfCode).forEach(key => {
    solutions[key] = adventOfCode[key]();
  });

  console.log(solutions);
} else {
  const solution = {};
  const dayArgument = arguments[0];
  solution[dayArgument] = adventOfCode[dayArgument]();

  console.log(solution);
}
