# Migrasi Insert KPI IT Software User 171

Tanggal eksekusi: 2026-08-27

## Scope

Migrasi ini mengisi KPI individual IT Software untuk:

| Kolom | Nilai |
| --- | --- |
| `tb_users.id` | `171` |
| `username` | `Al` |
| `nama_lngkp` | `Ahmad Lutfi Farizi` |
| `bagian` | `MT IT SOFTWARE` |
| `departement` | `IT` |
| `jabatan` | `Karyawan` |

Tabel yang diisi:

- KPI real: `tb_bobotkpi`, `tb_kpi`, `tb_whats`, `tb_hows`, `tb_indikator_whats`, `tb_indikator_hows`
- KPI simulasi: `tbsim_bobotkpi`, `tbsim_kpi`, `tbsim_whats`, `tbsim_hows`, `tbsim_indikator_whats`, `tbsim_indikator_hows`

Tidak ada perubahan struktur tabel.

## File Yang Dibuat

| File | Fungsi |
| --- | --- |
| `db_migrasi/migration_kpi_itsoftware_user_171.sql` | Insert migrasi KPI real dan simulasi user 171 |
| `db_migrasi/rollback_kpi_itsoftware_user_171.sql` | Tahap 4 rollback, mengembalikan KPI user 171 ke kondisi kosong sebelum migrasi |
| `db_migrasi/verify_kpi_itsoftware_user_171.sql` | Query verifikasi struktur KPI setelah migrasi |

Catatan teknis: rancangan pertama memakai stored procedure, tetapi MariaDB lokal menolak `CREATE PROCEDURE` karena tabel sistem `mysql.proc` belum di-upgrade. File migrasi dan rollback kemudian diubah menjadi pure SQL dengan `START TRANSACTION`, temporary target tables, dan assertion guard berbasis temporary table `NOT NULL`.

## Backup Sebelum Migrasi

Backup khusus user `171` dari tahap 3:

```text
db_migrasi/2026-08-26_backup_kpi_user_171_tahap_3.sql
```

Backup tersebut tidak berisi `INSERT` karena database live sebelum migrasi tidak memiliki data KPI real maupun simulasi untuk user `171`.

## Strategi Migrasi

Karena data KPI existing user `171` kosong:

1. Script menghapus data KPI user `171` pada tabel scope secara terbatas sebagai guard idempotent.
2. Script membuat target KPI real dari temporary target tables.
3. Script menyalin struktur KPI real ke KPI simulasi dengan mapping ID baru, tidak menganggap primary key real dan simulasi sama.
4. Script melakukan validasi sebelum `COMMIT`.

Bobot global `tb_bobotkpi` dan `tbsim_bobotkpi` diisi:

| Komponen | Bobot |
| --- | ---: |
| WHAT | 60 |
| HOW | 40 |

## Bobot KPI Utama

| KPI | Bobot |
| --- | ---: |
| Pembuatan dan Pengembangan KARISMA HRIS | 40 |
| Pengembangan & Support KarismaERP | 20 |
| Stabilitas & Performa Aplikasi | 15 |
| Pemeliharaan Sistem | 10 |
| Kehadiran & Kedisiplinan Kerja | 10 |
| Bantuan Perbaikan Perangkat Kerja | 5 |
| Total | 100 |

## Hasil Eksekusi

Command yang dijalankan:

```bash
mysql -uroot kiucoid_kpi < db_migrasi/migration_kpi_itsoftware_user_171.sql
```

Status:

```text
migration_kpi_itsoftware_user_171.sql selesai
```

## Hasil Validasi Ringkas

KPI utama:

| Scope | KPI | Total bobot WHAT | Total bobot HOW |
| --- | ---: | ---: | ---: |
| REAL | 6 | 100 | 100 |
| SIM | 6 | 100 | 100 |

Jumlah detail:

| Scope | WHAT | HOW | Indikator WHAT | Indikator HOW |
| --- | ---: | ---: | ---: | ---: |
| REAL | 12 | 20 | 96 | 160 |
| SIM | 12 | 20 | 96 | 160 |

Validasi bobot internal:

| Scope | WHAT internal | HOW internal |
| --- | --- | --- |
| REAL | Semua KPI = 100 | Semua KPI = 100 |
| SIM | Semua KPI = 100 | Semua KPI = 100 |

Validasi relasi dan duplicate:

| Scope | WHAT tanpa KPI | HOW tanpa KPI | Duplicate KPI | Duplicate WHAT | Duplicate HOW |
| --- | ---: | ---: | ---: | ---: | ---: |
| REAL | 0 | 0 | 0 | 0 | 0 |
| SIM | 0 | 0 | 0 | 0 | 0 |

## ID Hasil Migrasi

KPI real:

| ID | KPI | Bobot | WHAT | HOW |
| ---: | --- | ---: | ---: | ---: |
| 808 | Pembuatan dan Pengembangan KARISMA HRIS | 40 | 3 | 4 |
| 809 | Pengembangan & Support KarismaERP | 20 | 3 | 4 |
| 810 | Stabilitas & Performa Aplikasi | 15 | 2 | 3 |
| 811 | Pemeliharaan Sistem | 10 | 2 | 3 |
| 812 | Kehadiran & Kedisiplinan Kerja | 10 | 1 | 4 |
| 813 | Bantuan Perbaikan Perangkat Kerja | 5 | 1 | 2 |

KPI simulasi:

| ID | KPI | Bobot | WHAT | HOW |
| ---: | --- | ---: | ---: | ---: |
| 1348 | Pembuatan dan Pengembangan KARISMA HRIS | 40 | 3 | 4 |
| 1349 | Pengembangan & Support KarismaERP | 20 | 3 | 4 |
| 1350 | Stabilitas & Performa Aplikasi | 15 | 2 | 3 |
| 1351 | Pemeliharaan Sistem | 10 | 2 | 3 |
| 1352 | Kehadiran & Kedisiplinan Kerja | 10 | 1 | 4 |
| 1353 | Bantuan Perbaikan Perangkat Kerja | 5 | 1 | 2 |

## Rollback

Rollback tahap 4 tersedia di:

```text
db_migrasi/rollback_kpi_itsoftware_user_171.sql
```

Rollback hanya menghapus data KPI user `171` pada tabel scope dan mengembalikan kondisi sesuai backup tahap 3, yaitu kosong. Rollback tidak dijalankan setelah migrasi karena migrasi dan verifikasi berhasil.

## Verification

Verification file:

```text
db_migrasi/verify_kpi_itsoftware_user_171.sql
```

Command yang dijalankan:

```bash
mysql -uroot kiucoid_kpi < db_migrasi/verify_kpi_itsoftware_user_171.sql
```

Verification menampilkan user, bobot global, summary KPI, detail KPI, seluruh WHAT beserta indikator, seluruh HOW beserta indikator, count validation, orphan validation, dan duplicate validation.
