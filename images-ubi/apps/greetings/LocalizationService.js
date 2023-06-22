/**
 * Simulate an external localization service
 */
const fs = require("fs").promises;


const TRANSLATIONS = {
    "greeting": {
        "de-de": "Guten tag",
        "en-us": "Hi!",
        "es-es": "Hola, ¿que tal?",
        "fr-be": "Bonjour, ça va bien?",
        "it-it": "Ciao, come stai?",
        "ca": "Bon dia",
        "pt-pt": "Olá, tudo bem?",
        "hi": "Namaste",
        "nl-nl": "Hallo",
        "no-no": "Hei!",
        "el": "Yassou",
        "cs": "Ahoj!",
        "pl": "Cześć!",
        "sv-se": "Hej",
        "ru": "Privet",
        "tr": "Selam"
    }
}


async function translate(key, locale) {
    let translated;

    try {
        translated = await readFromFileCache(key, locale);
        console.info(`${locale} '${key}' found in cache`);
    } catch (error) {
        // Only handle the not found case (ENOENT)
        if (error.code !== "ENOENT") {
            throw err;
        }

        translated = await getTranslationFromExternalService(key, locale);

        await writeToFileCache(key, locale, translated);
    }

    return translated;
}


async function readFromFileCache(key, locale) {
    const buffer = await fs.readFile(generateCacheFilename(key, locale));
    return buffer.toString();
}


function writeToFileCache(key, locale, value) {
    return fs.writeFile(generateCacheFilename(key, locale), value);
}


function generateCacheFilename(key, locale) {
    return `/var/cache/translation_${key}_${locale}`;
}


function getTranslationFromExternalService(key, locale) {
    // Simulate a network delay of 500 millis
    return new Promise((resolve) => {
        setTimeout(() => {
            const translated = TRANSLATIONS[key][locale];
            resolve(translated);
        }, 500);
    });
}


function getSupportedLocaleIDs() {
    return Object.keys(TRANSLATIONS.greeting);
}


function getRandomLocaleID() {
    const locales = getSupportedLocaleIDs();
    const localeIndex = Math.floor(Math.random() * locales.length);
    return locales[localeIndex];
}


module.exports = {
    translate,
    getRandomLocaleID,
    getSupportedLocaleIDs
}
