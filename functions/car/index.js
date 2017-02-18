const lookupCar = require('@apis/car')

exports.handle = (event, context) => {
  // TODO: Move to utils
  const queryString = event.querystring
  const queryObject = queryString
    .slice(1, -1)
    .split(',')
    .map((pair) => pair.trim())
    .reduce((acc, curr) => {
      const keyValueSplit = curr.split('=')
      acc[keyValueSplit[0]] = keyValueSplit[1]
      return acc
    }, {})

  const carPlate = queryObject.plate

  lookupCar(carPlate)
    .then((car) => context.succeed({results: [car]}))
    .catch((error) => context.fail(error))
}
