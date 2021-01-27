const fs = require('fs');

JSON.parse(
    require('fs').readFileSync(0, 'utf-8')
)
    .items
    .map(x => `"${x.item.id}" "${x.item.title}" "${x.item.artist.name}"`)
    .map(x => console.log(x));
