# AGENT.md — POW (Point of Sale + Warehouse)

Context file ini digunakan oleh AI coding assistant (Claude Code, Cursor, dsb) agar memahami arsitektur, konvensi, dan batasan project sebelum melakukan perubahan kode. Selalu baca file ini terlebih dahulu sebelum membuat fitur baru.

---

## 1. Ringkasan Project

POW adalah platform manajemen retail terintegrasi yang menggabungkan dua modul utama:

- **Point of Sale (POS)** — transaksi penjualan di kasir (pilih produk, bayar, cetak struk)
- **Warehouse Management** — pengelolaan stok (barang masuk, keluar, penyesuaian, mutasi)

Target pengguna: bisnis retail menengah dengan satu atau lebih cabang. Setiap transaksi POS otomatis memperbarui stok di Warehouse secara real-time — tidak ada rekonsiliasi manual.

**Roles:** Owner (akses penuh), Admin (kelola sistem & laporan), Kasir (transaksi penjualan), Staff Gudang (kelola stok).

---

## 2. Tech Stack

| Layer | Teknologi | Catatan |
|---|---|---|
| Backend | Express.js (Node.js) | REST API, business logic, routing |
| Frontend | React.js (SPA) | Terpisah dari backend, konsumsi REST API |
| Database | MySQL | Relasional, transaksi atomik wajib untuk sinkronisasi stok |
| ORM | **Prisma** | Schema-first, type-safe, migration mirip konsep Eloquent |
| Auth | Session-based (`express-session`) | Session disimpan di store (gunakan `connect-session-sequelize`/`connect-redis`, jangan MemoryStore di production) |
| Styling | Tailwind CSS | Utility-first di sisi React |
| Bahasa | TypeScript | Disarankan untuk backend & frontend (konsisten dengan latar belakang Next.js/TS) |

**Penting:** Project ini BUKAN Laravel meskipun PRD awal sempat menyebut istilah "Eloquent"/"Blade" secara keliru — itu typo dari template dokumen. Stack final adalah Express.js + React.js seperti tabel di atas.

---

## 3. Struktur Repo (Monorepo)

```
pow/
├── backend/
│   ├── src/
│   │   ├── config/          # koneksi DB, session config, env loader
│   │   ├── middlewares/     # auth guard, role guard, error handler
│   │   ├── modules/         # domain-based, bukan technical-based
│   │   │   ├── auth/
│   │   │   ├── users/
│   │   │   ├── products/
│   │   │   ├── suppliers/
│   │   │   ├── branches/    # cabang
│   │   │   ├── pos/         # transaksi & transaksi_items
│   │   │   ├── warehouse/   # stocks, stock_movements, receipts
│   │   │   └── reports/
│   │   │       each module: controller.ts, service.ts, routes.ts, validation.ts
│   │   ├── routes/          # index router yang menggabungkan semua modules
│   │   └── app.ts
│   ├── prisma/
│   │   ├── schema.prisma
│   │   └── migrations/
│   └── package.json
├── frontend/
│   ├── src/
│   │   ├── pages/            # per role: kasir/, admin/, gudang/
│   │   ├── components/       # reusable UI
│   │   ├── features/         # domain-based state & API hooks (mirror backend modules)
│   │   ├── lib/               # axios instance, helpers
│   │   └── routes/
│   └── package.json
└── AGENT.md
```

**Aturan struktur:** modul backend & fitur frontend disusun per domain (products, pos, warehouse, dst), bukan per tipe file (jangan kumpulkan semua controller di satu folder besar).

---

## 4. Skema Database (ringkasan dari Database Design)

Tabel inti dan relasinya:

- `users` — id_user, email, password, id_role (FK), id_cabang (FK)
- `role` — id_role, role_name
- `cabang` — id_cabang, nama_cabang, alamat, is_active
- `category` — id_category, name_category
- `products` — id_products, name_products, price, unit, min_stock, id_category (FK), id_supplier (FK)
- `suppliers` — id_suppliers, nama_suppliers, no_hp, alamat
- `stocks` — id_stocks, id_product (FK), id_cabang (FK), quantity → **stok per produk per cabang**
- `transaksi` — id_transaksi, id_user (FK), id_cabang (FK), payment_method (enum: tunai, debit, qris, transfer), total, createdAt
- `transaksi_items` — id_transaksi_items, id_transaksi (FK), id_product (FK), quantity, price_at_sale
- `receipts` — id_receipts, id_suppliers (FK), id_branch (FK), received_at → **penerimaan barang dari supplier**
- `receipts_items` — id_receipts_items, id_receipts (FK), id_products (FK), quantity, price_buy
- `stock_movements` — id_stock_movements, id_product (FK), id_branch (FK), type, quantity, id_reference, created_at → **log semua mutasi stok (masuk/keluar/adjust)**

**Aturan krusial:**
- Setiap transaksi POS yang berhasil HARUS: (1) insert ke `transaksi` + `transaksi_items`, (2) decrement `stocks.quantity`, (3) insert log ke `stock_movements` dengan type `out` dan `id_reference` = id_transaksi. Ketiganya wajib dalam satu **database transaction** (Prisma `$transaction`) — jangan pernah split jadi beberapa request terpisah.
- Setiap penerimaan barang (`receipts`) HARUS increment `stocks.quantity` + log `stock_movements` type `in`, juga dalam satu transaction.
- Stok tidak boleh minus — validasi `quantity` produk vs stok tersedia SEBELUM transaksi disimpan, bukan sesudah.
- Stok dipisah per cabang (`stocks` punya FK `id_cabang`), bukan global per produk.

---

## 5. Role & Akses (ringkasan)

| Role | Akses |
|---|---|
| Owner | Semua fitur semua role |
| Admin | User, produk, supplier, cabang, batalkan transaksi, semua laporan |
| Kasir | Transaksi POS, riwayat transaksi sendiri |
| Staff Gudang | Barang masuk/keluar, penyesuaian stok, riwayat mutasi stok |

Implementasikan sebagai middleware `roleGuard(...allowedRoles)` di backend, dicek di setiap route, bukan hanya disembunyikan di UI frontend.

---

## 6. Konvensi Koding

- **Bahasa kode**: TypeScript untuk backend & frontend. Nama variabel/fungsi dalam bahasa Inggris meskipun dokumentasi bisnis dalam Bahasa Indonesia.
- **API response format**: konsisten, contoh:
  ```json
  { "success": true, "data": {...}, "message": "..." }
  { "success": false, "error": "..." }
  ```
- **Validasi input**: gunakan `zod` di backend sebelum masuk ke service layer.
- **Error handling**: satu `errorHandler` middleware global di Express, jangan try-catch manual di tiap controller untuk format response error.
- **Transaksi DB**: semua operasi yang menyentuh lebih dari satu tabel terkait stok WAJIB pakai `prisma.$transaction`.
- **Penamaan tabel/kolom**: ikuti skema existing (lihat bagian 4) walau penamaannya tidak 100% konsisten snake_case vs camelCase di dokumen asli — saat membuat `schema.prisma`, normalisasi ke `snake_case` untuk nama tabel/kolom DB, dan biarkan Prisma generate camelCase di sisi TypeScript client.
- **Commit message**: gunakan format `feat(modul): deskripsi`, `fix(modul): deskripsi`, mengikuti domain modul (pos, warehouse, auth, dst).

---

## 7. Prioritas Pengembangan (mengikuti scope dokumen)

1. Auth & manajemen user/role (fondasi semua modul lain)
2. Manajemen produk, kategori, supplier
3. Manajemen cabang
4. Modul Warehouse (stocks, receipts, stock_movements) — harus selesai sebelum POS karena POS bergantung pada validasi stok
5. Modul POS (transaksi, transaksi_items) + sinkronisasi stok otomatis
6. Pelaporan (penjualan, stok, export PDF/Excel)

---

## 8. Yang TIDAK boleh dilakukan AI assistant tanpa konfirmasi

- Mengubah struktur skema database yang sudah didefinisikan di bagian 4 tanpa konfirmasi eksplisit.
- Mengganti ORM, strategi auth, atau struktur monorepo tanpa diminta.
- Membuat migration langsung ke database production/cloud MySQL tanpa konfirmasi.
- Menggabungkan logic POS dan Warehouse dalam satu service/controller — keduanya harus tetap modular meski saling terhubung.