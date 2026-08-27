# Analisis Data dan Backup KPI User 171 - Tahap 2 dan 3

Tanggal: 2026-08-26

## Scope

Dokumen ini melanjutkan:

- Tahap 2: analisis data KPI existing user `171`.
- Tahap 3: backup khusus data KPI existing user `171`.

Tidak ada migrasi KPI baru, `INSERT`, `UPDATE`, atau `DELETE` data KPI yang dijalankan pada tahap ini.

Database live:

| Item | Nilai |
| --- | --- |
| Host | `localhost` |
| User | `root` |
| Database | `kiucoid_kpi` |

## User Target

Data user dari `tb_users`:

| Kolom | Nilai |
| --- | --- |
| `id` | `171` |
| `username` | `Al` |
| `nama_lngkp` | `Ahmad Lutfi Farizi` |
| `nik` | `QIU251131109` |
| `bagian` | `MT IT SOFTWARE` |
| `departement` | `IT` |
| `jabatan` | `Karyawan` |
| `atasan` | `Wahyu Arif Prasetyo` |
| `penilai` | `Diana Wulandari` |

## Tahap 2 - Hasil Analisis Data Existing

Query dilakukan terhadap seluruh tabel scope KPI real dan simulasi dengan filter `id_user = 171`. Untuk tabel indikator, filter dilakukan melalui parent WHAT/HOW milik user `171`.

### Row Count KPI Real

| Tabel | Jumlah record user 171 |
| --- | ---: |
| `tb_bobotkpi` | 0 |
| `tb_kpi` | 0 |
| `tb_whats` | 0 |
| `tb_hows` | 0 |
| `tb_indikator_whats` | 0 |
| `tb_indikator_hows` | 0 |

### Row Count KPI Simulasi

| Tabel | Jumlah record user 171 |
| --- | ---: |
| `tbsim_bobotkpi` | 0 |
| `tbsim_kpi` | 0 |
| `tbsim_whats` | 0 |
| `tbsim_hows` | 0 |
| `tbsim_indikator_whats` | 0 |
| `tbsim_indikator_hows` | 0 |

## Relasi Existing Yang Ditemukan

Karena seluruh tabel KPI scope untuk user `171` kosong, tidak ada relasi data existing yang dapat ditampilkan dari:

```text
Bobot KPI
-> KPI
-> What
-> indikator What
-> How
-> indikator How
```

Kondisi ini berlaku untuk KPI real dan KPI simulasi.

## Klasifikasi KPI Lama

Klasifikasi berdasarkan kondisi database live saat tahap 2:

| Kategori tindakan | Hasil analisis |
| --- | --- |
| Dipertahankan | Tidak ada, karena tidak ada KPI existing user 171 |
| Diubah | Tidak ada |
| Dipindahkan | Tidak ada |
| Diganti nama | Tidak ada |
| Dihapus | Tidak ada data yang perlu dihapus |
| Ditambahkan | Seluruh struktur KPI baru user 171 perlu dibuat pada tahap migrasi berikutnya |

Catatan: file dump/migrasi lama di repository pernah memuat rencana atau data KPI user `171`, tetapi database live `kiucoid_kpi` yang dianalisis pada tahap ini tidak memiliki record KPI real maupun simulasi untuk user `171`.

## Implikasi Untuk Tahap Migrasi Berikutnya

Karena tidak ada data KPI existing:

1. Tahap migrasi tidak perlu melakukan transformasi data lama.
2. Tidak perlu menjalankan `DELETE` untuk membersihkan KPI user `171`, kecuali sebagai guard idempotent yang tetap dibatasi `id_user = 171`.
3. Migrasi KPI baru harus membuat data dari awal pada:
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
4. Backup tetap dibuat sebagai bukti kondisi sebelum migrasi.

## Tahap 3 - Backup Data Existing

Backup khusus user `171` dibuat di:

```text
db_migrasi/2026-08-26_backup_kpi_user_171_tahap_3.sql
```

File backup memakai filter:

| Tabel | Filter backup |
| --- | --- |
| `tb_bobotkpi` | `id_user = 171` |
| `tb_kpi` | `id_user = 171` |
| `tb_whats` | `id_user = 171` |
| `tb_hows` | `id_user = 171` |
| `tb_indikator_whats` | `id_what IN (SELECT id_what FROM tb_whats WHERE id_user = 171)` |
| `tb_indikator_hows` | `id_how IN (SELECT id_how FROM tb_hows WHERE id_user = 171)` |
| `tbsim_bobotkpi` | `id_user = 171` |
| `tbsim_kpi` | `id_user = 171` |
| `tbsim_whats` | `id_user = 171` |
| `tbsim_hows` | `id_user = 171` |
| `tbsim_indikator_whats` | `id_what IN (SELECT id_what FROM tbsim_whats WHERE id_user = 171)` |
| `tbsim_indikator_hows` | `id_how IN (SELECT id_how FROM tbsim_hows WHERE id_user = 171)` |

Backup final tidak memiliki statement `INSERT` karena tidak ada record KPI user `171` pada 12 tabel scope saat backup dibuat.

## Validasi Backup

Validasi setelah backup:

| Cek | Hasil |
| --- | --- |
| File backup dibuat | Ya |
| Record user lain ikut ter-backup | Tidak |
| Statement `INSERT` pada backup | 0 |
| Data KPI user 171 berubah | Tidak |

## Status Tahap 2 dan 3

Selesai.

Tahap 2 menyimpulkan bahwa user `171` belum memiliki data KPI real maupun simulasi pada database live. Tahap 3 menghasilkan backup khusus user `171` yang merekam kondisi kosong tersebut sebelum tahap migrasi berikutnya.
