import { getItems } from './item-service';

describe('getItems', () => {
  it('should return an array', () => {
    expect(typeof getItems()).toBe('array');
  });
});
