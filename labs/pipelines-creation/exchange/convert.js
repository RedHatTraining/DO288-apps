const currencyRates = {
  usd: 1,
  eur: 0.824,
  gbp: 0.744,
  inr: 73.798,
  aud: 1.345,
  cad: 1.278,
  jpy: 104.171,
};

function convert(inCurrency, outCurrency, amount) {
  const conversionRate =
    (1 / currencyRates[inCurrency]) * currencyRates[outCurrency];
  const convertedAmount = amount * conversionRate;
  return Math.round(convertedAmount * 100) / 100;
}

module.exports = {
  convert,
};
