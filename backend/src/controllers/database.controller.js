const { checkDatabase } = require('../config/database');

const databaseHealth = async (req, res, next) => {
  try {
    const result = await checkDatabase();
    res.status(200).json({
      success: true,
      database: 'postgresql',
      status: 'online',
      serverTime: result.now
    });
  } catch (error) {
    next(error);
  }
};

module.exports = { databaseHealth };
