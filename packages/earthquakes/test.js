/* global expect, it, describe, jest */

jest.mock("request");

const getEarthquakes = require("./index.js");

describe("getting earthquakes", () => {
  it("should show all the earthquakes that are happening", () => {
    return getEarthquakes().then(earthquakes => {
      expect(earthquakes).toMatchSnapshot();
    });
  });
});
