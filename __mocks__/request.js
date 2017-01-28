/* global jest */
const fs = require('fs')

const request = jest.genMockFromModule('request')

const get = (options, callback) => {
  fs.readFile('./__mocks__/car-AA031-data.html', 'utf8', (err, data) => {
    if (err) {
      throw err
    }
    callback(null, {statusCode: 200}, data)
  })
}

request.get = get

module.exports = request
