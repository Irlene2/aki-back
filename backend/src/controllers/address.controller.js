const s=require('../services/address.service');
exports.list=async(req,res,next)=>{try{res.json({addresses:await s.list(req.auth.sub)})}catch(e){next(e)}};
exports.create=async(req,res,next)=>{try{res.status(201).json({address:await s.create(req.auth.sub,req.body||{})})}catch(e){next(e)}};
exports.update=async(req,res,next)=>{try{const address=await s.update(req.auth.sub,req.params.id,req.body||{});if(!address)return res.status(404).json({error:'Endereço não encontrado.'});res.json({address})}catch(e){next(e)}};
exports.remove=async(req,res,next)=>{try{const item=await s.remove(req.auth.sub,req.params.id);if(!item)return res.status(404).json({error:'Endereço não encontrado.'});res.status(204).end()}catch(e){next(e)}};
