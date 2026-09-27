const listOrders = (req, res) => {
  res.status(200).json({
    success: true,
    data: [],
    message: 'API de pedidos preparada para a próxima etapa: banco de dados.'
  });
};

module.exports = { listOrders };
