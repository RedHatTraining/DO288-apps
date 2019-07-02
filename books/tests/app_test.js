const chai = require('chai');
const chaiHTTP = require('chai-http');
const server = require('../server');

const { expect } = chai;

chai.use(chaiHTTP);

reqServer = process.env.HTTP_TEST_SERVER || server;

describe('Books App routes test', () => {
  it('GET to / should return 200', (done) => {
    chai.request(reqServer)
      .get('/')
      .end((err, res) => {
        expect(res).to.have.status(200);
        expect(res.text).to.include('Welcome');
        done();
      });
  });

  it('GET to /books should return 200', (done) => {
    chai.request(reqServer)
      .get('/books')
      .end((err, res) => {
        expect(res).to.have.status(200);
        expect(res.text).to.include('ULYSSES');
        done();
      });
  });

  it('GET to /authors should return 200', (done) => {
    chai.request(reqServer)
      .get('/authors')
      .end((err, res) => {
        expect(res).to.have.status(200);
        expect(res.text).to.include('James Joyce');
        done();
      });
  });
});
