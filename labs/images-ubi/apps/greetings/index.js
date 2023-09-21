const os = require("os");
const http = require("http");
const localization = require("./LocalizationService");


const hostname = "0.0.0.0";
const userInfo = os.userInfo();
const port = process.env.PORT || 8080;


main();


async function main() {
    console.info(`Running with user ID: ${userInfo.uid}, group ID: ${userInfo.gid}`);

    console.info("Verifying file cache...");
    try {
        await localization.translate("greeting", "en-us");
    } catch(error) {
        console.error("File cache does not work due to", error);
    }

    console.info("Starting server...");
    http
        .createServer(handleRequest)
        .listen(port, hostname, () => {
            console.log(`Server listening at http://${hostname}:${port}/`);
        });
}


async function handleRequest(req, res) {
    // Return a greeting message in a random language
    const locale = localization.getRandomLocaleID();
    const message = await localization.translate("greeting", locale);

    res.statusCode = 200;
    res.setHeader("Content-Type", "application/json");
    res.end(JSON.stringify({ message }));
}
