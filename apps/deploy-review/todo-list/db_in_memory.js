const data = [];

module.exports = {
    connect, close, list, create
}

async function connect() {
    return;
}

async function close() {
    return;
}


async function list(task) {
    return data;
}

async function create(task) {
    data.push({ task });
}
