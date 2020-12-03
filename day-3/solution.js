const fs = require('fs');

const maxMovesToRight = 7;

const traverseMap = (grid, movesToRight, movesDownward) => {
  const position = { x: 0, y: 0 };
  let didReachEndOfMap = false;
  let treesHit = 0;

  while (!didReachEndOfMap) {
    position.x += movesToRight;
    position.y += movesDownward;

    if (grid[position.y] === undefined) {
      didReachEndOfMap = true;
    } else if (grid[position.y][position.x] === '#') {
      treesHit++;
    }
  }

  return treesHit;
};

module.exports = {
  solve() {
    const grid = fs.readFileSync('./day-3/input.txt', 'utf8').split('\r\n');
    const depth = grid.length;
    const width = grid[0].length;

    const positionsToGoRight = depth * maxMovesToRight;
    const patternRepeatCount = Math.ceil(positionsToGoRight / width);

    const patternedGrid = grid.map(row => row.repeat(patternRepeatCount));

    return {
      partOne: traverseMap(patternedGrid, 3, 1),
      partTwo: [
        traverseMap(patternedGrid, 1, 1),
        traverseMap(patternedGrid, 3, 1),
        traverseMap(patternedGrid, 5, 1),
        traverseMap(patternedGrid, 7, 1),
        traverseMap(patternedGrid, 1, 2)
      ].reduce((left, right) => left * right)
    };
  }
};
