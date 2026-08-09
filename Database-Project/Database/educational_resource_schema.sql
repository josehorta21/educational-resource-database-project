-- Educational Resource Management System
-- MySQL 8.0+

CREATE DATABASE IF NOT EXISTS educational_resource_db;
USE educational_resource_db;

CREATE TABLE users (
    user_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    role ENUM('Student', 'Instructor', 'Resource Administrator', 'Academic Coordinator') NOT NULL,
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
    CONSTRAINT chk_courses_credits CHECK (credits BETWEEN 1 AND 6),
    CONSTRAINT fk_courses_instructor
        FOREIGN KEY (instructor_id) REFERENCES users(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE resources (
    resource_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    category_id INT UNSIGNED NOT NULL,
    title VARCHAR(150) NOT NULL,
    description VARCHAR(255) NOT NULL,
    resource_format ENUM('Physical', 'PDF', 'Web', 'Video', 'Audio', 'Software', 'Equipment', 'Dataset') NOT NULL,
    location_url VARCHAR(255) NOT NULL,
    availability_status ENUM('Available', 'Checked Out', 'Restricted', 'Archived') NOT NULL DEFAULT 'Available',
    created_by INT UNSIGNED NOT NULL,
    last_updated DATE NOT NULL,
    CONSTRAINT fk_resources_category
        FOREIGN KEY (category_id) REFERENCES categories(category_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_resources_creator
        FOREIGN KEY (created_by) REFERENCES users(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE course_resources (
    course_resource_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    course_id INT UNSIGNED NOT NULL,
    resource_id INT UNSIGNED NOT NULL,
    is_required BOOLEAN NOT NULL DEFAULT FALSE,
    week_number TINYINT UNSIGNED NULL,
    notes VARCHAR(255) NULL,
    assigned_on DATE NOT NULL,
    CONSTRAINT uq_course_resources UNIQUE (course_id, resource_id),
    CONSTRAINT chk_course_resources_week CHECK (week_number IS NULL OR week_number BETWEEN 1 AND 16),
    CONSTRAINT fk_course_resources_course
        FOREIGN KEY (course_id) REFERENCES courses(course_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_course_resources_resource
        FOREIGN KEY (resource_id) REFERENCES resources(resource_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE resource_usage (
    usage_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    resource_id INT UNSIGNED NOT NULL,
    user_id INT UNSIGNED NOT NULL,
    accessed_at DATETIME NOT NULL,
    action_type ENUM('Viewed', 'Downloaded', 'Borrowed', 'Returned') NOT NULL,
    feedback_rating TINYINT UNSIGNED NULL,
    CONSTRAINT chk_resource_usage_rating CHECK (feedback_rating IS NULL OR feedback_rating BETWEEN 1 AND 5),
    CONSTRAINT fk_resource_usage_resource
        FOREIGN KEY (resource_id) REFERENCES resources(resource_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_resource_usage_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

