const os = require("os");
const http = require("http");


const hostname = "0.0.0.0";
const userInfo = os.userInfo();
const port = process.env.PORT || 80;
const greetings = [
    "Guten tag",
    "Hi!",
    "Hello, how are you?",
    "Hola, ¿que tal?",
    "Bonjour, ça va bien?",
    "Ciao, come stai?",
    "Bon dia",
    "Salve",
    "Olá, tudo bem?",
    "Namaste",
    "Hallo",
    "Hei!",
    "Yassou",
    "Ahoj!",
    "Cześć!",
    "Hej",
    "Hey",
    "Privet",
    "Annyeong",
    "Selam"
];


console.log(`User ID: ${userInfo.uid}, group ID: ${userInfo.gid}`);


http
    .createServer(handleRequest)
    .listen(port, hostname, () => {
        console.log(`Server running as at http://${hostname}:${port}/`);
    });


function handleRequest(req, res)  {
    const randomGreetingIndex = Math.floor(Math.random() * greetings.length);
    const message = greetings[randomGreetingIndex];

    res.statusCode = 200;
    res.setHeader("Content-Type", "application/json");
    res.end(JSON.stringify({ message }));
}
