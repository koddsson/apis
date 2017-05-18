/* global jest */
const fs = require("fs");

const request = jest.genMockFromModule("request");

const get = (options, callback) => {
  switch (options.url) {
    case "http://www.vedur.is/skjalftar-og-eldgos/jardskjalftar":
      fs.readFile("./__mocks__/earthquakes-data.html", "utf8", (err, data) => {
        if (err) {
          throw err;
        }
        callback(null, { statusCode: 200 }, data);
      });
      break;
    case "http://www.samgongustofa.is/umferd/okutaeki/okutaekjaskra/uppfletting?vq=AA031":
      fs.readFile("./__mocks__/car-AA031-data.html", "utf8", (err, data) => {
        if (err) {
          throw err;
        }
        callback(null, { statusCode: 200 }, data);
      });
      break;
    default:
      throw new Error(`Unmocked network call made to ${options.url}`);
  }
};

request.get = get;

module.exports = request;
