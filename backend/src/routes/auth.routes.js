const router=require('express').Router(); const c=require('../controllers/auth.controller'); const {authenticate}=require('../middlewares/auth');
router.post('/login',c.login); router.post('/register',c.register); router.get('/me',authenticate,c.me); module.exports=router;
