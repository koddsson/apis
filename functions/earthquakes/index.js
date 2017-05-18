const getEarthquakes = require("@apis/earthquakes");

exports.handle = (event, context) => {
  getEarthquakes()
    .then(earthquakes => context.succeed({ results: earthquakes }))
    .catch(error => context.fail(error));
};
