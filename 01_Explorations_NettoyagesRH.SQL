show databases;
USE hr;

ALTER TABLE hr
    RENAME COLUMN first_name TO prenom,
    RENAME COLUMN last_name TO nom,
    RENAME COLUMN birthdate TO date_naissance,
    RENAME COLUMN gender TO genre,
    RENAME COLUMN race TO origine_ethnique,
    RENAME COLUMN department TO departement,
    RENAME COLUMN jobtitle TO intitule_poste,
    RENAME COLUMN location TO site,
    RENAME COLUMN hire_date TO date_embauche,
    RENAME COLUMN termdate TO date_depart,
    RENAME COLUMN location_city TO ville_site,
    RENAME COLUMN location_state TO region_site;




-- ============================================================
-- 01_EXPLORATION_HR.SQL
-- Explorations initiales pour comprendre la structure du dataset RH et détecter des anomalies
-- Objectif : vérifier la qualité, la structure et l'intégrité des données et corriger
-- ============================================================

USE hr;

-- 1. Aperçu des données
SELECT id FROM hr LIMIT 5;

-- ---------------------------
-- 2. Nombre total de lignes
-- ---------------------------
SELECT COUNT(*) AS nombre_total
FROM hr;

-- ---------------------------
-- 3. Valeurs distinctes (colonnes catégorielles)
-- ---------------------------
SELECT
    COUNT(DISTINCT genre) AS distinct_genre,
    COUNT(DISTINCT origine_ethnique) AS distinct_origine,
    COUNT(DISTINCT departement) AS distinct_departement,
    COUNT(DISTINCT intitule_poste) AS distinct_poste,
    COUNT(DISTINCT site) AS distinct_site
FROM hr;

-- ---------------------------
-- 4. Taille de la table
-- ---------------------------
SELECT
    table_name,
    ROUND((data_length + index_length) / 1024, 2) AS taille_Ko,
    ROUND((data_length + index_length) / 1024 / 1024, 2) AS taille_Mo
FROM information_schema.tables
WHERE table_name = 'hr';

-- ---------------------------
-- 5. Types des colonnes
-- ---------------------------
DESCRIBE hr;

-- ---------------------------
-- 6. Valeurs non nulles (qualité des données)
-- ---------------------------
SELECT
    COUNT(prenom) AS prenom_ok,
    COUNT(nom) AS nom_ok,
    COUNT(date_naissance) AS date_naissance_ok,
    COUNT(genre) AS genre_ok,
    COUNT(origine_ethnique) AS origine_ok,
    COUNT(departement) AS departement_ok,
    COUNT(intitule_poste) AS poste_ok,
    COUNT(site) AS site_ok,
    COUNT(date_embauche) AS embauche_ok,
    COUNT(date_depart) AS depart_ok,
    COUNT(ville_site) AS ville_ok,
    COUNT(region_site) AS region_ok
FROM hr;

-- ---------------------------
-- 7. Distribution des postes
-- ---------------------------
SELECT intitule_poste, COUNT(*) AS total
FROM hr
GROUP BY intitule_poste
ORDER BY total DESC;

-- ---------------------------
-- 8. Détection anomalies : date de départ < date d'embauche
-- ---------------------------
SELECT *
FROM hr
WHERE date_depart IS NOT NULL
  AND date_depart < date_embauche;

-- ---------------------------
-- 9. Statistiques sur l'ancienneté
-- ---------------------------
SELECT
    MIN(date_embauche) AS plus_ancien,
    MAX(date_embauche) AS plus_recent,
    COUNT(*) AS total_employes
FROM hr;

-- ---------------------------
-- 10. Suppression des lignes invalides (exemple)
-- ---------------------------
SET SQL_SAFE_UPDATES = 0;

DELETE FROM hr
WHERE prenom IS NULL
   OR nom IS NULL;

SET SQL_SAFE_UPDATES = 1;



-- ---------------------------
-- 11. Corriger les dates
-- ---------------------------
SET SQL_SAFE_UPDATES = 0;

-- 1) Correction date_naissance
UPDATE hr
SET date_naissance = CASE
                         WHEN date_naissance LIKE '%/%'
                             THEN DATE_FORMAT(STR_TO_DATE(date_naissance, '%m/%d/%Y'), '%Y-%m-%d')
                         WHEN date_naissance LIKE '%-%'
                             THEN DATE_FORMAT(STR_TO_DATE(date_naissance, '%Y-%m-%d'), '%Y-%m-%d')
                         ELSE NULL
    END;

-- 2) Correction date_embauche
UPDATE hr
SET date_embauche = CASE
                        WHEN date_embauche LIKE '%/%'
                            THEN DATE_FORMAT(STR_TO_DATE(date_embauche, '%m/%d/%Y'), '%Y-%m-%d')
                        WHEN date_embauche LIKE '%-%'
                            THEN DATE_FORMAT(STR_TO_DATE(date_embauche, '%Y-%m-%d'), '%Y-%m-%d')
                        ELSE NULL
    END;

-- 3) Correction date_depart (format UTC)
UPDATE hr
SET date_depart = NULL
WHERE TRIM(date_depart) = '';

SET SQL_SAFE_UPDATES = 1;

-- Vérification finale
DESCRIBE hr;

-- ---------------------------
-- 12. corriger les erreure de datatype
-- ---------------------------
ALTER TABLE hr
    MODIFY date_naissance DATE,
    MODIFY genre VARCHAR(20),
    MODIFY departement VARCHAR(100),
    MODIFY intitule_poste VARCHAR(100),
    MODIFY site VARCHAR(100),
    MODIFY date_embauche DATE,
    MODIFY date_depart DATE,
    MODIFY ville_site VARCHAR(100),
    MODIFY region_site VARCHAR(100);


-- ---------------------------
-- 13. concatener nom et prénom pour avoir un seul colonnes
-- ---------------------------
ALTER TABLE hr
    ADD COLUMN nom_complet VARCHAR(120);

UPDATE hr
SET nom_complet = CONCAT(prenom, ' ', nom);



ALTER TABLE hr
    MODIFY COLUMN nom_complet VARCHAR(120) AFTER id;


select * from hr;

-- ---------------------------
-- 14. supprimer les nom, prenom; origine car plus utilité
-- ---------------------------

ALTER TABLE hr
    DROP COLUMN origine_ethnique,
    DROP COLUMN nom,
    DROP COLUMN prenom;

-- ---------------------------
-- 15. ajouter la colonne Age
-- ---------------------------

ALTER TABLE hr
    ADD COLUMN age INT AFTER date_naissance;

UPDATE hr
SET age = TIMESTAMPDIFF(YEAR, date_naissance, CURDATE());


SELECT id, nom_complet, date_naissance
FROM hr
WHERE date_naissance > CURDATE();



SELECT MIN(age), MAX(age), AVG(age) FROM hr;



-- 16) Ajouter la clé primaire
ALTER TABLE hr
    ADD PRIMARY KEY (id(50));

describe hr;








