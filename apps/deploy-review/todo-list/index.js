const Fastify = require("fastify");

const DB = require("./db");

const api = Fastify({ logger: true });


api.get("/", async () => {
    return { title: 'Todo List API' };
});


api.get("/todos", async function listTodos() {
    const todos = await DB.list();
    return todos;
});


api.post("/todos", async function createTodo(request, reply) {
    const task = request.body.task;
    await DB.create(task);
    return reply.code(201).send();
});


api.addHook("onClose", async () => {
    await DB.close();
});


async function serve() {
    const port = process.env.PORT || 3000;
    await DB.connect();
    await api.listen({ port, host: "0.0.0.0" });
    api.log.info(`Server is listening on port ${port}`);
}


serve();
