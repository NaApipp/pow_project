-- phpMyAdmin SQL Dump
-- version 4.7.1
-- https://www.phpmyadmin.net/
--
-- Host: sql12.freesqldatabase.com
-- Generation Time: 30 Jun 2026 pada 09.09
-- Versi Server: 5.5.62-0ubuntu0.14.04.1
-- PHP Version: 7.0.33-0ubuntu0.16.04.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sql12831902`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_cabang`
--

CREATE TABLE `tb_cabang` (
  `id_cabang` int(11) NOT NULL,
  `nama_cabang` varchar(300) NOT NULL,
  `alamat` varchar(300) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_category`
--

CREATE TABLE `tb_category` (
  `id_category` int(11) NOT NULL,
  `name_category` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_products`
--

CREATE TABLE `tb_products` (
  `id_products` int(11) NOT NULL,
  `name_products` varchar(400) NOT NULL,
  `price` decimal(12,2) NOT NULL,
  `unit` varchar(300) DEFAULT NULL,
  `min_stock` int(11) DEFAULT '0',
  `id_category` int(11) DEFAULT NULL,
  `id_supplier` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_receipts`
--

CREATE TABLE `tb_receipts` (
  `id_receipts` int(11) NOT NULL,
  `id_suppliers` int(11) DEFAULT NULL,
  `id_branch` int(11) DEFAULT NULL,
  `received_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_receipts_items`
--

CREATE TABLE `tb_receipts_items` (
  `id_receipts_items` int(11) NOT NULL,
  `id_receipts` int(11) DEFAULT NULL,
  `id_products` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `price_buy` decimal(12,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_role`
--

CREATE TABLE `tb_role` (
  `id_role` int(11) NOT NULL,
  `role_name` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_stocks`
--

CREATE TABLE `tb_stocks` (
  `id_stocks` int(11) NOT NULL,
  `id_product` int(11) DEFAULT NULL,
  `id_cabang` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_stock_movements`
--

CREATE TABLE `tb_stock_movements` (
  `id_stock_move` int(11) NOT NULL,
  `id_product` int(11) DEFAULT NULL,
  `id_branch` int(11) DEFAULT NULL,
  `type` varchar(300) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `id_reference` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_suppliers`
--

CREATE TABLE `tb_suppliers` (
  `id_suppliers` int(11) NOT NULL,
  `nama_suppliers` varchar(300) NOT NULL,
  `no_hp` varchar(30) DEFAULT NULL,
  `alamat` varchar(300) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_transaksi`
--

CREATE TABLE `tb_transaksi` (
  `id_transaksi` int(11) NOT NULL,
  `id_user` int(11) DEFAULT NULL,
  `id_cabang` int(11) DEFAULT NULL,
  `payment_method` enum('tunai','debit') DEFAULT NULL,
  `total` decimal(12,2) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_transaksi_items`
--

CREATE TABLE `tb_transaksi_items` (
  `id_transaksi_items` int(11) NOT NULL,
  `id_transaksi` int(11) DEFAULT NULL,
  `id_product` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `price_at_sale` decimal(12,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_user`
--

CREATE TABLE `tb_user` (
  `id_user` int(11) NOT NULL,
  `email` varchar(300) NOT NULL,
  `password` varchar(200) NOT NULL,
  `id_role` int(11) DEFAULT NULL,
  `id_cabang` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tb_cabang`
--
ALTER TABLE `tb_cabang`
  ADD PRIMARY KEY (`id_cabang`);

--
-- Indexes for table `tb_category`
--
ALTER TABLE `tb_category`
  ADD PRIMARY KEY (`id_category`);

--
-- Indexes for table `tb_products`
--
ALTER TABLE `tb_products`
  ADD PRIMARY KEY (`id_products`),
  ADD KEY `id_category` (`id_category`),
  ADD KEY `id_supplier` (`id_supplier`);

--
-- Indexes for table `tb_receipts`
--
ALTER TABLE `tb_receipts`
  ADD PRIMARY KEY (`id_receipts`),
  ADD KEY `id_suppliers` (`id_suppliers`),
  ADD KEY `id_branch` (`id_branch`);

--
-- Indexes for table `tb_receipts_items`
--
ALTER TABLE `tb_receipts_items`
  ADD PRIMARY KEY (`id_receipts_items`),
  ADD KEY `id_receipts` (`id_receipts`),
  ADD KEY `id_products` (`id_products`);

--
-- Indexes for table `tb_role`
--
ALTER TABLE `tb_role`
  ADD PRIMARY KEY (`id_role`);

--
-- Indexes for table `tb_stocks`
--
ALTER TABLE `tb_stocks`
  ADD PRIMARY KEY (`id_stocks`),
  ADD KEY `id_product` (`id_product`),
  ADD KEY `id_cabang` (`id_cabang`);

--
-- Indexes for table `tb_stock_movements`
--
ALTER TABLE `tb_stock_movements`
  ADD PRIMARY KEY (`id_stock_move`),
  ADD KEY `id_product` (`id_product`),
  ADD KEY `id_branch` (`id_branch`);

--
-- Indexes for table `tb_suppliers`
--
ALTER TABLE `tb_suppliers`
  ADD PRIMARY KEY (`id_suppliers`);

--
-- Indexes for table `tb_transaksi`
--
ALTER TABLE `tb_transaksi`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `id_user` (`id_user`),
  ADD KEY `id_cabang` (`id_cabang`);

--
-- Indexes for table `tb_transaksi_items`
--
ALTER TABLE `tb_transaksi_items`
  ADD PRIMARY KEY (`id_transaksi_items`),
  ADD KEY `id_transaksi` (`id_transaksi`),
  ADD KEY `id_product` (`id_product`);

--
-- Indexes for table `tb_user`
--
ALTER TABLE `tb_user`
  ADD PRIMARY KEY (`id_user`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `id_role` (`id_role`),
  ADD KEY `id_cabang` (`id_cabang`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tb_cabang`
--
ALTER TABLE `tb_cabang`
  MODIFY `id_cabang` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tb_category`
--
ALTER TABLE `tb_category`
  MODIFY `id_category` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tb_products`
--
ALTER TABLE `tb_products`
  MODIFY `id_products` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tb_receipts`
--
ALTER TABLE `tb_receipts`
  MODIFY `id_receipts` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tb_receipts_items`
--
ALTER TABLE `tb_receipts_items`
  MODIFY `id_receipts_items` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tb_role`
--
ALTER TABLE `tb_role`
  MODIFY `id_role` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tb_stocks`
--
ALTER TABLE `tb_stocks`
  MODIFY `id_stocks` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tb_stock_movements`
--
ALTER TABLE `tb_stock_movements`
  MODIFY `id_stock_move` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tb_suppliers`
--
ALTER TABLE `tb_suppliers`
  MODIFY `id_suppliers` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tb_transaksi`
--
ALTER TABLE `tb_transaksi`
  MODIFY `id_transaksi` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tb_transaksi_items`
--
ALTER TABLE `tb_transaksi_items`
  MODIFY `id_transaksi_items` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tb_user`
--
ALTER TABLE `tb_user`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT;
--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `tb_products`
--
ALTER TABLE `tb_products`
  ADD CONSTRAINT `tb_products_ibfk_1` FOREIGN KEY (`id_category`) REFERENCES `tb_category` (`id_category`),
  ADD CONSTRAINT `tb_products_ibfk_2` FOREIGN KEY (`id_supplier`) REFERENCES `tb_suppliers` (`id_suppliers`);

--
-- Ketidakleluasaan untuk tabel `tb_receipts`
--
ALTER TABLE `tb_receipts`
  ADD CONSTRAINT `tb_receipts_ibfk_1` FOREIGN KEY (`id_suppliers`) REFERENCES `tb_suppliers` (`id_suppliers`),
  ADD CONSTRAINT `tb_receipts_ibfk_2` FOREIGN KEY (`id_branch`) REFERENCES `tb_cabang` (`id_cabang`);

--
-- Ketidakleluasaan untuk tabel `tb_receipts_items`
--
ALTER TABLE `tb_receipts_items`
  ADD CONSTRAINT `tb_receipts_items_ibfk_1` FOREIGN KEY (`id_receipts`) REFERENCES `tb_receipts` (`id_receipts`),
  ADD CONSTRAINT `tb_receipts_items_ibfk_2` FOREIGN KEY (`id_products`) REFERENCES `tb_products` (`id_products`);

--
-- Ketidakleluasaan untuk tabel `tb_stocks`
--
ALTER TABLE `tb_stocks`
  ADD CONSTRAINT `tb_stocks_ibfk_1` FOREIGN KEY (`id_product`) REFERENCES `tb_products` (`id_products`),
  ADD CONSTRAINT `tb_stocks_ibfk_2` FOREIGN KEY (`id_cabang`) REFERENCES `tb_cabang` (`id_cabang`);

--
-- Ketidakleluasaan untuk tabel `tb_stock_movements`
--
ALTER TABLE `tb_stock_movements`
  ADD CONSTRAINT `tb_stock_movements_ibfk_1` FOREIGN KEY (`id_product`) REFERENCES `tb_products` (`id_products`),
  ADD CONSTRAINT `tb_stock_movements_ibfk_2` FOREIGN KEY (`id_branch`) REFERENCES `tb_cabang` (`id_cabang`);

--
-- Ketidakleluasaan untuk tabel `tb_transaksi`
--
ALTER TABLE `tb_transaksi`
  ADD CONSTRAINT `tb_transaksi_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `tb_user` (`id_user`),
  ADD CONSTRAINT `tb_transaksi_ibfk_2` FOREIGN KEY (`id_cabang`) REFERENCES `tb_cabang` (`id_cabang`);

--
-- Ketidakleluasaan untuk tabel `tb_transaksi_items`
--
ALTER TABLE `tb_transaksi_items`
  ADD CONSTRAINT `tb_transaksi_items_ibfk_1` FOREIGN KEY (`id_transaksi`) REFERENCES `tb_transaksi` (`id_transaksi`),
  ADD CONSTRAINT `tb_transaksi_items_ibfk_2` FOREIGN KEY (`id_product`) REFERENCES `tb_products` (`id_products`);

--
-- Ketidakleluasaan untuk tabel `tb_user`
--
ALTER TABLE `tb_user`
  ADD CONSTRAINT `tb_user_ibfk_1` FOREIGN KEY (`id_role`) REFERENCES `tb_role` (`id_role`),
  ADD CONSTRAINT `tb_user_ibfk_2` FOREIGN KEY (`id_cabang`) REFERENCES `tb_cabang` (`id_cabang`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
