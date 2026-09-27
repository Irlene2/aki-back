const health = (req, res) => {
  res.status(200).json({
    success: true,
    service: 'aki-delivery-api',
    status: 'online',
    timestamp: new Date().toISOString()
  });
};

module.exports = { health };
