# Dokumentasi Database Migrasi KPI User 29 ke 171

Tanggal: 2026-08-26

## Database

Database aktif dari `helper/config.php`:

- Host: `localhost`
- User: `root`
- Database: `kiucoid_kpi`

Dump referensi yang discan:

- `kiucoid_kpi.sql`

## Identitas user

Hasil validasi pada database aktif lokal `kiucoid_kpi`.`tb_users`:

| id | username | nama_lngkp | jabatan | departement |
| --- | --- | --- | --- | --- |
| 29 | prayoga | Anang Prayoga | Karyawan | IT |
| 171 | Al | Ahmad Lutfi Farizi | Karyawan | IT |

Catatan validasi dump: file `kiucoid_kpi.sql` berisi user sampai `MAX(id) = 170`, sehingga `tb_users.id = 171` belum ada jika dump di-import apa adanya. Script migrasi tetap aman karena akan berhenti dengan pesan error jika target user belum tersedia.

## Tabel migrasi

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

## Jumlah data sumber id_user 29

| tabel | rows |
| --- | ---: |
| tb_bobotkpi | 1 |
| tb_kpi | 5 |
| tb_whats | 9 |
| tb_hows | 14 |
| tb_indikator_whats | 54 |
| tb_indikator_hows | 75 |
| tbsim_bobotkpi | 1 |
| tbsim_kpi | 5 |
| tbsim_whats | 10 |
| tbsim_hows | 15 |
| tbsim_indikator_whats | 61 |
| tbsim_indikator_hows | 81 |

## Jumlah data target id_user 171 sebelum migrasi

| tabel | rows |
| --- | ---: |
| tb_bobotkpi | 0 |
| tb_kpi | 0 |
| tb_whats | 0 |
| tb_hows | 0 |
| tbsim_bobotkpi | 0 |
| tbsim_kpi | 0 |
| tbsim_whats | 0 |
| tbsim_hows | 0 |

## Strategi migrasi

Primary key auto increment tidak disalin langsung.

SQL migrasi membuat mapping sementara:

- `tb_kpi.id` sumber dipetakan ke `tb_kpi.id` baru milik target.
- `tb_whats.id_what` sumber dipetakan ke `tb_whats.id_what` baru milik target.
- `tb_hows.id_how` sumber dipetakan ke `tb_hows.id_how` baru milik target.
- Strategi yang sama dipakai untuk tabel `tbsim_`.

Dengan cara ini, relasi anak ke indikator tetap benar setelah data masuk ke user 171.

## Guard migrasi

Script migrasi akan berhenti jika:

- `tb_users.id = 29` tidak ada.
- `tb_users.id = 171` tidak ada.
- user target `id_user = 171` sudah memiliki data pada tabel KPI aktif real atau simulasi.

## Perubahan schema

Tidak ada perubahan schema database.

Tidak ada `ALTER TABLE`, `CREATE TABLE` permanen, atau perubahan struktur kolom. Temporary table dan temporary stored procedure hanya dipakai selama eksekusi migrasi.

## Validasi teknis

SQL migrasi diuji pada database sementara dari dump `kiucoid_kpi.sql`. Karena dump belum memiliki `tb_users.id = 171`, pengujian pertama berhenti sesuai guard. Setelah user 171 dummy ditambahkan hanya di database test, migrasi berhasil dengan hasil:

| tabel | rows target 171 |
| --- | ---: |
| tb_bobotkpi | 1 |
| tb_kpi | 5 |
| tb_whats | 9 |
| tb_hows | 14 |
| tb_indikator_whats | 54 |
| tb_indikator_hows | 75 |
| tbsim_bobotkpi | 1 |
| tbsim_kpi | 5 |
| tbsim_whats | 10 |
| tbsim_hows | 15 |
| tbsim_indikator_whats | 61 |
| tbsim_indikator_hows | 81 |

Cek orphan relasi hasil migrasi:

| cek | total |
| --- | ---: |
| real_orphan_whats | 0 |
| real_orphan_hows | 0 |
| real_orphan_indikator_whats | 0 |
| real_orphan_indikator_hows | 0 |
| sim_orphan_whats | 0 |
| sim_orphan_hows | 0 |
| sim_orphan_indikator_whats | 0 |
| sim_orphan_indikator_hows | 0 |

Rollback juga diuji pada database sementara dan seluruh tabel target 171 kembali `0` baris.

## File SQL

- Migrasi: `db_migrasi/2026-08-26_migrasi_copy_kpi_user_29_to_171.sql`
- Rollback: `db_migrasi/2026-08-26_rollback_copy_kpi_user_29_to_171.sql`

## Query verifikasi setelah migrasi

```sql
SELECT 'tb_bobotkpi' AS tabel, COUNT(*) AS rows_target_171 FROM tb_bobotkpi WHERE id_user = 171
UNION ALL SELECT 'tb_kpi', COUNT(*) FROM tb_kpi WHERE id_user = 171
UNION ALL SELECT 'tb_whats', COUNT(*) FROM tb_whats WHERE id_user = 171
UNION ALL SELECT 'tb_hows', COUNT(*) FROM tb_hows WHERE id_user = 171
UNION ALL SELECT 'tb_indikator_whats', COUNT(*) FROM tb_indikator_whats iw INNER JOIN tb_whats w ON w.id_what = iw.id_what WHERE w.id_user = 171
UNION ALL SELECT 'tb_indikator_hows', COUNT(*) FROM tb_indikator_hows ih INNER JOIN tb_hows h ON h.id_how = ih.id_how WHERE h.id_user = 171
UNION ALL SELECT 'tbsim_bobotkpi', COUNT(*) FROM tbsim_bobotkpi WHERE id_user = 171
UNION ALL SELECT 'tbsim_kpi', COUNT(*) FROM tbsim_kpi WHERE id_user = 171
UNION ALL SELECT 'tbsim_whats', COUNT(*) FROM tbsim_whats WHERE id_user = 171
UNION ALL SELECT 'tbsim_hows', COUNT(*) FROM tbsim_hows WHERE id_user = 171
UNION ALL SELECT 'tbsim_indikator_whats', COUNT(*) FROM tbsim_indikator_whats iw INNER JOIN tbsim_whats w ON w.id_what = iw.id_what WHERE w.id_user = 171
UNION ALL SELECT 'tbsim_indikator_hows', COUNT(*) FROM tbsim_indikator_hows ih INNER JOIN tbsim_hows h ON h.id_how = ih.id_how WHERE h.id_user = 171;
```
