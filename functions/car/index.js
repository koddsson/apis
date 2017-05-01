const lookupCar = require('@apis/car')

exports.handle = (event, context) => {
  const carPlate = event.params.querystring.plate;

  lookupCar(carPlate)
    .then((car) => context.succeed({results: [car]}))
    .catch((error) => context.fail(error));
}
