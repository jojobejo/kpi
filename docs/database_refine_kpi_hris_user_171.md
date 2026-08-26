# Dokumentasi Database Penyempurnaan KPI Karisma HRIS User 171

Tanggal: 2026-08-26

## Database

Database aktif dari `helper/config.php`:

| Item | Nilai |
| --- | --- |
| Host | localhost |
| User | root |
| Database | kiucoid_kpi |

## Target Data

Perubahan dilakukan untuk:

| id_user | username | nama_lngkp | jabatan | departement |
| ---: | --- | --- | --- | --- |
| 171 | Al | Ahmad Lutfi Farizi | Karyawan | IT |

## Tabel Yang Diubah

KPI real:

- `tb_bobotkpi`
- `tb_kpi`
- `tb_whats`
- `tb_hows`
- `tb_indikator_whats`
- `tb_indikator_hows`

KPI simulasi:

- `tbsim_bobotkpi`
- `tbsim_kpi`
- `tbsim_whats`
- `tbsim_hows`
- `tbsim_indikator_whats`
- `tbsim_indikator_hows`

## Strategi Perubahan

Master KPI aktif user `171` direinsert supaya urutan tampil mengikuti prioritas bobot dari user:

1. KARISMA - HRIS (HUMAN RESOURCE INFORMATION SYSTEM)
2. Support KarismaERP
3. Stabilitas & Performa aplikasi
4. Pemeliharaan Sistem
5. Absensi
6. Supporting maintenance hardware

Alasan reinsert:

- Tabel `tb_kpi` dan `tbsim_kpi` tidak memiliki kolom urutan.
- Banyak halaman mengambil data KPI berdasarkan urutan primary key/insertion order.
- Data evidence, history, verified, dan archive user `171` tervalidasi kosong sebelum reinsert.

## Guard Script

Skrip berhenti otomatis jika:

- User `171` dengan username `Al` dan departement `IT` tidak ditemukan tepat satu baris.
- User `171` sudah memiliki data pada `tb_kpi_history`.
- User `171` sudah memiliki data pada `tb_eviden`.
- Total bobot kategori WHAT/HOW tidak sama dengan `100`.
- Total bobot detail WHAT/HOW per kategori tidak sama dengan `100`.

## Backup

Backup penuh database sebelum perubahan:

```text
C:\xampp\htdocs\kpi\db_migrasi\2026-08-26_backup_before_refine_kpi_hris_user_171.sql
```

Ukuran backup hasil `mysqldump`: sekitar 32 MB.

## Cara Eksekusi

Skrip yang sudah dijalankan:

```powershell
Get-Content C:\xampp\htdocs\kpi\db_migrasi\2026-08-26_refine_kpi_hris_user_171.sql | & C:\xampp\mysql\bin\mysql.exe -uroot
```

## Cara Rollback

Rollback paling aman adalah restore database dari backup penuh sebelum perubahan:

```powershell
Get-Content C:\xampp\htdocs\kpi\db_migrasi\2026-08-26_backup_before_refine_kpi_hris_user_171.sql | & C:\xampp\mysql\bin\mysql.exe -uroot kiucoid_kpi
```

Catatan: perintah rollback di atas mengembalikan database ke kondisi saat backup dibuat. Jika ada perubahan lain setelah backup, review dahulu sebelum restore penuh.

## Hasil Setelah Perubahan

Validasi kategori KPI real:

| Cek | Rows | Total WHAT | Total HOW |
| --- | ---: | ---: | ---: |
| `tb_kpi` user 171 | 6 | 100 | 100 |

Validasi kategori KPI simulasi:

| Cek | Rows | Total WHAT | Total HOW |
| --- | ---: | ---: | ---: |
| `tbsim_kpi` user 171 | 6 | 100 | 100 |

Validasi jumlah detail:

| Tabel | Jumlah |
| --- | ---: |
| `tb_whats` | 24 |
| `tb_hows` | 25 |
| `tb_indikator_whats` | 120 |
| `tb_indikator_hows` | 125 |
| `tbsim_whats` | 24 |
| `tbsim_hows` | 25 |
| `tbsim_indikator_whats` | 120 |
| `tbsim_indikator_hows` | 125 |

Validasi bobot detail real:

| Kategori | WHAT rows | WHAT bobot | HOW rows | HOW bobot |
| --- | ---: | ---: | ---: | ---: |
| KARISMA - HRIS (HUMAN RESOURCE INFORMATION SYSTEM) | 5 | 100 | 5 | 100 |
| Support KarismaERP | 4 | 100 | 4 | 100 |
| Stabilitas & Performa aplikasi | 4 | 100 | 4 | 100 |
| Pemeliharaan Sistem | 4 | 100 | 4 | 100 |
| Absensi | 3 | 100 | 4 | 100 |
| Supporting maintenance hardware | 4 | 100 | 4 | 100 |

Validasi detail tanpa indikator:

| Cek | Total |
| --- | ---: |
| `real_what_without_indicator` | 0 |
| `real_how_without_indicator` | 0 |
| `sim_what_without_indicator` | 0 |
| `sim_how_without_indicator` | 0 |

## Perubahan Schema

Tidak ada perubahan schema database.

Tidak ada `ALTER TABLE`, `CREATE TABLE` permanen, perubahan tipe kolom, index baru, atau tabel baru di database aplikasi. Perubahan hanya pada isi master data KPI user `171`.
