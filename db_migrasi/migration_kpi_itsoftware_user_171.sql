-- Migration KPI IT Software untuk tb_users.id = 171
-- Database target: kiucoid_kpi
-- Dibuat: 2026-08-27
-- Catatan:
-- 1. Script ini hanya memodifikasi data KPI user 171.
-- 2. Struktur tabel tidak diubah.
-- 3. KPI existing user 171 pada database live sebelum migrasi kosong.
-- 4. Untuk menjaga idempotency dan mencegah duplicate, data KPI user 171
--    pada scope tabel KPI dihapus dulu secara terbatas lalu dibuat ulang.

START TRANSACTION;

DROP TEMPORARY TABLE IF EXISTS tmp_assert_guard;
CREATE TEMPORARY TABLE tmp_assert_guard (ok INT NOT NULL);

INSERT INTO tmp_assert_guard
SELECT CASE WHEN (SELECT COUNT(*) FROM tb_users WHERE id = 171) = 1 THEN 1 ELSE NULL END;
TRUNCATE tmp_assert_guard;

    DROP TEMPORARY TABLE IF EXISTS tmp_target_kpi;
    DROP TEMPORARY TABLE IF EXISTS tmp_target_what;
    DROP TEMPORARY TABLE IF EXISTS tmp_target_how;
    DROP TEMPORARY TABLE IF EXISTS tmp_indicator_profiles;
    DROP TEMPORARY TABLE IF EXISTS tmp_real_kpi_map;
    DROP TEMPORARY TABLE IF EXISTS tmp_real_what_map;
    DROP TEMPORARY TABLE IF EXISTS tmp_real_how_map;
    DROP TEMPORARY TABLE IF EXISTS tmp_sim_kpi_map;
    DROP TEMPORARY TABLE IF EXISTS tmp_sim_what_map;
    DROP TEMPORARY TABLE IF EXISTS tmp_sim_how_map;

    CREATE TEMPORARY TABLE tmp_target_kpi (
        seq INT PRIMARY KEY,
        poin TEXT NOT NULL,
        bobot DOUBLE NOT NULL,
        poin2 TEXT NOT NULL,
        bobot2 DOUBLE NOT NULL
    );

    CREATE TEMPORARY TABLE tmp_target_what (
        kpi_seq INT NOT NULL,
        seq INT NOT NULL,
        tipe_what ENUM('A','B') DEFAULT 'A',
        p_what TEXT NOT NULL,
        bobot DOUBLE NOT NULL,
        target_omset DECIMAL(15,2) DEFAULT 0.00,
        hasil TEXT NOT NULL,
        nilai DOUBLE NOT NULL,
        total DOUBLE NOT NULL,
        profile_key VARCHAR(80) NOT NULL,
        PRIMARY KEY (kpi_seq, seq)
    );

    CREATE TEMPORARY TABLE tmp_target_how (
        kpi_seq INT NOT NULL,
        seq INT NOT NULL,
        tipe_how ENUM('A','B') DEFAULT 'A',
        p_how TEXT NOT NULL,
        bobot DOUBLE NOT NULL,
        target_omset DECIMAL(15,2) DEFAULT 0.00,
        hasil TEXT NOT NULL,
        nilai DOUBLE NOT NULL,
        total DOUBLE NOT NULL,
        profile_key VARCHAR(80) NOT NULL,
        PRIMARY KEY (kpi_seq, seq)
    );

    CREATE TEMPORARY TABLE tmp_indicator_profiles (
        item_type ENUM('WHAT','HOW') NOT NULL,
        profile_key VARCHAR(80) NOT NULL,
        urutan INT NOT NULL,
        keterangan TEXT NOT NULL,
        nilai DECIMAL(5,2) NOT NULL,
        PRIMARY KEY (item_type, profile_key, urutan)
    );

    INSERT INTO tmp_target_kpi (seq, poin, bobot, poin2, bobot2) VALUES
    (1, 'Pembuatan dan Pengembangan KARISMA HRIS', 40, 'Pembuatan dan Pengembangan KARISMA HRIS', 40),
    (2, 'Pengembangan & Support KarismaERP', 20, 'Pengembangan & Support KarismaERP', 20),
    (3, 'Stabilitas & Performa Aplikasi', 15, 'Stabilitas & Performa Aplikasi', 15),
    (4, 'Pemeliharaan Sistem', 10, 'Pemeliharaan Sistem', 10),
    (5, 'Kehadiran & Kedisiplinan Kerja', 10, 'Kehadiran & Kedisiplinan Kerja', 10),
    (6, 'Bantuan Perbaikan Perangkat Kerja', 5, 'Bantuan Perbaikan Perangkat Kerja', 5);

    INSERT INTO tmp_target_what (kpi_seq, seq, tipe_what, p_what, bobot, target_omset, hasil, nilai, total, profile_key) VALUES
    (1, 1, 'A', 'Penyelesaian KARISMA HRIS', 55, 0, 'Belum dinilai', 0, 0, 'what_hris_completion'),
    (1, 2, 'A', 'Kesiapan KARISMA HRIS digunakan', 30, 0, 'Belum dinilai', 0, 0, 'what_hris_ready'),
    (1, 3, 'A', 'Dokumentasi dan Panduan KARISMA HRIS', 15, 0, 'Belum dinilai', 0, 0, 'what_hris_doc'),
    (2, 1, 'A', 'Pengembangan dan Penyempurnaan KarismaERP', 65, 0, 'Belum dinilai', 0, 0, 'what_erp_dev'),
    (2, 2, 'A', 'Penanganan Masalah KarismaERP', 25, 0, 'Belum dinilai', 0, 0, 'what_erp_issue'),
    (2, 3, 'A', 'Catatan Perubahan KarismaERP', 10, 0, 'Belum dinilai', 0, 0, 'what_report'),
    (3, 1, 'A', 'Menjaga Aplikasi Tetap Berjalan Dengan Baik', 70, 0, 'Belum dinilai', 0, 0, 'what_app_stability'),
    (3, 2, 'A', 'Laporan Kondisi Aplikasi', 30, 0, 'Belum dinilai', 0, 0, 'what_report'),
    (4, 1, 'A', 'Pemeliharaan Berkala', 70, 0, 'Belum dinilai', 0, 0, 'what_maintenance'),
    (4, 2, 'A', 'Laporan Pemeliharaan Sistem', 30, 0, 'Belum dinilai', 0, 0, 'what_report'),
    (5, 1, 'A', 'Kehadiran & Kedisiplinan Kerja', 100, 0, 'Belum dinilai', 0, 0, 'what_attendance'),
    (6, 1, 'A', 'Bantuan Perbaikan Perangkat Kerja', 100, 0, 'Belum dinilai', 0, 0, 'what_hardware');

    INSERT INTO tmp_target_how (kpi_seq, seq, tipe_how, p_how, bobot, target_omset, hasil, nilai, total, profile_key) VALUES
    (1, 1, 'A', 'Menjalankan pembuatan KARISMA HRIS sesuai urutan pekerjaan, target waktu dan kebutuhan yang telah disepakati.', 40, 0, 'Belum dinilai', 0, 0, 'how_hris_work'),
    (1, 2, 'A', 'Melakukan pengecekan setiap bagian aplikasi sebelum digunakan dan segera memperbaiki apabila ditemukan masalah.', 30, 0, 'Belum dinilai', 0, 0, 'how_hris_check'),
    (1, 3, 'A', 'Memastikan setiap bagian KARISMA HRIS saling mendukung dan data yang digunakan sesuai kebutuhan perusahaan.', 20, 0, 'Belum dinilai', 0, 0, 'how_hris_integration'),
    (1, 4, 'A', 'Membuat catatan pekerjaan, panduan penggunaan dan laporan perkembangan KARISMA HRIS.', 10, 0, 'Belum dinilai', 0, 0, 'how_doc'),
    (2, 1, 'A', 'Memahami kebutuhan pengguna sebelum melakukan perubahan atau penambahan KarismaERP.', 30, 0, 'Belum dinilai', 0, 0, 'how_need_analysis'),
    (2, 2, 'A', 'Membuat, memeriksa dan memastikan hasil penyempurnaan KarismaERP dapat digunakan dengan baik.', 40, 0, 'Belum dinilai', 0, 0, 'how_build_check'),
    (2, 3, 'A', 'Menangani laporan masalah KarismaERP sampai dapat digunakan kembali.', 20, 0, 'Belum dinilai', 0, 0, 'how_issue_handling'),
    (2, 4, 'A', 'Mencatat perubahan dan hasil pekerjaan KarismaERP.', 10, 0, 'Belum dinilai', 0, 0, 'how_doc'),
    (3, 1, 'A', 'Melakukan pengecekan aplikasi secara rutin dan segera melakukan perbaikan apabila ditemukan masalah.', 50, 0, 'Belum dinilai', 0, 0, 'how_routine_check'),
    (3, 2, 'A', 'Melakukan perbaikan terhadap bagian aplikasi yang lambat atau mengganggu pekerjaan pengguna.', 30, 0, 'Belum dinilai', 0, 0, 'how_performance_fix'),
    (3, 3, 'A', 'Mencatat masalah, penyebab dan tindakan perbaikan agar masalah yang sama tidak sering terjadi kembali.', 20, 0, 'Belum dinilai', 0, 0, 'how_doc'),
    (4, 1, 'A', 'Melakukan pengecekan aplikasi dan data sesuai jadwal.', 50, 0, 'Belum dinilai', 0, 0, 'how_scheduled_check'),
    (4, 2, 'A', 'Memastikan data penting memiliki salinan cadangan dan dapat digunakan apabila dibutuhkan.', 30, 0, 'Belum dinilai', 0, 0, 'how_backup'),
    (4, 3, 'A', 'Mencatat pekerjaan pemeliharaan, masalah yang ditemukan dan hasil perbaikannya.', 20, 0, 'Belum dinilai', 0, 0, 'how_doc'),
    (5, 1, 'A', 'Kehadiran dan ketepatan waktu', 50, 0, 'Belum dinilai', 0, 0, 'how_attendance_time'),
    (5, 2, 'A', 'Mengikuti briefing', 20, 0, 'Belum dinilai', 0, 0, 'how_briefing'),
    (5, 3, 'A', 'Menjalankan prosedur izin/cuti', 20, 0, 'Belum dinilai', 0, 0, 'how_leave_procedure'),
    (5, 4, 'A', 'Mengikuti kegiatan perusahaan yang diwajibkan', 10, 0, 'Belum dinilai', 0, 0, 'how_company_activity'),
    (6, 1, 'A', 'Menangani laporan masalah perangkat secara cepat dan tepat.', 60, 0, 'Belum dinilai', 0, 0, 'how_hardware_fast'),
    (6, 2, 'A', 'Memastikan perangkat dapat digunakan kembali dan mencatat pekerjaan perbaikan yang telah dilakukan.', 40, 0, 'Belum dinilai', 0, 0, 'how_hardware_done_doc');

    INSERT INTO tmp_indicator_profiles (item_type, profile_key, urutan, keterangan, nilai) VALUES
    ('WHAT', 'what_hris_completion', 1, 'Seluruh target selesai dan terdapat tambahan pengembangan yang bermanfaat', 115),
    ('WHAT', 'what_hris_completion', 2, 'Seluruh target selesai lebih cepat atau hasil melebihi target', 110),
    ('WHAT', 'what_hris_completion', 3, 'Seluruh target yang ditetapkan selesai sesuai waktu', 100),
    ('WHAT', 'what_hris_completion', 4, 'Penyelesaian mencapai 90-99%', 90),
    ('WHAT', 'what_hris_completion', 5, 'Penyelesaian mencapai 80-89%', 80),
    ('WHAT', 'what_hris_completion', 6, 'Penyelesaian mencapai 60-79%', 60),
    ('WHAT', 'what_hris_completion', 7, 'Penyelesaian mencapai 40-59%', 40),
    ('WHAT', 'what_hris_completion', 8, 'Belum menghasilkan hasil yang dapat digunakan', 0),
    ('WHAT', 'what_hris_ready', 1, 'Aplikasi berjalan sangat baik, tidak ada masalah utama dan terdapat peningkatan tambahan', 115),
    ('WHAT', 'what_hris_ready', 2, 'Aplikasi berjalan baik dan hanya terdapat masalah kecil', 110),
    ('WHAT', 'what_hris_ready', 3, 'Aplikasi dapat digunakan sesuai kebutuhan tanpa masalah yang menghambat pekerjaan', 100),
    ('WHAT', 'what_hris_ready', 4, 'Terdapat masalah namun dapat segera diselesaikan', 90),
    ('WHAT', 'what_hris_ready', 5, 'Masih terdapat beberapa bagian yang perlu diperbaiki', 80),
    ('WHAT', 'what_hris_ready', 6, 'Aplikasi dapat digunakan tetapi masih sering mengalami masalah', 60),
    ('WHAT', 'what_hris_ready', 7, 'Aplikasi belum siap digunakan secara penuh', 40),
    ('WHAT', 'what_hris_ready', 8, 'Aplikasi tidak dapat digunakan', 0),
    ('WHAT', 'what_hris_doc', 1, 'Dokumentasi lengkap, panduan tersedia dan sudah dilakukan penjelasan kepada pengguna', 115),
    ('WHAT', 'what_hris_doc', 2, 'Dokumentasi dan panduan 100% lengkap', 110),
    ('WHAT', 'what_hris_doc', 3, 'Seluruh fungsi utama sudah memiliki dokumentasi', 100),
    ('WHAT', 'what_hris_doc', 4, 'Dokumentasi mencapai 90%', 90),
    ('WHAT', 'what_hris_doc', 5, 'Dokumentasi mencapai 80%', 80),
    ('WHAT', 'what_hris_doc', 6, 'Dokumentasi mencapai 60%', 60),
    ('WHAT', 'what_hris_doc', 7, 'Dokumentasi kurang dari 60%', 40),
    ('WHAT', 'what_hris_doc', 8, 'Tidak ada dokumentasi', 0),
    ('WHAT', 'what_erp_dev', 1, 'Seluruh target selesai dan terdapat tambahan perbaikan yang memberikan manfaat nyata', 115),
    ('WHAT', 'what_erp_dev', 2, 'Seluruh target selesai dengan hasil melebihi kebutuhan awal', 110),
    ('WHAT', 'what_erp_dev', 3, 'Seluruh target pekerjaan selesai sesuai rencana', 100),
    ('WHAT', 'what_erp_dev', 4, '90-99% selesai', 90),
    ('WHAT', 'what_erp_dev', 5, '80-89% selesai', 80),
    ('WHAT', 'what_erp_dev', 6, '60-79% selesai', 60),
    ('WHAT', 'what_erp_dev', 7, '40-59% selesai', 40),
    ('WHAT', 'what_erp_dev', 8, 'Tidak terdapat hasil pekerjaan', 0),
    ('WHAT', 'what_erp_issue', 1, 'Seluruh masalah tertangani sangat cepat dan masalah yang sama tidak terjadi kembali', 115),
    ('WHAT', 'what_erp_issue', 2, 'Hampir seluruh masalah selesai lebih cepat dari target', 110),
    ('WHAT', 'what_erp_issue', 3, 'Seluruh masalah selesai sesuai waktu yang ditentukan', 100),
    ('WHAT', 'what_erp_issue', 4, 'Sebagian kecil penyelesaian terlambat', 90),
    ('WHAT', 'what_erp_issue', 5, 'Beberapa pekerjaan terlambat', 80),
    ('WHAT', 'what_erp_issue', 6, 'Banyak pekerjaan melewati waktu penyelesaian', 60),
    ('WHAT', 'what_erp_issue', 7, 'Penanganan masalah sering terlambat', 40),
    ('WHAT', 'what_erp_issue', 8, 'Masalah tidak ditangani', 0),
    ('WHAT', 'what_app_stability', 1, 'Tidak ada gangguan utama dan terdapat peningkatan kualitas aplikasi', 115),
    ('WHAT', 'what_app_stability', 2, 'Tidak ada gangguan utama selama periode penilaian', 110),
    ('WHAT', 'what_app_stability', 3, 'Maksimal terdapat 1 gangguan dan dapat segera diselesaikan', 100),
    ('WHAT', 'what_app_stability', 4, 'Terdapat gangguan kecil tetapi tidak menghambat pekerjaan', 90),
    ('WHAT', 'what_app_stability', 5, 'Terdapat beberapa gangguan', 80),
    ('WHAT', 'what_app_stability', 6, 'Gangguan cukup sering terjadi', 60),
    ('WHAT', 'what_app_stability', 7, 'Gangguan sering menghambat pekerjaan', 40),
    ('WHAT', 'what_app_stability', 8, 'Aplikasi tidak dapat digunakan dengan baik', 0),
    ('WHAT', 'what_maintenance', 1, 'Seluruh pemeliharaan terlaksana dan terdapat tambahan tindakan pencegahan', 115),
    ('WHAT', 'what_maintenance', 2, 'Seluruh pemeliharaan selesai sesuai jadwal', 110),
    ('WHAT', 'what_maintenance', 3, 'Minimal 95% pekerjaan pemeliharaan selesai', 100),
    ('WHAT', 'what_maintenance', 4, '90-94% selesai', 90),
    ('WHAT', 'what_maintenance', 5, '80-89% selesai', 80),
    ('WHAT', 'what_maintenance', 6, '60-79% selesai', 60),
    ('WHAT', 'what_maintenance', 7, 'Kurang dari 60% selesai', 40),
    ('WHAT', 'what_maintenance', 8, 'Tidak dilakukan', 0),
    ('WHAT', 'what_hardware', 1, 'Seluruh pekerjaan selesai sangat baik dan masalah yang sama tidak berulang', 115),
    ('WHAT', 'what_hardware', 2, 'Hampir seluruh pekerjaan selesai lebih cepat', 110),
    ('WHAT', 'what_hardware', 3, 'Seluruh pekerjaan selesai sesuai target', 100),
    ('WHAT', 'what_hardware', 4, '90% pekerjaan sesuai target', 90),
    ('WHAT', 'what_hardware', 5, '80% pekerjaan sesuai target', 80),
    ('WHAT', 'what_hardware', 6, '60% pekerjaan sesuai target', 60),
    ('WHAT', 'what_hardware', 7, 'Kurang dari 60% pekerjaan sesuai target', 40),
    ('WHAT', 'what_hardware', 8, 'Tidak menjalankan pekerjaan', 0),
    ('WHAT', 'what_report', 1, 'Laporan sangat lengkap, tepat waktu, dan berisi tindak lanjut yang jelas', 115),
    ('WHAT', 'what_report', 2, 'Laporan lengkap dan selesai lebih cepat dari jadwal', 110),
    ('WHAT', 'what_report', 3, 'Laporan lengkap dan selesai sesuai jadwal', 100),
    ('WHAT', 'what_report', 4, 'Laporan hampir lengkap dan hanya ada kekurangan kecil', 90),
    ('WHAT', 'what_report', 5, 'Laporan cukup lengkap tetapi masih perlu beberapa perbaikan', 80),
    ('WHAT', 'what_report', 6, 'Laporan kurang lengkap atau sering terlambat', 60),
    ('WHAT', 'what_report', 7, 'Laporan sangat kurang dan sulit digunakan sebagai acuan', 40),
    ('WHAT', 'what_report', 8, 'Tidak membuat laporan', 0),
    ('WHAT', 'what_attendance', 1, 'Kehadiran, ketepatan waktu, briefing, izin/cuti, dan kegiatan wajib terlaksana sangat baik tanpa pelanggaran', 115),
    ('WHAT', 'what_attendance', 2, 'Kedisiplinan kerja sangat baik dan melebihi standar yang ditetapkan', 110),
    ('WHAT', 'what_attendance', 3, 'Kehadiran dan kedisiplinan kerja sesuai aturan perusahaan', 100),
    ('WHAT', 'what_attendance', 4, 'Terdapat kekurangan kecil tetapi tidak mengganggu pekerjaan', 90),
    ('WHAT', 'what_attendance', 5, 'Beberapa aturan kedisiplinan belum konsisten dijalankan', 80),
    ('WHAT', 'what_attendance', 6, 'Kedisiplinan kurang dan perlu banyak perbaikan', 60),
    ('WHAT', 'what_attendance', 7, 'Kedisiplinan sering tidak sesuai aturan', 40),
    ('WHAT', 'what_attendance', 8, 'Tidak menjalankan aturan kehadiran dan kedisiplinan kerja', 0);

    INSERT INTO tmp_indicator_profiles (item_type, profile_key, urutan, keterangan, nilai) VALUES
    ('HOW', 'how_hris_work', 1, 'Seluruh pekerjaan selesai lebih cepat dan terdapat tambahan hasil yang bermanfaat', 115),
    ('HOW', 'how_hris_work', 2, 'Seluruh pekerjaan selesai tepat waktu tanpa pekerjaan tertunda', 110),
    ('HOW', 'how_hris_work', 3, 'Minimal 95% pekerjaan selesai sesuai jadwal', 100),
    ('HOW', 'how_hris_work', 4, '85-94% pekerjaan selesai sesuai jadwal', 90),
    ('HOW', 'how_hris_work', 5, '75-84% pekerjaan selesai sesuai jadwal', 80),
    ('HOW', 'how_hris_work', 6, '60-74% pekerjaan selesai sesuai jadwal', 60),
    ('HOW', 'how_hris_work', 7, 'Kurang dari 60% pekerjaan selesai', 40),
    ('HOW', 'how_hris_work', 8, 'Tidak terdapat perkembangan pekerjaan yang terukur', 0),
    ('HOW', 'how_hris_check', 1, 'Pengecekan lengkap, tidak terdapat masalah utama dan terdapat peningkatan tambahan', 115),
    ('HOW', 'how_hris_check', 2, 'Pengecekan lengkap dan hanya ditemukan masalah kecil', 110),
    ('HOW', 'how_hris_check', 3, 'Seluruh bagian utama sudah diperiksa dan dapat digunakan', 100),
    ('HOW', 'how_hris_check', 4, 'Terdapat masalah tetapi seluruhnya dapat diselesaikan tepat waktu', 90),
    ('HOW', 'how_hris_check', 5, 'Masih terdapat beberapa perbaikan kecil', 80),
    ('HOW', 'how_hris_check', 6, 'Pengecekan dilakukan tetapi masih terdapat masalah berulang', 60),
    ('HOW', 'how_hris_check', 7, 'Pengecekan belum lengkap', 40),
    ('HOW', 'how_hris_check', 8, 'Tidak dilakukan pengecekan', 0),
    ('HOW', 'how_hris_integration', 1, 'Seluruh bagian HRIS saling mendukung sangat baik dan data sesuai kebutuhan perusahaan', 115),
    ('HOW', 'how_hris_integration', 2, 'Integrasi data berjalan baik dan melebihi kebutuhan awal', 110),
    ('HOW', 'how_hris_integration', 3, 'Seluruh bagian utama HRIS saling mendukung dan data sesuai kebutuhan', 100),
    ('HOW', 'how_hris_integration', 4, 'Sebagian kecil data atau alur perlu penyesuaian tetapi tidak menghambat pekerjaan', 90),
    ('HOW', 'how_hris_integration', 5, 'Beberapa bagian HRIS masih perlu disesuaikan', 80),
    ('HOW', 'how_hris_integration', 6, 'Integrasi dilakukan tetapi masih sering terdapat masalah data atau alur', 60),
    ('HOW', 'how_hris_integration', 7, 'Integrasi belum lengkap dan banyak bagian belum saling mendukung', 40),
    ('HOW', 'how_hris_integration', 8, 'Tidak ada integrasi atau kesesuaian data yang dapat digunakan', 0),
    ('HOW', 'how_doc', 1, 'Catatan pekerjaan, dokumentasi, dan laporan lengkap, tepat waktu, serta mudah ditindaklanjuti', 115),
    ('HOW', 'how_doc', 2, 'Dokumentasi lengkap dan selesai lebih cepat dari jadwal', 110),
    ('HOW', 'how_doc', 3, 'Dokumentasi lengkap dan selesai sesuai jadwal', 100),
    ('HOW', 'how_doc', 4, 'Dokumentasi hampir lengkap dan hanya ada kekurangan kecil', 90),
    ('HOW', 'how_doc', 5, 'Dokumentasi cukup lengkap tetapi perlu beberapa perbaikan', 80),
    ('HOW', 'how_doc', 6, 'Dokumentasi kurang lengkap atau sering terlambat', 60),
    ('HOW', 'how_doc', 7, 'Dokumentasi sangat kurang dan sulit digunakan', 40),
    ('HOW', 'how_doc', 8, 'Tidak membuat catatan atau dokumentasi', 0),
    ('HOW', 'how_need_analysis', 1, 'Kebutuhan pengguna dipahami sangat baik dan menghasilkan solusi yang lebih bermanfaat', 115),
    ('HOW', 'how_need_analysis', 2, 'Kebutuhan pengguna dipahami lengkap lebih cepat dari target', 110),
    ('HOW', 'how_need_analysis', 3, 'Kebutuhan pengguna dipahami sesuai kebutuhan pekerjaan', 100),
    ('HOW', 'how_need_analysis', 4, 'Kebutuhan pengguna hampir lengkap dipahami', 90),
    ('HOW', 'how_need_analysis', 5, 'Sebagian kebutuhan pengguna masih perlu diperjelas', 80),
    ('HOW', 'how_need_analysis', 6, 'Analisis kebutuhan kurang lengkap', 60),
    ('HOW', 'how_need_analysis', 7, 'Analisis kebutuhan sering tidak sesuai dengan masalah pengguna', 40),
    ('HOW', 'how_need_analysis', 8, 'Tidak melakukan analisis kebutuhan pengguna', 0),
    ('HOW', 'how_build_check', 1, 'Pekerjaan dibuat dan diperiksa sangat baik serta memberikan manfaat tambahan', 115),
    ('HOW', 'how_build_check', 2, 'Pekerjaan selesai lebih cepat dan hasil melebihi kebutuhan awal', 110),
    ('HOW', 'how_build_check', 3, 'Pekerjaan dibuat, diperiksa, dan dapat digunakan sesuai kebutuhan', 100),
    ('HOW', 'how_build_check', 4, 'Pekerjaan hampir sesuai dan hanya perlu perbaikan kecil', 90),
    ('HOW', 'how_build_check', 5, 'Pekerjaan dapat digunakan tetapi masih perlu beberapa perbaikan', 80),
    ('HOW', 'how_build_check', 6, 'Pekerjaan kurang stabil atau sering perlu perbaikan ulang', 60),
    ('HOW', 'how_build_check', 7, 'Pekerjaan belum dapat digunakan dengan baik', 40),
    ('HOW', 'how_build_check', 8, 'Tidak ada hasil pekerjaan yang dapat digunakan', 0),
    ('HOW', 'how_issue_handling', 1, 'Seluruh laporan masalah tertangani sangat cepat dan masalah tidak berulang', 115),
    ('HOW', 'how_issue_handling', 2, 'Hampir seluruh masalah selesai lebih cepat dari target', 110),
    ('HOW', 'how_issue_handling', 3, 'Seluruh masalah selesai sesuai target dan aplikasi dapat digunakan kembali', 100),
    ('HOW', 'how_issue_handling', 4, 'Sebagian kecil penyelesaian terlambat tetapi dampak dapat dikendalikan', 90),
    ('HOW', 'how_issue_handling', 5, 'Beberapa masalah terlambat diselesaikan', 80),
    ('HOW', 'how_issue_handling', 6, 'Banyak masalah melewati waktu penyelesaian', 60),
    ('HOW', 'how_issue_handling', 7, 'Penanganan masalah sering terlambat atau kurang tepat', 40),
    ('HOW', 'how_issue_handling', 8, 'Masalah tidak ditangani', 0),
    ('HOW', 'how_routine_check', 1, 'Pengecekan rutin sangat lengkap dan terdapat tindakan pencegahan tambahan', 115),
    ('HOW', 'how_routine_check', 2, 'Pengecekan rutin lengkap dan masalah diselesaikan lebih cepat', 110),
    ('HOW', 'how_routine_check', 3, 'Pengecekan rutin dilakukan dan masalah diselesaikan sesuai kebutuhan', 100),
    ('HOW', 'how_routine_check', 4, 'Pengecekan hampir lengkap dan masalah kecil dapat diselesaikan', 90),
    ('HOW', 'how_routine_check', 5, 'Pengecekan dilakukan tetapi beberapa bagian terlewat', 80),
    ('HOW', 'how_routine_check', 6, 'Pengecekan tidak konsisten dan masalah sering terlambat diketahui', 60),
    ('HOW', 'how_routine_check', 7, 'Pengecekan sangat kurang', 40),
    ('HOW', 'how_routine_check', 8, 'Tidak melakukan pengecekan aplikasi', 0),
    ('HOW', 'how_performance_fix', 1, 'Perbaikan performa sangat baik dan memberi peningkatan nyata bagi pengguna', 115),
    ('HOW', 'how_performance_fix', 2, 'Perbaikan selesai lebih cepat dan hasil melebihi kebutuhan', 110),
    ('HOW', 'how_performance_fix', 3, 'Bagian aplikasi yang lambat atau mengganggu berhasil diperbaiki sesuai target', 100),
    ('HOW', 'how_performance_fix', 4, 'Sebagian kecil perbaikan masih perlu penyempurnaan', 90),
    ('HOW', 'how_performance_fix', 5, 'Perbaikan dilakukan tetapi beberapa gangguan masih muncul', 80),
    ('HOW', 'how_performance_fix', 6, 'Perbaikan kurang efektif dan masalah cukup sering berulang', 60),
    ('HOW', 'how_performance_fix', 7, 'Perbaikan tidak menyelesaikan masalah utama', 40),
    ('HOW', 'how_performance_fix', 8, 'Tidak melakukan perbaikan performa', 0),
    ('HOW', 'how_scheduled_check', 1, 'Pengecekan aplikasi dan data sesuai jadwal, lengkap, dan disertai tindakan pencegahan tambahan', 115),
    ('HOW', 'how_scheduled_check', 2, 'Pengecekan selesai lebih cepat dan lengkap', 110),
    ('HOW', 'how_scheduled_check', 3, 'Pengecekan aplikasi dan data selesai sesuai jadwal', 100),
    ('HOW', 'how_scheduled_check', 4, 'Pengecekan hampir sesuai jadwal dan hanya ada kekurangan kecil', 90),
    ('HOW', 'how_scheduled_check', 5, 'Pengecekan cukup berjalan tetapi beberapa jadwal terlewat', 80),
    ('HOW', 'how_scheduled_check', 6, 'Pengecekan tidak konsisten', 60),
    ('HOW', 'how_scheduled_check', 7, 'Pengecekan sangat kurang', 40),
    ('HOW', 'how_scheduled_check', 8, 'Tidak melakukan pengecekan sesuai jadwal', 0),
    ('HOW', 'how_backup', 1, 'Seluruh data penting memiliki salinan cadangan yang terverifikasi dan siap digunakan', 115),
    ('HOW', 'how_backup', 2, 'Backup lengkap dan verifikasi selesai lebih cepat dari jadwal', 110),
    ('HOW', 'how_backup', 3, 'Data penting memiliki backup dan dapat digunakan bila dibutuhkan', 100),
    ('HOW', 'how_backup', 4, 'Backup tersedia dengan kekurangan kecil yang tidak menghambat pemulihan', 90),
    ('HOW', 'how_backup', 5, 'Backup tersedia tetapi belum sepenuhnya lengkap', 80),
    ('HOW', 'how_backup', 6, 'Backup kurang konsisten atau jarang diverifikasi', 60),
    ('HOW', 'how_backup', 7, 'Backup sangat kurang dan berisiko tidak dapat digunakan', 40),
    ('HOW', 'how_backup', 8, 'Tidak memastikan salinan cadangan data penting', 0),
    ('HOW', 'how_attendance_time', 1, 'Kehadiran dan ketepatan waktu sangat baik tanpa pelanggaran', 115),
    ('HOW', 'how_attendance_time', 2, 'Kehadiran dan ketepatan waktu melebihi standar yang ditetapkan', 110),
    ('HOW', 'how_attendance_time', 3, 'Kehadiran dan ketepatan waktu sesuai aturan', 100),
    ('HOW', 'how_attendance_time', 4, 'Terdapat kekurangan kecil pada ketepatan waktu', 90),
    ('HOW', 'how_attendance_time', 5, 'Ketepatan waktu belum konsisten', 80),
    ('HOW', 'how_attendance_time', 6, 'Kehadiran atau ketepatan waktu sering perlu diperbaiki', 60),
    ('HOW', 'how_attendance_time', 7, 'Kehadiran atau ketepatan waktu sering tidak sesuai aturan', 40),
    ('HOW', 'how_attendance_time', 8, 'Tidak menjalankan aturan kehadiran dan ketepatan waktu', 0),
    ('HOW', 'how_briefing', 1, 'Selalu mengikuti briefing dengan disiplin dan aktif mendukung kelancaran informasi', 115),
    ('HOW', 'how_briefing', 2, 'Mengikuti briefing sangat baik dan melebihi standar kehadiran', 110),
    ('HOW', 'how_briefing', 3, 'Mengikuti briefing sesuai jadwal yang berlaku', 100),
    ('HOW', 'how_briefing', 4, 'Hampir seluruh briefing diikuti dengan baik', 90),
    ('HOW', 'how_briefing', 5, 'Beberapa briefing tidak diikuti atau terlambat', 80),
    ('HOW', 'how_briefing', 6, 'Briefing sering tidak diikuti dengan konsisten', 60),
    ('HOW', 'how_briefing', 7, 'Briefing sangat sering terlewat', 40),
    ('HOW', 'how_briefing', 8, 'Tidak mengikuti briefing', 0),
    ('HOW', 'how_leave_procedure', 1, 'Seluruh izin/cuti mengikuti prosedur dengan lengkap, cepat, dan terdokumentasi', 115),
    ('HOW', 'how_leave_procedure', 2, 'Prosedur izin/cuti dijalankan sangat baik dan lebih rapi dari standar', 110),
    ('HOW', 'how_leave_procedure', 3, 'Prosedur izin/cuti dijalankan sesuai aturan', 100),
    ('HOW', 'how_leave_procedure', 4, 'Ada kekurangan kecil tetapi prosedur tetap terpenuhi', 90),
    ('HOW', 'how_leave_procedure', 5, 'Beberapa prosedur perlu diperbaiki', 80),
    ('HOW', 'how_leave_procedure', 6, 'Prosedur izin/cuti kurang konsisten dijalankan', 60),
    ('HOW', 'how_leave_procedure', 7, 'Prosedur izin/cuti sering tidak sesuai aturan', 40),
    ('HOW', 'how_leave_procedure', 8, 'Tidak menjalankan prosedur izin/cuti', 0),
    ('HOW', 'how_company_activity', 1, 'Seluruh kegiatan wajib diikuti sangat baik dan aktif mendukung pelaksanaan kegiatan', 115),
    ('HOW', 'how_company_activity', 2, 'Kegiatan wajib diikuti sangat baik dan melebihi standar', 110),
    ('HOW', 'how_company_activity', 3, 'Kegiatan wajib perusahaan diikuti sesuai aturan', 100),
    ('HOW', 'how_company_activity', 4, 'Hampir seluruh kegiatan wajib diikuti dengan baik', 90),
    ('HOW', 'how_company_activity', 5, 'Beberapa kegiatan wajib belum konsisten diikuti', 80),
    ('HOW', 'how_company_activity', 6, 'Kegiatan wajib sering tidak diikuti', 60),
    ('HOW', 'how_company_activity', 7, 'Kegiatan wajib sangat sering terlewat', 40),
    ('HOW', 'how_company_activity', 8, 'Tidak mengikuti kegiatan wajib perusahaan', 0),
    ('HOW', 'how_hardware_fast', 1, 'Seluruh laporan perangkat ditangani sangat cepat, tepat, dan masalah tidak berulang', 115),
    ('HOW', 'how_hardware_fast', 2, 'Hampir seluruh laporan perangkat selesai lebih cepat dari target', 110),
    ('HOW', 'how_hardware_fast', 3, 'Laporan perangkat ditangani cepat dan tepat sesuai target', 100),
    ('HOW', 'how_hardware_fast', 4, 'Sebagian kecil penanganan terlambat tetapi perangkat tetap dapat digunakan', 90),
    ('HOW', 'how_hardware_fast', 5, 'Beberapa penanganan perangkat terlambat', 80),
    ('HOW', 'how_hardware_fast', 6, 'Banyak penanganan perangkat melewati target', 60),
    ('HOW', 'how_hardware_fast', 7, 'Penanganan perangkat sering terlambat atau kurang tepat', 40),
    ('HOW', 'how_hardware_fast', 8, 'Tidak menangani laporan masalah perangkat', 0),
    ('HOW', 'how_hardware_done_doc', 1, 'Perangkat kembali digunakan dengan baik dan catatan perbaikan lengkap serta mudah ditindaklanjuti', 115),
    ('HOW', 'how_hardware_done_doc', 2, 'Perangkat kembali digunakan lebih cepat dan dokumentasi lengkap', 110),
    ('HOW', 'how_hardware_done_doc', 3, 'Perangkat dapat digunakan kembali dan pekerjaan perbaikan tercatat sesuai target', 100),
    ('HOW', 'how_hardware_done_doc', 4, 'Perangkat dapat digunakan dengan catatan perbaikan yang hampir lengkap', 90),
    ('HOW', 'how_hardware_done_doc', 5, 'Perangkat dapat digunakan tetapi catatan perbaikan perlu dilengkapi', 80),
    ('HOW', 'how_hardware_done_doc', 6, 'Perangkat dapat digunakan sebagian atau dokumentasi kurang lengkap', 60),
    ('HOW', 'how_hardware_done_doc', 7, 'Hasil perbaikan kurang jelas dan catatan sangat minim', 40),
    ('HOW', 'how_hardware_done_doc', 8, 'Tidak memastikan perangkat dapat digunakan atau tidak mencatat perbaikan', 0);

    INSERT INTO tmp_assert_guard
    SELECT CASE WHEN ABS((SELECT SUM(bobot) FROM tmp_target_kpi) - 100) <= 0.0001 THEN 1 ELSE NULL END;
    TRUNCATE tmp_assert_guard;

    INSERT INTO tmp_assert_guard
    SELECT CASE WHEN ABS((SELECT SUM(bobot2) FROM tmp_target_kpi) - 100) <= 0.0001 THEN 1 ELSE NULL END;
    TRUNCATE tmp_assert_guard;

    INSERT INTO tmp_assert_guard
    SELECT CASE WHEN (
        SELECT COUNT(*)
          FROM (
                SELECT kpi_seq, SUM(bobot) total_bobot
                  FROM tmp_target_what
                 GROUP BY kpi_seq
                HAVING ABS(SUM(bobot) - 100) > 0.0001
               ) x
    ) = 0 THEN 1 ELSE NULL END;
    TRUNCATE tmp_assert_guard;

    INSERT INTO tmp_assert_guard
    SELECT CASE WHEN (
        SELECT COUNT(*)
          FROM (
                SELECT kpi_seq, SUM(bobot) total_bobot
                  FROM tmp_target_how
                 GROUP BY kpi_seq
                HAVING ABS(SUM(bobot) - 100) > 0.0001
               ) x
    ) = 0 THEN 1 ELSE NULL END;
    TRUNCATE tmp_assert_guard;

    DELETE iw FROM tb_indikator_whats iw
      JOIN tb_whats w ON w.id_what = iw.id_what
     WHERE w.id_user = 171;
    DELETE ih FROM tb_indikator_hows ih
      JOIN tb_hows h ON h.id_how = ih.id_how
     WHERE h.id_user = 171;
    DELETE FROM tb_whats WHERE id_user = 171;
    DELETE FROM tb_hows WHERE id_user = 171;
    DELETE FROM tb_kpi WHERE id_user = 171;
    DELETE FROM tb_bobotkpi WHERE id_user = 171;

    DELETE iw FROM tbsim_indikator_whats iw
      JOIN tbsim_whats w ON w.id_what = iw.id_what
     WHERE w.id_user = 171;
    DELETE ih FROM tbsim_indikator_hows ih
      JOIN tbsim_hows h ON h.id_how = ih.id_how
     WHERE h.id_user = 171;
    DELETE FROM tbsim_whats WHERE id_user = 171;
    DELETE FROM tbsim_hows WHERE id_user = 171;
    DELETE FROM tbsim_kpi WHERE id_user = 171;
    DELETE FROM tbsim_bobotkpi WHERE id_user = 171;

    INSERT INTO tb_bobotkpi (id_user, bobotwhat, bobothow)
    VALUES (171, 60, 40);

    INSERT INTO tb_kpi (id_user, poin, bobot, poin2, bobot2)
    SELECT 171, poin, bobot, poin2, bobot2
      FROM tmp_target_kpi
     ORDER BY seq;

    CREATE TEMPORARY TABLE tmp_real_kpi_map AS
    SELECT t.seq, k.id
      FROM tmp_target_kpi t
      JOIN tb_kpi k ON k.id_user = 171 AND k.poin = t.poin;

    INSERT INTO tb_whats (id_user, id_kpi, tipe_what, p_what, bobot, target_omset, hasil, nilai, total)
    SELECT 171, km.id, tw.tipe_what, tw.p_what, tw.bobot, tw.target_omset, tw.hasil, tw.nilai, tw.total
      FROM tmp_target_what tw
      JOIN tmp_real_kpi_map km ON km.seq = tw.kpi_seq
     ORDER BY tw.kpi_seq, tw.seq;

    CREATE TEMPORARY TABLE tmp_real_what_map AS
    SELECT tw.kpi_seq, tw.seq, w.id_what
      FROM tmp_target_what tw
      JOIN tmp_real_kpi_map km ON km.seq = tw.kpi_seq
      JOIN tb_whats w ON w.id_user = 171 AND w.id_kpi = km.id AND w.p_what = tw.p_what;

    INSERT INTO tb_indikator_whats (id_what, keterangan, nilai, urutan)
    SELECT wm.id_what, ip.keterangan, ip.nilai, ip.urutan
      FROM tmp_target_what tw
      JOIN tmp_real_what_map wm ON wm.kpi_seq = tw.kpi_seq AND wm.seq = tw.seq
      JOIN tmp_indicator_profiles ip ON ip.item_type = 'WHAT' AND ip.profile_key = tw.profile_key
     ORDER BY tw.kpi_seq, tw.seq, ip.urutan;

    INSERT INTO tb_hows (id_user, id_kpi, tipe_how, p_how, bobot, target_omset, hasil, nilai, total)
    SELECT 171, km.id, th.tipe_how, th.p_how, th.bobot, th.target_omset, th.hasil, th.nilai, th.total
      FROM tmp_target_how th
      JOIN tmp_real_kpi_map km ON km.seq = th.kpi_seq
     ORDER BY th.kpi_seq, th.seq;

    CREATE TEMPORARY TABLE tmp_real_how_map AS
    SELECT th.kpi_seq, th.seq, h.id_how
      FROM tmp_target_how th
      JOIN tmp_real_kpi_map km ON km.seq = th.kpi_seq
      JOIN tb_hows h ON h.id_user = 171 AND h.id_kpi = km.id AND h.p_how = th.p_how;

    INSERT INTO tb_indikator_hows (id_how, keterangan, nilai, urutan)
    SELECT hm.id_how, ip.keterangan, ip.nilai, ip.urutan
      FROM tmp_target_how th
      JOIN tmp_real_how_map hm ON hm.kpi_seq = th.kpi_seq AND hm.seq = th.seq
      JOIN tmp_indicator_profiles ip ON ip.item_type = 'HOW' AND ip.profile_key = th.profile_key
     ORDER BY th.kpi_seq, th.seq, ip.urutan;

    INSERT INTO tbsim_bobotkpi (id_user, bobotwhat, bobothow)
    SELECT id_user, bobotwhat, bobothow
      FROM tb_bobotkpi
     WHERE id_user = 171;

    INSERT INTO tbsim_kpi (id_user, poin, bobot, poin2, bobot2)
    SELECT id_user, poin, bobot, poin2, bobot2
      FROM tb_kpi
     WHERE id_user = 171
     ORDER BY id;

    CREATE TEMPORARY TABLE tmp_sim_kpi_map AS
    SELECT rk.seq, sk.id
      FROM tmp_real_kpi_map rk
      JOIN tb_kpi tk ON tk.id = rk.id
      JOIN tbsim_kpi sk ON sk.id_user = 171 AND sk.poin = tk.poin;

    INSERT INTO tbsim_whats (id_user, id_kpi, tipe_what, p_what, bobot, target_omset, hasil, nilai, total)
    SELECT 171, skm.id, w.tipe_what, w.p_what, w.bobot, w.target_omset, COALESCE(w.hasil, ''), w.nilai, w.total
      FROM tmp_real_what_map rwm
      JOIN tmp_real_kpi_map rkm ON rkm.seq = rwm.kpi_seq
      JOIN tmp_sim_kpi_map skm ON skm.seq = rwm.kpi_seq
      JOIN tb_whats w ON w.id_what = rwm.id_what
     ORDER BY rwm.kpi_seq, rwm.seq;

    CREATE TEMPORARY TABLE tmp_sim_what_map AS
    SELECT rwm.kpi_seq, rwm.seq, sw.id_what
      FROM tmp_real_what_map rwm
      JOIN tb_whats rw ON rw.id_what = rwm.id_what
      JOIN tmp_sim_kpi_map skm ON skm.seq = rwm.kpi_seq
      JOIN tbsim_whats sw ON sw.id_user = 171 AND sw.id_kpi = skm.id AND sw.p_what = rw.p_what;

    INSERT INTO tbsim_indikator_whats (id_what, keterangan, nilai, urutan)
    SELECT swm.id_what, iw.keterangan, iw.nilai, iw.urutan
      FROM tmp_real_what_map rwm
      JOIN tmp_sim_what_map swm ON swm.kpi_seq = rwm.kpi_seq AND swm.seq = rwm.seq
      JOIN tb_indikator_whats iw ON iw.id_what = rwm.id_what
     ORDER BY swm.kpi_seq, swm.seq, iw.urutan;

    INSERT INTO tbsim_hows (id_user, id_kpi, tipe_how, p_how, bobot, target_omset, hasil, nilai, total)
    SELECT 171, skm.id, h.tipe_how, h.p_how, h.bobot, h.target_omset, COALESCE(h.hasil, ''), h.nilai, h.total
      FROM tmp_real_how_map rhm
      JOIN tmp_real_kpi_map rkm ON rkm.seq = rhm.kpi_seq
      JOIN tmp_sim_kpi_map skm ON skm.seq = rhm.kpi_seq
      JOIN tb_hows h ON h.id_how = rhm.id_how
     ORDER BY rhm.kpi_seq, rhm.seq;

    CREATE TEMPORARY TABLE tmp_sim_how_map AS
    SELECT rhm.kpi_seq, rhm.seq, sh.id_how
      FROM tmp_real_how_map rhm
      JOIN tb_hows rh ON rh.id_how = rhm.id_how
      JOIN tmp_sim_kpi_map skm ON skm.seq = rhm.kpi_seq
      JOIN tbsim_hows sh ON sh.id_user = 171 AND sh.id_kpi = skm.id AND sh.p_how = rh.p_how;

    INSERT INTO tbsim_indikator_hows (id_how, keterangan, nilai, urutan)
    SELECT shm.id_how, ih.keterangan, ih.nilai, ih.urutan
      FROM tmp_real_how_map rhm
      JOIN tmp_sim_how_map shm ON shm.kpi_seq = rhm.kpi_seq AND shm.seq = rhm.seq
      JOIN tb_indikator_hows ih ON ih.id_how = rhm.id_how
     ORDER BY shm.kpi_seq, shm.seq, ih.urutan;

    INSERT INTO tmp_assert_guard
    SELECT CASE WHEN
        (SELECT COUNT(*) FROM tb_kpi WHERE id_user = 171) = 6
        AND (SELECT COUNT(*) FROM tbsim_kpi WHERE id_user = 171) = 6
        AND ABS((SELECT SUM(bobot) FROM tb_kpi WHERE id_user = 171) - 100) <= 0.0001
        AND ABS((SELECT SUM(bobot2) FROM tb_kpi WHERE id_user = 171) - 100) <= 0.0001
        AND ABS((SELECT SUM(bobot) FROM tbsim_kpi WHERE id_user = 171) - 100) <= 0.0001
        AND ABS((SELECT SUM(bobot2) FROM tbsim_kpi WHERE id_user = 171) - 100) <= 0.0001
        AND (SELECT COUNT(*) FROM tb_whats WHERE id_user = 171) = 12
        AND (SELECT COUNT(*) FROM tbsim_whats WHERE id_user = 171) = 12
        AND (SELECT COUNT(*) FROM tb_hows WHERE id_user = 171) = 20
        AND (SELECT COUNT(*) FROM tbsim_hows WHERE id_user = 171) = 20
        AND (
            SELECT COUNT(*)
              FROM (
                    SELECT k.id, SUM(w.bobot) total_bobot
                      FROM tb_kpi k
                      JOIN tb_whats w ON w.id_kpi = k.id AND w.id_user = k.id_user
                     WHERE k.id_user = 171
                     GROUP BY k.id
                    HAVING ABS(SUM(w.bobot) - 100) > 0.0001
                   ) x
        ) = 0
        AND (
            SELECT COUNT(*)
              FROM (
                    SELECT k.id, SUM(h.bobot) total_bobot
                      FROM tb_kpi k
                      JOIN tb_hows h ON h.id_kpi = k.id AND h.id_user = k.id_user
                     WHERE k.id_user = 171
                     GROUP BY k.id
                    HAVING ABS(SUM(h.bobot) - 100) > 0.0001
                   ) x
        ) = 0
        AND (SELECT COUNT(*) FROM tb_whats w LEFT JOIN tb_kpi k ON k.id = w.id_kpi AND k.id_user = w.id_user WHERE w.id_user = 171 AND k.id IS NULL) = 0
        AND (SELECT COUNT(*) FROM tb_hows h LEFT JOIN tb_kpi k ON k.id = h.id_kpi AND k.id_user = h.id_user WHERE h.id_user = 171 AND k.id IS NULL) = 0
        AND (
            SELECT COUNT(*)
              FROM (
                    SELECT id_what, COUNT(*) indicator_count
                      FROM tb_indikator_whats
                     WHERE id_what IN (SELECT id_what FROM tb_whats WHERE id_user = 171)
                     GROUP BY id_what
                    HAVING COUNT(*) <> 8
                   ) x
        ) = 0
        AND (
            SELECT COUNT(*)
              FROM (
                    SELECT id_how, COUNT(*) indicator_count
                      FROM tb_indikator_hows
                     WHERE id_how IN (SELECT id_how FROM tb_hows WHERE id_user = 171)
                     GROUP BY id_how
                    HAVING COUNT(*) <> 8
                   ) x
        ) = 0
        AND (
            SELECT COUNT(*)
              FROM (
                    SELECT poin
                      FROM tb_kpi
                     WHERE id_user = 171
                     GROUP BY poin
                    HAVING COUNT(*) > 1
                   ) x
        ) = 0
        AND (
            SELECT COUNT(*)
              FROM (
                    SELECT id_kpi, p_what
                      FROM tb_whats
                     WHERE id_user = 171
                     GROUP BY id_kpi, p_what
                    HAVING COUNT(*) > 1
                   ) x
        ) = 0
        AND (
            SELECT COUNT(*)
              FROM (
                    SELECT id_kpi, p_how
                      FROM tb_hows
                     WHERE id_user = 171
                     GROUP BY id_kpi, p_how
                    HAVING COUNT(*) > 1
                   ) x
        ) = 0
    THEN 1 ELSE NULL END;
    TRUNCATE tmp_assert_guard;

    COMMIT;

SELECT 'migration_kpi_itsoftware_user_171.sql selesai' AS status;
