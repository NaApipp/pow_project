const bcrypt = require("bcrypt");
const UserModel = require("../models/userModels");
const {
  validateRegisterInput,
  validateLoginInput,
} = require("../utils/validators");

const SALT_ROUNDS = 12;

const AuthController = {
  // Logic Register API
  // POST /api/auth/register
  async register(req, res) {
    try {
      const { email, password, id_role, id_cabang } = req.body;

      const errors = validateRegisterInput({ email, password, id_role });
      if (errors.length > 0) {
        return res
          .status(400)
          .json({ success: false, message: "Validasi gagal.", errors });
      }

      const normalizedEmail = email.trim().toLowerCase();

      // Existing Email
      const existingUser = await UserModel.findByEmail(normalizedEmail);
      if (existingUser) {
        return res
          .status(409)
          .json({ success: false, message: "Email sudah terdaftar." });
      }

      // Validate id_cabang & id_cabang
      const finalIdRole = id_role || "1";
      const finalIdCabang = id_cabang || "1";

      const roleExists = await UserModel.checkRoleExists(finalIdRole);
      if (!roleExists) {
        return res.status(400).json({ success: false, message: "Id Role atau Id Cabang tidak ditemukan." });
      }

      const cabangExists = await UserModel.checkCabangExists(finalIdCabang);
      if (!cabangExists) {
        return res.status(400).json({ success: false, message: "Id Role atau Id Cabang tidak ditemukan." });
      }
      
      const hashedPassword = await bcrypt.hash(password, SALT_ROUNDS);

      const newUserId = await UserModel.create({
        email: normalizedEmail,
        hashedPassword,
        id_role: finalIdRole,
        id_cabang: finalIdCabang,
      });

      return res.status(201).json({
        success: true,
        message: "Registrasi berhasil. Silakan login.",
        data: { 
          email: normalizedEmail, 
          id_cabang: finalIdCabang,
          id_role: finalIdRole
        },
      });
    } catch (err) {
      console.error("Register error:", err);
      return res
        .status(500)
        .json({ success: false, message: "Terjadi kesalahan server." });
    }
  },

  // Logic Login API
  // POST /api/auth/login
  async login(req, res) {
    try {
      const { email, password } = req.body;

      const errors = validateLoginInput({ email, password });
      if (errors.length > 0) {
        return res
          .status(400)
          .json({ success: false, message: "Validasi gagal.", errors });
      }

      const normalizedEmail = email.trim().toLowerCase();
      const user = await UserModel.findByEmail(normalizedEmail);

      // Pesan generik agar tidak bocorkan apakah email terdaftar atau tidak
      const invalidCredsMsg = "Email atau password salah.";

      if (!user) {
        return res
          .status(401)
          .json({ success: false, message: invalidCredsMsg });
      }

      // if (!user.is_active) {
      //   return res.status(403).json({
      //     success: false,
      //     message: "Cabang yang ditaukan di akun anda dinonaktifkan. Hubungi Admin.",
      //   });
      // }

      const isPasswordValid = await bcrypt.compare(password, user.password);
      if (!isPasswordValid) {
        return res
          .status(401)
          .json({ success: false, message: invalidCredsMsg });
      }

      // Regenerasi session untuk mencegah session fixation
      req.session.regenerate((err) => {
        if (err) {
          console.error("Session regenerate error:", err);
          return res
            .status(500)
            .json({ success: false, message: "Terjadi kesalahan server." });
        }

        req.session.user = {
          id_user: user.id_user,
          email: user.email,
          id_role: user.id_role,
          id_cabang: user.id_cabang,
        };

        return res.status(200).json({
          success: true,
          message: "Login berhasil.",
          data: req.session.user,
        });
      });
    } catch (err) {
      console.error("Login error:", err);
      return res
        .status(500)
        .json({ success: false, message: "Terjadi kesalahan server." });
    }
  },

  // Logic Logout API
  // POST /api/auth/logout
  async logout(req, res) {
    req.session.destroy((err) => {
      if (err) {
        console.error("Logout error:", err);
        return res
          .status(500)
          .json({ success: false, message: "Gagal logout." });
      }
      res.clearCookie("connect.sid");
      return res
        .status(200)
        .json({ success: true, message: "Logout berhasil." });
    });
  },

  // Logic Save Data User Login API
  // GET /api/auth/me — cek sesi aktif
  async me(req, res) {
    if (!req.session.user) {
      return res.status(401).json({ success: false, message: "Belum login." });
    }
    return res.status(200).json({ success: true, data: req.session.user });
  },
};

module.exports = AuthController;
