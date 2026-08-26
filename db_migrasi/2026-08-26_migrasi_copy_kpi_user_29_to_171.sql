-- Migrasi copy data KPI aktif dari id_user 29 ke id_user 171.
-- Database target: kiucoid_kpi
-- Dibuat: 2026-08-26
--
-- Ruang lingkup:
-- 1. KPI real: tb_bobotkpi, tb_kpi, tb_whats, tb_hows,
--    tb_indikator_whats, tb_indikator_hows.
-- 2. KPI simulasi: tbsim_bobotkpi, tbsim_kpi, tbsim_whats, tbsim_hows,
--    tbsim_indikator_whats, tbsim_indikator_hows.
--
-- Tidak melakukan perubahan struktur tabel.
-- Tidak menyalin tb_kpi_history, tb_kpi_verified, tb_eviden, atau archive.

USE `kiucoid_kpi`;

DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_migrasi_copy_kpi_user_29_to_171`$$

CREATE PROCEDURE `sp_migrasi_copy_kpi_user_29_to_171`()
BEGIN
    DECLARE v_source_user_id INT DEFAULT 29;
    DECLARE v_target_user_id INT DEFAULT 171;
    DECLARE v_source_exists INT DEFAULT 0;
    DECLARE v_target_exists INT DEFAULT 0;
    DECLARE v_target_real_rows INT DEFAULT 0;
    DECLARE v_target_sim_rows INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        DROP TEMPORARY TABLE IF EXISTS tmp_real_kpi_src;
        DROP TEMPORARY TABLE IF EXISTS tmp_real_kpi_new;
        DROP TEMPORARY TABLE IF EXISTS tmp_real_kpi_map;
        DROP TEMPORARY TABLE IF EXISTS tmp_real_what_src;
        DROP TEMPORARY TABLE IF EXISTS tmp_real_what_new;
        DROP TEMPORARY TABLE IF EXISTS tmp_real_what_map;
        DROP TEMPORARY TABLE IF EXISTS tmp_real_how_src;
        DROP TEMPORARY TABLE IF EXISTS tmp_real_how_new;
        DROP TEMPORARY TABLE IF EXISTS tmp_real_how_map;
        DROP TEMPORARY TABLE IF EXISTS tmp_sim_kpi_src;
        DROP TEMPORARY TABLE IF EXISTS tmp_sim_kpi_new;
        DROP TEMPORARY TABLE IF EXISTS tmp_sim_kpi_map;
        DROP TEMPORARY TABLE IF EXISTS tmp_sim_what_src;
        DROP TEMPORARY TABLE IF EXISTS tmp_sim_what_new;
        DROP TEMPORARY TABLE IF EXISTS tmp_sim_what_map;
        DROP TEMPORARY TABLE IF EXISTS tmp_sim_how_src;
        DROP TEMPORARY TABLE IF EXISTS tmp_sim_how_new;
        DROP TEMPORARY TABLE IF EXISTS tmp_sim_how_map;
        RESIGNAL;
    END;

    SELECT COUNT(*) INTO v_source_exists FROM tb_users WHERE id = v_source_user_id;
    SELECT COUNT(*) INTO v_target_exists FROM tb_users WHERE id = v_target_user_id;

    IF v_source_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Migrasi dibatalkan: source id_user 29 tidak ditemukan di tb_users.';
    END IF;

    IF v_target_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Migrasi dibatalkan: target id_user 171 tidak ditemukan di tb_users.';
    END IF;

    SELECT
        (SELECT COUNT(*) FROM tb_bobotkpi WHERE id_user = v_target_user_id) +
        (SELECT COUNT(*) FROM tb_kpi WHERE id_user = v_target_user_id) +
        (SELECT COUNT(*) FROM tb_whats WHERE id_user = v_target_user_id) +
        (SELECT COUNT(*) FROM tb_hows WHERE id_user = v_target_user_id)
    INTO v_target_real_rows;

    SELECT
        (SELECT COUNT(*) FROM tbsim_bobotkpi WHERE id_user = v_target_user_id) +
        (SELECT COUNT(*) FROM tbsim_kpi WHERE id_user = v_target_user_id) +
        (SELECT COUNT(*) FROM tbsim_whats WHERE id_user = v_target_user_id) +
        (SELECT COUNT(*) FROM tbsim_hows WHERE id_user = v_target_user_id)
    INTO v_target_sim_rows;

    IF v_target_real_rows > 0 OR v_target_sim_rows > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Migrasi dibatalkan: target id_user 171 sudah memiliki data KPI. Jalankan rollback/bersihkan target dahulu jika memang ingin replace.';
    END IF;

    START TRANSACTION;

    INSERT INTO tb_bobotkpi (id_user, bobotwhat, bobothow)
    SELECT v_target_user_id, bobotwhat, bobothow
    FROM tb_bobotkpi
    WHERE id_user = v_source_user_id
    ORDER BY idbobotkpi;

    CREATE TEMPORARY TABLE tmp_real_kpi_src (
        seq INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        old_id INT NOT NULL,
        poin TEXT NOT NULL,
        bobot DOUBLE NOT NULL,
        poin2 TEXT NOT NULL,
        bobot2 DOUBLE NOT NULL
    );

    INSERT INTO tmp_real_kpi_src (old_id, poin, bobot, poin2, bobot2)
    SELECT id, poin, bobot, poin2, bobot2
    FROM tb_kpi
    WHERE id_user = v_source_user_id
    ORDER BY id;

    INSERT INTO tb_kpi (id_user, poin, bobot, poin2, bobot2)
    SELECT v_target_user_id, poin, bobot, poin2, bobot2
    FROM tmp_real_kpi_src
    ORDER BY seq;

    CREATE TEMPORARY TABLE tmp_real_kpi_new AS
    SELECT ROW_NUMBER() OVER (ORDER BY id) AS seq, id AS new_id
    FROM tb_kpi
    WHERE id_user = v_target_user_id;

    CREATE TEMPORARY TABLE tmp_real_kpi_map AS
    SELECT s.seq, s.old_id, n.new_id
    FROM tmp_real_kpi_src s
    INNER JOIN tmp_real_kpi_new n ON n.seq = s.seq;

    CREATE TEMPORARY TABLE tmp_real_what_src (
        seq INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        old_id INT NOT NULL,
        new_kpi_id INT NOT NULL,
        tipe_what ENUM('A','B') NULL DEFAULT 'A',
        p_what TEXT NOT NULL,
        bobot DOUBLE NOT NULL,
        target_omset DECIMAL(15,2) NULL,
        hasil TEXT NULL,
        nilai DOUBLE NOT NULL,
        total DOUBLE NOT NULL,
        is_edited TINYINT(1) NULL,
        edited_by INT NULL,
        edited_at TIMESTAMP NULL,
        original_p_what TEXT NULL,
        original_bobot DOUBLE NULL,
        original_hasil TEXT NULL,
        original_nilai DOUBLE NULL,
        original_total DOUBLE NULL,
        original_target_omset DECIMAL(15,2) NULL
    );

    INSERT INTO tmp_real_what_src (
        old_id, new_kpi_id, tipe_what, p_what, bobot, target_omset,
        hasil, nilai, total, is_edited, edited_by, edited_at,
        original_p_what, original_bobot, original_hasil, original_nilai,
        original_total, original_target_omset
    )
    SELECT
        w.id_what, km.new_id, w.tipe_what, w.p_what, w.bobot, w.target_omset,
        w.hasil, w.nilai, w.total, w.is_edited, w.edited_by, w.edited_at,
        w.original_p_what, w.original_bobot, w.original_hasil, w.original_nilai,
        w.original_total, w.original_target_omset
    FROM tb_whats w
    INNER JOIN tmp_real_kpi_map km ON km.old_id = w.id_kpi
    WHERE w.id_user = v_source_user_id
    ORDER BY w.id_what;

    INSERT INTO tb_whats (
        id_user, id_kpi, tipe_what, p_what, bobot, target_omset,
        hasil, nilai, total, is_edited, edited_by, edited_at,
        original_p_what, original_bobot, original_hasil, original_nilai,
        original_total, original_target_omset
    )
    SELECT
        v_target_user_id, new_kpi_id, tipe_what, p_what, bobot, target_omset,
        hasil, nilai, total, is_edited, edited_by, edited_at,
        original_p_what, original_bobot, original_hasil, original_nilai,
        original_total, original_target_omset
    FROM tmp_real_what_src
    ORDER BY seq;

    CREATE TEMPORARY TABLE tmp_real_what_new AS
    SELECT ROW_NUMBER() OVER (ORDER BY id_what) AS seq, id_what AS new_id
    FROM tb_whats
    WHERE id_user = v_target_user_id;

    CREATE TEMPORARY TABLE tmp_real_what_map AS
    SELECT s.seq, s.old_id, n.new_id
    FROM tmp_real_what_src s
    INNER JOIN tmp_real_what_new n ON n.seq = s.seq;

    INSERT INTO tb_indikator_whats (
        id_what, keterangan, nilai, urutan, created_at,
        is_edited, edited_by, edited_at, original_keterangan, original_nilai
    )
    SELECT
        wm.new_id, iw.keterangan, iw.nilai, iw.urutan, iw.created_at,
        iw.is_edited, iw.edited_by, iw.edited_at, iw.original_keterangan, iw.original_nilai
    FROM tb_indikator_whats iw
    INNER JOIN tmp_real_what_map wm ON wm.old_id = iw.id_what
    ORDER BY iw.id_what, iw.urutan, iw.id_indikator;

    CREATE TEMPORARY TABLE tmp_real_how_src (
        seq INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        old_id INT NOT NULL,
        new_kpi_id INT NOT NULL,
        tipe_how ENUM('A','B') NULL DEFAULT 'A',
        p_how TEXT NOT NULL,
        bobot DOUBLE NOT NULL,
        target_omset DECIMAL(15,2) NULL,
        hasil TEXT NULL,
        nilai DOUBLE NOT NULL,
        total DOUBLE NOT NULL,
        is_edited TINYINT(1) NULL,
        edited_by INT NULL,
        edited_at TIMESTAMP NULL,
        original_p_how TEXT NULL,
        original_bobot DOUBLE NULL,
        original_hasil TEXT NULL,
        original_nilai DOUBLE NULL,
        original_total DOUBLE NULL,
        original_target_omset DECIMAL(15,2) NULL
    );

    INSERT INTO tmp_real_how_src (
        old_id, new_kpi_id, tipe_how, p_how, bobot, target_omset,
        hasil, nilai, total, is_edited, edited_by, edited_at,
        original_p_how, original_bobot, original_hasil, original_nilai,
        original_total, original_target_omset
    )
    SELECT
        h.id_how, km.new_id, h.tipe_how, h.p_how, h.bobot, h.target_omset,
        h.hasil, h.nilai, h.total, h.is_edited, h.edited_by, h.edited_at,
        h.original_p_how, h.original_bobot, h.original_hasil, h.original_nilai,
        h.original_total, h.original_target_omset
    FROM tb_hows h
    INNER JOIN tmp_real_kpi_map km ON km.old_id = h.id_kpi
    WHERE h.id_user = v_source_user_id
    ORDER BY h.id_how;

    INSERT INTO tb_hows (
        id_user, id_kpi, tipe_how, p_how, bobot, target_omset,
        hasil, nilai, total, is_edited, edited_by, edited_at,
        original_p_how, original_bobot, original_hasil, original_nilai,
        original_total, original_target_omset
    )
    SELECT
        v_target_user_id, new_kpi_id, tipe_how, p_how, bobot, target_omset,
        hasil, nilai, total, is_edited, edited_by, edited_at,
        original_p_how, original_bobot, original_hasil, original_nilai,
        original_total, original_target_omset
    FROM tmp_real_how_src
    ORDER BY seq;

    CREATE TEMPORARY TABLE tmp_real_how_new AS
    SELECT ROW_NUMBER() OVER (ORDER BY id_how) AS seq, id_how AS new_id
    FROM tb_hows
    WHERE id_user = v_target_user_id;

    CREATE TEMPORARY TABLE tmp_real_how_map AS
    SELECT s.seq, s.old_id, n.new_id
    FROM tmp_real_how_src s
    INNER JOIN tmp_real_how_new n ON n.seq = s.seq;

    INSERT INTO tb_indikator_hows (
        id_how, keterangan, nilai, urutan, created_at,
        is_edited, edited_by, edited_at, original_keterangan, original_nilai
    )
    SELECT
        hm.new_id, ih.keterangan, ih.nilai, ih.urutan, ih.created_at,
        ih.is_edited, ih.edited_by, ih.edited_at, ih.original_keterangan, ih.original_nilai
    FROM tb_indikator_hows ih
    INNER JOIN tmp_real_how_map hm ON hm.old_id = ih.id_how
    ORDER BY ih.id_how, ih.urutan, ih.id_indikator;

    INSERT INTO tbsim_bobotkpi (id_user, bobotwhat, bobothow)
    SELECT v_target_user_id, bobotwhat, bobothow
    FROM tbsim_bobotkpi
    WHERE id_user = v_source_user_id
    ORDER BY idbobotkpi;

    CREATE TEMPORARY TABLE tmp_sim_kpi_src (
        seq INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        old_id INT NOT NULL,
        poin TEXT NOT NULL,
        bobot DOUBLE NOT NULL,
        poin2 TEXT NOT NULL,
        bobot2 DOUBLE NOT NULL
    );

    INSERT INTO tmp_sim_kpi_src (old_id, poin, bobot, poin2, bobot2)
    SELECT id, poin, bobot, poin2, bobot2
    FROM tbsim_kpi
    WHERE id_user = v_source_user_id
    ORDER BY id;

    INSERT INTO tbsim_kpi (id_user, poin, bobot, poin2, bobot2)
    SELECT v_target_user_id, poin, bobot, poin2, bobot2
    FROM tmp_sim_kpi_src
    ORDER BY seq;

    CREATE TEMPORARY TABLE tmp_sim_kpi_new AS
    SELECT ROW_NUMBER() OVER (ORDER BY id) AS seq, id AS new_id
    FROM tbsim_kpi
    WHERE id_user = v_target_user_id;

    CREATE TEMPORARY TABLE tmp_sim_kpi_map AS
    SELECT s.seq, s.old_id, n.new_id
    FROM tmp_sim_kpi_src s
    INNER JOIN tmp_sim_kpi_new n ON n.seq = s.seq;

    CREATE TEMPORARY TABLE tmp_sim_what_src (
        seq INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        old_id INT NOT NULL,
        new_kpi_id INT NOT NULL,
        tipe_what ENUM('A','B') NULL DEFAULT 'A',
        p_what TEXT NOT NULL,
        bobot DOUBLE NOT NULL,
        target_omset DECIMAL(15,2) NULL,
        hasil TEXT NOT NULL,
        nilai DOUBLE NOT NULL,
        total DOUBLE NOT NULL
    );

    INSERT INTO tmp_sim_what_src (
        old_id, new_kpi_id, tipe_what, p_what, bobot,
        target_omset, hasil, nilai, total
    )
    SELECT
        w.id_what, km.new_id, w.tipe_what, w.p_what, w.bobot,
        w.target_omset, w.hasil, w.nilai, w.total
    FROM tbsim_whats w
    INNER JOIN tmp_sim_kpi_map km ON km.old_id = w.id_kpi
    WHERE w.id_user = v_source_user_id
    ORDER BY w.id_what;

    INSERT INTO tbsim_whats (
        id_user, id_kpi, tipe_what, p_what, bobot,
        target_omset, hasil, nilai, total
    )
    SELECT
        v_target_user_id, new_kpi_id, tipe_what, p_what, bobot,
        target_omset, hasil, nilai, total
    FROM tmp_sim_what_src
    ORDER BY seq;

    CREATE TEMPORARY TABLE tmp_sim_what_new AS
    SELECT ROW_NUMBER() OVER (ORDER BY id_what) AS seq, id_what AS new_id
    FROM tbsim_whats
    WHERE id_user = v_target_user_id;

    CREATE TEMPORARY TABLE tmp_sim_what_map AS
    SELECT s.seq, s.old_id, n.new_id
    FROM tmp_sim_what_src s
    INNER JOIN tmp_sim_what_new n ON n.seq = s.seq;

    INSERT INTO tbsim_indikator_whats (id_what, keterangan, nilai, urutan, created_at)
    SELECT wm.new_id, iw.keterangan, iw.nilai, iw.urutan, iw.created_at
    FROM tbsim_indikator_whats iw
    INNER JOIN tmp_sim_what_map wm ON wm.old_id = iw.id_what
    ORDER BY iw.id_what, iw.urutan, iw.id_indikator;

    CREATE TEMPORARY TABLE tmp_sim_how_src (
        seq INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        old_id INT NOT NULL,
        new_kpi_id INT NOT NULL,
        tipe_how ENUM('A','B') NULL DEFAULT 'A',
        p_how TEXT NOT NULL,
        bobot DOUBLE NOT NULL,
        target_omset DECIMAL(15,2) NULL,
        hasil TEXT NOT NULL,
        nilai DOUBLE NOT NULL,
        total DOUBLE NOT NULL
    );

    INSERT INTO tmp_sim_how_src (
        old_id, new_kpi_id, tipe_how, p_how, bobot,
        target_omset, hasil, nilai, total
    )
    SELECT
        h.id_how, km.new_id, h.tipe_how, h.p_how, h.bobot,
        h.target_omset, h.hasil, h.nilai, h.total
    FROM tbsim_hows h
    INNER JOIN tmp_sim_kpi_map km ON km.old_id = h.id_kpi
    WHERE h.id_user = v_source_user_id
    ORDER BY h.id_how;

    INSERT INTO tbsim_hows (
        id_user, id_kpi, tipe_how, p_how, bobot,
        target_omset, hasil, nilai, total
    )
    SELECT
        v_target_user_id, new_kpi_id, tipe_how, p_how, bobot,
        target_omset, hasil, nilai, total
    FROM tmp_sim_how_src
    ORDER BY seq;

    CREATE TEMPORARY TABLE tmp_sim_how_new AS
    SELECT ROW_NUMBER() OVER (ORDER BY id_how) AS seq, id_how AS new_id
    FROM tbsim_hows
    WHERE id_user = v_target_user_id;

    CREATE TEMPORARY TABLE tmp_sim_how_map AS
    SELECT s.seq, s.old_id, n.new_id
    FROM tmp_sim_how_src s
    INNER JOIN tmp_sim_how_new n ON n.seq = s.seq;

    INSERT INTO tbsim_indikator_hows (id_how, keterangan, nilai, urutan, created_at)
    SELECT hm.new_id, ih.keterangan, ih.nilai, ih.urutan, ih.created_at
    FROM tbsim_indikator_hows ih
    INNER JOIN tmp_sim_how_map hm ON hm.old_id = ih.id_how
    ORDER BY ih.id_how, ih.urutan, ih.id_indikator;

    COMMIT;

    SELECT 'tb_bobotkpi' AS tabel, COUNT(*) AS rows_target_171 FROM tb_bobotkpi WHERE id_user = v_target_user_id
    UNION ALL SELECT 'tb_kpi', COUNT(*) FROM tb_kpi WHERE id_user = v_target_user_id
    UNION ALL SELECT 'tb_whats', COUNT(*) FROM tb_whats WHERE id_user = v_target_user_id
    UNION ALL SELECT 'tb_hows', COUNT(*) FROM tb_hows WHERE id_user = v_target_user_id
    UNION ALL SELECT 'tb_indikator_whats', COUNT(*) FROM tb_indikator_whats iw INNER JOIN tb_whats w ON w.id_what = iw.id_what WHERE w.id_user = v_target_user_id
    UNION ALL SELECT 'tb_indikator_hows', COUNT(*) FROM tb_indikator_hows ih INNER JOIN tb_hows h ON h.id_how = ih.id_how WHERE h.id_user = v_target_user_id
    UNION ALL SELECT 'tbsim_bobotkpi', COUNT(*) FROM tbsim_bobotkpi WHERE id_user = v_target_user_id
    UNION ALL SELECT 'tbsim_kpi', COUNT(*) FROM tbsim_kpi WHERE id_user = v_target_user_id
    UNION ALL SELECT 'tbsim_whats', COUNT(*) FROM tbsim_whats WHERE id_user = v_target_user_id
    UNION ALL SELECT 'tbsim_hows', COUNT(*) FROM tbsim_hows WHERE id_user = v_target_user_id
    UNION ALL SELECT 'tbsim_indikator_whats', COUNT(*) FROM tbsim_indikator_whats iw INNER JOIN tbsim_whats w ON w.id_what = iw.id_what WHERE w.id_user = v_target_user_id
    UNION ALL SELECT 'tbsim_indikator_hows', COUNT(*) FROM tbsim_indikator_hows ih INNER JOIN tbsim_hows h ON h.id_how = ih.id_how WHERE h.id_user = v_target_user_id;
END$$

DELIMITER ;

CALL `sp_migrasi_copy_kpi_user_29_to_171`();

DROP PROCEDURE IF EXISTS `sp_migrasi_copy_kpi_user_29_to_171`;
