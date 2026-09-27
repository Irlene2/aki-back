const router=require('express').Router();const c=require('../controllers/product.controller');const {authenticate,requirePermission}=require('../middlewares/auth');
router.get('/',c.list);router.post('/',authenticate,requirePermission('products.manage'),c.create);router.put('/:id',authenticate,requirePermission('products.manage'),c.update);module.exports=router;
