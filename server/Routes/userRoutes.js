    const express=require('express')
    const router =express.Router();

    const UserController = require('../Controller/userController')
    router.post("/signup", UserController.createUser);
    router.post("/login", UserController.loginUser);
    router.delete("/deleteuser/:id",UserController.deleteUser);
    router.get("/users",UserController.getAllUsers);
    router.put("updateuser/:id",UserController.updateUser);

    module.exports = router;