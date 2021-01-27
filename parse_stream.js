const fs = require('fs');

console.log(
    JSON.parse(
        require('fs').readFileSync(0, 'utf-8')
    )
    .url
);
