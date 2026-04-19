show databases;
use hr;

show tables;
use hr;

select * from hr limit 5;

-- ============================================================
-- 1. Répartition des employés par genre
-- ============================================================
SELECT genre, COUNT(*) AS total
FROM hr
GROUP BY genre;


-- ============================================================
-- 3. Distribution des âges des employés
-- ============================================================
SELECT age, COUNT(*) AS total
FROM hr
GROUP BY age
ORDER BY age;

-- ============================================================
-- 4. Nombre d’employés par site (siège vs remote)
-- ============================================================
SELECT site, COUNT(*) AS total
FROM hr
GROUP BY site;

-- ============================================================
-- 5. Ancienneté moyenne des employés terminés
-- ============================================================
SELECT
    ROUND(AVG(DATEDIFF(date_depart, date_embauche) / 365), 2)
        AS anciennete_moyenne_annees
FROM hr
WHERE date_depart IS NOT NULL;

-- ============================================================
-- 6. Répartition du genre par département et poste
-- ============================================================
SELECT departement, intitule_poste, genre, COUNT(*) AS total
FROM hr
GROUP BY departement, intitule_poste, genre
ORDER BY departement, intitule_poste;

-- ============================================================
-- 7. Distribution des intitulés de poste
-- ============================================================
SELECT intitule_poste, COUNT(*) AS total
FROM hr
GROUP BY intitule_poste
ORDER BY total DESC;

-- ============================================================
-- 8. Taux de turnover par département
-- ============================================================
SELECT
    departement,
    COUNT(*) AS total_employes,
    SUM(CASE WHEN date_depart IS NOT NULL THEN 1 ELSE 0 END) AS total_depart,
    ROUND(
            SUM(CASE WHEN date_depart IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*) * 100,
            2
    ) AS taux_turnover
FROM hr
GROUP BY departement
ORDER BY taux_turnover DESC;

-- ============================================================
-- 9. Répartition des employés par ville et région
-- ============================================================
SELECT ville_site, region_site, COUNT(*) AS total
FROM hr
GROUP BY ville_site, region_site
ORDER BY  total desc ;

-- ============================================================
-- 10. Évolution des embauches dans le temps
-- ============================================================
SELECT
    YEAR(date_embauche) AS annee,
    COUNT(*) AS embauches
FROM hr
GROUP BY YEAR(date_embauche)
ORDER BY annee;

-- Évolution des départs
SELECT
    YEAR(date_depart) AS annee,
    COUNT(*) AS departs
FROM hr
WHERE date_depart IS NOT NULL
GROUP BY YEAR(date_depart)
ORDER BY annee;

-- ============================================================
-- 11. Ancienneté moyenne par département
-- ============================================================
SELECT
    departement,
    ROUND(AVG(DATEDIFF(CURDATE(), date_embauche) / 365), 2)
        AS anciennete_moyenne_annees
FROM hr
GROUP BY departement


-- ============================================================
-- 12. Nombre d’employés actuellement actifs dans l’entreprise
-- ============================================================

SELECT COUNT(*) AS employes_actifs
FROM hr
WHERE date_depart IS NULL;

-- ============================================================
-- 13. Nombre d’employés ayant quitté l’entreprise
-- ============================================================

SELECT COUNT(*) AS employes_termines
FROM hr
WHERE date_depart IS NOT NULL;

-- ============================================================
-- 14. Taux d’employés actifs vs terminés
-- ============================================================

SELECT
    SUM(CASE WHEN date_depart IS NULL THEN 1 ELSE 0 END) AS actifs,
    SUM(CASE WHEN date_depart IS NOT NULL THEN 1 ELSE 0 END) AS termines,
    ROUND(
            SUM(CASE WHEN date_depart IS NULL THEN 1 ELSE 0 END)
                / COUNT(*) * 100, 2
    ) AS taux_actifs_pourcent,
    ROUND(
            SUM(CASE WHEN date_depart IS NOT NULL THEN 1 ELSE 0 END)
                / COUNT(*) * 100, 2
    ) AS taux_termines_pourcent
FROM hr;

-- ============================================================
-- 15. Répartition des employés par genre
-- ============================================================

CREATE VIEW v_genre_breakdown AS
SELECT genre, COUNT(*) AS total
FROM hr
GROUP BY genre;





-- ============================================================
-- 16. Âge + tranches d’âge
-- ============================================================

CREATE VIEW v_age_distribution AS
SELECT
    age,
    CASE
        WHEN age < 25 THEN '18-25'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        WHEN age >= 55 THEN '55+'
        END AS tranche_age,
    COUNT(*) AS total
FROM hr
GROUP BY age, tranche_age
ORDER BY age;



-- ============================================================
-- 17. Turnover par département
-- ============================================================

CREATE VIEW v_turnover_departement AS
SELECT
    departement,
    COUNT(*) AS total_employes,
    SUM(CASE WHEN date_depart IS NOT NULL THEN 1 ELSE 0 END) AS total_depart,
    ROUND(
            SUM(CASE WHEN date_depart IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*) * 100,
            2
    ) AS taux_turnover
FROM hr
GROUP BY departement
ORDER BY taux_turnover DESC;




-- ============================================================
-- 18. Effectifs actifs vs terminés
-- ============================================================

CREATE VIEW v_effectifs_actifs AS
SELECT
    SUM(CASE WHEN date_depart IS NULL THEN 1 ELSE 0 END) AS actifs,
    SUM(CASE WHEN date_depart IS NOT NULL THEN 1 ELSE 0 END) AS termines,
    ROUND(
            SUM(CASE WHEN date_depart IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100,
            2
    ) AS taux_actifs_pourcent,
    ROUND(
            SUM(CASE WHEN date_depart IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*) * 100,
            2
    ) AS taux_termines_pourcent
FROM hr;



-- ============================================================
-- 19. Ancienneté moyenne par département
-- ============================================================


CREATE VIEW v_anciennete_departement AS
SELECT
    departement,
    ROUND(AVG(DATEDIFF(CURDATE(), date_embauche) / 365), 2) AS anciennete_moyenne_annees
FROM hr
GROUP BY departement
ORDER BY anciennete_moyenne_annees DESC;


