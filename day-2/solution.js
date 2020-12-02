const fs = require('fs');

const mapToEntry = line => {
  const [_, min, max, character, password] = line.match(`([\\d]*)-([\\d]*) ([\\w]): ([\\w]*)`);
  return {
    min: Number(min),
    max: Number(max),
    character,
    password,
    isValid: false
  };
};

const updateValidityBasedOnCharacterCount = entries => {
  entries.forEach(entry => {
    const matches = entry.password.match(new RegExp(entry.character, 'g')) || [];
    entry.isValid = matches.length >= entry.min && matches.length <= entry.max;
  });

  return entries;
};

const updateValidityBasedOnCharacterPosition = entries => {
  entries.forEach(entry => {
    const isAtMin = entry.password[entry.min - 1] === entry.character;
    const isAtMax = entry.password[entry.max - 1] === entry.character;
    entry.isValid = !(isAtMin && isAtMax) && (isAtMin || isAtMax);
  });

  return entries;
};

module.exports = {
  solve() {
    const entries = fs.readFileSync('./day-2/input.txt', 'utf8').split('\r\n').map(mapToEntry);

    return {
      partOne: updateValidityBasedOnCharacterCount(entries).filter(entry => entry.isValid).length,
      partTwo: updateValidityBasedOnCharacterPosition(entries).filter(entry => entry.isValid).length
    };
  }
};
