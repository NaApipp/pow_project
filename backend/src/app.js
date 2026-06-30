// const express = require('express');
// const session = require('express-session');
// const MySQLStore = require('express-mysql-session')(session);
// require('dotenv').config();

// const pool = require('./config/db');
// const authRoutes = require('./routes/authRoutes');

// const app = express();
// app.use(express.json());

// // Session store di MySQL agar persist meski server restart
// const sessionStore = new MySQLStore({}, pool);

// app.use(
//   session({
//     key: 'pow_session',
//     secret: process.env.SESSION_SECRET || 'ganti_dengan_secret_kuat',
//     store: sessionStore,
//     resave: false,
//     saveUninitialized: false,
//     cookie: {
//       httpOnly: true,
//       secure: process.env.NODE_ENV === 'production', // true jika pakai HTTPS
//       maxAge: 1000 * 60 * 60 * 8, // 8 jam, sesuai shift kerja
//     },
//   })
// );

// app.use('/api/auth', authRoutes);

// const PORT = process.env.PORT || 5000;
// app.listen(PORT, () => console.log(`POW backend jalan di port ${PORT}`));