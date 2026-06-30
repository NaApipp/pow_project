const express = require('express');
const router = express.Router();
const AuthController = require('../controllers/authController');
const { isAuthenticated } = require('../middlewares/authMiddleware');

router.post('/register', AuthController.register);
router.post('/login', AuthController.login);
router.post('/logout', isAuthenticated, AuthController.logout);
router.get('/me', isAuthenticated, AuthController.me);

module.exports = router;