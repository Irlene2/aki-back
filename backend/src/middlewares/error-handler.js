module.exports = (err, req, res, next) => {
  console.error(err);

  const status = Number(err.statusCode || err.status || 500);
  const message = status >= 500 ? 'Erro interno do servidor' : err.message;

  res.status(status).json({
    success: false,
    error: message
  });
};
