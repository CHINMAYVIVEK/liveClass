-- Enable UUID extension (for PostgreSQL)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Students Table (Updated for UUID v4 with additional profiling fields)
CREATE TABLE students (
    student_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),  -- Use UUIDv4 for student_id
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    email VARCHAR(150) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    password_hash TEXT,  -- For local password-based login (if applicable)
    sso_provider VARCHAR(50),  -- e.g., 'google', 'facebook', etc.
    sso_provider_id VARCHAR(255),  -- Unique ID from SSO provider (e.g., google_user_id)
    profile_picture_url TEXT,  -- URL to profile picture (could be from SSO provider)
    bio TEXT,  -- Short bio or description
    date_of_birth DATE,
    address TEXT,  -- Optional, can store address details
    gender VARCHAR(20),  -- Gender (optional)
    social_media_handles JSONB,  -- JSON object to store multiple social media links
    nationality VARCHAR(50),  -- Nationality (optional)
    preferred_language VARCHAR(50),  -- Preferred language (optional)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_students_email UNIQUE(email)
);

-- Instructors Table (Updated for UUID v4 with additional profiling fields)
CREATE TABLE instructors (
    instructor_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),  -- Use UUIDv4 for instructor_id
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    email VARCHAR(150) UNIQUE NOT NULL,
    phone_number VARCHAR(15),
    password_hash TEXT,  -- For local password-based login (if applicable)
    sso_provider VARCHAR(50),  -- e.g., 'google', 'facebook', etc.
    sso_provider_id VARCHAR(255),  -- Unique ID from SSO provider (e.g., google_user_id)
    profile_picture_url TEXT,  -- URL to profile picture (could be from SSO provider)
    bio TEXT,  -- Short bio or description
    date_of_birth DATE,
    address TEXT,  -- Optional, can store address details
    gender VARCHAR(20),  -- Gender (optional)
    social_media_handles JSONB,  -- JSON object to store multiple social media links
    qualifications TEXT,  -- Qualifications (optional)
    years_of_experience INTEGER,  -- Years of experience (optional)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_instructors_email UNIQUE(email)
);

-- Courses Table (Unchanged)
CREATE TABLE courses (
    course_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),  -- Use UUIDv4 for course_id
    title VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

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
CREATE INDEX idx_students_email ON students(email);
CREATE INDEX idx_instructors_email ON instructors(email);
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


-- Delete all tables in the schema

--DROP TABLE IF EXISTS notes CASCADE;
--DROP TABLE IF EXISTS class_recordings CASCADE;
--DROP TABLE IF EXISTS classes CASCADE;
--DROP TABLE IF EXISTS students_enrolled CASCADE;
--DROP TABLE IF EXISTS batches CASCADE;
--DROP TABLE IF EXISTS instructors CASCADE;
--DROP TABLE IF EXISTS students CASCADE;
--DROP TABLE IF EXISTS courses CASCADE;




INSERT INTO students (first_name, last_name, email, phone_number, bio, date_of_birth, address, created_at, updated_at, gender) VALUES
    ('Hayley', 'Reichel-Watsica', 'Aaliyah23@hotmail.com', '5134639584', 'patriot, grad, developer', '1972-12-08', '305 Volkman Junction', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Female'),
    ('Jacques', 'Keeling', 'Brooke_Donnelly96@hotmail.com', '4066888808', 'boulder junkie  🦞', '2005-05-05', '5162 Bryce Ports', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Male'),
    ('Otis', 'Jerde', 'Aida_Rohan74@yahoo.com', '4473104490', 'coach', '1978-01-23', '16929 Eliezer Lock', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Male'),
    ('Kurt', 'Mann', 'Kiley.Corkery@hotmail.com', '3155964450', 'grad, public speaker', '2004-07-03', '68951 Broderick Tunnel', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Male'),
    ('Rafael', 'Jacobi', 'Kaley.OHara@hotmail.com', '8673866673', 'riot enthusiast, student 🏴', '1986-10-17', '6017 Bergnaum Lake', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Male'),
    ('Finn', 'Weissnat', 'Hailey_Ferry57@hotmail.com', '2763355087', 'ownership fan, activist', '1961-12-12', '865 Bernier Curve', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Male'),
    ('Jaquan', 'Roberts', 'Torey23@yahoo.com', '6729075110', 'business owner, streamer', '1963-03-11', '3598 Bradley Falls', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Male'),
    ('Duncan', 'McGlynn', 'Keyon81@yahoo.com', '4278634877', 'creator', '1952-08-24', '191 Fahey Pass', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Male'),
    ('Meta', 'Macejkovic', 'Madelyn96@gmail.com', '6222217119', 'singer', '1991-09-05', '34269 Trantow Crest', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Female'),
    ('Noble', 'O''Conner', 'Anthony_Kuhlman@hotmail.com', '5359151355', 'educator, coach, author 🎞️', '1958-05-28', '1207 Annabell Harbor', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Male'),
    ('Devante', 'Schneider', 'Buck_Waters@yahoo.com', '9624077577', 'dreamer, person, musician 🧻', '1970-01-18', '952 Adams Pines', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Male'),
    ('Tierra', 'Grimes', 'Jeanie.Mitchell@gmail.com', '1893569013', 'friend', '2004-09-18', '830 Charlene Common', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Female'),
    ('Esperanza', 'Christiansen', 'Sheila94@yahoo.com', '6883809944', 'dud advocate', '1975-11-20', '630 Medhurst Extension', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Female'),
    ('Hortense', 'Schoen', 'Salvador_Feil54@hotmail.com', '3756000406', 'teacher, leader, activist 🔺', '1994-07-11', '3906 Rhoda Estates', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Female'),
    ('Kimberly', 'Murphy', 'Fannie_Prohaska7@yahoo.com', '2777980326', 'activist, foodie, grad 🐆', '1984-03-06', '4194 Paucek Drives', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Female'),
    ('Doris', 'Altenwerth', 'Everardo_Schmeler90@gmail.com', '7522228558', 'grad', '1972-12-16', '150 Randi Greens', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Female'),
    ('Louie', 'Rutherford', 'Gayle.Block18@gmail.com', '8882665115', 'dreamer, singer, model ♑', '1953-10-11', '594 Dagmar Corner', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Male'),
    ('Ike', 'Kshlerin', 'Jesus50@gmail.com', '7805166231', 'lip lover, gamer 🙋🏿‍♀️', '1957-08-13', '7516 Considine Ways', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Male'),
    ('Newell', 'Fadel', 'Amalia.Tromp31@hotmail.com', '5808350869', 'excuse advocate, artist', '1986-01-11', '776 Piper Ranch', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Male'),
    ('Alexzander', 'Russel', 'Wade25@gmail.com', '7638754670', 'icing enthusiast, veteran 👉🏾', '2001-10-11', '5499 Doyle Well', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Male');

INSERT INTO students (
    first_name, last_name, email, phone_number, bio, date_of_birth, address, created_at, updated_at, gender
) VALUES
    ('Vito', 'Lockman', 'Celine_Steuber-Rau21@yahoo.com', '9207294670', 'leader, streamer', '1967-10-10', '613 Schulist Avenue', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Male'),
    ('Lera', 'Gleichner', 'Alva.Will@hotmail.com', '2798414006', 'teacher, grad, streamer 🇸🇹', '1977-11-12', '10125 Judge Dam', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Female'),
    ('Lowell', 'Jacobs', 'Dayne_Hirthe@yahoo.com', '8116335463', 'blogger, inventor, educator', '1984-05-14', '99326 Dicki Court', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Male'),
    ('Jesse', 'Deckow', 'Marlin83@yahoo.com', '5694493358', 'birdbath advocate  🌋', '1960-06-19', '72885 Leif Causeway', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Male'),
    ('Aniyah', 'Lindgren', 'Carson.McLaughlin36@yahoo.com', '2052368595', 'prestige fan, nerd', '2003-05-19', '721 Franz Via', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Female'),
    ('Samir', 'Heller', 'Candelario39@yahoo.com', '6544214140', 'bin supporter, philosopher 🕧', '1992-02-02', '530 Jaleel Parkways', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Male'),
    ('Burnice', 'Hagenes', 'Noe_Schimmel@hotmail.com', '9109145707', 'parent', '1946-01-04', '5709 Armstrong Mews', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Female'),
    ('Sophie', 'Labadie', 'Ilene.Goldner72@gmail.com', '2409692444', 'kingdom lover, streamer 🌥️', '1956-05-27', '47759 Bins Gardens', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Female'),
    ('Brian', 'Robel', 'Durward82@gmail.com', '8767334932', 'traveler, streamer, teacher ❄️', '1962-09-03', '707 Mary Motorway', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Male'),
    ('Ivy', 'Kuhic', 'Shaylee.Nienow15@hotmail.com', '3939203110', 'inventor, foodie', '2004-07-31', '506 Leopoldo Hollow', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Female'),
    ('Torrey', 'Rice', 'Jammie_Zboncak8@yahoo.com', '6417339828', 'creator, veteran, dreamer 🙂', '1962-12-21', '334 Hermann Fords', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Male'),
    ('Nicole', 'Friesen', 'Jacques_Feil@yahoo.com', '2519532910', 'inventor', '1950-09-17', '5929 Johnny Via', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Female'),
    ('Noe', 'Wolf', 'Lucile_Bradtke@hotmail.com', '5865114587', 'grad', '1959-08-11', '2021 Jacinthe Bypass', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Female'),
    ('Fay', 'Deckow', 'Guillermo.Mante@yahoo.com', '4073996134', 'surname advocate', '1981-10-22', '1582 Kiel Crossroad', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Female'),
    ('Greyson', 'Schmeler', 'Laurence.Bashirian@gmail.com', '9245817055', 'developer, musician', '1972-10-03', '78073 Marlon View', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Male'),
    ('Dejah', 'Hickle', 'Dillon_Thompson24@yahoo.com', '5875510624', 'crayon lover, veteran 🤛🏻', '2002-03-01', '703 Renner Highway', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Female'),
    ('Jarrell', 'MacGyver', 'Amara.Dietrich49@gmail.com', '9067236429', 'film lover, foodie, grad', '1980-12-26', '25733 Buckridge Expressway', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Male'),
    ('Melba', 'Larkin', 'Rosalind_Frami81@yahoo.com', '4644941015', 'traveler', '1951-05-02', '70684 Jacobi Lock', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Female'),
    ('Hollie', 'Stroman', 'Sylvan_Rice16@yahoo.com', '8945265287', 'inventor, blogger, environmentalist 👱🏼‍♀️', '1962-12-23', '72925 Fritsch Alley', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Female'),
    ('Mayra', 'Corkery-Strosin', 'Angeline.OConnell-Lebsack12@yahoo.com', '9426196075', 'key advocate', '1984-05-19', '874 Marquardt Hills', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Female');


INSERT INTO students (
    first_name, last_name, email, phone_number, bio, date_of_birth, address, gender, nationality, created_at, updated_at
) VALUES
    ('Ladarius', 'Treutel', 'Vena.Wilderman@hotmail.com', '1793750681', 'jaw lover, streamer', '1993-11-02', '19107 Fisher Light', 'male', 'Equatorial Guinea', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Ruthie', 'Wiegand', 'Xander77@gmail.com', '5464884243', 'disposal devotee, author', '1997-08-05', '744 Ashtyn Mall', 'female', 'Egypt', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Hazle', 'Runolfsdottir', 'Litzy67@gmail.com', '1227671253', 'futon enthusiast 💘', '1966-09-20', '971 Wisoky Plaza', 'male', 'Niger', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Darby', 'Cronin', 'Jonathon84@hotmail.com', '5658347362', 'musician, film lover, traveler 🟧', '1948-01-09', '731 Wisoky Meadow', 'male', 'North Macedonia', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Ralph', 'Grimes', 'Lenore_Beahan29@hotmail.com', '3836139729', 'robotics supporter, singer', '1958-04-14', '91887 Hudson Via', 'transgender', 'Micronesia', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Charles', 'Konopelski', 'Henderson_Shanahan@yahoo.com', '9465082333', 'author, parent, business owner 🤛🏻', '1990-07-07', '34961 Rae Port', 'transgender', 'Sierra Leone', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Arturo', 'Renner-Stokes', 'Zena30@hotmail.com', '7759390524', 'call lover 🕡', '1969-11-09', '5927 Gerhold Pines', 'transgender', 'Dominican Republic', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Rosamond', 'Adams', 'Pat79@hotmail.com', '7987201279', 'engineer', '1976-07-24', '2637 Walker Wall', 'transgender', 'Azerbaijan', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Jennifer', 'Champlin-Jones', 'Joanne61@gmail.com', '9864506299', 'divider fan, veteran', '1957-10-09', '2486 Pollich Shores', 'transgender', 'Gibraltar', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Imelda', 'Wiegand', 'Jason.Schaefer95@gmail.com', '7407914786', 'convention enthusiast, traveler', '2003-02-03', '147 Rodrigo Valley', 'transgender', 'India', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Lon', 'Witting', 'Angel.Kohler84@yahoo.com', '5002014803', 'public speaker', '1961-06-29', '184 Erich Tunnel', 'transgender', 'United States Minor Outlying Islands', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Alan', 'Hudson', 'Opal.Johns@gmail.com', '1397829364', 'nerd, foodie', '2002-02-28', '508 Zieme Parkways', 'transgender', 'Micronesia', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Elenor', 'Fritsch', 'Clementine_Schaden53@yahoo.com', '8295290183', 'philosopher, author, scientist', '1958-04-30', '9429 Elmer Key', 'transgender', 'Nauru', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Sage', 'Donnelly', 'Veronica_Corwin47@hotmail.com', '8268190897', 'info supporter 🎂', '1997-11-12', '524 Hoeger Hollow', 'transgender', 'Tonga', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Macy', 'Dach', 'Jenifer80@yahoo.com', '4526491417', 'parent, model, photographer', '1976-04-03', '926 Breanne Gateway', 'female', 'Mauritius', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Craig', 'Bauch', 'Sylvia.Zemlak@hotmail.com', '1439791617', 'dreamer, philosopher, entrepreneur', '1982-04-30', '163 Larson Branch', 'transgender', 'Saint Pierre and Miquelon', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Elliott', 'Windler', 'Alta4@gmail.com', '4989552860', 'philosopher', '1956-02-11', '99297 Lehner Ramp', 'male', 'Mexico', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Maryse', 'Kreiger', 'Zoie.Beahan@gmail.com', '1860429252', 'opportunist fan 🐸', '1964-11-22', '688 Johnson Plaza', 'female', 'Mauritius', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Shayna', 'Strosin', 'Berry.Parisian@yahoo.com', '7412009586', 'filmmaker, streamer', '1952-12-05', '82900 Waters Drive', 'transgender', 'Pakistan', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Rhiannon', 'Olson', 'Haskell94@yahoo.com', '1451813540', 'coach, leader, parent 🎤', '2006-03-12', '767 Gus Bypass', 'female', 'Zimbabwe', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);




INSERT INTO instructors (
    first_name, last_name, email, phone_number, password_hash, sso_provider, 
    sso_provider_id, profile_picture_url, bio, date_of_birth, address, 
    gender, social_media_handles, qualifications, years_of_experience, created_at, updated_at
) VALUES
('Olen', 'Aufderhar', 'Jermey.Kihn58@hotmail.com', '2178212016', NULL, NULL, NULL, NULL, 'venture lover  🤢', '1977-04-08', '816 Mireille Trafficway, Faroe Islands', 'male', '{}' , NULL, 7, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Terrell', 'Ratke', 'Brenden.Jerde58@gmail.com', '3485162506', NULL, NULL, NULL, NULL, 'grad', '1983-07-20', '335 Etha Fort, Iceland', 'male', '{}' , NULL, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Ardith', 'Stehr', 'Alycia_Murazik@gmail.com', '3178833752', NULL, NULL, NULL, NULL, 'streamer, foodie', '1963-08-27', '28816 Laurie Village, Isle of Man', 'female', '{}' , NULL, 9, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Flavio', 'McGlynn', 'Reyes.Friesen@gmail.com', '17536005310', NULL, NULL, NULL, NULL, 'cousin advocate, developer', '1972-01-22', '3261 Kristopher Bypass, Cyprus', 'male', '{}' , NULL, 8, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Kaylie', 'Ledner', 'Shad_Johnson@hotmail.com', '3564235003', NULL, NULL, NULL, NULL, 'minor-league enthusiast  🍰', '1963-06-13', '13983 Kunze Loaf, Virgin Islands, U.S.', 'female', '{}' , NULL, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Ike', 'Hamill', 'Robyn85@yahoo.com', '2346717557', NULL, NULL, NULL, NULL, 'entrepreneur', '1975-11-27', '1651 Amber Estate, Ghana', 'male', '{}' , NULL, 8, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Bernadette', 'Daugherty', 'Jessyca21@yahoo.com', '8219724759', NULL, NULL, NULL, NULL, 'scientist, designer', '1988-09-25', '2052 Littel Radial, Curacao', 'female', '{}' , NULL, 9, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Georgiana', 'Walker', 'Ewell53@yahoo.com', '12794557150', NULL, NULL, NULL, NULL, 'smith junkie, scientist 🔉', '1954-05-12', '4761 Harrison Knoll, Cyprus', 'female', '{}' , NULL, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Maddison', 'Runolfsdottir', 'Reece_Borer56@gmail.com', '6813432609', NULL, NULL, NULL, NULL, 'restoration advocate  🏙️', '1969-04-06', '2089 Ebert Shore, Mexico', 'female', '{}' , NULL, 8, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Kristian', 'Feest', 'Osvaldo87@yahoo.com', '9115050418', NULL, NULL, NULL, NULL, 'exterior lover, foodie', '1973-10-09', '4017 Nettie Cliffs, Guyana', 'male', '{}' , NULL, 7, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);



INSERT INTO courses (title, description) VALUES
('Data Structures and Algorithms (DSA)', 'Learn the fundamentals of DSA, including arrays, trees, graphs, sorting algorithms, and more.'),
('Hindustani Classical Vocal', 'An in-depth course focusing on ragas, classical techniques, and the history of Hindustani vocal music.'),
('Falit Jyotish (Vedic Astrology)', 'Explore the ancient science of astrology, learn how to interpret horoscopes, and understand planetary influences.'),
('Web Development with HTML, CSS, and JavaScript', 'A beginner-friendly course to learn the basics of web development including front-end technologies.'),
('Introduction to Machine Learning', 'Dive into machine learning concepts, algorithms, and techniques for data prediction and analysis.'),
('Photography Basics', 'Learn the principles of photography, camera settings, lighting techniques, and editing.'),
('Creative Writing', 'Enhance your writing skills, explore various styles, and develop your voice as a writer.'),
('Personal Finance and Investment Strategies', 'Learn how to manage personal finances, save, and make informed investment decisions.'),
('Public Speaking and Communication Skills', 'Improve your public speaking, presentation techniques, and interpersonal communication skills.'),
('Fitness and Weight Loss', 'A comprehensive guide to fitness routines, nutrition, and effective weight loss strategies.'),
('Yoga for Beginners', 'Understand the basics of yoga, including poses, breathing exercises, and relaxation techniques.'),
('Entrepreneurship and Business Startups', 'Gain insights into launching and running a successful startup, including business plans, marketing, and operations.'),
('Art of Meditation and Mindfulness', 'Learn various meditation techniques, mindfulness practices, and how they benefit mental health.'),
('Culinary Arts: Basics of Cooking', 'Learn the fundamental techniques of cooking, knife skills, and how to prepare meals from scratch.'),
('Introduction to Graphic Design', 'Learn the basics of graphic design, including design principles, tools, and typography.'),
('Advanced Excel for Data Analysis', 'Take your Excel skills to the next level, focusing on data analysis, pivot tables, and complex formulas.'),
('Music Theory and Composition', 'Understand the foundational principles of music theory, including scales, chords, and how to compose music.'),
('Film Making and Video Production', 'Explore the world of filmmaking, from scripting to shooting, editing, and post-production techniques.'),
('Artificial Intelligence for Beginners', 'Get started with AI, covering fundamental concepts like neural networks, deep learning, and natural language processing.'),
('Digital Marketing and Social Media Strategies', 'Learn how to use digital platforms, social media, and SEO techniques to grow businesses and brands online.');


INSERT INTO batches (course_id, batch_name, instructor_id, start_date, end_date) VALUES
('a0e8f6a9-8cb2-4cb2-bbc4-133fcce4418e', 'DSA Batch 1', '111d7c66-0541-4712-967f-3f586834ca80', '2025-03-10', '2025-06-10'),
('bfc774d9-ad68-439b-b61b-399a319e29a8', 'Hindustani Classical Vocal Batch 1', 'a264b4d1-2090-47df-8678-62a3b7275f91', '2025-04-01', '2025-07-01'),
('d81d4bf6-b6cc-45b2-9c80-d3dfe0b0408f', 'Vedic Astrology Batch 1', '55d31bd8-3f21-48de-9688-87fc9e81bada', '2025-03-15', '2025-06-15'),
('7da5aed3-23b4-438a-a296-8c4e70f48bcb', 'Web Development Batch 1', 'ae365955-0bcf-4766-96ec-65b15ebe2464', '2025-03-20', '2025-06-20'),
('72e35ada-ae9e-4d49-a869-d6a538a8fae7', 'Machine Learning Batch 1', '69abd674-83bd-48ac-9836-35c82e87aa4a', '2025-03-25', '2025-06-25'),
('09f85481-2596-4ca2-a942-ed4a1d610868', 'Photography Basics Batch 1', '8e26af9f-6f97-41c2-aac3-d482af993449', '2025-04-05', '2025-07-05'),
('987c94d2-efa9-46dc-90ae-835f4e0be0d2', 'Creative Writing Batch 1', '57f92096-3a7b-440b-899a-5ea811699888', '2025-03-30', '2025-06-30'),
('8692643e-ae1e-47c8-99be-3df0bc5fc549', 'Personal Finance Batch 1', '933a7e90-4873-4d9c-a480-ffeb02480af5', '2025-03-18', '2025-06-18'),
('42e52d6d-d010-441b-b1b8-6fbfb65e732c', 'Public Speaking Batch 1', '2bd2f411-c397-4d20-a734-32c0432bdb68', '2025-04-10', '2025-07-10'),
('38fd7790-3886-40e1-911b-fc8b7ed0f15f', 'Fitness and Weight Loss Batch 1', 'fdfa098a-8812-4096-b62f-2c86bccf7436', '2025-04-01', '2025-06-01'),
('071e82d5-fcf7-4d31-9f2c-ac5f02fa4a2a', 'Yoga for Beginners Batch 1', '111d7c66-0541-4712-967f-3f586834ca80', '2025-04-15', '2025-07-15'),
('e2dfd6dc-6c55-41fd-a258-263adb97755f', 'Entrepreneurship and Startups Batch 1', 'a264b4d1-2090-47df-8678-62a3b7275f91', '2025-03-05', '2025-06-05'),
('1268c870-784d-4560-afec-0d0e1d1de4bb', 'Meditation and Mindfulness Batch 1', '55d31bd8-3f21-48de-9688-87fc9e81bada', '2025-03-22', '2025-06-22'),
('c3fd5628-21d1-4e48-89c8-c7c4fc8b5735', 'Culinary Arts Batch 1', '69abd674-83bd-48ac-9836-35c82e87aa4a', '2025-04-20', '2025-07-20'),
('a7fbc32f-40f2-401f-8438-69a092f434d9', 'Graphic Design Batch 1', '8e26af9f-6f97-41c2-aac3-d482af993449', '2025-03-28', '2025-06-28'),
('6d792c1b-6fc0-4681-9f9e-f87ddac71a81', 'Advanced Excel Batch 1', '57f92096-3a7b-440b-899a-5ea811699888', '2025-03-12', '2025-06-12'),
('b3db5b7d-8e97-457f-89f7-fbf85f410241', 'Music Theory and Composition Batch 1', '933a7e90-4873-4d9c-a480-ffeb02480af5', '2025-03-17', '2025-06-17'),
('8258c893-173e-48cc-8b71-a5f73bd7cf65', 'Film Making and Video Production Batch 1', '2bd2f411-c397-4d20-a734-32c0432bdb68', '2025-04-08', '2025-07-08'),
('3c47155d-8b3f-44cc-8087-f3a836d7636a', 'Artificial Intelligence Batch 1', 'fdfa098a-8812-4096-b62f-2c86bccf7436', '2025-04-02', '2025-07-02'),
('eac68131-7cbe-4eaa-9918-cc99b8f55196', 'Digital Marketing Batch 1', '111d7c66-0541-4712-967f-3f586834ca80', '2025-04-18', '2025-07-18');


-- Enroll students into each batch (5 students per batch)
INSERT INTO students_enrolled (student_id, batch_id) VALUES
('7cf84eee-4155-495f-a0c7-a20335f89feb', '16803052-76df-47f5-b20f-3dc6a5f1da8e'),
('d6845c76-4866-4de3-877a-374e013b5d6f', '16803052-76df-47f5-b20f-3dc6a5f1da8e'),
('01e97943-24e2-424a-b379-a5823befa1de', '16803052-76df-47f5-b20f-3dc6a5f1da8e'),
('245dfbc8-63ed-44b2-808d-ab96cee358f2', '16803052-76df-47f5-b20f-3dc6a5f1da8e'),
('c6929acd-8108-4bc4-ba22-3da4dd05e6a3', '16803052-76df-47f5-b20f-3dc6a5f1da8e'),

('18890d51-344f-4544-b2b6-849cc5f8775c', 'eff2f223-48e8-4a45-87d7-7757859ccd11'),
('69032098-ade8-46e8-97d0-fb533db6972f', 'eff2f223-48e8-4a45-87d7-7757859ccd11'),
('ba404079-2809-413c-b6c8-c1d4a2f7a472', 'eff2f223-48e8-4a45-87d7-7757859ccd11'),
('1c54d620-144a-4603-bb1a-daddcdafb889', 'eff2f223-48e8-4a45-87d7-7757859ccd11'),
('def18a96-3c33-4e68-adca-503093f2abd1', 'eff2f223-48e8-4a45-87d7-7757859ccd11'),

('90223bb8-a019-4dfc-adf1-e98e20f0d898', 'd6d6ce87-0094-48d1-beb9-2a7b774b6772'),
('8fa18847-2eac-48bb-8e9b-16e5cc495551', 'd6d6ce87-0094-48d1-beb9-2a7b774b6772'),
('bef57a27-d040-499d-880f-a25af4eb6b3c', 'd6d6ce87-0094-48d1-beb9-2a7b774b6772'),
('e7333421-b669-49db-bb46-918d0f1176b4', 'd6d6ce87-0094-48d1-beb9-2a7b774b6772'),
('c0b5dc21-0924-433d-a8e5-51fd310a3d31', 'd6d6ce87-0094-48d1-beb9-2a7b774b6772'),

('82940495-be7b-4542-8dbb-8627205ed819', 'ccc5850c-5b95-48e8-b6d9-00f36805aef9'),
('4320492e-e725-4012-bdef-e751fe4f8082', 'ccc5850c-5b95-48e8-b6d9-00f36805aef9'),
('685c792f-9e1d-4f84-80e4-7f886e6f79cd', 'ccc5850c-5b95-48e8-b6d9-00f36805aef9'),
('b978131d-5694-43a4-aa79-98b93e9ee342', 'ccc5850c-5b95-48e8-b6d9-00f36805aef9'),
('26699616-9291-4921-9936-eefe2a47dd81', 'ccc5850c-5b95-48e8-b6d9-00f36805aef9'),

('e5fe5cc8-6bbd-4711-bd27-00b590ab12f3', 'fd70a9a1-334d-4924-9ca1-62ee2153ee10'),
('b1eb4175-89bd-48ea-be5a-31d1ea1d1cbd', 'fd70a9a1-334d-4924-9ca1-62ee2153ee10'),
('869b8929-0db4-4854-88d3-bb7c92b84890', 'fd70a9a1-334d-4924-9ca1-62ee2153ee10'),
('469b7e31-16e7-447c-a426-f2246660b33d', 'fd70a9a1-334d-4924-9ca1-62ee2153ee10'),
('55725929-db53-4fe0-ba2d-e1b444841b44', 'fd70a9a1-334d-4924-9ca1-62ee2153ee10'),

('d3c4569e-8026-44f4-8de3-01d05184aadc', '8f45e16d-0856-46e9-8bf7-2e7405adb6b9'),
('a49a2e8d-8854-4782-8928-8c9f54a82bf1', '8f45e16d-0856-46e9-8bf7-2e7405adb6b9'),
('57678847-a44f-4a09-8095-0adf6537b9b5', '8f45e16d-0856-46e9-8bf7-2e7405adb6b9'),
('b2d3cd1b-0c5c-47fc-a82f-1bdc997c619b', '8f45e16d-0856-46e9-8bf7-2e7405adb6b9'),
('c75c4275-9c18-46a3-a81c-5ae8f15cd16d', '8f45e16d-0856-46e9-8bf7-2e7405adb6b9'),

('54d81c1c-b3de-4fa7-bdd6-459c4df54591', 'bda99212-4b3c-4cd8-ba19-da9f5d384359'),
('c3cc83b9-286e-469f-b9e7-387c0f1c35d1', 'bda99212-4b3c-4cd8-ba19-da9f5d384359'),
('43239cc2-f601-4999-91bd-f476d9e9674d', 'bda99212-4b3c-4cd8-ba19-da9f5d384359'),
('060aed65-757d-4f97-afec-3708ecd934c1', 'bda99212-4b3c-4cd8-ba19-da9f5d384359'),
('503b721f-dba5-496d-85e7-57c2b3533674', 'bda99212-4b3c-4cd8-ba19-da9f5d384359'),

('31fa39a7-67db-4137-9a70-be82ec8a7d7a', 'e6f6d1a6-872d-4516-be03-e5749e34380a'),
('e5ce6744-bd11-4257-ad94-d044a63f6ef1', 'e6f6d1a6-872d-4516-be03-e5749e34380a'),
('b9024243-1834-4c13-a4a8-336506ee2350', 'e6f6d1a6-872d-4516-be03-e5749e34380a'),
('7844e880-08ec-438c-bdd2-28284c93e5b6', 'e6f6d1a6-872d-4516-be03-e5749e34380a'),
('1838aa07-a82c-4688-bcff-74bcde9c58eb', 'e6f6d1a6-872d-4516-be03-e5749e34380a'),

('056c8219-e7dc-4b03-b2a4-22c6db909c91', '9e90077e-d666-4cda-848b-3d3011767fd8'),
('a05db27b-28ee-4f90-9ad7-73d25337f87f', '9e90077e-d666-4cda-848b-3d3011767fd8'),
('eccada38-0b14-4171-ba0d-2a3989d96372', '9e90077e-d666-4cda-848b-3d3011767fd8'),
('9e872591-4b92-4136-a989-9d16ae533f10', '9e90077e-d666-4cda-848b-3d3011767fd8'),
('547adb2c-8092-469c-89f1-23f7914a9d93', '9e90077e-d666-4cda-848b-3d3011767fd8');



