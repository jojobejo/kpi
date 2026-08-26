# Dokumentasi Development Migrasi KPI User 29 ke 171

Tanggal: 2026-08-26

## Tujuan

Menyiapkan migrasi data KPI aktif dari user sumber `id_user = 29` ke user target `id_user = 171` pada aplikasi KPI Digital.

## Hasil scanning project

Project menggunakan PHP native dengan router utama `router.php`.

Route module KPI yang relevan:

- `home-kpi-real` -> `app/dashboard/home-kpi-real.php`
- `home-kpi-simulasi` -> `app/dashboard/home-kpi-simulasi.php`
- `detail-kpi-real` -> `app/dashboard/detail-kpi-real.php`
- `detail-kpi-simulasi` -> `app/dashboard/detail-kpi-simulasi.php`
- `kpianggota` -> `app/kpi/kpianggota.php`
- `kpidepartemen` -> `app/kpi/kpidepartemen.php`
- `kpidetailanggota` -> `app/kpi/kpidetailanggota.php`
- `kpidirektur` -> `app/kpi/kpidirektur.php`
- `kpikabag` -> `app/kpi/kpikabag.php`
- `kpikadep` -> `app/kpi/kpikadep.php`

Helper yang relevan:

- `helper/config.php`
- `helper/getUser.php`
- `helper/getKPI.php`
- `helper/getKPI_sim.php`
- `helper/getWhat.php`
- `helper/getHow.php`
- `helper/kpi_lock_functions.php`

## Alur data KPI

Module KPI memakai `tb_users.id` sebagai `id_user`.

KPI real:

- Header bobot KPI user disimpan di `tb_bobotkpi`.
- Kategori/poin KPI utama disimpan di `tb_kpi`.
- Detail What disimpan di `tb_whats` dan mengarah ke `tb_kpi.id`.
- Detail How disimpan di `tb_hows` dan mengarah ke `tb_kpi.id`.
- Indikator What disimpan di `tb_indikator_whats` dan mengarah ke `tb_whats.id_what`.
- Indikator How disimpan di `tb_indikator_hows` dan mengarah ke `tb_hows.id_how`.

KPI simulasi:

- Struktur sama, tetapi memakai prefix `tbsim_`.

## Keputusan implementasi

Migrasi dibuat sebagai SQL insert-copy transaksional, bukan perubahan kode aplikasi.

File migrasi:

- `db_migrasi/2026-08-26_migrasi_copy_kpi_user_29_to_171.sql`
- `db_migrasi/2026-08-26_rollback_copy_kpi_user_29_to_171.sql`

Data yang disalin:

- KPI real aktif.
- KPI simulasi aktif.
- Bobot KPI real dan simulasi.
- What/How beserta indikator anaknya.
- Nilai, hasil, total, target omset, dan metadata edit yang berada pada tabel aktif.

Data yang tidak disalin:

- `tb_kpi_history`
- `tb_kpi_verified`
- `tb_eviden`
- tabel archive

Alasan: tabel tersebut adalah riwayat/verifikasi/bukti masa lalu, bukan struktur KPI aktif yang diminta untuk ditambahkan ke user target.

## Cara menjalankan

Disarankan backup database terlebih dahulu.

Jalankan migrasi:

```bash
C:\xampp\mysql\bin\mysql.exe -uroot < C:\xampp\htdocs\kpi\db_migrasi\2026-08-26_migrasi_copy_kpi_user_29_to_171.sql
```

Jika perlu rollback:

```bash
C:\xampp\mysql\bin\mysql.exe -uroot < C:\xampp\htdocs\kpi\db_migrasi\2026-08-26_rollback_copy_kpi_user_29_to_171.sql
```

Jika menjalankan dari PowerShell, gunakan pola ini karena PowerShell tidak memakai operator `<` seperti cmd:

```powershell
Get-Content C:\xampp\htdocs\kpi\db_migrasi\2026-08-26_migrasi_copy_kpi_user_29_to_171.sql | & C:\xampp\mysql\bin\mysql.exe -uroot
```

## Validasi aplikasi

Setelah SQL dijalankan:

- Login sebagai user target `id_user = 171`.
- Buka `detail-kpi-real` dan pastikan data KPI real muncul.
- Buka `detail-kpi-simulasi` dan pastikan data KPI simulasi muncul.
- Cek halaman dashboard/summary agar bobot What dan How terbaca.

## Catatan

Tidak ada perubahan file aplikasi PHP.

Validasi SQL dilakukan pada database test hasil import dump. Dump `kiucoid_kpi.sql` belum memuat `tb_users.id = 171`, sehingga guard migrasi terbukti menghentikan eksekusi jika target user belum tersedia. Pada database aktif lokal `kiucoid_kpi`, user 171 tersedia.
