-- =============================================================
-- Quarterly Database Project Part 3: Implement & Test
-- Project: Educational Resource Management System
-- Team: Anudari Undrakh and Jose Antonio Horta Herrera
-- Database platform: MySQL 8.0.16 or later
-- =============================================================

-- The DROP statement makes this classroom script safe to rerun from the top.
DROP DATABASE IF EXISTS educational_resource_db;
CREATE DATABASE educational_resource_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;
USE educational_resource_db;

-- =============================================================
-- 1. TABLES, KEYS, AND CONSTRAINTS
-- =============================================================

CREATE TABLE users (
    user_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    role ENUM(
        'Student',
        'Instructor',
        'Resource Administrator',
        'Academic Coordinator'
    ) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE categories (
    category_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(60) NOT NULL UNIQUE,
    description VARCHAR(255) NOT NULL
);

CREATE TABLE courses (
    course_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(12) NOT NULL UNIQUE,
    course_title VARCHAR(100) NOT NULL,
    department VARCHAR(60) NOT NULL,
    credits TINYINT UNSIGNED NOT NULL,
    instructor_id INT UNSIGNED NOT NULL,
    status ENUM('Active', 'Inactive') NOT NULL DEFAULT 'Active',
    CONSTRAINT chk_courses_credits
        CHECK (credits BETWEEN 1 AND 6),
    CONSTRAINT fk_courses_instructor
        FOREIGN KEY (instructor_id) REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE resources (
    resource_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    category_id INT UNSIGNED NOT NULL,
    title VARCHAR(150) NOT NULL,
    description VARCHAR(255) NOT NULL,
    resource_format ENUM(
        'Physical', 'PDF', 'Web', 'Video',
        'Audio', 'Software', 'Equipment', 'Dataset'
    ) NOT NULL,
    location_url VARCHAR(255) NOT NULL,
    availability_status ENUM(
        'Available', 'Checked Out', 'Restricted', 'Archived'
    ) NOT NULL DEFAULT 'Available',
    created_by INT UNSIGNED NOT NULL,
    last_updated DATE NOT NULL,
    CONSTRAINT fk_resources_category
        FOREIGN KEY (category_id) REFERENCES categories(category_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_resources_creator
        FOREIGN KEY (created_by) REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE course_resources (
    course_resource_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    course_id INT UNSIGNED NOT NULL,
    resource_id INT UNSIGNED NOT NULL,
    is_required BOOLEAN NOT NULL DEFAULT FALSE,
    week_number TINYINT UNSIGNED NULL,
    notes VARCHAR(255) NULL,
    assigned_on DATE NOT NULL,
    CONSTRAINT uq_course_resources
        UNIQUE (course_id, resource_id),
    CONSTRAINT chk_course_resources_week
        CHECK (week_number IS NULL OR week_number BETWEEN 1 AND 16),
    CONSTRAINT fk_course_resources_course
        FOREIGN KEY (course_id) REFERENCES courses(course_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_course_resources_resource
        FOREIGN KEY (resource_id) REFERENCES resources(resource_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE resource_usage (
    usage_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    resource_id INT UNSIGNED NOT NULL,
    user_id INT UNSIGNED NOT NULL,
    accessed_at DATETIME NOT NULL,
    action_type ENUM('Viewed', 'Downloaded', 'Borrowed', 'Returned') NOT NULL,
    feedback_rating TINYINT UNSIGNED NULL,
    CONSTRAINT chk_resource_usage_rating
        CHECK (feedback_rating IS NULL OR feedback_rating BETWEEN 1 AND 5),
    CONSTRAINT fk_resource_usage_resource
        FOREIGN KEY (resource_id) REFERENCES resources(resource_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_resource_usage_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Indexes support the most common filters, joins, and chronological reports.
CREATE INDEX idx_users_role_active
    ON users (role, active);

CREATE INDEX idx_courses_department_status
    ON courses (department, status);

CREATE INDEX idx_resources_category_status
    ON resources (category_id, availability_status);

CREATE INDEX idx_course_resources_course_week
    ON course_resources (course_id, week_number);

CREATE INDEX idx_resource_usage_resource_accessed
    ON resource_usage (resource_id, accessed_at);

CREATE INDEX idx_resource_usage_user_accessed
    ON resource_usage (user_id, accessed_at);

-- =============================================================
-- 2. SAMPLE DATA (40 ROWS PER TABLE)
-- Import order follows the foreign-key dependencies.
-- =============================================================

START TRANSACTION;

INSERT INTO users (user_id, first_name, last_name, email, role, active) VALUES
    (1, 'Aaliyah', 'Anderson', 'aaliyah.anderson@college.edu', 'Student', 1),
    (2, 'Alejandro', 'Bennett', 'alejandro.bennett@college.edu', 'Student', 1),
    (3, 'Amara', 'Castillo', 'amara.castillo@college.edu', 'Student', 1),
    (4, 'Benjamin', 'Diaz', 'benjamin.diaz@college.edu', 'Student', 1),
    (5, 'Camila', 'Edwards', 'camila.edwards@college.edu', 'Student', 1),
    (6, 'Carlos', 'Flores', 'carlos.flores@college.edu', 'Student', 1),
    (7, 'Chloe', 'Garcia', 'chloe.garcia@college.edu', 'Student', 1),
    (8, 'Daniel', 'Hernandez', 'daniel.hernandez@college.edu', 'Student', 1),
    (9, 'Elena', 'Ibrahim', 'elena.ibrahim@college.edu', 'Student', 1),
    (10, 'Ethan', 'Johnson', 'ethan.johnson@college.edu', 'Student', 1),
    (11, 'Fatima', 'Kim', 'fatima.kim@college.edu', 'Student', 1),
    (12, 'Gabriel', 'Lopez', 'gabriel.lopez@college.edu', 'Student', 1),
    (13, 'Grace', 'Martinez', 'grace.martinez@college.edu', 'Student', 1),
    (14, 'Hassan', 'Nguyen', 'hassan.nguyen@college.edu', 'Student', 1),
    (15, 'Isabella', 'Ortiz', 'isabella.ortiz@college.edu', 'Student', 1),
    (16, 'Jack', 'Patel', 'jack.patel@college.edu', 'Student', 1),
    (17, 'Jasmine', 'Quinn', 'jasmine.quinn@college.edu', 'Student', 1),
    (18, 'Jose', 'Ramirez', 'jose.ramirez@college.edu', 'Student', 1),
    (19, 'Kai', 'Singh', 'kai.singh@college.edu', 'Student', 1),
    (20, 'Layla', 'Thompson', 'layla.thompson@college.edu', 'Student', 1),
    (21, 'Leo', 'Usman', 'leo.usman@college.edu', 'Student', 1),
    (22, 'Lucia', 'Vargas', 'lucia.vargas@college.edu', 'Student', 1),
    (23, 'Maya', 'Williams', 'maya.williams@college.edu', 'Student', 1),
    (24, 'Mateo', 'Xu', 'mateo.xu@college.edu', 'Student', 1),
    (25, 'Naomi', 'Young', 'naomi.young@college.edu', 'Student', 1),
    (26, 'Noah', 'Zamora', 'noah.zamora@college.edu', 'Student', 1),
    (27, 'Olivia', 'Brooks', 'olivia.brooks@college.edu', 'Student', 0),
    (28, 'Omar', 'Chen', 'omar.chen@college.edu', 'Student', 1),
    (29, 'Priya', 'Davis', 'priya.davis@college.edu', 'Instructor', 1),
    (30, 'Rafael', 'Evans', 'rafael.evans@college.edu', 'Instructor', 1),
    (31, 'Sofia', 'Foster', 'sofia.foster@college.edu', 'Instructor', 1),
    (32, 'Samuel', 'Green', 'samuel.green@college.edu', 'Instructor', 1),
    (33, 'Valentina', 'Hall', 'valentina.hall@college.edu', 'Instructor', 1),
    (34, 'William', 'Ito', 'william.ito@college.edu', 'Instructor', 1),
    (35, 'Ximena', 'Jones', 'ximena.jones@college.edu', 'Instructor', 1),
    (36, 'Yusuf', 'Khan', 'yusuf.khan@college.edu', 'Instructor', 1),
    (37, 'Anudari', 'Undrakh', 'anudari.undrakh@college.edu', 'Resource Administrator', 1),
    (38, 'Louis', 'Ngonzo', 'louis.ngonzo@college.edu', 'Resource Administrator', 1),
    (39, 'Jordan', 'Horta', 'jordan.horta@college.edu', 'Academic Coordinator', 1),
    (40, 'Taylor', 'Rivera', 'taylor.rivera@college.edu', 'Academic Coordinator', 1);

INSERT INTO categories (category_id, category_name, description) VALUES
    (1, 'Textbook', 'Textbook materials used to support instruction, practice, reference, or assessment.'),
    (2, 'E-Book', 'E-Book materials used to support instruction, practice, reference, or assessment.'),
    (3, 'Study Guide', 'Study Guide materials used to support instruction, practice, reference, or assessment.'),
    (4, 'Video Lecture', 'Video Lecture materials used to support instruction, practice, reference, or assessment.'),
    (5, 'Lab Manual', 'Lab Manual materials used to support instruction, practice, reference, or assessment.'),
    (6, 'Practice Quiz', 'Practice Quiz materials used to support instruction, practice, reference, or assessment.'),
    (7, 'Dataset', 'Dataset materials used to support instruction, practice, reference, or assessment.'),
    (8, 'Slide Deck', 'Slide Deck materials used to support instruction, practice, reference, or assessment.'),
    (9, 'Research Article', 'Research Article materials used to support instruction, practice, reference, or assessment.'),
    (10, 'Tutorial', 'Tutorial materials used to support instruction, practice, reference, or assessment.'),
    (11, 'Reference Website', 'Reference Website materials used to support instruction, practice, reference, or assessment.'),
    (12, 'Software Tool', 'Software Tool materials used to support instruction, practice, reference, or assessment.'),
    (13, 'Simulation', 'Simulation materials used to support instruction, practice, reference, or assessment.'),
    (14, 'Worksheet', 'Worksheet materials used to support instruction, practice, reference, or assessment.'),
    (15, 'Case Study', 'Case Study materials used to support instruction, practice, reference, or assessment.'),
    (16, 'Podcast', 'Podcast materials used to support instruction, practice, reference, or assessment.'),
    (17, 'Audiobook', 'Audiobook materials used to support instruction, practice, reference, or assessment.'),
    (18, 'Coding Exercise', 'Coding Exercise materials used to support instruction, practice, reference, or assessment.'),
    (19, 'Formula Sheet', 'Formula Sheet materials used to support instruction, practice, reference, or assessment.'),
    (20, 'Reading List', 'Reading List materials used to support instruction, practice, reference, or assessment.'),
    (21, 'Course Syllabus', 'Course Syllabus materials used to support instruction, practice, reference, or assessment.'),
    (22, 'Discussion Prompt', 'Discussion Prompt materials used to support instruction, practice, reference, or assessment.'),
    (23, 'Project Brief', 'Project Brief materials used to support instruction, practice, reference, or assessment.'),
    (24, 'Rubric', 'Rubric materials used to support instruction, practice, reference, or assessment.'),
    (25, 'Sample Exam', 'Sample Exam materials used to support instruction, practice, reference, or assessment.'),
    (26, 'Answer Key', 'Answer Key materials used to support instruction, practice, reference, or assessment.'),
    (27, 'Infographic', 'Infographic materials used to support instruction, practice, reference, or assessment.'),
    (28, 'Map', 'Map materials used to support instruction, practice, reference, or assessment.'),
    (29, 'Timeline', 'Timeline materials used to support instruction, practice, reference, or assessment.'),
    (30, 'Primary Source', 'Primary Source materials used to support instruction, practice, reference, or assessment.'),
    (31, 'Secondary Source', 'Secondary Source materials used to support instruction, practice, reference, or assessment.'),
    (32, 'Language Resource', 'Language Resource materials used to support instruction, practice, reference, or assessment.'),
    (33, 'Accessibility Resource', 'Accessibility Resource materials used to support instruction, practice, reference, or assessment.'),
    (34, 'Career Guide', 'Career Guide materials used to support instruction, practice, reference, or assessment.'),
    (35, 'Citation Guide', 'Citation Guide materials used to support instruction, practice, reference, or assessment.'),
    (36, 'Library Reserve', 'Library Reserve materials used to support instruction, practice, reference, or assessment.'),
    (37, 'Equipment Guide', 'Equipment Guide materials used to support instruction, practice, reference, or assessment.'),
    (38, 'Safety Guide', 'Safety Guide materials used to support instruction, practice, reference, or assessment.'),
    (39, 'Field Manual', 'Field Manual materials used to support instruction, practice, reference, or assessment.'),
    (40, 'Capstone Template', 'Capstone Template materials used to support instruction, practice, reference, or assessment.');

INSERT INTO courses (course_id, course_code, course_title, department, credits, instructor_id, status) VALUES
    (1, 'CSC 110', 'Introduction to Programming', 'Computer Science', 3, 29, 'Active'),
    (2, 'CSC 120', 'Data Structures', 'Computer Science', 4, 30, 'Active'),
    (3, 'CSC 210', 'Database Fundamentals', 'Computer Science', 5, 31, 'Active'),
    (4, 'CSC 240', 'Web Development', 'Computer Science', 3, 32, 'Active'),
    (5, 'MAT 107', 'College Algebra', 'Mathematics', 4, 33, 'Active'),
    (6, 'MAT 151', 'Calculus I', 'Mathematics', 5, 34, 'Active'),
    (7, 'MAT 152', 'Calculus II', 'Mathematics', 3, 35, 'Active'),
    (8, 'STA 220', 'Applied Statistics', 'Mathematics', 4, 36, 'Active'),
    (9, 'ENG 101', 'English Composition I', 'English', 5, 29, 'Active'),
    (10, 'ENG 102', 'English Composition II', 'English', 3, 30, 'Active'),
    (11, 'BIO 101', 'General Biology', 'Biology', 4, 31, 'Active'),
    (12, 'BIO 201', 'Human Anatomy', 'Biology', 5, 32, 'Active'),
    (13, 'CHM 121', 'General Chemistry I', 'Chemistry', 3, 33, 'Active'),
    (14, 'CHM 122', 'General Chemistry II', 'Chemistry', 4, 34, 'Active'),
    (15, 'PHY 114', 'General Physics I', 'Physics', 5, 35, 'Active'),
    (16, 'PHY 115', 'General Physics II', 'Physics', 3, 36, 'Active'),
    (17, 'HIS 111', 'World History I', 'History', 4, 29, 'Active'),
    (18, 'HIS 112', 'World History II', 'History', 5, 30, 'Active'),
    (19, 'PSY 101', 'Introduction to Psychology', 'Psychology', 3, 31, 'Active'),
    (20, 'SOC 101', 'Introduction to Sociology', 'Sociology', 4, 32, 'Active'),
    (21, 'BUS 101', 'Introduction to Business', 'Business', 5, 33, 'Active'),
    (22, 'ACC 201', 'Financial Accounting', 'Business', 3, 34, 'Active'),
    (23, 'ECO 201', 'Microeconomics', 'Economics', 4, 35, 'Active'),
    (24, 'ECO 202', 'Macroeconomics', 'Economics', 5, 36, 'Active'),
    (25, 'ART 101', 'Art Appreciation', 'Fine Arts', 3, 29, 'Active'),
    (26, 'MUS 105', 'Music Appreciation', 'Fine Arts', 4, 30, 'Active'),
    (27, 'COM 110', 'Public Speaking', 'Communication', 5, 31, 'Active'),
    (28, 'PHI 101', 'Introduction to Philosophy', 'Humanities', 3, 32, 'Active'),
    (29, 'SPA 121', 'Spanish I', 'World Languages', 4, 33, 'Active'),
    (30, 'SPA 122', 'Spanish II', 'World Languages', 5, 34, 'Active'),
    (31, 'JPN 121', 'Japanese I', 'World Languages', 3, 35, 'Active'),
    (32, 'JPN 122', 'Japanese II', 'World Languages', 4, 36, 'Active'),
    (33, 'ENV 101', 'Environmental Science', 'Environmental Studies', 5, 29, 'Active'),
    (34, 'NUT 100', 'Nutrition and Wellness', 'Health Sciences', 3, 30, 'Active'),
    (35, 'HSC 110', 'Personal Health', 'Health Sciences', 4, 31, 'Active'),
    (36, 'CIS 125', 'Computer Applications', 'Information Systems', 5, 32, 'Active'),
    (37, 'CIS 155', 'Network Fundamentals', 'Information Systems', 3, 33, 'Active'),
    (38, 'EDU 101', 'Foundations of Education', 'Education', 4, 34, 'Active'),
    (39, 'ENGR 110', 'Engineering Design', 'Engineering', 5, 35, 'Active'),
    (40, 'CAP 290', 'Interdisciplinary Capstone', 'Interdisciplinary Studies', 3, 36, 'Inactive');

INSERT INTO resources (resource_id, category_id, title, description, resource_format, location_url, availability_status, created_by, last_updated) VALUES
    (1, 1, 'Programming Fundamentals: A Practical Approach', 'Curated textbook supporting college-level learning objectives.', 'Physical', 'Learning Center - Shelf A1', 'Available', 37, '2026-06-01'),
    (2, 2, 'Data Structures Open Text', 'Curated e-book supporting college-level learning objectives.', 'PDF', 'https://resources.college.edu/items/002', 'Available', 38, '2026-07-02'),
    (3, 3, 'Database Design Review Guide', 'Curated study guide supporting college-level learning objectives.', 'Web', 'https://resources.college.edu/items/003', 'Available', 39, '2026-06-03'),
    (4, 4, 'Responsive Web Design Lecture Series', 'Curated video lecture supporting college-level learning objectives.', 'Video', 'https://resources.college.edu/items/004', 'Restricted', 40, '2026-07-04'),
    (5, 5, 'General Biology Laboratory Manual', 'Curated lab manual supporting college-level learning objectives.', 'Audio', 'https://resources.college.edu/items/005', 'Checked Out', 37, '2026-06-05'),
    (6, 6, 'Calculus I Practice Quiz Bank', 'Curated practice quiz supporting college-level learning objectives.', 'Software', 'https://resources.college.edu/items/006', 'Available', 38, '2026-07-06'),
    (7, 7, 'Seattle Climate Observations Dataset', 'Curated dataset supporting college-level learning objectives.', 'Equipment', 'Learning Center - Shelf A7', 'Archived', 39, '2026-06-07'),
    (8, 8, 'Academic Writing Slide Deck', 'Curated slide deck supporting college-level learning objectives.', 'Dataset', 'https://resources.college.edu/items/008', 'Available', 40, '2026-07-08'),
    (9, 9, 'Learning Science Research Collection', 'Curated research article supporting college-level learning objectives.', 'Physical', 'Learning Center - Shelf C9', 'Available', 37, '2026-06-09'),
    (10, 10, 'Git and GitHub Guided Tutorial', 'Curated tutorial supporting college-level learning objectives.', 'PDF', 'https://resources.college.edu/items/010', 'Available', 38, '2026-07-10'),
    (11, 11, 'Purdue Online Writing Lab Reference', 'Curated reference website supporting college-level learning objectives.', 'Web', 'https://resources.college.edu/items/011', 'Restricted', 39, '2026-06-11'),
    (12, 12, 'MySQL Workbench Student Edition', 'Curated software tool supporting college-level learning objectives.', 'Video', 'https://resources.college.edu/items/012', 'Checked Out', 40, '2026-07-12'),
    (13, 13, 'Virtual Chemistry Lab Simulation', 'Curated simulation supporting college-level learning objectives.', 'Audio', 'https://resources.college.edu/items/013', 'Available', 37, '2026-06-13'),
    (14, 14, 'Statistics Probability Worksheet', 'Curated worksheet supporting college-level learning objectives.', 'Software', 'https://resources.college.edu/items/014', 'Archived', 38, '2026-07-14'),
    (15, 15, 'Business Ethics Case Study', 'Curated case study supporting college-level learning objectives.', 'Equipment', 'Learning Center - Shelf C6', 'Available', 39, '2026-06-15'),
    (16, 16, 'History in Context Podcast', 'Curated podcast supporting college-level learning objectives.', 'Dataset', 'https://resources.college.edu/items/016', 'Available', 40, '2026-07-16'),
    (17, 17, 'Introduction to Psychology Audiobook', 'Curated audiobook supporting college-level learning objectives.', 'Physical', 'Learning Center - Shelf E8', 'Available', 37, '2026-06-17'),
    (18, 18, 'JavaScript Array Coding Exercises', 'Curated coding exercise supporting college-level learning objectives.', 'PDF', 'https://resources.college.edu/items/018', 'Restricted', 38, '2026-07-18'),
    (19, 19, 'Calculus Formula Reference Sheet', 'Curated formula sheet supporting college-level learning objectives.', 'Web', 'https://resources.college.edu/items/019', 'Checked Out', 39, '2026-06-19'),
    (20, 20, 'World Literature Reading List', 'Curated reading list supporting college-level learning objectives.', 'Video', 'https://resources.college.edu/items/020', 'Available', 40, '2026-07-20'),
    (21, 21, 'Database Fundamentals Syllabus', 'Curated course syllabus supporting college-level learning objectives.', 'Audio', 'https://resources.college.edu/items/021', 'Archived', 37, '2026-06-21'),
    (22, 22, 'Sociology Community Discussion Prompt', 'Curated discussion prompt supporting college-level learning objectives.', 'Software', 'https://resources.college.edu/items/022', 'Available', 38, '2026-07-22'),
    (23, 23, 'Engineering Design Project Brief', 'Curated project brief supporting college-level learning objectives.', 'Equipment', 'Learning Center - Shelf E5', 'Available', 39, '2026-06-23'),
    (24, 24, 'Oral Presentation Evaluation Rubric', 'Curated rubric supporting college-level learning objectives.', 'Dataset', 'https://resources.college.edu/items/024', 'Available', 40, '2026-07-24'),
    (25, 25, 'General Chemistry Sample Midterm', 'Curated sample exam supporting college-level learning objectives.', 'Physical', 'Learning Center - Shelf A7', 'Restricted', 37, '2026-06-25'),
    (26, 26, 'Physics Practice Exam Answer Key', 'Curated answer key supporting college-level learning objectives.', 'PDF', 'https://resources.college.edu/items/026', 'Checked Out', 38, '2026-07-26'),
    (27, 27, 'Human Anatomy Systems Infographic', 'Curated infographic supporting college-level learning objectives.', 'Web', 'https://resources.college.edu/items/027', 'Available', 39, '2026-06-27'),
    (28, 28, 'Global Trade Routes Map', 'Curated map supporting college-level learning objectives.', 'Video', 'https://resources.college.edu/items/028', 'Archived', 40, '2026-07-28'),
    (29, 29, 'Modern Computing Milestones Timeline', 'Curated timeline supporting college-level learning objectives.', 'Audio', 'https://resources.college.edu/items/029', 'Available', 37, '2026-06-01'),
    (30, 30, 'Civil Rights Primary Documents', 'Curated primary source supporting college-level learning objectives.', 'Software', 'https://resources.college.edu/items/030', 'Available', 38, '2026-07-02'),
    (31, 31, 'Environmental Policy Background Reader', 'Curated secondary source supporting college-level learning objectives.', 'Equipment', 'Learning Center - Shelf A4', 'Available', 39, '2026-06-03'),
    (32, 32, 'Spanish Verb Practice Resource', 'Curated language resource supporting college-level learning objectives.', 'Dataset', 'https://resources.college.edu/items/032', 'Restricted', 40, '2026-07-04'),
    (33, 33, 'Accessible Document Design Guide', 'Curated accessibility resource supporting college-level learning objectives.', 'Physical', 'Learning Center - Shelf C6', 'Checked Out', 37, '2026-06-05'),
    (34, 34, 'Software Internship Preparation Guide', 'Curated career guide supporting college-level learning objectives.', 'PDF', 'https://resources.college.edu/items/034', 'Available', 38, '2026-07-06'),
    (35, 35, 'APA Citation Quick Guide', 'Curated citation guide supporting college-level learning objectives.', 'Web', 'https://resources.college.edu/items/035', 'Archived', 39, '2026-06-07'),
    (36, 36, 'Financial Accounting Library Reserve', 'Curated library reserve supporting college-level learning objectives.', 'Video', 'https://resources.college.edu/items/036', 'Available', 40, '2026-07-08'),
    (37, 37, 'Microscope Equipment Guide', 'Curated equipment guide supporting college-level learning objectives.', 'Audio', 'https://resources.college.edu/items/037', 'Available', 37, '2026-06-09'),
    (38, 38, 'Chemistry Laboratory Safety Guide', 'Curated safety guide supporting college-level learning objectives.', 'Software', 'https://resources.college.edu/items/038', 'Available', 38, '2026-07-10'),
    (39, 39, 'Ecology Field Observation Manual', 'Curated field manual supporting college-level learning objectives.', 'Equipment', 'Learning Center - Shelf C3', 'Restricted', 39, '2026-06-11'),
    (40, 40, 'Interdisciplinary Capstone Report Template', 'Curated capstone template supporting college-level learning objectives.', 'Dataset', 'https://resources.college.edu/items/040', 'Checked Out', 40, '2026-07-12');

INSERT INTO course_resources (course_resource_id, course_id, resource_id, is_required, week_number, notes, assigned_on) VALUES
    (1, 1, 1, 1, 1, 'Required before the weekly class meeting.', '2026-06-01'),
    (2, 2, 8, 1, 2, 'Required before the weekly class meeting.', '2026-06-02'),
    (3, 3, 15, 0, 3, 'Recommended for additional practice.', '2026-06-03'),
    (4, 4, 22, 1, 4, 'Required before the weekly class meeting.', '2026-06-04'),
    (5, 5, 4, 1, 5, 'Required before the weekly class meeting.', '2026-06-05'),
    (6, 6, 11, 0, 6, 'Recommended for additional practice.', '2026-06-06'),
    (7, 7, 18, 1, 7, 'Required before the weekly class meeting.', '2026-06-07'),
    (8, 8, 25, 1, 8, 'Required before the weekly class meeting.', '2026-06-08'),
    (9, 9, 7, 0, 9, 'Recommended for additional practice.', '2026-06-09'),
    (10, 10, 14, 1, 10, 'Required before the weekly class meeting.', '2026-06-10'),
    (11, 11, 21, 1, 1, 'Required before the weekly class meeting.', '2026-06-11'),
    (12, 12, 3, 0, 2, 'Recommended for additional practice.', '2026-06-12'),
    (13, 13, 10, 1, 3, 'Required before the weekly class meeting.', '2026-06-13'),
    (14, 14, 17, 1, 4, 'Required before the weekly class meeting.', '2026-06-14'),
    (15, 15, 24, 0, 5, 'Recommended for additional practice.', '2026-06-15'),
    (16, 16, 6, 1, 6, 'Required before the weekly class meeting.', '2026-06-16'),
    (17, 17, 13, 1, 7, 'Required before the weekly class meeting.', '2026-06-17'),
    (18, 18, 20, 0, 8, 'Recommended for additional practice.', '2026-06-18'),
    (19, 19, 2, 1, 9, 'Required before the weekly class meeting.', '2026-06-19'),
    (20, 20, 9, 1, 10, 'Required before the weekly class meeting.', '2026-06-20'),
    (21, 1, 16, 0, 1, 'Recommended for additional practice.', '2026-06-21'),
    (22, 2, 23, 1, 2, 'Required before the weekly class meeting.', '2026-06-22'),
    (23, 3, 5, 1, 3, 'Required before the weekly class meeting.', '2026-06-23'),
    (24, 4, 12, 0, 4, 'Recommended for additional practice.', '2026-06-24'),
    (25, 5, 19, 1, 5, 'Required before the weekly class meeting.', '2026-06-25'),
    (26, 6, 1, 1, 6, 'Required before the weekly class meeting.', '2026-06-26'),
    (27, 7, 8, 0, 7, 'Recommended for additional practice.', '2026-06-27'),
    (28, 8, 15, 1, 8, 'Required before the weekly class meeting.', '2026-06-28'),
    (29, 9, 22, 1, 9, 'Required before the weekly class meeting.', '2026-06-01'),
    (30, 10, 4, 0, 10, 'Recommended for additional practice.', '2026-06-02'),
    (31, 11, 11, 1, 1, 'Required before the weekly class meeting.', '2026-06-03'),
    (32, 12, 18, 1, 2, 'Required before the weekly class meeting.', '2026-06-04'),
    (33, 13, 25, 0, 3, 'Recommended for additional practice.', '2026-06-05'),
    (34, 14, 7, 1, 4, 'Required before the weekly class meeting.', '2026-06-06'),
    (35, 15, 14, 1, 5, 'Required before the weekly class meeting.', '2026-06-07'),
    (36, 16, 21, 0, 6, 'Recommended for additional practice.', '2026-06-08'),
    (37, 17, 3, 1, 7, 'Required before the weekly class meeting.', '2026-06-09'),
    (38, 18, 10, 1, 8, 'Required before the weekly class meeting.', '2026-06-10'),
    (39, 19, 17, 0, 9, 'Recommended for additional practice.', '2026-06-11'),
    (40, 20, 24, 1, 10, 'Required before the weekly class meeting.', '2026-06-12');

INSERT INTO resource_usage (usage_id, resource_id, user_id, accessed_at, action_type, feedback_rating) VALUES
    (1, 1, 1, '2026-07-01 08:00:00', 'Viewed', NULL),
    (2, 12, 10, '2026-07-02 09:07:00', 'Downloaded', 2),
    (3, 23, 19, '2026-07-03 10:14:00', 'Borrowed', 3),
    (4, 34, 28, '2026-07-04 11:21:00', 'Returned', 4),
    (5, 5, 9, '2026-07-05 12:28:00', 'Viewed', 5),
    (6, 16, 18, '2026-07-06 13:35:00', 'Downloaded', NULL),
    (7, 27, 27, '2026-07-07 14:42:00', 'Borrowed', 2),
    (8, 38, 8, '2026-07-08 15:49:00', 'Returned', 3),
    (9, 9, 17, '2026-07-09 16:56:00', 'Viewed', 4),
    (10, 20, 26, '2026-07-10 17:03:00', 'Downloaded', 5),
    (11, 31, 7, '2026-07-11 08:10:00', 'Borrowed', NULL),
    (12, 2, 16, '2026-07-12 09:17:00', 'Returned', 2),
    (13, 13, 25, '2026-07-13 10:24:00', 'Viewed', 3),
    (14, 24, 6, '2026-07-14 11:31:00', 'Downloaded', 4),
    (15, 35, 15, '2026-07-15 12:38:00', 'Borrowed', 5),
    (16, 6, 24, '2026-07-16 13:45:00', 'Returned', NULL),
    (17, 17, 5, '2026-07-17 14:52:00', 'Viewed', 2),
    (18, 28, 14, '2026-07-18 15:59:00', 'Downloaded', 3),
    (19, 39, 23, '2026-07-19 16:06:00', 'Borrowed', 4),
    (20, 10, 4, '2026-07-20 17:13:00', 'Returned', 5),
    (21, 21, 13, '2026-07-21 08:20:00', 'Viewed', NULL),
    (22, 32, 22, '2026-07-22 09:27:00', 'Downloaded', 2),
    (23, 3, 3, '2026-07-23 10:34:00', 'Borrowed', 3),
    (24, 14, 12, '2026-07-24 11:41:00', 'Returned', 4),
    (25, 25, 21, '2026-07-25 12:48:00', 'Viewed', 5),
    (26, 36, 2, '2026-07-26 13:55:00', 'Downloaded', NULL),
    (27, 7, 11, '2026-07-27 14:02:00', 'Borrowed', 2),
    (28, 18, 20, '2026-07-28 15:09:00', 'Returned', 3),
    (29, 29, 1, '2026-07-01 16:16:00', 'Viewed', 4),
    (30, 40, 10, '2026-07-02 17:23:00', 'Downloaded', 5),
    (31, 11, 19, '2026-07-03 08:30:00', 'Borrowed', NULL),
    (32, 22, 28, '2026-07-04 09:37:00', 'Returned', 2),
    (33, 33, 9, '2026-07-05 10:44:00', 'Viewed', 3),
    (34, 4, 18, '2026-07-06 11:51:00', 'Downloaded', 4),
    (35, 15, 27, '2026-07-07 12:58:00', 'Borrowed', 5),
    (36, 26, 8, '2026-07-08 13:05:00', 'Returned', NULL),
    (37, 37, 17, '2026-07-09 14:12:00', 'Viewed', 2),
    (38, 8, 26, '2026-07-10 15:19:00', 'Downloaded', 3),
    (39, 19, 7, '2026-07-11 16:26:00', 'Borrowed', 4),
    (40, 30, 16, '2026-07-12 17:33:00', 'Returned', 5);

COMMIT;

-- =============================================================
-- 3. VIEWS FOR COMMON DATA RETRIEVAL
-- =============================================================

-- View 1 combines courses, instructors, assigned resources, and categories.
CREATE OR REPLACE VIEW vw_course_resource_catalog AS
SELECT
    c.course_id,
    c.course_code,
    c.course_title,
    c.department,
    CONCAT(i.first_name, ' ', i.last_name) AS instructor_name,
    r.resource_id,
    r.title AS resource_title,
    cat.category_name,
    r.resource_format,
    r.availability_status,
    cr.is_required,
    cr.week_number,
    cr.notes,
    cr.assigned_on
FROM courses AS c
JOIN users AS i
    ON i.user_id = c.instructor_id
JOIN course_resources AS cr
    ON cr.course_id = c.course_id
JOIN resources AS r
    ON r.resource_id = cr.resource_id
JOIN categories AS cat
    ON cat.category_id = r.category_id;

-- View 2 summarizes how each resource has been used and rated.
CREATE OR REPLACE VIEW vw_resource_usage_summary AS
SELECT
    r.resource_id,
    r.title AS resource_title,
    cat.category_name,
    r.resource_format,
    r.availability_status,
    COUNT(ru.usage_id) AS total_interactions,
    SUM(CASE WHEN ru.action_type = 'Viewed' THEN 1 ELSE 0 END) AS total_views,
    SUM(CASE WHEN ru.action_type = 'Downloaded' THEN 1 ELSE 0 END) AS total_downloads,
    SUM(CASE WHEN ru.action_type = 'Borrowed' THEN 1 ELSE 0 END) AS total_borrows,
    SUM(CASE WHEN ru.action_type = 'Returned' THEN 1 ELSE 0 END) AS total_returns,
    ROUND(AVG(ru.feedback_rating), 2) AS average_rating,
    MAX(ru.accessed_at) AS last_accessed_at
FROM resources AS r
JOIN categories AS cat
    ON cat.category_id = r.category_id
LEFT JOIN resource_usage AS ru
    ON ru.resource_id = r.resource_id
GROUP BY
    r.resource_id,
    r.title,
    cat.category_name,
    r.resource_format,
    r.availability_status;

-- =============================================================
-- 4. SAMPLE QUERIES USED TO TEST THE DATABASE
-- =============================================================

-- Query 1: Show active courses with their instructors and assigned resources.
-- This query tests five-table joins and the Course_Resources junction table.
SELECT
    c.course_code,
    c.course_title,
    CONCAT(i.first_name, ' ', i.last_name) AS instructor_name,
    r.title AS resource_title,
    cat.category_name,
    cr.is_required,
    cr.week_number
FROM courses AS c
JOIN users AS i
    ON i.user_id = c.instructor_id
JOIN course_resources AS cr
    ON cr.course_id = c.course_id
JOIN resources AS r
    ON r.resource_id = cr.resource_id
JOIN categories AS cat
    ON cat.category_id = r.category_id
WHERE c.status = 'Active'
ORDER BY c.course_code, cr.week_number, r.title;

-- Query 2: Count available resources by format and calculate the share for each format.
-- This tests filtering, grouping, aggregate functions, and a subquery.
SELECT
    r.resource_format,
    COUNT(*) AS available_resource_count,
    ROUND(
        100.0 * COUNT(*) /
        (
            SELECT COUNT(*)
            FROM resources
            WHERE availability_status = 'Available'
        ),
        1
    ) AS share_of_available_percent
FROM resources AS r
WHERE r.availability_status = 'Available'
GROUP BY r.resource_format
ORDER BY available_resource_count DESC, r.resource_format;

-- Query 3: Summarize student activity and feedback.
-- This tests a three-table join, conditional aggregates, and HAVING.
SELECT
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS student_name,
    COUNT(ru.usage_id) AS total_interactions,
    SUM(CASE WHEN ru.action_type = 'Downloaded' THEN 1 ELSE 0 END) AS downloads,
    SUM(CASE WHEN ru.action_type = 'Borrowed' THEN 1 ELSE 0 END) AS borrows,
    ROUND(AVG(ru.feedback_rating), 2) AS average_rating
FROM users AS u
JOIN resource_usage AS ru
    ON ru.user_id = u.user_id
JOIN resources AS r
    ON r.resource_id = ru.resource_id
WHERE u.role = 'Student'
GROUP BY u.user_id, u.first_name, u.last_name
HAVING COUNT(ru.usage_id) >= 1
ORDER BY total_interactions DESC, student_name;

-- Query 4: Find highly rated resources and show when each was last accessed.
-- This tests the aggregate view, filtering, date formatting, and reusable reporting logic.
SELECT
    resource_title,
    category_name,
    total_interactions,
    average_rating,
    DATE_FORMAT(last_accessed_at, '%b %d, %Y') AS last_accessed
FROM vw_resource_usage_summary
WHERE average_rating >= 4
ORDER BY average_rating DESC, last_accessed_at DESC, resource_title
LIMIT 5;

-- Query 5: List courses that have required resources and show their count.
-- This tests the first view, grouping, and a business-focused HAVING condition.
SELECT
    course_code,
    course_title,
    instructor_name,
    COUNT(*) AS required_resource_count
FROM vw_course_resource_catalog
WHERE is_required = TRUE
GROUP BY course_id, course_code, course_title, instructor_name
HAVING COUNT(*) >= 1
ORDER BY required_resource_count DESC, course_code;

-- Query 6: Monthly usage by action type and resource format.
-- This tests date functions, joins, grouping, and chronological reporting.
SELECT
    DATE_FORMAT(ru.accessed_at, '%Y-%m') AS activity_month,
    r.resource_format,
    ru.action_type,
    COUNT(*) AS action_count
FROM resource_usage AS ru
JOIN resources AS r
    ON r.resource_id = ru.resource_id
GROUP BY
    DATE_FORMAT(ru.accessed_at, '%Y-%m'),
    r.resource_format,
    ru.action_type
ORDER BY activity_month, r.resource_format, ru.action_type;

-- =============================================================
-- 5. VALIDATION QUERIES
-- =============================================================

-- Expected result: 40 records in every table.
SELECT 'users' AS table_name, COUNT(*) AS row_count FROM users
UNION ALL
SELECT 'categories', COUNT(*) FROM categories
UNION ALL
SELECT 'courses', COUNT(*) FROM courses
UNION ALL
SELECT 'resources', COUNT(*) FROM resources
UNION ALL
SELECT 'course_resources', COUNT(*) FROM course_resources
UNION ALL
SELECT 'resource_usage', COUNT(*) FROM resource_usage;

-- Expected result: 0 orphaned foreign-key records.
SELECT
    (SELECT COUNT(*)
     FROM courses AS c
     LEFT JOIN users AS u ON u.user_id = c.instructor_id
     WHERE u.user_id IS NULL)
    +
    (SELECT COUNT(*)
     FROM resources AS r
     LEFT JOIN categories AS cat ON cat.category_id = r.category_id
     LEFT JOIN users AS u ON u.user_id = r.created_by
     WHERE cat.category_id IS NULL OR u.user_id IS NULL)
    +
    (SELECT COUNT(*)
     FROM course_resources AS cr
     LEFT JOIN courses AS c ON c.course_id = cr.course_id
     LEFT JOIN resources AS r ON r.resource_id = cr.resource_id
     WHERE c.course_id IS NULL OR r.resource_id IS NULL)
    +
    (SELECT COUNT(*)
     FROM resource_usage AS ru
     LEFT JOIN resources AS r ON r.resource_id = ru.resource_id
     LEFT JOIN users AS u ON u.user_id = ru.user_id
     WHERE r.resource_id IS NULL OR u.user_id IS NULL)
    AS total_orphan_records;

-- Optional view checks.
SELECT *
FROM vw_course_resource_catalog
ORDER BY course_code, week_number
LIMIT 20;

SELECT *
FROM vw_resource_usage_summary
ORDER BY total_interactions DESC, resource_title
LIMIT 20;
