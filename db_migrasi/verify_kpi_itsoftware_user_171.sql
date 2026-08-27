-- Verification KPI IT Software untuk tb_users.id = 171
-- Database target: kiucoid_kpi
-- Dibuat: 2026-08-27

SELECT
    u.id AS user_id,
    u.username,
    u.nama_lngkp,
    u.bagian,
    u.departement,
    u.jabatan
FROM tb_users u
WHERE u.id = 171;

SELECT 'REAL_BOBOT_GLOBAL' AS section, id_user, bobotwhat, bobothow
FROM tb_bobotkpi
WHERE id_user = 171;

SELECT 'SIM_BOBOT_GLOBAL' AS section, id_user, bobotwhat, bobothow
FROM tbsim_bobotkpi
WHERE id_user = 171;

SELECT
    'REAL_KPI_SUMMARY' AS section,
    COUNT(*) AS kpi_count,
    SUM(bobot) AS total_bobot_what,
    SUM(bobot2) AS total_bobot_how
FROM tb_kpi
WHERE id_user = 171;

SELECT
    'SIM_KPI_SUMMARY' AS section,
    COUNT(*) AS kpi_count,
    SUM(bobot) AS total_bobot_what,
    SUM(bobot2) AS total_bobot_how
FROM tbsim_kpi
WHERE id_user = 171;

SELECT
    'REAL_KPI_DETAIL' AS section,
    k.id AS kpi_id,
    k.poin AS kpi,
    k.bobot AS bobot_kpi_what,
    k.poin2 AS how_group,
    k.bobot2 AS bobot_kpi_how,
    COALESCE(w.what_count, 0) AS what_count,
    COALESCE(w.bobot_what_sum, 0) AS bobot_what_sum,
    COALESCE(h.how_count, 0) AS how_count,
    COALESCE(h.bobot_how_sum, 0) AS bobot_how_sum
FROM tb_kpi k
LEFT JOIN (
    SELECT id_user, id_kpi, COUNT(*) AS what_count, SUM(bobot) AS bobot_what_sum
    FROM tb_whats
    WHERE id_user = 171
    GROUP BY id_user, id_kpi
) w ON w.id_kpi = k.id AND w.id_user = k.id_user
LEFT JOIN (
    SELECT id_user, id_kpi, COUNT(*) AS how_count, SUM(bobot) AS bobot_how_sum
    FROM tb_hows
    WHERE id_user = 171
    GROUP BY id_user, id_kpi
) h ON h.id_kpi = k.id AND h.id_user = k.id_user
WHERE k.id_user = 171
ORDER BY k.id;

SELECT
    'REAL_WHAT_INDICATOR' AS section,
    k.id AS kpi_id,
    k.poin AS kpi,
    w.id_what,
    w.p_what AS what_name,
    w.bobot AS bobot_what,
    iw.urutan AS indikator_urutan,
    iw.keterangan AS indikator_what,
    iw.nilai AS nilai_what
FROM tb_kpi k
JOIN tb_whats w ON w.id_kpi = k.id AND w.id_user = k.id_user
LEFT JOIN tb_indikator_whats iw ON iw.id_what = w.id_what
WHERE k.id_user = 171
ORDER BY k.id, w.id_what, iw.urutan;

SELECT
    'REAL_HOW_INDICATOR' AS section,
    k.id AS kpi_id,
    k.poin AS kpi,
    h.id_how,
    h.p_how AS how_name,
    h.bobot AS bobot_how,
    ih.urutan AS indikator_urutan,
    ih.keterangan AS indikator_how,
    ih.nilai AS nilai_how
FROM tb_kpi k
JOIN tb_hows h ON h.id_kpi = k.id AND h.id_user = k.id_user
LEFT JOIN tb_indikator_hows ih ON ih.id_how = h.id_how
WHERE k.id_user = 171
ORDER BY k.id, h.id_how, ih.urutan;

SELECT
    'SIM_KPI_DETAIL' AS section,
    k.id AS kpi_id,
    k.poin AS kpi,
    k.bobot AS bobot_kpi_what,
    k.poin2 AS how_group,
    k.bobot2 AS bobot_kpi_how,
    COALESCE(w.what_count, 0) AS what_count,
    COALESCE(w.bobot_what_sum, 0) AS bobot_what_sum,
    COALESCE(h.how_count, 0) AS how_count,
    COALESCE(h.bobot_how_sum, 0) AS bobot_how_sum
FROM tbsim_kpi k
LEFT JOIN (
    SELECT id_user, id_kpi, COUNT(*) AS what_count, SUM(bobot) AS bobot_what_sum
    FROM tbsim_whats
    WHERE id_user = 171
    GROUP BY id_user, id_kpi
) w ON w.id_kpi = k.id AND w.id_user = k.id_user
LEFT JOIN (
    SELECT id_user, id_kpi, COUNT(*) AS how_count, SUM(bobot) AS bobot_how_sum
    FROM tbsim_hows
    WHERE id_user = 171
    GROUP BY id_user, id_kpi
) h ON h.id_kpi = k.id AND h.id_user = k.id_user
WHERE k.id_user = 171
ORDER BY k.id;

SELECT
    'VALIDATION_COUNTS' AS section,
    (SELECT COUNT(*) FROM tb_kpi WHERE id_user = 171) AS real_kpi,
    (SELECT COUNT(*) FROM tb_whats WHERE id_user = 171) AS real_whats,
    (SELECT COUNT(*) FROM tb_hows WHERE id_user = 171) AS real_hows,
    (SELECT COUNT(*) FROM tb_indikator_whats iw JOIN tb_whats w ON w.id_what = iw.id_what WHERE w.id_user = 171) AS real_indikator_whats,
    (SELECT COUNT(*) FROM tb_indikator_hows ih JOIN tb_hows h ON h.id_how = ih.id_how WHERE h.id_user = 171) AS real_indikator_hows,
    (SELECT COUNT(*) FROM tbsim_kpi WHERE id_user = 171) AS sim_kpi,
    (SELECT COUNT(*) FROM tbsim_whats WHERE id_user = 171) AS sim_whats,
    (SELECT COUNT(*) FROM tbsim_hows WHERE id_user = 171) AS sim_hows,
    (SELECT COUNT(*) FROM tbsim_indikator_whats iw JOIN tbsim_whats w ON w.id_what = iw.id_what WHERE w.id_user = 171) AS sim_indikator_whats,
    (SELECT COUNT(*) FROM tbsim_indikator_hows ih JOIN tbsim_hows h ON h.id_how = ih.id_how WHERE h.id_user = 171) AS sim_indikator_hows;

SELECT
    'VALIDATION_ORPHAN_REAL' AS section,
    (SELECT COUNT(*) FROM tb_whats w LEFT JOIN tb_kpi k ON k.id = w.id_kpi AND k.id_user = w.id_user WHERE w.id_user = 171 AND k.id IS NULL) AS what_without_kpi,
    (SELECT COUNT(*) FROM tb_hows h LEFT JOIN tb_kpi k ON k.id = h.id_kpi AND k.id_user = h.id_user WHERE h.id_user = 171 AND k.id IS NULL) AS how_without_kpi,
    (SELECT COUNT(*) FROM tb_indikator_whats iw LEFT JOIN tb_whats w ON w.id_what = iw.id_what WHERE iw.id_what IN (SELECT id_what FROM tb_whats WHERE id_user = 171) AND w.id_what IS NULL) AS indikator_what_without_parent,
    (SELECT COUNT(*) FROM tb_indikator_hows ih LEFT JOIN tb_hows h ON h.id_how = ih.id_how WHERE ih.id_how IN (SELECT id_how FROM tb_hows WHERE id_user = 171) AND h.id_how IS NULL) AS indikator_how_without_parent;

SELECT
    'VALIDATION_DUPLICATE_REAL' AS section,
    (SELECT COUNT(*) FROM (SELECT poin FROM tb_kpi WHERE id_user = 171 GROUP BY poin HAVING COUNT(*) > 1) d) AS duplicate_kpi,
    (SELECT COUNT(*) FROM (SELECT id_kpi, p_what FROM tb_whats WHERE id_user = 171 GROUP BY id_kpi, p_what HAVING COUNT(*) > 1) d) AS duplicate_what,
    (SELECT COUNT(*) FROM (SELECT id_kpi, p_how FROM tb_hows WHERE id_user = 171 GROUP BY id_kpi, p_how HAVING COUNT(*) > 1) d) AS duplicate_how;
