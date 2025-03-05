-- Enable UUID extension (for PostgreSQL)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Roles Table: Defines different roles for users (e.g., student, instructor, admin)
CREATE TABLE roles (
    role_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    role_name VARCHAR(50) UNIQUE NOT NULL,  -- e.g., 'student', 'instructor', 'admin'
    description TEXT  -- Optional description of the role
);

-- Common Users Table (for both students and instructors)
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),  -- UUIDv4 for user_id
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    email VARCHAR(150) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    password_hash TEXT,  -- For local password-based login (bcrypt, scrypt, Argon2)
    sso_provider VARCHAR(50),  -- e.g., 'google', 'facebook', etc.
    sso_provider_id VARCHAR(255),  -- Unique ID from SSO provider (e.g., google_user_id)
    profile_picture_url TEXT,  -- URL to profile picture (could be from SSO provider)
    bio TEXT,  -- Short bio or description
    date_of_birth DATE,
    address TEXT,  -- Optional, can store address details
    gender VARCHAR(20) CHECK (gender IN ('male', 'female', 'transgender')),  -- Gender with validation
    social_media_handles JSONB,  -- JSON object to store multiple social media links
    nationality VARCHAR(50),  -- Nationality (optional)
    preferred_language VARCHAR(50),  -- Preferred language (optional)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_email UNIQUE(email)
);

-- User Roles Table: Associates users with one or more roles
CREATE TABLE user_roles (
    user_id UUID NOT NULL,  -- Foreign key to users table
    role_id UUID NOT NULL,  -- Foreign key to roles table
    PRIMARY KEY (user_id, role_id),
    CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE CASCADE
);

-- Students Table (references common user fields)
CREATE TABLE students (
    student_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,  -- Foreign key reference to users table
    CONSTRAINT fk_students_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Instructors Table (references common user fields)
CREATE TABLE instructors (
    instructor_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,  -- Foreign key reference to users table
    qualifications TEXT,  -- Qualifications (optional)
    years_of_experience INTEGER,  -- Years of experience (optional)
    CONSTRAINT fk_instructors_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);


CREATE TABLE course_types (
    type_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),  -- Use UUIDv4 for type_id
    type_name VARCHAR(255) NOT NULL,  -- Name of the course type (e.g., Technical, Music, History)
    description TEXT
);



CREATE TABLE courses (
    course_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),  -- Use UUIDv4 for course_id
    title VARCHAR(255) NOT NULL,
    description TEXT,
    image VARCHAR(255),
    is_active BOOLEAN DEFAULT FALSE,
    sequence_no INT DEFAULT 0,
    course_price VARCHAR(255) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    course_level VARCHAR(50) CHECK (course_level IN ('beginner', 'intermediate', 'advanced')) NOT NULL DEFAULT 'beginner',
    course_type_id UUID,
    CONSTRAINT fk_course_type FOREIGN KEY (course_type_id) REFERENCES course_types(type_id)
);

ALTER TABLE courses
ADD COLUMN course_level VARCHAR(50) CHECK (course_level IN ('beginner', 'intermediate', 'advanced')) NOT NULL DEFAULT 'beginner',
ADD COLUMN course_type_id UUID,
ADD CONSTRAINT fk_course_type FOREIGN KEY (course_type_id) REFERENCES course_types(type_id);


-- Batches Table (Updated for UUID v4)
CREATE TABLE batches (
    batch_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),  -- Use UUIDv4 for batch_id
    course_id UUID NOT NULL,  -- Foreign Key Reference to courses
    batch_name VARCHAR(100) NOT NULL,
    instructor_id UUID NOT NULL,  -- Foreign Key Reference to instructors
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_batches_course FOREIGN KEY(course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    CONSTRAINT fk_batches_instructor FOREIGN KEY(instructor_id) REFERENCES instructors(instructor_id) ON DELETE SET NULL
);

-- Students Enrolled Table (Updated for UUID v4)
CREATE TABLE students_enrolled (
    enrollment_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),  -- Use UUIDv4 for enrollment_id
    student_id UUID NOT NULL,  -- Foreign Key Reference to students
    batch_id UUID NOT NULL,  -- Foreign Key Reference to batches
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_enrollments_student FOREIGN KEY(student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    CONSTRAINT fk_enrollments_batch FOREIGN KEY(batch_id) REFERENCES batches(batch_id) ON DELETE CASCADE
);

-- Classes Table (Updated for UUID v4)
CREATE TABLE classes (
    class_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),  -- Use UUIDv4 for class_id
    batch_id UUID NOT NULL,  -- Foreign Key Reference to batches
    title VARCHAR(255) NOT NULL,
    scheduled_at TIMESTAMP,
    live_url TEXT,  -- URL to the live class platform
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_classes_batch FOREIGN KEY(batch_id) REFERENCES batches(batch_id) ON DELETE CASCADE
);

-- Class Recordings Table (Updated for UUID v4)
CREATE TABLE class_recordings (
    recording_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),  -- Use UUIDv4 for recording_id
    class_id UUID NOT NULL,  -- Foreign Key Reference to classes
    recording_url TEXT,  -- URL where the recording is stored
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_recordings_class FOREIGN KEY(class_id) REFERENCES classes(class_id) ON DELETE CASCADE
);

-- Notes Table (Updated for UUID v4)
CREATE TABLE notes (
    note_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),  -- Use UUIDv4 for note_id
    class_id UUID NOT NULL,  -- Foreign Key Reference to classes
    user_id UUID NOT NULL,  -- Foreign Key Reference to students or instructors
    note_url TEXT,  -- URL to the note document
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_notes_class FOREIGN KEY(class_id) REFERENCES classes(class_id) ON DELETE CASCADE,
    CONSTRAINT fk_notes_user FOREIGN KEY(user_id) REFERENCES students(student_id) ON DELETE CASCADE
);

-- Indexes for optimization (Unchanged and added foreign key indexes)
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_user_roles_user_id ON user_roles(user_id);
CREATE INDEX idx_user_roles_role_id ON user_roles(role_id);
CREATE INDEX idx_classes_batch_id ON classes(batch_id);
CREATE INDEX idx_enrollments_student_id ON students_enrolled(student_id);
CREATE INDEX idx_enrollments_batch_id ON students_enrolled(batch_id);
CREATE INDEX idx_class_recordings_class_id ON class_recordings(class_id);
CREATE INDEX idx_notes_class_id ON notes(class_id);
CREATE INDEX idx_notes_user_id ON notes(user_id);

-- Additional Indexes to optimize by timestamp
CREATE INDEX idx_batches_created_at ON batches(created_at);
CREATE INDEX idx_classes_scheduled_at ON classes(scheduled_at);
CREATE INDEX idx_class_recordings_recorded_at ON class_recordings(recorded_at);
CREATE INDEX idx_students_enrolled_date ON students_enrolled(enrollment_date);

-- Consider partitioning or sharding tables as they grow
-- Example partitioning on created_at for users, students_enrolled, etc.


-- Delete all tables in the schema

--DROP TABLE IF EXISTS notes CASCADE;
--DROP TABLE IF EXISTS class_recordings CASCADE;
--DROP TABLE IF EXISTS classes CASCADE;
--DROP TABLE IF EXISTS students_enrolled CASCADE;
--DROP TABLE IF EXISTS batches CASCADE;
--DROP TABLE IF EXISTS instructors CASCADE;
--DROP TABLE IF EXISTS students CASCADE;
--DROP TABLE IF EXISTS courses CASCADE;

INSERT INTO roles (role_name, description)
VALUES
    ('student', 'A user role representing a student in the system.'),
    ('instructor', 'A user role representing an instructor or teacher in the system.'),
    ('manager', 'A user role with managerial privileges, managing batches, courses, and students.'),
    ('admin', 'A user role with full administrative privileges to manage all aspects of the system.');



INSERT INTO users (
    first_name,
    last_name,
    email,
    phone_number,
    password_hash,
    sso_provider,
    sso_provider_id,
    profile_picture_url,
    bio,
    date_of_birth,
    address,
    gender,
    social_media_handles,
    nationality,
    preferred_language,
    created_at,
    updated_at
) values
    ('John', 'Doe', 'john.doe1@example.com', '+91 7000123456', 'hashed_password_1', 'google', 'google_id_1', 'https://randomuser.me/api/portraits/men/1.jpg', 'Bio: John Doe', '1990-01-15', '123 Main St, Springfield, USA', 'male', '{"facebook": "http://facebook.com/johndoe", "twitter": "http://twitter.com/johndoe"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Jane', 'Smith', 'jane.smith2@example.com', '+91 7000234567', 'hashed_password_2', 'facebook', 'facebook_id_2', 'https://randomuser.me/api/portraits/women/2.jpg', 'Bio: Jane Smith', '1985-02-20', '456 Oak St, London, UK', 'female', '{"facebook": "http://facebook.com/janesmith", "twitter": "http://twitter.com/janesmith"}', 'UK', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Alice', 'Johnson', 'alice.johnson3@example.com', '+91 7000345678', 'hashed_password_3', 'google', 'google_id_3', 'https://randomuser.me/api/portraits/women/3.jpg', 'Bio: Alice Johnson', '1995-03-25', '789 Elm St, New Delhi, India', 'female', '{"facebook": "http://facebook.com/alicejohnson", "twitter": "http://twitter.com/alicejohnson"}', 'India', 'Hindi, English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Bob', 'Brown', 'bob.brown4@example.com', '+91 7000456789', 'hashed_password_4', 'facebook', 'facebook_id_4', 'https://randomuser.me/api/portraits/men/4.jpg', 'Bio: Bob Brown', '1987-04-30', '101 Pine St, Moscow, Russia', 'male', '{"facebook": "http://facebook.com/bobbrown", "twitter": "http://twitter.com/bobbrown"}', 'Russia', 'Russian', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Charlie', 'Davis', 'charlie.davis5@example.com', '+91 7000567890', 'hashed_password_5', 'google', 'google_id_5', 'https://randomuser.me/api/portraits/men/5.jpg', 'Bio: Charlie Davis', '1992-05-05', '202 Maple St, Berlin, Germany', 'male', '{"facebook": "http://facebook.com/charliedavis", "twitter": "http://twitter.com/charliedavis"}', 'Germany', 'German', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('David', 'Martinez', 'david.martinez6@example.com', '+91 7000678901', 'hashed_password_6', 'facebook', 'facebook_id_6', 'https://randomuser.me/api/portraits/men/6.jpg', 'Bio: David Martinez', '1988-06-10', '303 Birch St, New York, USA', 'male', '{"facebook": "http://facebook.com/davidmartinez", "twitter": "http://twitter.com/davidmartinez"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Eva', 'Miller', 'eva.miller7@example.com', '+91 7000789012', 'hashed_password_7', 'google', 'google_id_7', 'https://randomuser.me/api/portraits/women/7.jpg', 'Bio: Eva Miller', '1993-07-15', '404 Cedar St, London, UK', 'female', '{"facebook": "http://facebook.com/evamiller", "twitter": "http://twitter.com/evamiller"}', 'UK', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Frank', 'Wilson', 'frank.wilson8@example.com', '+91 7000890123', 'hashed_password_8', 'facebook', 'facebook_id_8', 'https://randomuser.me/api/portraits/men/8.jpg', 'Bio: Frank Wilson', '1991-08-20', '505 Willow St, Mumbai, India', 'male', '{"facebook": "http://facebook.com/frankwilson", "twitter": "http://twitter.com/frankwilson"}', 'India', 'Hindi, English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Grace', 'Moore', 'grace.moore9@example.com', '+91 7000901234', 'hashed_password_9', 'google', 'google_id_9', 'https://randomuser.me/api/portraits/women/9.jpg', 'Bio: Grace Moore', '1994-09-25', '606 Oak St, Berlin, Germany', 'female', '{"facebook": "http://facebook.com/gracemoore", "twitter": "http://twitter.com/gracemoore"}', 'Germany', 'German', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Henry', 'Taylor', 'henry.taylor10@example.com', '+91 7000123457', 'hashed_password_10', 'facebook', 'facebook_id_10', 'https://randomuser.me/api/portraits/men/10.jpg', 'Bio: Henry Taylor', '1986-10-30', '707 Pine St, Moscow, Russia', 'male', '{"facebook": "http://facebook.com/henrytaylor", "twitter": "http://twitter.com/henrytaylor"}', 'Russia', 'Russian', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Ivy', 'Anderson', 'ivy.anderson11@example.com', '+91 7000234568', 'hashed_password_11', 'google', 'google_id_11', 'https://randomuser.me/api/portraits/women/11.jpg', 'Bio: Ivy Anderson', '1990-11-10', '808 Birch St, New York, USA', 'female', '{"facebook": "http://facebook.com/ivyanderson", "twitter": "http://twitter.com/ivyanderson"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Jack', 'Thomas', 'jack.thomas12@example.com', '+91 7000345679', 'hashed_password_12', 'facebook', 'facebook_id_12', 'https://randomuser.me/api/portraits/men/12.jpg', 'Bio: Jack Thomas', '1989-12-15', '909 Maple St, London, UK', 'male', '{"facebook": "http://facebook.com/jackthomas", "twitter": "http://twitter.com/jackthomas"}', 'UK', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Kathy', 'Jackson', 'kathy.jackson13@example.com', '+91 7000456790', 'hashed_password_13', 'google', 'google_id_13', 'https://randomuser.me/api/portraits/women/13.jpg', 'Bio: Kathy Jackson', '1992-01-20', '1010 Elm St, New Delhi, India', 'female', '{"facebook": "http://facebook.com/kathyjackson", "twitter": "http://twitter.com/kathyjackson"}', 'India', 'Hindi, English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Louis', 'White', 'louis.white14@example.com', '+91 7000567901', 'hashed_password_14', 'facebook', 'facebook_id_14', 'https://randomuser.me/api/portraits/men/14.jpg', 'Bio: Louis White', '1994-02-25', '1111 Cedar St, Moscow, Russia', 'male', '{"facebook": "http://facebook.com/louiswhite", "twitter": "http://twitter.com/louiswhite"}', 'Russia', 'Russian', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Mona', 'Harris', 'mona.harris15@example.com', '+91 7000679012', 'hashed_password_15', 'google', 'google_id_15', 'https://randomuser.me/api/portraits/women/15.jpg', 'Bio: Mona Harris', '1991-03-30', '1212 Willow St, New York, USA', 'female', '{"facebook": "http://facebook.com/monaharris", "twitter": "http://twitter.com/monaharris"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Nathan', 'Clark', 'nathan.clark16@example.com', '+91 7000789123', 'hashed_password_16', 'facebook', 'facebook_id_16', 'https://randomuser.me/api/portraits/men/16.jpg', 'Bio: Nathan Clark', '1987-04-10', '1313 Pine St, London, UK', 'male', '{"facebook": "http://facebook.com/nathanclark", "twitter": "http://twitter.com/nathanclark"}', 'UK', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Olivia', 'Lewis', 'olivia.lewis17@example.com', '+91 7000890234', 'hashed_password_17', 'google', 'google_id_17', 'https://randomuser.me/api/portraits/women/17.jpg', 'Bio: Olivia Lewis', '1993-05-05', '1414 Birch St, New Delhi, India', 'female', '{"facebook": "http://facebook.com/olivialeis", "twitter": "http://twitter.com/olivialeis"}', 'India', 'Hindi, English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Paul', 'Walker', 'paul.walker18@example.com', '+91 7000901345', 'hashed_password_18', 'facebook', 'facebook_id_18', 'https://randomuser.me/api/portraits/men/18.jpg', 'Bio: Paul Walker', '1995-06-15', '1515 Oak St, Berlin, Germany', 'male', '{"facebook": "http://facebook.com/paulwalker", "twitter": "http://twitter.com/paulwalker"}', 'Germany', 'German', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Quincy', 'Young', 'quincy.young19@example.com', '+91 7000123458', 'hashed_password_19', 'google', 'google_id_19', 'https://randomuser.me/api/portraits/men/19.jpg', 'Bio: Quincy Young', '1984-07-20', '1616 Cedar St, Moscow, Russia', 'male', '{"facebook": "http://facebook.com/quincyyoung", "twitter": "http://twitter.com/quincyyoung"}', 'Russia', 'Russian', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Rachel', 'King', 'rachel.king20@example.com', '+91 7000234569', 'hashed_password_20', 'facebook', 'facebook_id_20', 'https://randomuser.me/api/portraits/women/20.jpg', 'Bio: Rachel King', '1990-08-25', '1717 Willow St, New York, USA', 'female', '{"facebook": "http://facebook.com/rachelking", "twitter": "http://twitter.com/rachelking"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Tom', 'Scott', 'tom.scott21@example.com', '+91 7000123459', 'hashed_password_21', 'google', 'google_id_21', 'https://randomuser.me/api/portraits/men/1.jpg', 'Bio: Tom Scott', '1989-09-10', '1818 Oak St, Moscow, Russia', 'male', '{"facebook": "http://facebook.com/tomscott", "twitter": "http://twitter.com/tomscott"}', 'Russia', 'Russian', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Emily', 'Green', 'emily.green22@example.com', '+91 7000234570', 'hashed_password_22', 'facebook', 'facebook_id_22', 'https://randomuser.me/api/portraits/women/2.jpg', 'Bio: Emily Green', '1994-10-12', '1919 Maple St, Berlin, Germany', 'female', '{"facebook": "http://facebook.com/emilygreen", "twitter": "http://twitter.com/emilygreen"}', 'Germany', 'German', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Sam', 'Adams', 'sam.adams23@example.com', '+91 7000345680', 'hashed_password_23', 'google', 'google_id_23', 'https://randomuser.me/api/portraits/men/3.jpg', 'Bio: Sam Adams', '1986-11-15', '2020 Birch St, New Delhi, India', 'male', '{"facebook": "http://facebook.com/samadams", "twitter": "http://twitter.com/samadams"}', 'India', 'Hindi, English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Sophia', 'Baker', 'sophia.baker24@example.com', '+91 7000456801', 'hashed_password_24', 'facebook', 'facebook_id_24', 'https://randomuser.me/api/portraits/women/4.jpg', 'Bio: Sophia Baker', '1992-12-20', '2121 Pine St, New York, USA', 'female', '{"facebook": "http://facebook.com/sophiabaker", "twitter": "http://twitter.com/sophiabaker"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Lucas', 'Carter', 'lucas.carter25@example.com', '+91 7000567912', 'hashed_password_25', 'google', 'google_id_25', 'https://randomuser.me/api/portraits/men/5.jpg', 'Bio: Lucas Carter', '1991-01-05', '2222 Willow St, London, UK', 'male', '{"facebook": "http://facebook.com/lucascarter", "twitter": "http://twitter.com/lucascarter"}', 'UK', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Isabella', 'Martinez', 'isabella.martinez26@example.com', '+91 7000679023', 'hashed_password_26', 'facebook', 'facebook_id_26', 'https://randomuser.me/api/portraits/women/6.jpg', 'Bio: Isabella Martinez', '1995-02-10', '2323 Oak St, New Delhi, India', 'female', '{"facebook": "http://facebook.com/isabellamartinez", "twitter": "http://twitter.com/isabellamartinez"}', 'India', 'Hindi, English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('James', 'Wilson', 'james.wilson27@example.com', '+91 7000789134', 'hashed_password_27', 'google', 'google_id_27', 'https://randomuser.me/api/portraits/men/7.jpg', 'Bio: James Wilson', '1987-03-15', '2424 Cedar St, Moscow, Russia', 'male', '{"facebook": "http://facebook.com/jameswilson", "twitter": "http://twitter.com/jameswilson"}', 'Russia', 'Russian', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Charlotte', 'Allen', 'charlotte.allen28@example.com', '+91 7000890245', 'hashed_password_28', 'facebook', 'facebook_id_28', 'https://randomuser.me/api/portraits/women/8.jpg', 'Bio: Charlotte Allen', '1993-04-20', '2525 Pine St, London, UK', 'female', '{"facebook": "http://facebook.com/charlotteallen", "twitter": "http://twitter.com/charlotteallen"}', 'UK', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Ethan', 'King', 'ethan.king29@example.com', '+91 7000901356', 'hashed_password_29', 'google', 'google_id_29', 'https://randomuser.me/api/portraits/men/9.jpg', 'Bio: Ethan King', '1990-05-25', '2626 Birch St, New York, USA', 'male', '{"facebook": "http://facebook.com/ethanking", "twitter": "http://twitter.com/ethanking"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Ava', 'Lopez', 'ava.lopez30@example.com', '+91 7000123457', 'hashed_password_30', 'facebook', 'facebook_id_30', 'https://randomuser.me/api/portraits/women/10.jpg', 'Bio: Ava Lopez', '1988-06-30', '2727 Cedar St, New York, USA', 'female', '{"facebook": "http://facebook.com/avalopez", "twitter": "http://twitter.com/avalopez"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Mason', 'Gonzalez', 'mason.gonzalez31@example.com', '+91 7000234578', 'hashed_password_31', 'google', 'google_id_31', 'https://randomuser.me/api/portraits/men/11.jpg', 'Bio: Mason Gonzalez', '1992-07-05', '2828 Cedar St, New Delhi, India', 'male', '{"facebook": "http://facebook.com/masongonzalez", "twitter": "http://twitter.com/masongonzalez"}', 'India', 'Hindi, English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Amelia', 'Taylor', 'amelia.taylor32@example.com', '+91 7000345689', 'hashed_password_32', 'facebook', 'facebook_id_32', 'https://randomuser.me/api/portraits/women/12.jpg', 'Bio: Amelia Taylor', '1987-08-10', '2929 Willow St, Moscow, Russia', 'female', '{"facebook": "http://facebook.com/ameliataylor", "twitter": "http://twitter.com/ameliataylor"}', 'Russia', 'Russian', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Liam', 'Harris', 'liam.harris33@example.com', '+91 7000456790', 'hashed_password_33', 'google', 'google_id_33', 'https://randomuser.me/api/portraits/men/13.jpg', 'Bio: Liam Harris', '1995-09-15', '3030 Birch St, Berlin, Germany', 'male', '{"facebook": "http://facebook.com/liamharris", "twitter": "http://twitter.com/liamharris"}', 'Germany', 'German', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Zoe', 'Cunningham', 'zoe.cunningham34@example.com', '+91 7000567901', 'hashed_password_34', 'facebook', 'facebook_id_34', 'https://randomuser.me/api/portraits/women/14.jpg', 'Bio: Zoe Cunningham', '1991-10-20', '3131 Pine St, London, UK', 'female', '{"facebook": "http://facebook.com/zoecunningham", "twitter": "http://twitter.com/zoecunningham"}', 'UK', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Megan', 'Wright', 'megan.wright35@example.com', '+91 7000679012', 'hashed_password_35', 'google', 'google_id_35', 'https://randomuser.me/api/portraits/women/15.jpg', 'Bio: Megan Wright', '1990-11-25', '3232 Oak St, New York, USA', 'female', '{"facebook": "http://facebook.com/meganwright", "twitter": "http://twitter.com/meganwright"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Daniel', 'Martin', 'daniel.martin36@example.com', '+91 7000789123', 'hashed_password_36', 'facebook', 'facebook_id_36', 'https://randomuser.me/api/portraits/men/16.jpg', 'Bio: Daniel Martin', '1989-12-30', '3333 Cedar St, New Delhi, India', 'male', '{"facebook": "http://facebook.com/danielmartin", "twitter": "http://twitter.com/danielmartin"}', 'India', 'Hindi, English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Ethan', 'Davis', 'ethan.davis37@example.com', '+91 7000890234', 'hashed_password_37', 'google', 'google_id_37', 'https://randomuser.me/api/portraits/men/17.jpg', 'Bio: Ethan Davis', '1992-01-10', '3434 Pine St, Moscow, Russia', 'male', '{"facebook": "http://facebook.com/ethandavis", "twitter": "http://twitter.com/ethandavis"}', 'Russia', 'Russian', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Lily', 'Taylor', 'lily.taylor38@example.com', '+91 7000901345', 'hashed_password_38', 'facebook', 'facebook_id_38', 'https://randomuser.me/api/portraits/women/18.jpg', 'Bio: Lily Taylor', '1993-02-14', '3535 Birch St, Berlin, Germany', 'female', '{"facebook": "http://facebook.com/lilytaylor", "twitter": "http://twitter.com/lilytaylor"}', 'Germany', 'German', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Chloe', 'Hernandez', 'chloe.hernandez39@example.com', '+91 7000123456', 'hashed_password_39', 'google', 'google_id_39', 'https://randomuser.me/api/portraits/women/19.jpg', 'Bio: Chloe Hernandez', '1994-03-20', '3636 Cedar St, New York, USA', 'female', '{"facebook": "http://facebook.com/chloehernandez", "twitter": "http://twitter.com/chloehernandez"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Joshua', 'Young', 'joshua.young40@example.com', '+91 7000234567', 'hashed_password_40', 'facebook', 'facebook_id_40', 'https://randomuser.me/api/portraits/men/20.jpg', 'Bio: Joshua Young', '1988-04-25', '3737 Willow St, London, UK', 'male', '{"facebook": "http://facebook.com/joshuayoung", "twitter": "http://twitter.com/joshuayoung"}', 'UK', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Michael', 'Scott', 'michael.scott21@example.com', '+91 7000123460', 'hashed_password_21', 'google', 'google_id_21', 'https://randomuser.me/api/portraits/men/21.jpg', 'Bio: Michael Scott', '1980-01-12', '123 Office St, Scranton, USA', 'male', '{"facebook": "http://facebook.com/michaelscott", "twitter": "http://twitter.com/michaelscott"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Pam', 'Beesly', 'pam.beesly22@example.com', '+91 7000234570', 'hashed_password_22', 'facebook', 'facebook_id_22', 'https://randomuser.me/api/portraits/women/22.jpg', 'Bio: Pam Beesly', '1983-02-15', '456 Art St, Scranton, USA', 'female', '{"facebook": "http://facebook.com/pambeesly", "twitter": "http://twitter.com/pambeesly"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Jim', 'Halpert', 'jim.halpert23@example.com', '+91 7000345680', 'hashed_password_23', 'google', 'google_id_23', 'https://randomuser.me/api/portraits/men/23.jpg', 'Bio: Jim Halpert', '1985-03-10', '789 Paper St, Scranton, USA', 'male', '{"facebook": "http://facebook.com/jimhalpert", "twitter": "http://twitter.com/jimhalpert"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Angela', 'Martin', 'angela.martin24@example.com', '+91 7000456791', 'hashed_password_24', 'facebook', 'facebook_id_24', 'https://randomuser.me/api/portraits/women/24.jpg', 'Bio: Angela Martin', '1982-04-22', '101 Oak St, Scranton, USA', 'female', '{"facebook": "http://facebook.com/angelamartin", "twitter": "http://twitter.com/angelamartin"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Dwight', 'Schrute', 'dwight.schrute25@example.com', '+91 7000567902', 'hashed_password_25', 'google', 'google_id_25', 'https://randomuser.me/api/portraits/men/25.jpg', 'Bio: Dwight Schrute', '1978-05-05', '202 Beet St, Scranton, USA', 'male', '{"facebook": "http://facebook.com/dwightschrute", "twitter": "http://twitter.com/dwightschrute"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Ryan', 'Howard', 'ryan.howard26@example.com', '+91 7000679013', 'hashed_password_26', 'facebook', 'facebook_id_26', 'https://randomuser.me/api/portraits/men/26.jpg', 'Bio: Ryan Howard', '1986-06-18', '303 Technology St, Scranton, USA', 'male', '{"facebook": "http://facebook.com/ryanhoward", "twitter": "http://twitter.com/ryanhoward"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Kelly', 'Kapoor', 'kelly.kapoor27@example.com', '+91 7000789124', 'hashed_password_27', 'google', 'google_id_27', 'https://randomuser.me/api/portraits/women/27.jpg', 'Bio: Kelly Kapoor', '1987-07-30', '404 Fashion St, Scranton, USA', 'female', '{"facebook": "http://facebook.com/kellykapoor", "twitter": "http://twitter.com/kellykapoor"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Stanley', 'Hudson', 'stanley.hudson28@example.com', '+91 7000890235', 'hashed_password_28', 'facebook', 'facebook_id_28', 'https://randomuser.me/api/portraits/men/28.jpg', 'Bio: Stanley Hudson', '1950-08-15', '505 Calm St, Scranton, USA', 'male', '{"facebook": "http://facebook.com/stanleyhudson", "twitter": "http://twitter.com/stanleyhudson"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Phyllis', 'Vance', 'phyllis.vance29@example.com', '+91 7000901346', 'hashed_password_29', 'google', 'google_id_29', 'https://randomuser.me/api/portraits/women/29.jpg', 'Bio: Phyllis Vance', '1960-09-01', '606 Cozy St, Scranton, USA', 'female', '{"facebook": "http://facebook.com/phyllisvance", "twitter": "http://twitter.com/phyllisvance"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Creed', 'Bratton', 'creed.bratton30@example.com', '+91 7000123461', 'hashed_password_30', 'facebook', 'facebook_id_30', 'https://randomuser.me/api/portraits/men/30.jpg', 'Bio: Creed Bratton', '1945-10-10', '707 Mysterious St, Scranton, USA', 'male', '{"facebook": "http://facebook.com/creedbratton", "twitter": "http://twitter.com/creedbratton"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Oscar', 'Martinez', 'oscar.martinez31@example.com', '+91 7000234571', 'hashed_password_31', 'google', 'google_id_31', 'https://randomuser.me/api/portraits/men/31.jpg', 'Bio: Oscar Martinez', '1980-11-06', '808 Accountant St, Scranton, USA', 'male', '{"facebook": "http://facebook.com/oscarmartinez", "twitter": "http://twitter.com/oscarmartinez"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Toby', 'Flenderson', 'toby.flenderson32@example.com', '+91 7000345681', 'hashed_password_32', 'facebook', 'facebook_id_32', 'https://randomuser.me/api/portraits/men/32.jpg', 'Bio: Toby Flenderson', '1970-12-24', '909 Human Resources St, Scranton, USA', 'male', '{"facebook": "http://facebook.com/tobyflenderson", "twitter": "http://twitter.com/tobyflenderson"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Meredith', 'Palmer', 'meredith.palmer33@example.com', '+91 7000456792', 'hashed_password_33', 'google', 'google_id_33', 'https://randomuser.me/api/portraits/women/33.jpg', 'Bio: Meredith Palmer', '1965-01-18', '101 Party St, Scranton, USA', 'female', '{"facebook": "http://facebook.com/meredithpalmer", "twitter": "http://twitter.com/meredithpalmer"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Jan', 'Levinson', 'jan.levinson34@example.com', '+91 7000567903', 'hashed_password_34', 'facebook', 'facebook_id_34', 'https://randomuser.me/api/portraits/women/34.jpg', 'Bio: Jan Levinson', '1975-02-22', '202 Boss St, Scranton, USA', 'female', '{"facebook": "http://facebook.com/janlevinson", "twitter": "http://twitter.com/janlevinson"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Karen', 'Filippelli', 'karen.filippelli35@example.com', '+91 7000679014', 'hashed_password_35', 'google', 'google_id_35', 'https://randomuser.me/api/portraits/women/35.jpg', 'Bio: Karen Filippelli', '1985-03-14', '303 Sales St, Scranton, USA', 'female', '{"facebook": "http://facebook.com/karenfilippelli", "twitter": "http://twitter.com/karenfilippelli"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Holly', 'Flax', 'holly.flax36@example.com', '+91 7000789125', 'hashed_password_36', 'facebook', 'facebook_id_36', 'https://randomuser.me/api/portraits/women/36.jpg', 'Bio: Holly Flax', '1984-04-01', '404 HR St, Scranton, USA', 'female', '{"facebook": "http://facebook.com/hollyflax", "twitter": "http://twitter.com/hollyflax"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Darryl', 'Philbin', 'darryl.philbin37@example.com', '+91 7000890236', 'hashed_password_37', 'google', 'google_id_37', 'https://randomuser.me/api/portraits/men/37.jpg', 'Bio: Darryl Philbin', '1971-05-12', '505 Warehouse St, Scranton, USA', 'male', '{"facebook": "http://facebook.com/darrylphilbin", "twitter": "http://twitter.com/darrylphilbin"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Ryan', 'Gosling', 'ryan.gosling38@example.com', '+91 7000901347', 'hashed_password_38', 'facebook', 'facebook_id_38', 'https://randomuser.me/api/portraits/men/38.jpg', 'Bio: Ryan Gosling', '1980-06-14', '606 Hollywood St, Los Angeles, USA', 'male', '{"facebook": "http://facebook.com/ryangosling", "twitter": "http://twitter.com/ryangosling"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Emma', 'Stone', 'emma.stone39@example.com', '+91 7000123462', 'hashed_password_39', 'google', 'google_id_39', 'https://randomuser.me/api/portraits/women/39.jpg', 'Bio: Emma Stone', '1988-07-10', '707 Sunset St, Los Angeles, USA', 'female', '{"facebook": "http://facebook.com/emmastone", "twitter": "http://twitter.com/emmastone"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Ryan', 'Reynolds', 'ryan.reynolds40@example.com', '+91 7000234572', 'hashed_password_40', 'facebook', 'facebook_id_40', 'https://randomuser.me/api/portraits/men/40.jpg', 'Bio: Ryan Reynolds', '1976-10-23', '808 Broadway St, New York, USA', 'male', '{"facebook": "http://facebook.com/ryanreynolds", "twitter": "http://twitter.com/ryanreynolds"}', 'USA', 'English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


INSERT INTO users (
    first_name,
    last_name,
    email,
    phone_number,
    password_hash,
    sso_provider,
    sso_provider_id,
    profile_picture_url,
    bio,
    date_of_birth,
    address,
    gender,
    social_media_handles,
    nationality,
    preferred_language,
    created_at,
    updated_at
) VALUES
    ('Aarav', 'Sharma', 'aarav.sharma1@example.com', '+91 7000123463', 'hashed_password_1', 'google', 'google_id_1', 'https://randomuser.me/api/portraits/men/1.jpg', 'Bio: Aarav Sharma', '1990-01-15', '123 MG Road, New Delhi, India', 'male', '{"facebook": "http://facebook.com/aaravsharma", "twitter": "http://twitter.com/aaravsharma"}', 'India', 'Hindi, English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Priya', 'Patel', 'priya.patel2@example.com', '+91 7000234573', 'hashed_password_2', 'facebook', 'facebook_id_2', 'https://randomuser.me/api/portraits/women/2.jpg', 'Bio: Priya Patel', '1987-02-20', '456 Oak St, Mumbai, India', 'female', '{"facebook": "http://facebook.com/priyapatel", "twitter": "http://twitter.com/priyapatel"}', 'India', 'Hindi, Gujarati', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Ravi', 'Verma', 'ravi.verma3@example.com', '+91 7000345682', 'hashed_password_3', 'google', 'google_id_3', 'https://randomuser.me/api/portraits/men/3.jpg', 'Bio: Ravi Verma', '1992-03-25', '789 Park Lane, Bangalore, India', 'male', '{"facebook": "http://facebook.com/raviverma", "twitter": "http://twitter.com/raviverma"}', 'India', 'Kannada, English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Ananya', 'Singh', 'ananya.singh4@example.com', '+91 7000456794', 'hashed_password_4', 'facebook', 'facebook_id_4', 'https://randomuser.me/api/portraits/women/4.jpg', 'Bio: Ananya Singh', '1995-04-30', '101 Palm St, Chennai, India', 'female', '{"facebook": "http://facebook.com/ananyasingh", "twitter": "http://twitter.com/ananyasingh"}', 'India', 'Tamil, English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Amit', 'Kumar', 'amit.kumar5@example.com', '+91 7000567904', 'hashed_password_5', 'google', 'google_id_5', 'https://randomuser.me/api/portraits/men/5.jpg', 'Bio: Amit Kumar', '1986-05-10', '202 Rose St, Pune, India', 'male', '{"facebook": "http://facebook.com/amitkumar", "twitter": "http://twitter.com/amitkumar"}', 'India', 'Hindi, Marathi', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Sanya', 'Mehta', 'sanya.mehta6@example.com', '+91 7000679015', 'hashed_password_6', 'facebook', 'facebook_id_6', 'https://randomuser.me/api/portraits/women/6.jpg', 'Bio: Sanya Mehta', '1993-06-15', '303 Maple St, Ahmedabad, India', 'female', '{"facebook": "http://facebook.com/sanyamehta", "twitter": "http://twitter.com/sanyamehta"}', 'India', 'Gujarati, Hindi', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Vikram', 'Yadav', 'vikram.yadav7@example.com', '+91 7000789126', 'hashed_password_7', 'google', 'google_id_7', 'https://randomuser.me/api/portraits/men/7.jpg', 'Bio: Vikram Yadav', '1985-07-20', '404 Shakti St, Jaipur, India', 'male', '{"facebook": "http://facebook.com/vikramyadav", "twitter": "http://twitter.com/vikramyadav"}', 'India', 'Hindi, Rajasthani', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Sneha', 'Iyer', 'sneha.iyer8@example.com', '+91 7000890237', 'hashed_password_8', 'facebook', 'facebook_id_8', 'https://randomuser.me/api/portraits/women/8.jpg', 'Bio: Sneha Iyer', '1990-08-25', '505 Coconut St, Mumbai, India', 'female', '{"facebook": "http://facebook.com/snehaayer", "twitter": "http://twitter.com/snehaayer"}', 'India', 'Marathi, Hindi', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Karan', 'Joshi', 'karan.joshi9@example.com', '+91 7000901348', 'hashed_password_9', 'google', 'google_id_9', 'https://randomuser.me/api/portraits/men/9.jpg', 'Bio: Karan Joshi', '1992-09-30', '606 Blue St, Bangalore, India', 'male', '{"facebook": "http://facebook.com/karanjoshi", "twitter": "http://twitter.com/karanjoshi"}', 'India', 'Kannada, Hindi', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Ritu', 'Sharma', 'ritu.sharma10@example.com', '+91 7000123464', 'hashed_password_10', 'facebook', 'facebook_id_10', 'https://randomuser.me/api/portraits/women/10.jpg', 'Bio: Ritu Sharma', '1988-10-05', '707 Sunset St, Delhi, India', 'female', '{"facebook": "http://facebook.com/ritusharma", "twitter": "http://twitter.com/ritusharma"}', 'India', 'Hindi, Punjabi', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Anil', 'Reddy', 'anil.reddy11@example.com', '+91 7000234574', 'hashed_password_11', 'google', 'google_id_11', 'https://randomuser.me/api/portraits/men/11.jpg', 'Bio: Anil Reddy', '1990-11-15', '808 Sapphire St, Hyderabad, India', 'male', '{"facebook": "http://facebook.com/anilreddy", "twitter": "http://twitter.com/anilreddy"}', 'India', 'Telugu, English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Divya', 'Nair', 'divya.nair12@example.com', '+91 7000345683', 'hashed_password_12', 'facebook', 'facebook_id_12', 'https://randomuser.me/api/portraits/women/12.jpg', 'Bio: Divya Nair', '1993-12-20', '909 Green St, Kochi, India', 'female', '{"facebook": "http://facebook.com/divyanair", "twitter": "http://twitter.com/divyanair"}', 'India', 'Malayalam, English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Harish', 'Mishra', 'harish.mishra13@example.com', '+91 7000456795', 'hashed_password_13', 'google', 'google_id_13', 'https://randomuser.me/api/portraits/men/13.jpg', 'Bio: Harish Mishra', '1982-01-25', '101 West St, Lucknow, India', 'male', '{"facebook": "http://facebook.com/harishmishra", "twitter": "http://twitter.com/harishmishra"}', 'India', 'Hindi, Bhojpuri', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Neha', 'Gupta', 'neha.gupta14@example.com', '+91 7000567905', 'hashed_password_14', 'facebook', 'facebook_id_14', 'https://randomuser.me/api/portraits/women/14.jpg', 'Bio: Neha Gupta', '1994-02-10', '1111 Valley St, Kanpur, India', 'female', '{"facebook": "http://facebook.com/nehagupta", "twitter": "http://twitter.com/nehagupta"}', 'India', 'Hindi, English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Manish', 'Singh', 'manish.singh15@example.com', '+91 7000679016', 'hashed_password_15', 'google', 'google_id_15', 'https://randomuser.me/api/portraits/men/15.jpg', 'Bio: Manish Singh', '1985-03-12', '1212 City Center, Gurgaon, India', 'male', '{"facebook": "http://facebook.com/manishsingh", "twitter": "http://twitter.com/manishsingh"}', 'India', 'Hindi, Haryanvi', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Komal', 'Chawla', 'komal.chawla16@example.com', '+91 7000789127', 'hashed_password_16', 'facebook', 'facebook_id_16', 'https://randomuser.me/api/portraits/women/16.jpg', 'Bio: Komal Chawla', '1991-04-28', '1313 Blue Ridge, Chandigarh, India', 'female', '{"facebook": "http://facebook.com/komalchawla", "twitter": "http://twitter.com/komalchawla"}', 'India', 'Punjabi, Hindi', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Pankaj', 'Gupta', 'pankaj.gupta17@example.com', '+91 7000890238', 'hashed_password_17', 'google', 'google_id_17', 'https://randomuser.me/api/portraits/men/17.jpg', 'Bio: Pankaj Gupta', '1989-05-18', '1414 Red St, Kolkata, India', 'male', '{"facebook": "http://facebook.com/pankajgupta", "twitter": "http://twitter.com/pankajgupta"}', 'India', 'Bengali, Hindi', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Sweta', 'Patel', 'sweta.patel18@example.com', '+91 7000901349', 'hashed_password_18', 'facebook', 'facebook_id_18', 'https://randomuser.me/api/portraits/women/18.jpg', 'Bio: Sweta Patel', '1990-06-21', '1515 Tulip St, Surat, India', 'female', '{"facebook": "http://facebook.com/swetapatel", "twitter": "http://twitter.com/swetapatel"}', 'India', 'Gujarati, Hindi', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Sandeep', 'Kaur', 'sandeep.kaur19@example.com', '+91 7000123465', 'hashed_password_19', 'google', 'google_id_19', 'https://randomuser.me/api/portraits/men/19.jpg', 'Bio: Sandeep Kaur', '1987-07-08', '1616 Orchard St, Patiala, India', 'male', '{"facebook": "http://facebook.com/sandeepkaur", "twitter": "http://twitter.com/sandeepkaur"}', 'India', 'Punjabi, Hindi', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Tanya', 'Kumar', 'tanya.kumar20@example.com', '+91 7000234575', 'hashed_password_20', 'facebook', 'facebook_id_20', 'https://randomuser.me/api/portraits/women/20.jpg', 'Bio: Tanya Kumar', '1994-08-22', '1717 Riverside St, Noida, India', 'female', '{"facebook": "http://facebook.com/tanyakumar", "twitter": "http://twitter.com/tanyakumar"}', 'India', 'Hindi, English', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


-- Student role 61-80
INSERT INTO user_roles (user_id, role_id) VALUES
    ('bcf77305-f749-430c-861e-380af125f29e', '44fd7635-c193-4246-8869-18ad463e13be'),
    ('3a523e55-bdb7-49ca-95e3-df594bb83570', '44fd7635-c193-4246-8869-18ad463e13be'),
    ('7b6c25b6-3be7-4000-8ba7-3f7458bdd81b', '44fd7635-c193-4246-8869-18ad463e13be'),
    ('fb2ba136-52c7-4697-abf7-285546b083cd', '44fd7635-c193-4246-8869-18ad463e13be'),
    ('969f5295-d52d-4a42-8109-fdd4df9a6108', '44fd7635-c193-4246-8869-18ad463e13be'),
    ('9f088dc0-cf25-45e6-b017-b77a8be5fb68', '44fd7635-c193-4246-8869-18ad463e13be'),
    ('ffd7fa35-e727-4a8d-a75d-7aeedfc46078', '44fd7635-c193-4246-8869-18ad463e13be'),
    ('510e86b8-aa97-4199-82ac-37b9d33f9d71', '44fd7635-c193-4246-8869-18ad463e13be'),
    ('58e6251b-0c72-4049-877b-0c71e415a56f', '44fd7635-c193-4246-8869-18ad463e13be'),
    ('efd59086-b6bc-4104-a07f-cef6304d47d4', '44fd7635-c193-4246-8869-18ad463e13be'),
    ('f98a6d29-bb55-41be-b101-d5cb9a918261', '44fd7635-c193-4246-8869-18ad463e13be'),
    ('f6cbfe7c-80b3-4e25-836b-4b4321734b42', '44fd7635-c193-4246-8869-18ad463e13be'),
    ('ccc747c0-5e38-4463-997d-9a1b0e8dd585', '44fd7635-c193-4246-8869-18ad463e13be'),
    ('230bc85c-7b80-4ae7-8eed-4186e06c69b7', '44fd7635-c193-4246-8869-18ad463e13be'),
    ('9481094d-0ee9-4435-8cb5-b99edba6f60f', '44fd7635-c193-4246-8869-18ad463e13be'),
    ('e63dd0bf-e77b-4300-899e-157276ef5159', '44fd7635-c193-4246-8869-18ad463e13be'),
    ('8211ed29-b33a-4290-a422-a552c842f946', '44fd7635-c193-4246-8869-18ad463e13be'),
    ('e6049452-8673-4362-833e-01432733fb8a', '44fd7635-c193-4246-8869-18ad463e13be'),
    ('411ed73b-ceef-4012-b050-2d847c3f92b4', '44fd7635-c193-4246-8869-18ad463e13be'),
    ('6ef6c94f-54e5-49d0-a6b4-e8e0bff3870e', '44fd7635-c193-4246-8869-18ad463e13be');


INSERT INTO students (user_id) VALUES
    ('bcf77305-f749-430c-861e-380af125f29e'),
    ('3a523e55-bdb7-49ca-95e3-df594bb83570'),
    ('7b6c25b6-3be7-4000-8ba7-3f7458bdd81b'),
    ('fb2ba136-52c7-4697-abf7-285546b083cd'),
    ('969f5295-d52d-4a42-8109-fdd4df9a6108'),
    ('9f088dc0-cf25-45e6-b017-b77a8be5fb68'),
    ('ffd7fa35-e727-4a8d-a75d-7aeedfc46078'),
    ('510e86b8-aa97-4199-82ac-37b9d33f9d71'),
    ('58e6251b-0c72-4049-877b-0c71e415a56f'),
    ('efd59086-b6bc-4104-a07f-cef6304d47d4'),
    ('f98a6d29-bb55-41be-b101-d5cb9a918261'),
    ('f6cbfe7c-80b3-4e25-836b-4b4321734b42'),
    ('ccc747c0-5e38-4463-997d-9a1b0e8dd585'),
    ('230bc85c-7b80-4ae7-8eed-4186e06c69b7'),
    ('9481094d-0ee9-4435-8cb5-b99edba6f60f'),
    ('e63dd0bf-e77b-4300-899e-157276ef5159'),
    ('8211ed29-b33a-4290-a422-a552c842f946'),
    ('e6049452-8673-4362-833e-01432733fb8a'),
    ('411ed73b-ceef-4012-b050-2d847c3f92b4'),
    ('6ef6c94f-54e5-49d0-a6b4-e8e0bff3870e');


-- instructors 1-10

INSERT INTO user_roles (user_id, role_id) VALUES
    ('276f780a-bfd0-4472-97e9-1962f0bf7e66', '41ab7d5f-d889-4e89-a510-2e3c928a304e'),
    ('7ad6c580-33bc-48f7-9a47-43d4d9214449', '41ab7d5f-d889-4e89-a510-2e3c928a304e'),
    ('029a2bba-dd50-4485-897c-c890fb3eec02', '41ab7d5f-d889-4e89-a510-2e3c928a304e'),
    ('4abad104-843a-4ad7-992b-7217e6b434db', '41ab7d5f-d889-4e89-a510-2e3c928a304e'),
    ('1a3baa80-11ea-49e5-b88c-4a83a47fee17', '41ab7d5f-d889-4e89-a510-2e3c928a304e'),
    ('491d7f3e-a927-41f4-ae5a-a177e0ca7f04', '41ab7d5f-d889-4e89-a510-2e3c928a304e'),
    ('7e97574d-2b02-43fe-9456-c79900e15722', '41ab7d5f-d889-4e89-a510-2e3c928a304e'),
    ('ad050e44-70d1-4786-b902-9abfde66e1d8', '41ab7d5f-d889-4e89-a510-2e3c928a304e'),
    ('caf7215c-93a5-4594-9f31-36ca06ae86be', '41ab7d5f-d889-4e89-a510-2e3c928a304e'),
    ('d522ef17-c837-4a1f-93b5-082040fee391', '41ab7d5f-d889-4e89-a510-2e3c928a304e');

INSERT INTO instructors (user_id, qualifications, years_of_experience) VALUES
    ('276f780a-bfd0-4472-97e9-1962f0bf7e66', 'MSc Computer Science', 5),
    ('7ad6c580-33bc-48f7-9a47-43d4d9214449', 'PhD in Mathematics', 10),
    ('029a2bba-dd50-4485-897c-c890fb3eec02', 'MBA, BBA', 7),
    ('4abad104-843a-4ad7-992b-7217e6b434db', 'B.Tech in Electrical Engineering', 3),
    ('1a3baa80-11ea-49e5-b88c-4a83a47fee17', 'MSc Chemistry', 8),
    ('491d7f3e-a927-41f4-ae5a-a177e0ca7f04', 'M.A. in History', 12),
    ('7e97574d-2b02-43fe-9456-c79900e15722', 'BCA', 2),
    ('ad050e44-70d1-4786-b902-9abfde66e1d8', 'MBA in Marketing', 6),
    ('caf7215c-93a5-4594-9f31-36ca06ae86be', 'B.Tech in Mechanical Engineering', 9),
    ('d522ef17-c837-4a1f-93b5-082040fee391', 'PhD in Physics', 15);


INSERT INTO course_types (type_name, description) VALUES
('Technical', 'Courses focused on technical skills like programming, data science, and engineering.'),
('Music', 'Courses dedicated to music theory, instruments, and performance skills.'),
('History', 'Courses on historical events, ancient civilizations, and world history.'),
('Arts', 'Courses exploring different forms of visual and performing arts.'),
('Literature', 'Courses related to reading, analyzing, and interpreting literature across various genres.'),
('Business', 'Courses that cover business management, entrepreneurship, and organizational behavior.'),
('Psychology', 'Courses related to human behavior, mental processes, and psychological theories.'),
('Health & Fitness', 'Courses aimed at promoting physical health, fitness, and well-being.'),
('Environmental Studies', 'Courses focusing on environmental science, sustainability, and climate change.'),
('Social Sciences', 'Courses covering sociology, anthropology, economics, and political science.');



-- Insert data into the courses table with correct course_type_id and course_level
INSERT INTO courses (title, description, image, is_active, sequence_no, course_price, course_level, course_type_id) VALUES
('Hindustani Vocal', 'Learn the art of Hindustani classical vocal music, including ragas, taals, and improvisation techniques.', 'default_image_path.jpg', TRUE, 1, '0', 'beginner', 'e8b28ce5-1c30-49c2-98ac-9c2dc3fe1039'),  -- Music
('Falit Jyotish', 'Study the ancient Indian science of astrology, focusing on predictive astrology and charts.', 'default_image_path.jpg', TRUE, 2, '0', 'beginner', '437817d3-a279-42eb-bd81-516fbe8f422c'),  -- History
('Singing', 'Explore the basics of singing, voice techniques, and song interpretation across different genres.', 'default_image_path.jpg', TRUE, 3, '0', 'beginner', 'e8b28ce5-1c30-49c2-98ac-9c2dc3fe1039'),  -- Music
('DSA', 'Learn Data Structures and Algorithms, key concepts in computer science for solving complex problems efficiently.', 'default_image_path.jpg', TRUE, 4, '0', 'intermediate', 'bfbe9aa7-3329-4749-ae68-206dacb58901'),  -- Technical
('Web Development', 'Introduction to web development covering front-end and back-end technologies like HTML, CSS, JavaScript, and server-side scripting.', 'default_image_path.jpg', TRUE, 5, '0', 'intermediate', 'bfbe9aa7-3329-4749-ae68-206dacb58901'),  -- Technical
('Golang', 'Master the Go programming language, focusing on concurrency, performance, and building scalable applications.', 'default_image_path.jpg', TRUE, 6, '0', 'intermediate', 'bfbe9aa7-3329-4749-ae68-206dacb58901'),  -- Technical
('Rust', 'Learn Rust, a systems programming language known for memory safety and high performance.', 'default_image_path.jpg', TRUE, 7, '0', 'intermediate', 'bfbe9aa7-3329-4749-ae68-206dacb58901'),  -- Technical
('Ancient Indian History', 'Explore the rich history of ancient India, focusing on its kingdoms, cultures, and contributions to world heritage.', 'default_image_path.jpg', TRUE, 8, '0', 'beginner', '437817d3-a279-42eb-bd81-516fbe8f422c'),  -- History
('Environmental Studies', 'Study the key concepts of ecology, conservation, and the impact of human activities on the environment.', 'default_image_path.jpg', TRUE, 9, '0', 'beginner', '5e033d99-00c5-4e47-8e1d-fa07cdc536dc'),  -- Environmental Studies
('Social Psychology', 'Study how individuals are influenced by their social environment and how attitudes, beliefs, and behaviors are shaped by society.', 'default_image_path.jpg', TRUE, 10, '0', 'beginner', '0b898119-8736-40a5-8a53-63950787084c'),  -- Psychology
('World War II: A Historical Perspective', 'An in-depth study of the causes, events, and aftermath of World War II and its impact on the world.', 'default_image_path.jpg', TRUE, 11, '0', 'beginner', '437817d3-a279-42eb-bd81-516fbe8f422c'),  -- History
('Environmental Sustainability', 'Learn about sustainable practices and how they help protect ecosystems and biodiversity for future generations.', 'default_image_path.jpg', TRUE, 12, '0', 'intermediate', '5e033d99-00c5-4e47-8e1d-fa07cdc536dc'),  -- Environmental Studies
('Modern Political Philosophy', 'Examine key political ideologies and philosophies from the Enlightenment to contemporary thought.', 'default_image_path.jpg', TRUE, 13, '0', 'intermediate', '0fe8c8d3-7ccf-44cc-ab42-2e98a5574dcf'),  -- Social Sciences
('Ancient Greek Philosophy', 'Study the foundational ideas of Greek philosophers like Socrates, Plato, and Aristotle and their lasting impact on Western thought.', 'default_image_path.jpg', TRUE, 14, '0', 'beginner', '437817d3-a279-42eb-bd81-516fbe8f422c'),  -- History
('Social Media and Society', 'Explore the role of social media in shaping modern society, culture, and individual behavior.', 'default_image_path.jpg', TRUE, 15, '0', 'intermediate', '0fe8c8d3-7ccf-44cc-ab42-2e98a5574dcf'),  -- Social Sciences
('History of the Roman Empire', 'Learn about the rise and fall of the Roman Empire and its influence on Western civilization.', 'default_image_path.jpg', TRUE, 16, '0', 'beginner', '437817d3-a279-42eb-bd81-516fbe8f422c'),  -- History
('Gender Studies', 'Study the social and cultural aspects of gender, identity, and equality in different societies throughout history.', 'default_image_path.jpg', TRUE, 17, '0', 'beginner', '0fe8c8d3-7ccf-44cc-ab42-2e98a5574dcf'),  -- Social Sciences
('Climate Change and Policy', 'Understand the science of climate change and the policies aimed at mitigating its effects on a global scale.', 'default_image_path.jpg', TRUE, 18, '0', 'intermediate', '5e033d99-00c5-4e47-8e1d-fa07cdc536dc'),  -- Environmental Studies
('Ancient Civilizations', 'Explore the history of ancient civilizations like Mesopotamia, Egypt, the Indus Valley, and China.', 'default_image_path.jpg', TRUE, 19, '0', 'beginner', '437817d3-a279-42eb-bd81-516fbe8f422c'),  -- History
('Public Health and Society', 'Study the intersections between public health, society, and policy, focusing on issues like disease prevention and health education.', 'default_image_path.jpg', TRUE, 20, '0', 'intermediate', 'c89d164c-e2c9-48df-96f3-ccbdffd6d3a8');  -- Health & Fitness



