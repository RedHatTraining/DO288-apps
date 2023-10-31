const { Client } = require("pg");


const host = process.env.DB_HOST || "postgresql";
const user = process.env.DB_USER || "developer";
const password = process.env.DB_PASSWORD || "developer";
const database = "todo_list";
const client = new Client({ host, user, database, user, password });

module.exports = {
    connect, close, list, create
}

async function connect() {
    try {
        await client.connect();
    } catch(error) {
        throw new Error("Could not connect to database:" + error);
    }

    await createSchema(client);
}

async function close() {
    client.close();
}


async function list(task) {
    const result = await client.query("SELECT * FROM todos");
    return result.rows;
}

async function create(task) {
    await client.query("INSERT INTO todos (task) VALUES ($1)", [task]);
}


function createSchema(client) {
    return client.query(`
        CREATE TABLE IF NOT EXISTS todos (
            id serial PRIMARY KEY,
            task TEXT NOT NULL
        );
    `)
}