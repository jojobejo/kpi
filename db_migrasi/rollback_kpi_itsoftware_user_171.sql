-- Rollback KPI IT Software untuk tb_users.id = 171
-- Database target: kiucoid_kpi
-- Dibuat: 2026-08-27
-- Kondisi sebelum migrasi berdasarkan backup tahap 3:
-- semua tabel KPI real dan simulasi untuk user 171 kosong.
-- Rollback ini mengembalikan kondisi tersebut tanpa memengaruhi user lain.

START TRANSACTION;

DROP TEMPORARY TABLE IF EXISTS tmp_assert_guard;
CREATE TEMPORARY TABLE tmp_assert_guard (ok INT NOT NULL);

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

    INSERT INTO tmp_assert_guard
    SELECT CASE WHEN (
        (SELECT COUNT(*) FROM tb_bobotkpi WHERE id_user = 171) +
        (SELECT COUNT(*) FROM tb_kpi WHERE id_user = 171) +
        (SELECT COUNT(*) FROM tb_whats WHERE id_user = 171) +
        (SELECT COUNT(*) FROM tb_hows WHERE id_user = 171) +
        (SELECT COUNT(*) FROM tb_indikator_whats iw JOIN tb_whats w ON w.id_what = iw.id_what WHERE w.id_user = 171) +
        (SELECT COUNT(*) FROM tb_indikator_hows ih JOIN tb_hows h ON h.id_how = ih.id_how WHERE h.id_user = 171) +
        (SELECT COUNT(*) FROM tbsim_bobotkpi WHERE id_user = 171) +
        (SELECT COUNT(*) FROM tbsim_kpi WHERE id_user = 171) +
        (SELECT COUNT(*) FROM tbsim_whats WHERE id_user = 171) +
        (SELECT COUNT(*) FROM tbsim_hows WHERE id_user = 171) +
        (SELECT COUNT(*) FROM tbsim_indikator_whats iw JOIN tbsim_whats w ON w.id_what = iw.id_what WHERE w.id_user = 171) +
        (SELECT COUNT(*) FROM tbsim_indikator_hows ih JOIN tbsim_hows h ON h.id_how = ih.id_how WHERE h.id_user = 171)
    ) = 0 THEN 1 ELSE NULL END;
    TRUNCATE tmp_assert_guard;

    COMMIT;

SELECT 'rollback_kpi_itsoftware_user_171.sql selesai' AS status;
