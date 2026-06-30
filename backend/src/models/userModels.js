const pool = require('../config/db');

const UserModel = {
  async findByEmail(email) {
    const [rows] = await pool.query('SELECT * FROM tb_user WHERE email = ? LIMIT 1', [email]);
    return rows[0] || null;
  },

  async findById(id) {
    const [rows] = await pool.query(
      'SELECT id_user, full_name, email, id_role, id_cabang, is_active FROM tb_user WHERE id = ? LIMIT 1',
      [id]
    );
    return rows[0] || null;
  },


  async create({  email, hashedPassword, id_role, id_cabang }) {
    const [result] = await pool.query(
      `INSERT INTO tb_user ( email, password, id_role, id_cabang)
       VALUES (?, ?, ?, ?)`,
      [ email, hashedPassword, id_role || '1', id_cabang || '1']
    );
    return result.insertId;
  },

  async checkRoleExists(id_role) {
    const [rows] = await pool.query('SELECT 1 FROM tb_role WHERE id_role = ? LIMIT 1', [id_role]);
    return rows.length > 0;
  },

  async checkCabangExists(id_cabang) {
    const [rows] = await pool.query('SELECT 1 FROM tb_cabang WHERE id_cabang = ? LIMIT 1', [id_cabang]);
    return rows.length > 0;
  },
};

module.exports = UserModel;