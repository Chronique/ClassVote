# 🗳️ ClassVote & SMP21 On-Chain Voting

Repository ini berisi kumpulan Smart Contract dan antarmuka aplikasi voting desentralisasi yang dibangun di atas jaringan **Base**. Proyek ini dirancang untuk memfasilitasi pemilihan transparan, adil, dan efisien di lingkungan sekolah, seperti pemilihan Ketua Kelas atau Ketua OSIS.

## 🚀 Fitur Utama

- **Gasless Transactions**: Menggunakan **Base Paymaster** sehingga pemilih (murid) tidak perlu memiliki saldo ETH untuk memberikan suara. Biaya gas ditanggung oleh sekolah.
- **Dynamic Poll Title**: Judul pemilihan (misal: "Ketua Kelas" atau "Ketua OSIS") dapat diubah secara dinamis oleh Admin tanpa deploy ulang kontrak.
- **Multiple Admin Support**: Mendukung banyak akun Admin (Guru, Kepsek, Panitia) yang didaftarkan langsung melalui *constructor* atau fungsi tambahan.
- **Recyclable Sessions (Poll ID)**: Sistem menggunakan ID Sesi unik, memungkinkan satu kontrak digunakan berkali-kali untuk berbagai jenis pemilihan tanpa menghapus daftar murid (*whitelist*).
- **Transparent & Immutable**: Semua hasil suara tercatat permanen di blockchain Base, mencegah manipulasi data.
- **Base Builder Integrated**: Mendukung ekosistem Base dengan menyertakan *Builder Code* pada setiap transaksi.

## 📜 Smart Contracts

Terdapat dua kontrak utama dalam repository ini:

1.  **`contracts/ClassVote.sol`**: Versi awal untuk pemungutan suara sederhana.
2.  **`contracts/SMP21Voting.sol`**: Versi terbaru yang dioptimalkan untuk SMP 21 dengan fitur Admin tambahan, judul dinamis, dan manajemen sesi pemilihan.

## 🛠️ Teknologi yang Digunakan

- **Solidity**: Bahasa pemrograman untuk Smart Contract.
- **Base Network**: Jaringan Layer 2 Ethereum yang cepat dan murah.
- **Wagmi & Viem**: Library untuk interaksi blockchain di sisi frontend.
- **React & Next.js**: Framework untuk antarmuka pengguna (UI).
- **Framer Motion**: Untuk animasi UI yang halus dan modern.
- **Material Design 3 (M3)**: Standar desain ikon dan komponen.

## ⚙️ Cara Penggunaan

### Tambah Kandidat
Admin dapat memasukkan nama dan URL foto kandidat (mendukung link Google Drive yang sudah dikonversi menjadi *direct link*).

### Manajemen Murid
Alamat dompet murid dimasukkan ke dalam *whitelist* agar memiliki hak suara. Daftar ini tetap tersimpan meskipun sesi pemilihan di-reset.

### Reset Pemilihan
Admin memiliki dua opsi reset:
- **Reset Polling**: Menghapus hasil suara dan kandidat untuk memulai sesi baru, namun **menyimpan** daftar murid.
- **Reset Total**: Menghapus seluruh data termasuk daftar murid.

## 🏗️ Developer Info

Proyek ini mendukung ekosistem Base.
- **Builder Code**: `bc_vghq983e`

---
Dibuat dengan ❤️ untuk kemajuan digitalisasi pendidikan di **SMP Negeri 21 Kota Jambi**.
