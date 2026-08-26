USE `kiucoid_kpi`;

DELIMITER $$

DROP PROCEDURE IF EXISTS refine_kpi_hris_user_171 $$
CREATE PROCEDURE refine_kpi_hris_user_171()
BEGIN
    DECLARE v_user_count INT DEFAULT 0;
    DECLARE v_history_count INT DEFAULT 0;
    DECLARE v_eviden_count INT DEFAULT 0;

    DECLARE v_kpi_hris INT;
    DECLARE v_kpi_erp INT;
    DECLARE v_kpi_stability INT;
    DECLARE v_kpi_maintenance INT;
    DECLARE v_kpi_attendance INT;
    DECLARE v_kpi_hardware INT;

    DECLARE v_sim_hris INT;
    DECLARE v_sim_erp INT;
    DECLARE v_sim_stability INT;
    DECLARE v_sim_maintenance INT;
    DECLARE v_sim_attendance INT;
    DECLARE v_sim_hardware INT;

    DECLARE v_item INT;

    SELECT COUNT(*)
      INTO v_user_count
      FROM tb_users
     WHERE id = 171
       AND username = 'Al'
       AND departement = 'IT';

    IF v_user_count <> 1 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Guard gagal: target user 171/Al departement IT tidak ditemukan tepat 1 baris.';
    END IF;

    SELECT COUNT(*)
      INTO v_history_count
      FROM tb_kpi_history
     WHERE id_user = 171;

    IF v_history_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Guard gagal: user 171 sudah memiliki history KPI. Review manual sebelum reinsert master KPI.';
    END IF;

    SELECT COUNT(*)
      INTO v_eviden_count
      FROM tb_eviden
     WHERE id_user = 171;

    IF v_eviden_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Guard gagal: user 171 sudah memiliki eviden KPI. Review manual sebelum reinsert master KPI.';
    END IF;

    START TRANSACTION;

    DELETE FROM tb_indikator_whats
     WHERE id_what IN (SELECT id_what FROM tb_whats WHERE id_user = 171);
    DELETE FROM tb_indikator_hows
     WHERE id_how IN (SELECT id_how FROM tb_hows WHERE id_user = 171);
    DELETE FROM tb_whats WHERE id_user = 171;
    DELETE FROM tb_hows WHERE id_user = 171;
    DELETE FROM tb_kpi WHERE id_user = 171;
    DELETE FROM tb_bobotkpi WHERE id_user = 171;

    DELETE FROM tbsim_indikator_whats
     WHERE id_what IN (SELECT id_what FROM tbsim_whats WHERE id_user = 171);
    DELETE FROM tbsim_indikator_hows
     WHERE id_how IN (SELECT id_how FROM tbsim_hows WHERE id_user = 171);
    DELETE FROM tbsim_whats WHERE id_user = 171;
    DELETE FROM tbsim_hows WHERE id_user = 171;
    DELETE FROM tbsim_kpi WHERE id_user = 171;
    DELETE FROM tbsim_bobotkpi WHERE id_user = 171;

    INSERT INTO tb_bobotkpi (id_user, bobotwhat, bobothow) VALUES (171, 60, 40);
    INSERT INTO tbsim_bobotkpi (id_user, bobotwhat, bobothow) VALUES (171, 60, 40);

    INSERT INTO tb_kpi (id_user, poin, bobot, poin2, bobot2) VALUES
    (171, 'KARISMA - HRIS (HUMAN RESOURCE INFORMATION SYSTEM)', 40, 'Development KARISMA - HRIS sampai siap dipakai operasional', 40);
    SET v_kpi_hris = LAST_INSERT_ID();

    INSERT INTO tb_kpi (id_user, poin, bobot, poin2, bobot2) VALUES
    (171, 'Support KarismaERP', 20, 'Penyempurnaan dan support modul KarismaERP yang berdampak ke operasional', 20);
    SET v_kpi_erp = LAST_INSERT_ID();

    INSERT INTO tb_kpi (id_user, poin, bobot, poin2, bobot2) VALUES
    (171, 'Stabilitas & Performa aplikasi', 15, 'Menjaga aplikasi HRIS/KPI/KarismaERP tetap stabil, cepat, dan aman dipakai', 15);
    SET v_kpi_stability = LAST_INSERT_ID();

    INSERT INTO tb_kpi (id_user, poin, bobot, poin2, bobot2) VALUES
    (171, 'Pemeliharaan Sistem', 10, 'Pemeliharaan preventif dan korektif sistem secara terjadwal', 10);
    SET v_kpi_maintenance = LAST_INSERT_ID();

    INSERT INTO tb_kpi (id_user, poin, bobot, poin2, bobot2) VALUES
    (171, 'Absensi', 8, 'Kedisiplinan absensi dan kepatuhan kegiatan wajib perusahaan', 8);
    SET v_kpi_attendance = LAST_INSERT_ID();

    INSERT INTO tb_kpi (id_user, poin, bobot, poin2, bobot2) VALUES
    (171, 'Supporting maintenance hardware', 7, 'Membantu perawatan hardware agar pekerjaan user tidak terhambat', 7);
    SET v_kpi_hardware = LAST_INSERT_ID();

    INSERT INTO tbsim_kpi (id_user, poin, bobot, poin2, bobot2) VALUES
    (171, 'KARISMA - HRIS (HUMAN RESOURCE INFORMATION SYSTEM)', 40, 'Development KARISMA - HRIS sampai siap dipakai operasional', 40);
    SET v_sim_hris = LAST_INSERT_ID();

    INSERT INTO tbsim_kpi (id_user, poin, bobot, poin2, bobot2) VALUES
    (171, 'Support KarismaERP', 20, 'Penyempurnaan dan support modul KarismaERP yang berdampak ke operasional', 20);
    SET v_sim_erp = LAST_INSERT_ID();

    INSERT INTO tbsim_kpi (id_user, poin, bobot, poin2, bobot2) VALUES
    (171, 'Stabilitas & Performa aplikasi', 15, 'Menjaga aplikasi HRIS/KPI/KarismaERP tetap stabil, cepat, dan aman dipakai', 15);
    SET v_sim_stability = LAST_INSERT_ID();

    INSERT INTO tbsim_kpi (id_user, poin, bobot, poin2, bobot2) VALUES
    (171, 'Pemeliharaan Sistem', 10, 'Pemeliharaan preventif dan korektif sistem secara terjadwal', 10);
    SET v_sim_maintenance = LAST_INSERT_ID();

    INSERT INTO tbsim_kpi (id_user, poin, bobot, poin2, bobot2) VALUES
    (171, 'Absensi', 8, 'Kedisiplinan absensi dan kepatuhan kegiatan wajib perusahaan', 8);
    SET v_sim_attendance = LAST_INSERT_ID();

    INSERT INTO tbsim_kpi (id_user, poin, bobot, poin2, bobot2) VALUES
    (171, 'Supporting maintenance hardware', 7, 'Membantu perawatan hardware agar pekerjaan user tidak terhambat', 7);
    SET v_sim_hardware = LAST_INSERT_ID();

    /* WHAT - real */
    INSERT INTO tb_whats (id_user, id_kpi, tipe_what, p_what, bobot, target_omset, hasil, nilai, total) VALUES
    (171, v_kpi_hris, 'A', 'Core module HRIS siap digunakan: master karyawan, organisasi, jabatan, kontrak, cuti/izin/sakit, dan data absensi', 30, 0, 'Belum dinilai', 0, 0);
    SET v_item = LAST_INSERT_ID();
    INSERT INTO tb_indikator_whats (id_what, keterangan, nilai, urutan) VALUES
    (v_item, 'Semua core module selesai, terintegrasi, dan siap go-live tanpa bug critical', 115, 1),
    (v_item, 'Semua core module selesai dan siap UAT/go-live', 100, 2),
    (v_item, 'Minimal 90% core module selesai dengan bug minor terkendali', 90, 3),
    (v_item, 'Minimal 75% core module selesai namun masih perlu perbaikan mayor', 80, 4),
    (v_item, 'Kurang dari 75% core module selesai atau tidak ada bukti valid', 0, 5);

    INSERT INTO tb_whats (id_user, id_kpi, tipe_what, p_what, bobot, target_omset, hasil, nilai, total) VALUES
    (171, v_kpi_hris, 'A', 'Workflow approval dan employee self-service HRIS berjalan untuk request karyawan, approval atasan/HRD, status tracking, dan notifikasi', 25, 0, 'Belum dinilai', 0, 0);
    SET v_item = LAST_INSERT_ID();
    INSERT INTO tb_indikator_whats (id_what, keterangan, nilai, urutan) VALUES
    (v_item, 'Workflow selesai end-to-end, mudah dipakai, dan lolos UAT user', 115, 1),
    (v_item, 'Workflow selesai sesuai scope dan siap dipakai', 100, 2),
    (v_item, 'Workflow selesai dengan gap minor yang tidak menghambat operasional', 90, 3),
    (v_item, 'Workflow berjalan sebagian dan masih membutuhkan workaround manual', 80, 4),
    (v_item, 'Workflow belum berjalan atau tidak ada bukti testing', 0, 5);

    INSERT INTO tb_whats (id_user, id_kpi, tipe_what, p_what, bobot, target_omset, hasil, nilai, total) VALUES
    (171, v_kpi_hris, 'A', 'Integrasi data HRIS dengan KPI/KarismaERP: user, departemen, jabatan, absensi, dan audit trail konsisten', 20, 0, 'Belum dinilai', 0, 0);
    SET v_item = LAST_INSERT_ID();
    INSERT INTO tb_indikator_whats (id_what, keterangan, nilai, urutan) VALUES
    (v_item, 'Integrasi stabil, data konsisten, dan ada audit trail valid', 115, 1),
    (v_item, 'Integrasi selesai dan data utama konsisten', 100, 2),
    (v_item, 'Integrasi selesai dengan temuan minor terdokumentasi', 90, 3),
    (v_item, 'Integrasi parsial atau masih ada koreksi data manual', 80, 4),
    (v_item, 'Integrasi belum tersedia atau data tidak dapat divalidasi', 0, 5);

    INSERT INTO tb_whats (id_user, id_kpi, tipe_what, p_what, bobot, target_omset, hasil, nilai, total) VALUES
    (171, v_kpi_hris, 'A', 'Go-live quality HRIS: UAT, training, SOP, rollback plan, dan bug critical selesai sebelum dipakai operasional', 15, 0, 'Belum dinilai', 0, 0);
    SET v_item = LAST_INSERT_ID();
    INSERT INTO tb_indikator_whats (id_what, keterangan, nilai, urutan) VALUES
    (v_item, 'Go-live lebih cepat/tepat waktu, 0 bug critical, training dan SOP lengkap', 115, 1),
    (v_item, 'Go-live tepat waktu, 0 bug critical, training dan SOP tersedia', 100, 2),
    (v_item, 'Go-live dengan bug minor dan mitigasi jelas', 90, 3),
    (v_item, 'Go-live tertunda atau dokumen pendukung belum lengkap', 80, 4),
    (v_item, 'Tidak go-live atau bug critical belum selesai', 0, 5);

    INSERT INTO tb_whats (id_user, id_kpi, tipe_what, p_what, bobot, target_omset, hasil, nilai, total) VALUES
    (171, v_kpi_hris, 'A', 'Dokumentasi teknis, user guide, release note, dan catatan keputusan HRIS lengkap serta mudah diteruskan ke tim', 10, 0, 'Belum dinilai', 0, 0);
    SET v_item = LAST_INSERT_ID();
    INSERT INTO tb_indikator_whats (id_what, keterangan, nilai, urutan) VALUES
    (v_item, '100% dokumentasi lengkap, rapi, dan sudah direview atasan/HRD', 115, 1),
    (v_item, 'Dokumentasi lengkap untuk seluruh fitur utama', 100, 2),
    (v_item, 'Minimal 90% dokumentasi lengkap', 90, 3),
    (v_item, 'Dokumentasi ada tetapi belum lengkap/kurang rapi', 80, 4),
    (v_item, 'Dokumentasi tidak tersedia', 0, 5);

    INSERT INTO tb_whats (id_user, id_kpi, tipe_what, p_what, bobot, target_omset, hasil, nilai, total) VALUES
    (171, v_kpi_erp, 'A', 'Enhancement KarismaERP sesuai kebutuhan operasional prioritas selesai dan berdampak pada efisiensi proses bisnis', 35, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_erp, 'A', 'Bug KarismaERP yang mengganggu transaksi/data diselesaikan dengan validasi sebelum dan sesudah perbaikan', 30, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_erp, 'A', 'Support integrasi/reporting antara HRIS, KPI, dan KarismaERP sesuai kebutuhan manajemen', 20, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_erp, 'A', 'Dokumentasi perubahan KarismaERP, release note, dan panduan penggunaan tersedia setiap rilis', 15, 0, 'Belum dinilai', 0, 0);

    INSERT INTO tb_whats (id_user, id_kpi, tipe_what, p_what, bobot, target_omset, hasil, nilai, total) VALUES
    (171, v_kpi_stability, 'A', 'Error critical aplikasi produksi HRIS/KPI/KarismaERP support maksimal 1 kasus per bulan', 45, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_stability, 'A', 'Response time dan query utama aplikasi stabil pada jam operasional', 25, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_stability, 'A', 'Backup dan recovery point aplikasi kritikal berjalan sesuai jadwal serta dapat diverifikasi', 20, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_stability, 'A', 'Laporan stabilitas, incident, RCA, dan tindakan perbaikan disampaikan rutin', 10, 0, 'Belum dinilai', 0, 0);

    INSERT INTO tb_whats (id_user, id_kpi, tipe_what, p_what, bobot, target_omset, hasil, nilai, total) VALUES
    (171, v_kpi_maintenance, 'A', 'Preventive maintenance aplikasi/server lokal terjadwal, terdokumentasi, dan tidak mengganggu operasional', 40, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_maintenance, 'A', 'Bug minor dan technical debt kecil yang berisiko operasional ditangani secara bertahap', 25, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_maintenance, 'A', 'Housekeeping data, file upload, log, dan backup lama dilakukan agar sistem tetap rapi', 20, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_maintenance, 'A', 'Laporan maintenance berisi hasil, risiko, dan next action tersedia tepat waktu', 15, 0, 'Belum dinilai', 0, 0);

    INSERT INTO tb_whats (id_user, id_kpi, tipe_what, p_what, bobot, target_omset, hasil, nilai, total) VALUES
    (171, v_kpi_attendance, 'A', 'Kehadiran sesuai data HRD: cuti, izin, sakit, dan absen tercatat benar', 60, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_attendance, 'A', 'Kehadiran briefing, senam Sabtu, dan kegiatan wajib perusahaan sesuai jadwal', 25, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_attendance, 'A', 'Ketepatan waktu hadir briefing dan aktivitas kerja harian', 15, 0, 'Belum dinilai', 0, 0);

    INSERT INTO tb_whats (id_user, id_kpi, tipe_what, p_what, bobot, target_omset, hasil, nilai, total) VALUES
    (171, v_kpi_hardware, 'A', 'Support maintenance hardware tanpa kesalahan berulang pada perangkat user', 40, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_hardware, 'A', 'Issue hardware yang menghambat pekerjaan user diselesaikan sesuai prioritas dampak kerja', 35, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_hardware, 'A', 'Inventarisasi dan dokumentasi kondisi perangkat diperbarui setelah perbaikan/perawatan', 15, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_hardware, 'A', 'Eskalasi kebutuhan sparepart atau penggantian perangkat dilakukan dengan alasan teknis yang jelas', 10, 0, 'Belum dinilai', 0, 0);

    INSERT INTO tb_indikator_whats (id_what, keterangan, nilai, urutan)
    SELECT id_what, 'Target terlampaui/selesai lebih cepat dengan bukti lengkap dan tanpa rework mayor', 115, 1
      FROM tb_whats WHERE id_user = 171 AND id_what > v_item;
    INSERT INTO tb_indikator_whats (id_what, keterangan, nilai, urutan)
    SELECT id_what, 'Target tercapai 100% sesuai scope/SLA dengan bukti valid', 100, 2
      FROM tb_whats WHERE id_user = 171 AND id_what > v_item;
    INSERT INTO tb_indikator_whats (id_what, keterangan, nilai, urutan)
    SELECT id_what, 'Target tercapai 90-99% atau ada minor gap yang tidak menghambat operasional', 90, 3
      FROM tb_whats WHERE id_user = 171 AND id_what > v_item;
    INSERT INTO tb_indikator_whats (id_what, keterangan, nilai, urutan)
    SELECT id_what, 'Target tercapai 75-89% atau terlambat dengan dampak operasional ringan', 80, 4
      FROM tb_whats WHERE id_user = 171 AND id_what > v_item;
    INSERT INTO tb_indikator_whats (id_what, keterangan, nilai, urutan)
    SELECT id_what, 'Target kurang dari 75%, tidak ada bukti, atau pekerjaan tidak selesai', 0, 5
      FROM tb_whats WHERE id_user = 171 AND id_what > v_item;

    /* HOW - real */
    INSERT INTO tb_hows (id_user, id_kpi, tipe_how, p_how, bobot, target_omset, hasil, nilai, total) VALUES
    (171, v_kpi_hris, 'A', 'Menyusun roadmap, backlog, scope prioritas, dan timeline HRIS bersama HRD/manajemen', 20, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_hris, 'A', 'Membangun modul HRIS sesuai sprint dengan validasi input, hak akses, audit log, dan standar coding yang rapi', 30, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_hris, 'A', 'Melakukan testing, UAT, bug fixing, dan validasi data sebelum go-live', 25, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_hris, 'A', 'Menyiapkan dokumentasi, training singkat, dan handover operasional ke HRD/user terkait', 15, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_hris, 'A', 'Melaporkan progress mingguan, risiko, hambatan, dan keputusan yang dibutuhkan kepada atasan', 10, 0, 'Belum dinilai', 0, 0);

    INSERT INTO tb_hows (id_user, id_kpi, tipe_how, p_how, bobot, target_omset, hasil, nilai, total) VALUES
    (171, v_kpi_erp, 'A', 'Menganalisis request user KarismaERP dan dampaknya ke proses bisnis sebelum development', 25, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_erp, 'A', 'Mengembangkan enhancement kecil/menengah sesuai prioritas dan timeline yang disepakati', 30, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_erp, 'A', 'Melakukan testing regresi modul terkait sebelum rilis ke user', 25, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_erp, 'A', 'Mengomunikasikan status, UAT, dan handover perubahan kepada user terkait', 20, 0, 'Belum dinilai', 0, 0);

    INSERT INTO tb_hows (id_user, id_kpi, tipe_how, p_how, bobot, target_omset, hasil, nilai, total) VALUES
    (171, v_kpi_stability, 'A', 'Monitoring error log, database, akses aplikasi, dan anomali performa setiap hari kerja', 30, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_stability, 'A', 'Menangani incident critical dengan RCA, action plan, dan verifikasi setelah perbaikan', 30, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_stability, 'A', 'Melakukan optimasi query, kode, asset, atau konfigurasi yang berdampak pada performa', 20, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_stability, 'A', 'Menjalankan backup, cek hasil backup, dan simulasi restore berkala untuk aplikasi kritikal', 20, 0, 'Belum dinilai', 0, 0);

    INSERT INTO tb_hows (id_user, id_kpi, tipe_how, p_how, bobot, target_omset, hasil, nilai, total) VALUES
    (171, v_kpi_maintenance, 'A', 'Menjalankan checklist maintenance mingguan/bulanan untuk aplikasi, database, dan file upload', 35, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_maintenance, 'A', 'Menyelesaikan ticket troubleshooting sesuai SLA dan prioritas dampak operasional', 30, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_maintenance, 'A', 'Mendokumentasikan akar masalah, solusi, dan pencegahan agar masalah tidak berulang', 20, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_maintenance, 'A', 'Koordinasi jadwal maintenance dengan user/atasan agar gangguan kerja minimal', 15, 0, 'Belum dinilai', 0, 0);

    INSERT INTO tb_hows (id_user, id_kpi, tipe_how, p_how, bobot, target_omset, hasil, nilai, total) VALUES
    (171, v_kpi_attendance, 'A', 'Mengikuti SOP izin tidak masuk dan memastikan approval HRD/atasan sebelum tidak hadir', 35, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_attendance, 'A', 'Hadir briefing, senam Sabtu, dan kegiatan wajib sesuai jadwal yang berlaku', 25, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_attendance, 'A', 'Menjaga ketepatan waktu masuk, briefing, dan komunikasi jika ada kendala', 25, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_attendance, 'A', 'Melaporkan kendala absensi secara jujur, cepat, dan terdokumentasi', 15, 0, 'Belum dinilai', 0, 0);

    INSERT INTO tb_hows (id_user, id_kpi, tipe_how, p_how, bobot, target_omset, hasil, nilai, total) VALUES
    (171, v_kpi_hardware, 'A', 'Melakukan diagnosa awal hardware secara cepat dan tepat sebelum perbaikan', 30, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_hardware, 'A', 'Melakukan perbaikan/perawatan perangkat sesuai SOP dan prioritas dampak pekerjaan user', 30, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_hardware, 'A', 'Update status pekerjaan hardware kepada user dan atasan sampai issue selesai', 20, 0, 'Belum dinilai', 0, 0),
    (171, v_kpi_hardware, 'A', 'Mencatat hasil perbaikan, penyebab, sparepart, dan rekomendasi pencegahan', 20, 0, 'Belum dinilai', 0, 0);

    INSERT INTO tb_indikator_hows (id_how, keterangan, nilai, urutan)
    SELECT id_how, 'Dilakukan lebih cepat/lebih lengkap dari target dengan bukti valid dan tanpa rework mayor', 115, 1
      FROM tb_hows WHERE id_user = 171;
    INSERT INTO tb_indikator_hows (id_how, keterangan, nilai, urutan)
    SELECT id_how, 'Dilakukan 100% sesuai target/SLA dengan bukti valid', 100, 2
      FROM tb_hows WHERE id_user = 171;
    INSERT INTO tb_indikator_hows (id_how, keterangan, nilai, urutan)
    SELECT id_how, 'Dilakukan 90-99% atau ada minor gap yang tidak menghambat hasil', 90, 3
      FROM tb_hows WHERE id_user = 171;
    INSERT INTO tb_indikator_hows (id_how, keterangan, nilai, urutan)
    SELECT id_how, 'Dilakukan 75-89% atau terlambat dengan dampak ringan', 80, 4
      FROM tb_hows WHERE id_user = 171;
    INSERT INTO tb_indikator_hows (id_how, keterangan, nilai, urutan)
    SELECT id_how, 'Kurang dari 75%, tidak ada bukti, atau tidak dilakukan', 0, 5
      FROM tb_hows WHERE id_user = 171;

    /* Copy refined real KPI structure into simulation tables with fresh IDs. */
    INSERT INTO tbsim_whats (id_user, id_kpi, tipe_what, p_what, bobot, target_omset, hasil, nilai, total)
    SELECT 171,
           CASE k.poin
               WHEN 'KARISMA - HRIS (HUMAN RESOURCE INFORMATION SYSTEM)' THEN v_sim_hris
               WHEN 'Support KarismaERP' THEN v_sim_erp
               WHEN 'Stabilitas & Performa aplikasi' THEN v_sim_stability
               WHEN 'Pemeliharaan Sistem' THEN v_sim_maintenance
               WHEN 'Absensi' THEN v_sim_attendance
               WHEN 'Supporting maintenance hardware' THEN v_sim_hardware
           END,
           w.tipe_what, w.p_what, w.bobot, w.target_omset, w.hasil, w.nilai, w.total
      FROM tb_whats w
      JOIN tb_kpi k ON k.id = w.id_kpi
     WHERE w.id_user = 171
     ORDER BY k.id, w.id_what;

    INSERT INTO tbsim_hows (id_user, id_kpi, tipe_how, p_how, bobot, target_omset, hasil, nilai, total)
    SELECT 171,
           CASE k.poin
               WHEN 'KARISMA - HRIS (HUMAN RESOURCE INFORMATION SYSTEM)' THEN v_sim_hris
               WHEN 'Support KarismaERP' THEN v_sim_erp
               WHEN 'Stabilitas & Performa aplikasi' THEN v_sim_stability
               WHEN 'Pemeliharaan Sistem' THEN v_sim_maintenance
               WHEN 'Absensi' THEN v_sim_attendance
               WHEN 'Supporting maintenance hardware' THEN v_sim_hardware
           END,
           h.tipe_how, h.p_how, h.bobot, h.target_omset, h.hasil, h.nilai, h.total
      FROM tb_hows h
      JOIN tb_kpi k ON k.id = h.id_kpi
     WHERE h.id_user = 171
     ORDER BY k.id, h.id_how;

    INSERT INTO tbsim_indikator_whats (id_what, keterangan, nilai, urutan)
    SELECT sw.id_what, iw.keterangan, iw.nilai, iw.urutan
      FROM tb_whats w
      JOIN tb_kpi k ON k.id = w.id_kpi
      JOIN tb_indikator_whats iw ON iw.id_what = w.id_what
      JOIN tbsim_kpi sk ON sk.id_user = 171 AND sk.poin = k.poin
      JOIN tbsim_whats sw ON sw.id_user = 171
                         AND sw.id_kpi = sk.id
                         AND sw.p_what = w.p_what
                         AND sw.bobot = w.bobot
     WHERE w.id_user = 171
     ORDER BY sw.id_what, iw.urutan;

    INSERT INTO tbsim_indikator_hows (id_how, keterangan, nilai, urutan)
    SELECT sh.id_how, ih.keterangan, ih.nilai, ih.urutan
      FROM tb_hows h
      JOIN tb_kpi k ON k.id = h.id_kpi
      JOIN tb_indikator_hows ih ON ih.id_how = h.id_how
      JOIN tbsim_kpi sk ON sk.id_user = 171 AND sk.poin = k.poin
      JOIN tbsim_hows sh ON sh.id_user = 171
                        AND sh.id_kpi = sk.id
                        AND sh.p_how = h.p_how
                        AND sh.bobot = h.bobot
     WHERE h.id_user = 171
     ORDER BY sh.id_how, ih.urutan;

    SELECT COALESCE(SUM(bobot), 0) INTO v_user_count FROM tb_kpi WHERE id_user = 171;
    IF v_user_count <> 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Validasi gagal: total bobot WHAT tb_kpi bukan 100.';
    END IF;

    SELECT COALESCE(SUM(bobot2), 0) INTO v_user_count FROM tb_kpi WHERE id_user = 171;
    IF v_user_count <> 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Validasi gagal: total bobot HOW tb_kpi bukan 100.';
    END IF;

    SELECT COALESCE(SUM(bobot), 0) INTO v_user_count FROM tbsim_kpi WHERE id_user = 171;
    IF v_user_count <> 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Validasi gagal: total bobot WHAT tbsim_kpi bukan 100.';
    END IF;

    SELECT COALESCE(SUM(bobot2), 0) INTO v_user_count FROM tbsim_kpi WHERE id_user = 171;
    IF v_user_count <> 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Validasi gagal: total bobot HOW tbsim_kpi bukan 100.';
    END IF;

    SELECT COUNT(*)
      INTO v_user_count
      FROM (
            SELECT id_kpi
              FROM tb_whats
             WHERE id_user = 171
             GROUP BY id_kpi
            HAVING SUM(bobot) <> 100
           ) failed_what_weight;
    IF v_user_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Validasi gagal: ada bobot WHAT detail yang tidak 100.';
    END IF;

    SELECT COUNT(*)
      INTO v_user_count
      FROM (
            SELECT id_kpi
              FROM tb_hows
             WHERE id_user = 171
             GROUP BY id_kpi
            HAVING SUM(bobot) <> 100
           ) failed_how_weight;
    IF v_user_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Validasi gagal: ada bobot HOW detail yang tidak 100.';
    END IF;

    SELECT COUNT(*)
      INTO v_user_count
      FROM (
            SELECT id_kpi
              FROM tbsim_whats
             WHERE id_user = 171
             GROUP BY id_kpi
            HAVING SUM(bobot) <> 100
           ) failed_sim_what_weight;
    IF v_user_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Validasi gagal: ada bobot WHAT simulasi detail yang tidak 100.';
    END IF;

    SELECT COUNT(*)
      INTO v_user_count
      FROM (
            SELECT id_kpi
              FROM tbsim_hows
             WHERE id_user = 171
             GROUP BY id_kpi
            HAVING SUM(bobot) <> 100
           ) failed_sim_how_weight;
    IF v_user_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Validasi gagal: ada bobot HOW simulasi detail yang tidak 100.';
    END IF;

    COMMIT;
END $$

DELIMITER ;

CALL refine_kpi_hris_user_171();
DROP PROCEDURE IF EXISTS refine_kpi_hris_user_171;

SELECT 'tb_kpi' AS table_name, COUNT(*) AS rows_count, SUM(bobot) AS total_bobot_what, SUM(bobot2) AS total_bobot_how
  FROM tb_kpi
 WHERE id_user = 171;
SELECT id, poin, bobot, poin2, bobot2
  FROM tb_kpi
 WHERE id_user = 171
 ORDER BY id;
SELECT k.poin, COUNT(w.id_what) AS total_what, SUM(w.bobot) AS bobot_what_detail
  FROM tb_kpi k
  LEFT JOIN tb_whats w ON w.id_kpi = k.id AND w.id_user = k.id_user
 WHERE k.id_user = 171
 GROUP BY k.id, k.poin
 ORDER BY k.id;
SELECT k.poin, COUNT(h.id_how) AS total_how, SUM(h.bobot) AS bobot_how_detail
  FROM tb_kpi k
  LEFT JOIN tb_hows h ON h.id_kpi = k.id AND h.id_user = k.id_user
 WHERE k.id_user = 171
 GROUP BY k.id, k.poin
 ORDER BY k.id;
