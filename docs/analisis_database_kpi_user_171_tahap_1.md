# Analisis Database KPI User 171 - Tahap 1

Tanggal: 2026-08-26

## Scope Tahap 1

Tahap ini hanya melakukan analisis struktur database dan pemakaian tabel KPI di aplikasi.

Tidak ada query `INSERT`, `UPDATE`, atau `DELETE` yang dijalankan untuk data KPI user `171`.

Database aktif dibaca dari `helper/config.php`:

| Item | Nilai |
| --- | --- |
| Host | `localhost` |
| User | `root` |
| Database | `kiucoid_kpi` |

## Sumber Verifikasi

Struktur tabel diverifikasi langsung dari MySQL lokal dengan `SHOW CREATE TABLE` pada:

- `tb_bobotkpi`
- `tb_kpi`
- `tb_whats`
- `tb_hows`
- `tb_indikator_whats`
- `tb_indikator_hows`
- `tbsim_bobotkpi`
- `tbsim_kpi`
- `tbsim_whats`
- `tbsim_hows`
- `tbsim_indikator_whats`
- `tbsim_indikator_hows`

Cross-check tambahan dilakukan melalui `information_schema.COLUMNS`, `information_schema.TABLE_CONSTRAINTS`, `information_schema.KEY_COLUMN_USAGE`, dan `SHOW INDEX`.

## Ringkasan Struktur KPI Real

### `tb_bobotkpi`

| Kolom | Tipe | Keterangan |
| --- | --- | --- |
| `idbobotkpi` | `int(11)` auto increment | Primary key |
| `id_user` | `int(11)` | Kolom user |
| `bobotwhat` | `int(11)` | Bobot global WHAT |
| `bobothow` | `int(11)` | Bobot global HOW |

### `tb_kpi`

| Kolom | Tipe | Keterangan |
| --- | --- | --- |
| `id` | `int(11)` auto increment | Primary key, dipakai sebagai `id_kpi` oleh detail |
| `id_user` | `int(11)` | Kolom user |
| `poin` | `text` | Nama/deskripsi KPI untuk WHAT |
| `bobot` | `double` | Bobot utama WHAT |
| `poin2` | `text` | Nama/deskripsi KPI untuk HOW |
| `bobot2` | `double` | Bobot utama HOW |

### `tb_whats`

| Kolom | Tipe | Keterangan |
| --- | --- | --- |
| `id_what` | `int(11)` auto increment | Primary key |
| `id_user` | `int(11)` | Kolom user |
| `id_kpi` | `int(11)` | Relasi logis ke `tb_kpi.id` |
| `tipe_what` | `enum('A','B')` default `A` | Tipe penilaian: indikator atau target angka |
| `p_what` | `text` | Isi WHAT |
| `bobot` | `double` | Bobot internal WHAT |
| `target_omset` | `decimal(15,2)` default `0.00` | Target numerik untuk tipe `B` |
| `hasil` | `text` nullable | Hasil/keterangan nilai |
| `nilai` | `double` | Nilai penilaian |
| `total` | `double` | `nilai * bobot / 100` |
| `is_edited` | `tinyint(1)` default `0` | Tracking edit atasan |
| `edited_by` | `int(11)` nullable | User pengubah |
| `edited_at` | `timestamp` nullable | Waktu edit |
| `original_*` | beberapa kolom | Snapshot nilai awal sebelum edit atasan |

### `tb_hows`

Strukturnya sejajar dengan `tb_whats`, dengan perbedaan nama kolom utama:

| Kolom | Tipe | Keterangan |
| --- | --- | --- |
| `id_how` | `int(11)` auto increment | Primary key |
| `id_user` | `int(11)` | Kolom user |
| `id_kpi` | `int(11)` | Relasi logis ke `tb_kpi.id` |
| `tipe_how` | `enum('A','B')` default `A` | Tipe penilaian |
| `p_how` | `text` | Isi HOW |
| `bobot` | `double` | Bobot internal HOW |
| `target_omset` | `decimal(15,2)` default `0.00` | Target numerik untuk tipe `B` |
| `hasil` | `text` nullable | Hasil/keterangan nilai |
| `nilai` | `double` | Nilai penilaian |
| `total` | `double` | `nilai * bobot / 100` |
| `is_edited`, `edited_by`, `edited_at`, `original_*` | tracking edit | Hanya ada di tabel real |

### `tb_indikator_whats`

| Kolom | Tipe | Keterangan |
| --- | --- | --- |
| `id_indikator` | `int(11)` auto increment | Primary key |
| `id_what` | `int(11)` | Relasi logis ke `tb_whats.id_what` |
| `keterangan` | `text` | Label indikator |
| `nilai` | `decimal(5,2)` | Nilai indikator |
| `urutan` | `int(11)` default `1` | Urutan tampil |
| `created_at` | `timestamp` default `current_timestamp()` | Waktu pembuatan |
| `is_edited`, `edited_by`, `edited_at`, `original_*` | tracking edit | Hanya ada di tabel real |

### `tb_indikator_hows`

| Kolom | Tipe | Keterangan |
| --- | --- | --- |
| `id_indikator` | `int(11)` auto increment | Primary key |
| `id_how` | `int(11)` | Relasi logis ke `tb_hows.id_how` |
| `keterangan` | `text` | Label indikator |
| `nilai` | `decimal(5,2)` | Nilai indikator |
| `urutan` | `int(11)` default `1` | Urutan tampil |
| `created_at` | `timestamp` default `current_timestamp()` | Waktu pembuatan |
| `is_edited`, `edited_by`, `edited_at`, `original_*` | tracking edit | Hanya ada di tabel real |

## Ringkasan Struktur KPI Simulasi

Tabel simulasi memakai pola nama dan relasi yang sama dengan tabel real:

| Tabel simulasi | Padanan real | Catatan perbedaan |
| --- | --- | --- |
| `tbsim_bobotkpi` | `tb_bobotkpi` | Struktur sama |
| `tbsim_kpi` | `tb_kpi` | Struktur sama |
| `tbsim_whats` | `tb_whats` | Tidak punya kolom edit tracking; `hasil` `NOT NULL` |
| `tbsim_hows` | `tb_hows` | Tidak punya kolom edit tracking; `hasil` `NOT NULL` |
| `tbsim_indikator_whats` | `tb_indikator_whats` | Tidak punya kolom edit tracking |
| `tbsim_indikator_hows` | `tb_indikator_hows` | Tidak punya kolom edit tracking |

## Primary Key, Index, dan Foreign Key

Primary key:

| Tabel | Primary key |
| --- | --- |
| `tb_bobotkpi`, `tbsim_bobotkpi` | `idbobotkpi` |
| `tb_kpi`, `tbsim_kpi` | `id` |
| `tb_whats`, `tbsim_whats` | `id_what` |
| `tb_hows`, `tbsim_hows` | `id_how` |
| `tb_indikator_whats`, `tbsim_indikator_whats` | `id_indikator` |
| `tb_indikator_hows`, `tbsim_indikator_hows` | `id_indikator` |

Index non-primary yang ditemukan:

| Tabel | Index |
| --- | --- |
| `tb_indikator_whats` | `id_what` |
| `tb_indikator_hows` | `idx_id_how`, `idx_urutan` |
| `tbsim_indikator_whats` | `fk_indikator_whats` pada `id_what` |
| `tbsim_indikator_hows` | `idx_id_how`, `idx_urutan` |

Foreign key eksplisit:

- Tidak ditemukan foreign key eksplisit pada 12 tabel KPI scope ini di database live `kiucoid_kpi`.
- Relasi parent-child dipakai secara logis oleh aplikasi melalui kolom `id_user`, `id_kpi`, `id_what`, dan `id_how`.
- Catatan: dump legacy `db/db_kpi.sql` memiliki constraint indikator untuk sebagian tabel real, tetapi struktur live database yang dipakai aplikasi saat analisis ini tidak memilikinya. Tahap berikutnya harus mengikuti struktur live database.

## Hubungan Antar Tabel

Hubungan logis KPI real:

```text
tb_bobotkpi.id_user
tb_kpi.id_user

tb_kpi.id
  -> tb_whats.id_kpi
  -> tb_hows.id_kpi

tb_whats.id_what
  -> tb_indikator_whats.id_what

tb_hows.id_how
  -> tb_indikator_hows.id_how
```

Hubungan logis KPI simulasi:

```text
tbsim_bobotkpi.id_user
tbsim_kpi.id_user

tbsim_kpi.id
  -> tbsim_whats.id_kpi
  -> tbsim_hows.id_kpi

tbsim_whats.id_what
  -> tbsim_indikator_whats.id_what

tbsim_hows.id_how
  -> tbsim_indikator_hows.id_how
```

Karena tidak ada foreign key eksplisit, migrasi/backup harus menjaga urutan manual:

1. Parent: `*_bobotkpi`, `*_kpi`
2. Child: `*_whats`, `*_hows`
3. Grandchild: `*_indikator_whats`, `*_indikator_hows`

Untuk penghapusan, urutannya harus dibalik: indikator dulu, lalu WHAT/HOW, lalu KPI/bobot.

## Kolom Yang Diminta

| Kebutuhan identifikasi | Kolom yang ditemukan |
| --- | --- |
| User | `id_user` di `*_bobotkpi`, `*_kpi`, `*_whats`, `*_hows` |
| KPI | `tb_kpi.id`, `tb_kpi.poin`, `tb_kpi.poin2`; simulasi sama di `tbsim_kpi` |
| Bobot utama | `tb_kpi.bobot`, `tb_kpi.bobot2`; simulasi sama |
| Bobot global | `tb_bobotkpi.bobotwhat`, `tb_bobotkpi.bobothow`; simulasi sama |
| Bobot detail | `tb_whats.bobot`, `tb_hows.bobot`; simulasi sama |
| WHAT | `tb_whats.p_what`, `tb_whats.tipe_what`; simulasi sama |
| HOW | `tb_hows.p_how`, `tb_hows.tipe_how`; simulasi sama |
| Indikator WHAT | `tb_indikator_whats.keterangan`, `nilai`, `urutan`; simulasi sama |
| Indikator HOW | `tb_indikator_hows.keterangan`, `nilai`, `urutan`; simulasi sama |
| Nilai | `nilai`, `total`, `hasil`, `target_omset` pada WHAT/HOW |
| Status aktif | Tidak ditemukan pada 12 tabel scope KPI |
| Periode KPI | Tidak ditemukan pada 12 tabel scope KPI |

Catatan periode/status terkait KPI di luar scope tabel utama:

- `tb_kpi_history` memiliki kolom `bulan`.
- `tb_kpi_verified` dipakai untuk status verifikasi bulanan.
- `tb_kpi_lock_settings` mengatur lock berdasarkan tanggal/status.
- `tbar_archive` menyimpan archive per `bulan`.

## Row Count Global Saat Analisis

| Tabel | Jumlah row |
| --- | ---: |
| `tb_bobotkpi` | 163 |
| `tb_kpi` | 718 |
| `tb_whats` | 977 |
| `tb_hows` | 2134 |
| `tb_indikator_whats` | 5461 |
| `tb_indikator_hows` | 10069 |
| `tbsim_bobotkpi` | 100 |
| `tbsim_kpi` | 381 |
| `tbsim_whats` | 554 |
| `tbsim_hows` | 1067 |
| `tbsim_indikator_whats` | 3577 |
| `tbsim_indikator_hows` | 5657 |

## Pemakaian di Kode Aplikasi

Project ini tidak memakai struktur MVC formal dengan model class terpisah. Akses database KPI tersebar di helper, file `app`, dan view `pages`.

### Helper

| File | Pemakaian |
| --- | --- |
| `helper/getKPI.php` | Ambil `tb_kpi` berdasarkan `$_SESSION['id_user']`, hitung `SUM(bobot)` |
| `helper/getKPI_sim.php` | Ambil `tbsim_kpi`, hitung `SUM(bobot)` |
| `helper/getWhat.php` | Ambil `tb_whats` berdasarkan `id_user` dan `id_kpi` |
| `helper/getHow.php` | Ambil `tb_hows` berdasarkan `id_user` |
| `helper/getHow_sim.php` | Ambil `tbsim_hows` berdasarkan `id_user` |

### Controller/handler KPI real

`app/dashboard/detail-kpi-real.php` menangani:

- Insert/update `tb_kpi`.
- Insert `tb_whats` dan `tb_indikator_whats`.
- Insert `tb_hows` dan `tb_indikator_hows`.
- Penilaian WHAT/HOW, termasuk kalkulasi `total`.
- Delete KPI dengan urutan manual: indikator, WHAT/HOW, lalu `tb_kpi`.
- Tracking edit atasan pada tabel real melalui `is_edited`, `edited_by`, `edited_at`, dan kolom `original_*`.

### Controller/handler KPI simulasi

`app/dashboard/detail-kpi-simulasi.php` menangani pola yang sama untuk tabel simulasi:

- Insert/update `tbsim_kpi`.
- Insert `tbsim_whats` dan `tbsim_indikator_whats`.
- Insert `tbsim_hows` dan `tbsim_indikator_hows`.
- Delete KPI simulasi dengan urutan manual.

Perbedaan penting: tabel simulasi tidak memiliki kolom edit tracking.

### View/detail KPI

`pages/kpi/k_main.php` membaca:

- `tb_whats` berdasarkan `id_user` dan `id_kpi`.
- `tb_indikator_whats` berdasarkan `id_what`, urut `urutan`.
- `tb_hows` berdasarkan `id_user` dan `id_kpi`.
- `tb_indikator_hows` berdasarkan `id_how`, urut `urutan`.

View ini juga menampilkan badge edit atasan dari kolom edit tracking real.

### Dashboard dan summary

File yang menghitung summary KPI real/simulasi memakai pola:

- `SUM(total)` dari `*_whats` dan `*_hows`.
- Bobot global dari `*_bobotkpi`.
- Bobot kategori dari `*_kpi`.

File terkait:

- `pages/dashboard/p_mainSummary.php`
- `pages/dashboard/p_mainSummarysim.php`
- `app/dashboard/home-kpi-real.php`
- `app/dashboard/home-kpi-simulasi.php`
- `app/kpi/kpianggota.php`
- `app/kpi/kpikabag.php`
- `app/kpi/kpikadep.php`
- `app/kpi/kpidepartemen.php`
- `app/kpi/kpidirektur.php`

### Simulasi dari KPI real

`app/dashboard/home-kpi-real.php` memiliki handler `simulateKPI` yang:

1. Menghapus data simulasi user yang sedang aktif.
2. Menyalin `tb_kpi` ke `tbsim_kpi`.
3. Menyalin `tb_whats` ke `tbsim_whats`.
4. Menyalin `tb_indikator_whats` ke `tbsim_indikator_whats`.
5. Menyalin `tb_hows` ke `tbsim_hows`.
6. Menyalin `tb_indikator_hows` ke `tbsim_indikator_hows`.
7. Menyalin `tb_bobotkpi` ke `tbsim_bobotkpi`.

Handler ini membuktikan mapping ID KPI real ke simulasi perlu dibuat ulang karena `id` parent baru berbeda setelah insert.

### Pembuatan user

`app/adminhrd/datauser-adminhrd.php` membuat row awal:

- `tb_bobotkpi` dengan `bobotwhat = 0`, `bobothow = 0`.
- `tbsim_bobotkpi` dengan `bobotwhat = 0`, `bobothow = 0`.

## Implikasi Untuk Tahap Berikutnya

Sebelum tahap analisis data user 171 dan migrasi:

1. Query harus selalu filter `id_user = 171` pada parent dan child yang punya `id_user`.
2. Query indikator harus dibatasi melalui parent milik user 171, misalnya join ke `tb_whats` atau `tb_hows`.
3. Jangan mengandalkan foreign key database untuk cleanup; urutan delete/copy harus eksplisit.
4. Saat menyalin real ke simulasi, jangan memakai `id_kpi`, `id_what`, atau `id_how` lama secara langsung; buat mapping ID baru.
5. Untuk tabel real, insert harus mengisi kolom wajib saja dan membiarkan kolom edit tracking default/null.
6. Untuk tabel simulasi, kolom `hasil` wajib `NOT NULL`, jadi insert perlu memberi nilai default seperti string kosong.
7. Validasi bobot perlu dilakukan minimal pada:
   - total `tb_kpi.bobot` dan `tb_kpi.bobot2` user 171;
   - total `tbsim_kpi.bobot` dan `tbsim_kpi.bobot2` user 171;
   - total `bobot` WHAT per KPI;
   - total `bobot` HOW per KPI.

## Status Tahap 1

Selesai.

Tahap ini menghasilkan dokumentasi analisis struktur dan pemakaian tabel. Tahap ini belum melakukan analisis data existing user 171, backup, migrasi, insert, update, ataupun delete.
