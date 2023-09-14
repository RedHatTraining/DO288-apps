const Fastify = require("fastify");
const { isPalindrome } = require("./palindrome");


const api = Fastify({ logger: true });


api.get("/word/:input", function handler(request, reply) {
    const { input } = request.params;

    const palidrome = isPalindrome(input);

    reply.send({
        input,
        palidrome,
        length: input.length
    });
});


api.listen({ port: 3000, host: "0.0.0.0" }, (err) => {
    if (err) {
        api.log.error(err);
        process.exit(1);
    }
});
