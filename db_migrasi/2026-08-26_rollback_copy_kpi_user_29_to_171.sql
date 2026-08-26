-- Rollback migrasi copy data KPI aktif dari id_user 29 ke id_user 171.
-- Database target: kiucoid_kpi
-- Dibuat: 2026-08-26
--
-- Catatan:
-- 1. Rollback ini menghapus data KPI aktif milik id_user 171 pada tabel KPI real
--    dan simulasi yang menjadi target migrasi.
-- 2. Gunakan hanya jika id_user 171 memang belum memiliki data KPI manual lain,
--    sesuai precheck awal migrasi.
-- 3. Tidak mengubah struktur tabel.

USE `kiucoid_kpi`;

START TRANSACTION;

DELETE iw
FROM tb_indikator_whats iw
INNER JOIN tb_whats w ON w.id_what = iw.id_what
WHERE w.id_user = 171;

DELETE ih
FROM tb_indikator_hows ih
INNER JOIN tb_hows h ON h.id_how = ih.id_how
WHERE h.id_user = 171;

DELETE FROM tb_whats WHERE id_user = 171;
DELETE FROM tb_hows WHERE id_user = 171;
DELETE FROM tb_kpi WHERE id_user = 171;
DELETE FROM tb_bobotkpi WHERE id_user = 171;

DELETE iw
FROM tbsim_indikator_whats iw
INNER JOIN tbsim_whats w ON w.id_what = iw.id_what
WHERE w.id_user = 171;

DELETE ih
FROM tbsim_indikator_hows ih
INNER JOIN tbsim_hows h ON h.id_how = ih.id_how
WHERE h.id_user = 171;

DELETE FROM tbsim_whats WHERE id_user = 171;
DELETE FROM tbsim_hows WHERE id_user = 171;
DELETE FROM tbsim_kpi WHERE id_user = 171;
DELETE FROM tbsim_bobotkpi WHERE id_user = 171;

COMMIT;

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
