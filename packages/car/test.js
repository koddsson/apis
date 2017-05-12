/* global expect, it, describe, jest */

jest.mock('request');

const lookupCar = require('./index.js');

describe('car lookup', () => {
  it('should lookup cars by plate number', () => {
    return lookupCar('AA031').then(carData => {
      expect(carData.number).toEqual('AA031');
    });
  });
});