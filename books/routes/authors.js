const express = require('express');

const router = express.Router();

const authors = require('../data/authors');

/* GET users listing. */
router.get('/', (req, res) => {
  res.json(authors);
});

module.exports = router;
