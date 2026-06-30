const VALID_ROLES = ['admin', 'kasir', 'staff_gudang'];

function validateRegisterInput({  email, password, role }) {
  const errors = [];

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!email || !emailRegex.test(email)) {
    errors.push('Format email tidak valid.');
  }

  if (!password || password.length < 8) {
    errors.push('Password minimal 8 karakter.');
  } else if (!/[A-Z]/.test(password) || !/[0-9]/.test(password)) {
    errors.push('Password harus mengandung huruf kapital dan angka.');
  }

  if (role && !VALID_ROLES.includes(role)) {
    errors.push('Role tidak valid.');
  }

  return errors;
}

function validateLoginInput({ email, password }) {
  const errors = [];
  if (!email) errors.push('Email wajib diisi.');
  if (!password) errors.push('Password wajib diisi.');
  return errors;
}

module.exports = { validateRegisterInput, validateLoginInput, VALID_ROLES };