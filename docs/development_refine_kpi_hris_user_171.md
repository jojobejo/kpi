# Dokumentasi Development Penyempurnaan KPI Karisma HRIS User 171

Tanggal: 2026-08-26

## Tujuan

Menyempurnakan struktur KPI IT untuk fokus utama development `KARISMA - HRIS (HUMAN RESOURCE INFORMATION SYSTEM)` berdasarkan lampiran user.

Permintaan utama:

- KPI harus fokus pada development Karisma HRIS.
- Urutan bobot dari paling tinggi ke paling rendah:
  - KARISMA - HRIS (HUMAN RESOURCE INFORMATION SYSTEM)
  - Support KarismaERP
  - Stabilitas & Performa aplikasi
  - Pemeliharaan Sistem
  - Absensi
  - Supporting maintenance hardware
- Penyempurnaan tidak hanya pada `WHAT`, tetapi juga `HOW` dan poin penilaian/indikatornya.

## Scope Development

Perubahan dilakukan pada master data KPI aktif lokal untuk user:

| id_user | username | nama | departement |
| --- | --- | --- | --- |
| 171 | Al | Ahmad Lutfi Farizi | IT |

Tidak ada perubahan file aplikasi PHP karena modul KPI sudah mendukung CRUD KPI, WHAT, HOW, bobot, dan indikator.

## Keputusan Bobot

Bobot kategori dibuat total `100%` dengan urutan sesuai arahan:

| Urutan | Kategori KPI | Bobot |
| ---: | --- | ---: |
| 1 | KARISMA - HRIS (HUMAN RESOURCE INFORMATION SYSTEM) | 40% |
| 2 | Support KarismaERP | 20% |
| 3 | Stabilitas & Performa aplikasi | 15% |
| 4 | Pemeliharaan Sistem | 10% |
| 5 | Absensi | 8% |
| 6 | Supporting maintenance hardware | 7% |

Bobot global KPI tetap:

| Komponen | Bobot |
| --- | ---: |
| WHAT | 60% |
| HOW | 40% |

Alasan:

- HRIS menjadi prioritas utama dan tetap dominan.
- Support KarismaERP ditempatkan sebagai prioritas kedua karena masih berdampak langsung ke operasional.
- Stabilitas, maintenance, absensi, dan hardware tetap dinilai, tetapi bobotnya diturunkan agar tidak mengalahkan fokus pembangunan HRIS.

## Ringkasan WHAT

### KARISMA - HRIS

| WHAT | Bobot |
| --- | ---: |
| Core module HRIS siap digunakan: master karyawan, organisasi, jabatan, kontrak, cuti/izin/sakit, dan data absensi | 30% |
| Workflow approval dan employee self-service HRIS berjalan untuk request karyawan, approval atasan/HRD, status tracking, dan notifikasi | 25% |
| Integrasi data HRIS dengan KPI/KarismaERP: user, departemen, jabatan, absensi, dan audit trail konsisten | 20% |
| Go-live quality HRIS: UAT, training, SOP, rollback plan, dan bug critical selesai sebelum dipakai operasional | 15% |
| Dokumentasi teknis, user guide, release note, dan catatan keputusan HRIS lengkap serta mudah diteruskan ke tim | 10% |

### Support KarismaERP

| WHAT | Bobot |
| --- | ---: |
| Enhancement KarismaERP sesuai kebutuhan operasional prioritas selesai dan berdampak pada efisiensi proses bisnis | 35% |
| Bug KarismaERP yang mengganggu transaksi/data diselesaikan dengan validasi sebelum dan sesudah perbaikan | 30% |
| Support integrasi/reporting antara HRIS, KPI, dan KarismaERP sesuai kebutuhan manajemen | 20% |
| Dokumentasi perubahan KarismaERP, release note, dan panduan penggunaan tersedia setiap rilis | 15% |

### Stabilitas & Performa Aplikasi

| WHAT | Bobot |
| --- | ---: |
| Error critical aplikasi produksi HRIS/KPI/KarismaERP support maksimal 1 kasus per bulan | 45% |
| Response time dan query utama aplikasi stabil pada jam operasional | 25% |
| Backup dan recovery point aplikasi kritikal berjalan sesuai jadwal serta dapat diverifikasi | 20% |
| Laporan stabilitas, incident, RCA, dan tindakan perbaikan disampaikan rutin | 10% |

### Pemeliharaan Sistem

| WHAT | Bobot |
| --- | ---: |
| Preventive maintenance aplikasi/server lokal terjadwal, terdokumentasi, dan tidak mengganggu operasional | 40% |
| Bug minor dan technical debt kecil yang berisiko operasional ditangani secara bertahap | 25% |
| Housekeeping data, file upload, log, dan backup lama dilakukan agar sistem tetap rapi | 20% |
| Laporan maintenance berisi hasil, risiko, dan next action tersedia tepat waktu | 15% |

### Absensi

| WHAT | Bobot |
| --- | ---: |
| Kehadiran sesuai data HRD: cuti, izin, sakit, dan absen tercatat benar | 60% |
| Kehadiran briefing, senam Sabtu, dan kegiatan wajib perusahaan sesuai jadwal | 25% |
| Ketepatan waktu hadir briefing dan aktivitas kerja harian | 15% |

### Supporting Maintenance Hardware

| WHAT | Bobot |
| --- | ---: |
| Support maintenance hardware tanpa kesalahan berulang pada perangkat user | 40% |
| Issue hardware yang menghambat pekerjaan user diselesaikan sesuai prioritas dampak kerja | 35% |
| Inventarisasi dan dokumentasi kondisi perangkat diperbarui setelah perbaikan/perawatan | 15% |
| Eskalasi kebutuhan sparepart atau penggantian perangkat dilakukan dengan alasan teknis yang jelas | 10% |

## Ringkasan HOW

### KARISMA - HRIS

| HOW | Bobot |
| --- | ---: |
| Menyusun roadmap, backlog, scope prioritas, dan timeline HRIS bersama HRD/manajemen | 20% |
| Membangun modul HRIS sesuai sprint dengan validasi input, hak akses, audit log, dan standar coding yang rapi | 30% |
| Melakukan testing, UAT, bug fixing, dan validasi data sebelum go-live | 25% |
| Menyiapkan dokumentasi, training singkat, dan handover operasional ke HRD/user terkait | 15% |
| Melaporkan progress mingguan, risiko, hambatan, dan keputusan yang dibutuhkan kepada atasan | 10% |

### Support KarismaERP

| HOW | Bobot |
| --- | ---: |
| Menganalisis request user KarismaERP dan dampaknya ke proses bisnis sebelum development | 25% |
| Mengembangkan enhancement kecil/menengah sesuai prioritas dan timeline yang disepakati | 30% |
| Melakukan testing regresi modul terkait sebelum rilis ke user | 25% |
| Mengomunikasikan status, UAT, dan handover perubahan kepada user terkait | 20% |

### Stabilitas & Performa Aplikasi

| HOW | Bobot |
| --- | ---: |
| Monitoring error log, database, akses aplikasi, dan anomali performa setiap hari kerja | 30% |
| Menangani incident critical dengan RCA, action plan, dan verifikasi setelah perbaikan | 30% |
| Melakukan optimasi query, kode, asset, atau konfigurasi yang berdampak pada performa | 20% |
| Menjalankan backup, cek hasil backup, dan simulasi restore berkala untuk aplikasi kritikal | 20% |

### Pemeliharaan Sistem

| HOW | Bobot |
| --- | ---: |
| Menjalankan checklist maintenance mingguan/bulanan untuk aplikasi, database, dan file upload | 35% |
| Menyelesaikan ticket troubleshooting sesuai SLA dan prioritas dampak operasional | 30% |
| Mendokumentasikan akar masalah, solusi, dan pencegahan agar masalah tidak berulang | 20% |
| Koordinasi jadwal maintenance dengan user/atasan agar gangguan kerja minimal | 15% |

### Absensi

| HOW | Bobot |
| --- | ---: |
| Mengikuti SOP izin tidak masuk dan memastikan approval HRD/atasan sebelum tidak hadir | 35% |
| Hadir briefing, senam Sabtu, dan kegiatan wajib sesuai jadwal yang berlaku | 25% |
| Menjaga ketepatan waktu masuk, briefing, dan komunikasi jika ada kendala | 25% |
| Melaporkan kendala absensi secara jujur, cepat, dan terdokumentasi | 15% |

### Supporting Maintenance Hardware

| HOW | Bobot |
| --- | ---: |
| Melakukan diagnosa awal hardware secara cepat dan tepat sebelum perbaikan | 30% |
| Melakukan perbaikan/perawatan perangkat sesuai SOP dan prioritas dampak pekerjaan user | 30% |
| Update status pekerjaan hardware kepada user dan atasan sampai issue selesai | 20% |
| Mencatat hasil perbaikan, penyebab, sparepart, dan rekomendasi pencegahan | 20% |

## Standar Poin Penilaian

Indikator penilaian dibuat agar hasil bisa dinilai dengan bukti:

| Nilai | Standar |
| ---: | --- |
| 115 | Target terlampaui atau selesai lebih cepat, bukti lengkap, dan tanpa rework mayor |
| 100 | Target tercapai 100% sesuai scope/SLA dengan bukti valid |
| 90 | Target tercapai 90-99% atau ada minor gap yang tidak menghambat operasional |
| 80 | Target tercapai 75-89% atau terlambat dengan dampak operasional ringan |
| 0 | Target kurang dari 75%, tidak ada bukti, atau pekerjaan tidak selesai |

Untuk beberapa poin HRIS utama, indikator dibuat lebih spesifik, misalnya core module, workflow approval, integrasi data, go-live quality, dan dokumentasi.

## Cara Penggunaan di Aplikasi

1. Login ke aplikasi KPI sebagai user `Al` atau admin yang dapat melihat KPI user `171`.
2. Buka KPI real untuk melihat target aktif.
3. Buka KPI simulasi untuk melihat struktur target simulasi yang sudah disamakan.
4. Saat penilaian, pilih indikator pada masing-masing WHAT/HOW berdasarkan bukti pekerjaan.
5. Upload evidence yang relevan, seperti screenshot fitur, hasil UAT, release note, laporan bug, laporan maintenance, backup log, atau dokumen handover.

## File Terkait

- SQL perubahan: `db_migrasi/2026-08-26_refine_kpi_hris_user_171.sql`
- Backup sebelum perubahan: `db_migrasi/2026-08-26_backup_before_refine_kpi_hris_user_171.sql`
- Dokumentasi database: `docs/database_refine_kpi_hris_user_171.md`

## Catatan Validasi

- Skrip diuji terlebih dahulu pada database clone `kiucoid_kpi_hris_test`.
- Skrip berhasil dijalankan pada database aktif lokal `kiucoid_kpi`.
- Tidak ada perubahan kode aplikasi PHP.
