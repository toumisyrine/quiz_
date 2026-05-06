-- Script de création de toutes les bases de données LearnHub
-- Exécuter dans MySQL Workbench ou ligne de commande MySQL
-- Usage: mysql -u root -p < create-databases.sql

-- ============================================
-- Création des bases de données
-- ============================================

-- 1. Base principale (Quiz, Feedback, Kids Games)
CREATE DATABASE IF NOT EXISTS learnify_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- 2. Base AI Service
CREATE DATABASE IF NOT EXISTS ai_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- 3. Base User Service
CREATE DATABASE IF NOT EXISTS user_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- 4. Base Course Service
CREATE DATABASE IF NOT EXISTS course_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- 5. Base Event Service
CREATE DATABASE IF NOT EXISTS event_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- 6. Base Job Service
CREATE DATABASE IF NOT EXISTS job_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- 7. Base Payment Service
CREATE DATABASE IF NOT EXISTS payment_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- 8. Base Certificate Service
CREATE DATABASE IF NOT EXISTS certificate_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- 9. Base Preevaluation Service
CREATE DATABASE IF NOT EXISTS preevaluation_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- ============================================
-- Vérification
-- ============================================

SHOW DATABASES;

-- ============================================
-- Afficher les informations
-- ============================================

SELECT 
    'learnify_db' as database_name,
    DEFAULT_CHARACTER_SET_NAME as charset,
    DEFAULT_COLLATION_NAME as collation
FROM information_schema.SCHEMATA 
WHERE SCHEMA_NAME = 'learnify_db'

UNION ALL

SELECT 
    'ai_db' as database_name,
    DEFAULT_CHARACTER_SET_NAME as charset,
    DEFAULT_COLLATION_NAME as collation
FROM information_schema.SCHEMATA 
WHERE SCHEMA_NAME = 'ai_db'

UNION ALL

SELECT 
    'user_db' as database_name,
    DEFAULT_CHARACTER_SET_NAME as charset,
    DEFAULT_COLLATION_NAME as collation
FROM information_schema.SCHEMATA 
WHERE SCHEMA_NAME = 'user_db'

UNION ALL

SELECT 
    'course_db' as database_name,
    DEFAULT_CHARACTER_SET_NAME as charset,
    DEFAULT_COLLATION_NAME as collation
FROM information_schema.SCHEMATA 
WHERE SCHEMA_NAME = 'course_db'

UNION ALL

SELECT 
    'event_db' as database_name,
    DEFAULT_CHARACTER_SET_NAME as charset,
    DEFAULT_COLLATION_NAME as collation
FROM information_schema.SCHEMATA 
WHERE SCHEMA_NAME = 'event_db'

UNION ALL

SELECT 
    'job_db' as database_name,
    DEFAULT_CHARACTER_SET_NAME as charset,
    DEFAULT_COLLATION_NAME as collation
FROM information_schema.SCHEMATA 
WHERE SCHEMA_NAME = 'job_db'

UNION ALL

SELECT 
    'payment_db' as database_name,
    DEFAULT_CHARACTER_SET_NAME as charset,
    DEFAULT_COLLATION_NAME as collation
FROM information_schema.SCHEMATA 
WHERE SCHEMA_NAME = 'payment_db'

UNION ALL

SELECT 
    'certificate_db' as database_name,
    DEFAULT_CHARACTER_SET_NAME as charset,
    DEFAULT_COLLATION_NAME as collation
FROM information_schema.SCHEMATA 
WHERE SCHEMA_NAME = 'certificate_db'

UNION ALL

SELECT 
    'preevaluation_db' as database_name,
    DEFAULT_CHARACTER_SET_NAME as charset,
    DEFAULT_COLLATION_NAME as collation
FROM information_schema.SCHEMATA 
WHERE SCHEMA_NAME = 'preevaluation_db';

-- ============================================
-- Message de succès
-- ============================================

SELECT '✅ Toutes les bases de données ont été créées avec succès!' as message;
SELECT '📊 Total: 9 bases de données' as info;
SELECT '🔤 Encodage: UTF8MB4 (support des emojis)' as encoding;
SELECT '📝 Prochaine étape: Configurer les variables d\'environnement' as next_step;
