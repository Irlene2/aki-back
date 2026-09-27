const router=require('express').Router();const c=require('../controllers/order.controller');const {authenticate,requirePermission}=require('../middlewares/auth');
router.use(authenticate);router.get('/',c.list);router.post('/',c.create);router.get('/:id',c.get);router.get('/:id/history',c.history);router.patch('/:id/status',requirePermission('orders.manage'),c.status);module.exports=router;
