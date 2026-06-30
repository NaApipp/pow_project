const express = require('express');
const cors = require('cors');
require('dotenv').config();
const session = require('express-session');
const MySQLStore = require('express-mysql-session')(session);

const pool = require('./config/db');
const apiRoutes = require('./routes/api.js');
const authRoutes = require('./routes/authRoutes');


const app = express();
const PORT = process.env.PORT || 5000;

// ── Middleware ──────────────────────────────
app.use(cors({
  origin: process.env.CLIENT_URL || 'http://localhost:5173',
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  credentials: true,
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Session store di MySQL agar persist meski server restart
const sessionStore = new MySQLStore({}, pool);

app.use(
  session({
    key: 'pow_session',
    secret: process.env.SESSION_SECRET || 'ganti_dengan_secret_kuat',
    store: sessionStore,
    resave: false,
    saveUninitialized: false,
    cookie: {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production', // true jika pakai HTTPS
      maxAge: 1000 * 60 * 60 * 8, // 8 jam, sesuai shift kerja
    },
  })
);

// ── Routes ──────────────────────────────────
app.use('/api', apiRoutes);
app.use('/api/auth', authRoutes);

// ── Health check ────────────────────────────
app.get('/', (req, res) => {
  res.json({ message: 'Server is running 🚀' });
});

// ── Error handler ───────────────────────────
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Internal Server Error' });
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});