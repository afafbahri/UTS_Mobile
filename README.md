# PageUp — Aplikasi Katalog Buku Digital

## Deskripsi Aplikasi
**PageUp** adalah aplikasi katalog buku digital berbasis **Flutter** yang dirancang untuk memudahkan pengguna dalam menelusuri, mencari, dan menyimpan daftar buku bacaan mereka.  
Aplikasi ini menerapkan konsep **penyimpanan data lokal (SharedPreferences)**, **navigasi antarhalaman**, serta **pengelolaan state sederhana** dalam Flutter.  
Setiap pengguna dapat **melakukan registrasi dan login**, lalu mengakses koleksi buku, mencari buku berdasarkan kategori, serta menyimpan buku yang disukai ke dalam **wishlist pribadi**.

---

## Tujuan Pengembangan
- Menyediakan media literasi digital yang interaktif dan menarik.  
- Menerapkan konsep dasar pengembangan aplikasi mobile menggunakan Flutter.  
- Melatih penggunaan **widget dasar**, **navigasi**, dan **penyimpanan lokal** dalam konteks aplikasi nyata.  
- Menumbuhkan minat baca melalui tampilan modern dan pengalaman pengguna yang menyenangkan.

---

## Struktur Halaman dan Fungsinya

| Halaman | Nama File | Deskripsi |
|----------|------------|-----------|
| **Login Page** | `login_page.dart` | Halaman untuk pengguna masuk ke aplikasi. Data login diverifikasi dari data lokal (SharedPreferences). |
| **Register Page** | `register_page.dart` | Halaman untuk membuat akun baru. Data disimpan secara lokal menggunakan SharedPreferences. |
| **Home Page** | `home_page.dart` | Menampilkan daftar buku trending, dan seluruh buku dalam bentuk grid. |
| **Explore Page** | `explore_page.dart` | Halaman untuk mencari buku berdasarkan judul, penulis, atau kategori. |
| **Wishlist Page** | `wishlist_page.dart` | Menampilkan daftar buku yang telah disimpan oleh pengguna. Data tersimpan secara lokal per akun pengguna. |
| **Book Detail Page** | `book_detail_page.dart` | Menampilkan detail buku terpilih (judul, penulis, kategori, deskripsi). |

---

## Fitur Utama

- **Autentikasi Lokal** — Registrasi dan login menggunakan SharedPreferences tanpa database eksternal.  
- **Wishlist Pribadi** — Buku yang ditandai dengan ikon bookmark akan tersimpan untuk tiap pengguna.  
- **Pencarian Buku** — Pengguna dapat mencari buku berdasarkan judul, penulis, atau kategori.  
- **Antarmuka Modern** — Menggunakan warna utama biru lembut dan navy dengan desain yang sederhana dan elegan.  
- **Penyimpanan Lokal Per Pengguna** — Data wishlist disimpan terpisah berdasarkan akun pengguna (misalnya `wishlist_email@example.com`).  

---

## Cara Menjalankan Aplikasi

1. **Login / Register**  
   - Pengguna baru tekan **Register** untuk membuat akun (nama, email, password).  
   - Setelah berhasil, muncul pop-up konfirmasi, lalu bisa login ke aplikasi.  

2. **Home Page**  
   - Menampilkan sapaan “Halo, [Nama Pengguna] 👋”, daftar **Trending Books**, dan **All Books**.  
   - Ketuk buku untuk melihat detail atau tekan ikon **bookmark** untuk menambah ke wishlist.  

3. **Explore Page**  
   - Cari buku berdasarkan judul, penulis, atau kategori.  
   - Buku bisa langsung ditambahkan ke wishlist dari halaman ini.  

4. **Wishlist Page**  
   - Menampilkan daftar buku favorit pengguna.  
   - Buku dapat dihapus dari wishlist atau dilihat detailnya.  

5. **Logout**  
   - Tekan ikon **Logout** di kanan atas halaman Home untuk keluar dari akun.  
   - Data wishlist tetap tersimpan dan akan muncul lagi saat login ulang.  

git clone https://github.com/username/PageUp.git
cd PageUp
