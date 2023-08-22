const fastify = require('fastify')({ logger: true })
const { convert } = require("./convert");

/*
Available Currencies

usd, eur, gbp, inr, aud, cad, jpy
*/
fastify.get('/convert/:value/:from/:to', (request, reply) => {
    const { from, to, value } = request.params;
    reply.send({
        inCurrency: from,
        inValue: value,
        outCurrency: to,
        outValue: convert(from, to, value)
    });
})

fastify.listen({ port: 3000, host: "0.0.0.0" }, (err) => {
    if (err) {
        fastify.log.error(err)
        process.exit(1)
    }
});
