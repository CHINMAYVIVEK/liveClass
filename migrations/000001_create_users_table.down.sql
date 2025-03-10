DROP TRIGGER IF EXISTS update_instructors_timestamp ON instructors;
DROP TRIGGER IF EXISTS update_students_timestamp ON students;
DROP TRIGGER IF EXISTS update_users_timestamp ON users;
DROP FUNCTION IF EXISTS update_timestamp();

DROP TABLE IF EXISTS instructors;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS user_roles;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS users;