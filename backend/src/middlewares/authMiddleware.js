// Middleware: pastikan user sudah login (session aktif)
function isAuthenticated(req, res, next) {
  if (req.session && req.session.user) {
    return next();
  }
  return res.status(401).json({ success: false, message: 'Silakan login terlebih dahulu.' });
}

// Middleware: batasi akses berdasarkan role
// Contoh penggunaan: hasRole('admin') atau hasRole('admin', 'kasir')
function hasRole(...allowedRoles) {
  return (req, res, next) => {
    if (!req.session || !req.session.user) {
      return res.status(401).json({ success: false, message: 'Silakan login terlebih dahulu.' });
    }
    if (!allowedRoles.includes(req.session.user.role)) {
      return res.status(403).json({ success: false, message: 'Anda tidak memiliki akses ke fitur ini.' });
    }
    return next();
  };
}

module.exports = { isAuthenticated, hasRole };