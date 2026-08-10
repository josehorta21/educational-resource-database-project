--Referential Integrity Tests
-- Educational Resource Management System
-- Purpose: Check for records that reference missing related records.

-- 1. Check for course_resources records with missing courses or resources
SELECT
    cr.course_resource_id,
    cr.course_id,
    cr.resource_id
FROM course_resources cr
LEFT JOIN courses c
    ON cr.course_id = c.course_id
LEFT JOIN resources r
    ON cr.resource_id = r.resource_id
WHERE c.course_id IS NULL
   OR r.resource_id IS NULL;

-- 2. Check for resource_usage records with missing users or resources
SELECT
    ru.usage_id,
    ru.user_id,
    ru.resource_id
FROM resource_usage ru
LEFT JOIN users u
    ON ru.user_id = u.user_id
LEFT JOIN resources r
    ON ru.resource_id = r.resource_id
WHERE u.user_id IS NULL
   OR r.resource_id IS NULL;

-- 3. Check for resources with missing categories
SELECT
    r.resource_id,
    r.category_id
FROM resources r
LEFT JOIN categories c
    ON r.category_id = c.category_id
WHERE c.category_id IS NULL;

-- 4. Check for courses with missing instructors
SELECT
    c.course_id,
    c.instructor_id
FROM courses c
LEFT JOIN users u
    ON c.instructor_id = u.user_id
WHERE u.user_id IS NULL;
