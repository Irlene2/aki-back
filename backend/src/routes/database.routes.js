const express = require('express');
const { databaseHealth } = require('../controllers/database.controller');

const router = express.Router();
router.get('/health', databaseHealth);

module.exports = router;
