const router=require('express').Router();const c=require('../controllers/address.controller');const {authenticate}=require('../middlewares/auth');
router.use(authenticate);router.get('/',c.list);router.post('/',c.create);router.patch('/:id',c.update);router.delete('/:id',c.remove);module.exports=router;
