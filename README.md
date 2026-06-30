# POW Project

Proyek ini adalah aplikasi Full-Stack yang terdiri dari **Frontend** (React + Vite) dan **Backend** (Node.js + Express). Proyek ini dikonfigurasi menggunakan **npm workspaces** sehingga Anda dapat menjalankan kedua sisi secara bersamaan maupun terpisah.

## 🛠 Prasyarat (Prerequisites)

Pastikan Anda sudah menginstal aplikasi berikut di sistem Anda:
- [Node.js](https://nodejs.org/) (Disarankan versi LTS, misal 18.x atau 20.x)
- `npm` (Bawaan dari instalasi Node.js)

## 🚀 Cara Menjalankan Proyek (Cara Cepat)

Karena proyek ini menggunakan fitur `workspaces` dari npm, Anda bisa langsung menjalankan frontend dan backend secara bersamaan hanya dengan beberapa langkah:

1. **Buka terminal** dan arahkan ke folder root proyek (`pow-full`).
2. **Install semua dependensi** (untuk root, frontend, dan backend sekaligus):
   ```bash
   npm install
   ```
3. **Konfigurasi Environment Backend**:
   Pastikan file `.env` sudah ada di dalam folder `backend/` (lihat detail pada bagian [Konfigurasi .env](#%EF%B8%8F-konfigurasi-env-backend)).
4. **Jalankan Aplikasi (Frontend & Backend Bersamaan)**:
   ```bash
   npm run dev
   ```
   *Perintah ini menggunakan `concurrently` untuk menjalankan backend dengan Nodemon dan frontend dengan Vite di satu terminal yang sama.*

- **Frontend** biasanya akan berjalan di: `http://localhost:5173`
- **Backend** akan berjalan di: `http://localhost:5000` (atau port lain sesuai konfigurasi)

---

## 📂 Cara Menjalankan Secara Terpisah (Opsional)

Jika Anda ingin menjalankan atau melakukan debug pada masing-masing sisi di terminal yang berbeda, ikuti langkah berikut:

### 1. Menjalankan Backend Saja
1. Buka terminal dan masuk ke folder `backend`:
   ```bash
   cd backend
   ```
2. Jalankan server development:
   ```bash
   npm run dev
   ```
   *(Backend akan menggunakan nodemon sehingga otomatis restart ketika ada perubahan kode)*.

### 2. Menjalankan Frontend Saja
1. Buka terminal baru dan masuk ke folder `frontend`:
   ```bash
   cd frontend
   ```
2. Jalankan server development:
   ```bash
   npm run dev
   ```

---

## ⚙️ Konfigurasi `.env` Backend

Untuk backend, terdapat file environment variabel (env). Pastikan Anda memiliki file bernama `.env` di dalam folder `backend/` dengan struktur seperti ini (sesuaikan nilai kredensialnya jika menggunakan DB lokal):

```env
PORT=5000
CLIENT_URL=http://localhost:5173

# Konfigurasi Database MySQL
DB_HOST=sql12.freesqldatabase.com
DB_NAME=sql12831902
DB_USER=sql12831902
DB_PASSWORD=4IEuwmGU5U
PORT=3306 
# Catatan Penting: Terdapat 2 variabel bernama 'PORT' di file env asli. Variabel di bagian bawah akan menimpa yang atas.
# Disarankan mengubah baris "PORT=3306" menjadi "DB_PORT=3306" agar Express JS tetap berjalan di port 5000 dan tidak bentrok dengan port DB.

SESSION_SECRET=sajzdpayxpmtpegmbryw
```

---

## 📦 Build untuk Production (Frontend)

Jika Anda ingin mem-build frontend agar siap untuk di-deploy ke production, Anda cukup menjalankan perintah berikut dari **root folder proyek**:

```bash
npm run build
```
File hasil build (production ready) akan di-generate dan tersimpan di dalam folder `frontend/dist`.
