const fastify = require("fastify")({ logger: true });
const { convert } = require("./convert");

/*
Available Currencies

usd, eur, gbp, inr, aud, cad, jpy
*/
fastify.get("/convert/:inValue/:inCurrency/:outCurrency", (request, reply) => {
  const { inCurrency, outCurrency, inValue } = request.params;
  reply.send({
    inCurrency,
    inValue,
    outCurrency,
    outValue: convert(inCurrency, outCurrency, inValue),
  });
});

fastify.listen({ port: 3000, host: "0.0.0.0" }, (err) => {
  if (err) {
    fastify.log.error(err);
    process.exit(1);
  }
});
