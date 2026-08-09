# Database Design Explanation

## Project Purpose

The Educational Resource Management System gives a college one searchable place to manage textbooks, e-books, study guides, videos, laboratory materials, assessments, and other course content. It replaces scattered records maintained in spreadsheets, folders, email messages, websites, and paper files.

## Design Decisions

The design uses six entities in a normalized relational structure. `Users` stores all system participants and distinguishes students, instructors, resource administrators, and academic coordinators with the `role` attribute. `Courses` identifies the instructor assigned to each course. `Categories` provides a controlled classification list, while `Resources` stores the descriptive, format, location, availability, and maintenance details for each learning item.

Because one course may use many resources and one resource may support many courses, `Course_Resources` resolves that many-to-many relationship. Its attributes record whether a resource is required, the intended course week, and assignment notes. `Resource_Usage` stores user interactions with resources so the institution can later analyze access, downloads, loans, returns, and optional feedback.

## Relationships and Cardinality

| Parent entity | Child entity | Cardinality | Foreign key | Meaning |
|---|---|---:|---|---|
| Users | Courses | 1:M | `courses.instructor_id` | One instructor may teach many courses; each course has one instructor. |
| Users | Resources | 1:M | `resources.created_by` | One authorized user may create many resource records. |
| Categories | Resources | 1:M | `resources.category_id` | One category may classify many resources; each resource has one category. |
| Courses | Course_Resources | 1:M | `course_resources.course_id` | One course may have many resource assignments. |
| Resources | Course_Resources | 1:M | `course_resources.resource_id` | One resource may be assigned to many courses. |
| Users | Resource_Usage | 1:M | `resource_usage.user_id` | One user may create many usage records. |
| Resources | Resource_Usage | 1:M | `resource_usage.resource_id` | One resource may have many usage records. |

The two 1:M relationships connecting `Courses` and `Resources` to `Course_Resources` implement the logical M:N relationship between courses and resources.

## Data Dictionary

### Users

| Attribute | Data type | Constraint | Purpose |
|---|---|---|---|
| user_id | INT UNSIGNED | PK, AUTO_INCREMENT | Unique user identifier. |
| first_name | VARCHAR(50) | NOT NULL | User first name. |
| last_name | VARCHAR(50) | NOT NULL | User last name. |
| email | VARCHAR(120) | UNIQUE, NOT NULL | Institutional email address. |
| role | ENUM | NOT NULL | Student, Instructor, Resource Administrator, or Academic Coordinator. |
| active | BOOLEAN | NOT NULL, DEFAULT TRUE | Indicates whether the account is active. |

### Courses

| Attribute | Data type | Constraint | Purpose |
|---|---|---|---|
| course_id | INT UNSIGNED | PK, AUTO_INCREMENT | Unique course identifier. |
| course_code | VARCHAR(12) | UNIQUE, NOT NULL | Catalog code such as CSC 110. |
| course_title | VARCHAR(100) | NOT NULL | Official course title. |
| department | VARCHAR(60) | NOT NULL | Academic department. |
| credits | TINYINT UNSIGNED | NOT NULL | Credit value from 1 through 6. |
| instructor_id | INT UNSIGNED | FK, NOT NULL | References `users.user_id`. |
| status | ENUM | NOT NULL | Active or Inactive. |

### Categories

| Attribute | Data type | Constraint | Purpose |
|---|---|---|---|
| category_id | INT UNSIGNED | PK, AUTO_INCREMENT | Unique category identifier. |
| category_name | VARCHAR(60) | UNIQUE, NOT NULL | Controlled category name. |
| description | VARCHAR(255) | NOT NULL | Category definition. |

### Resources

| Attribute | Data type | Constraint | Purpose |
|---|---|---|---|
| resource_id | INT UNSIGNED | PK, AUTO_INCREMENT | Unique resource identifier. |
| category_id | INT UNSIGNED | FK, NOT NULL | References `categories.category_id`. |
| title | VARCHAR(150) | NOT NULL | Resource title. |
| description | VARCHAR(255) | NOT NULL | Short description. |
| resource_format | ENUM | NOT NULL | Physical, PDF, Web, Video, Audio, Software, Equipment, or Dataset. |
| location_url | VARCHAR(255) | NOT NULL | Shelf location or web address. |
| availability_status | ENUM | NOT NULL | Available, Checked Out, Restricted, or Archived. |
| created_by | INT UNSIGNED | FK, NOT NULL | References `users.user_id`. |
| last_updated | DATE | NOT NULL | Date of the most recent review. |

### Course_Resources

| Attribute | Data type | Constraint | Purpose |
|---|---|---|---|
| course_resource_id | INT UNSIGNED | PK, AUTO_INCREMENT | Unique assignment identifier. |
| course_id | INT UNSIGNED | FK, NOT NULL | References `courses.course_id`. |
| resource_id | INT UNSIGNED | FK, NOT NULL | References `resources.resource_id`. |
| is_required | BOOLEAN | NOT NULL | Identifies required material. |
| week_number | TINYINT UNSIGNED | NULL | Planned course week. |
| notes | VARCHAR(255) | NULL | Instructor or coordinator notes. |
| assigned_on | DATE | NOT NULL | Date the resource was assigned. |

### Resource_Usage

| Attribute | Data type | Constraint | Purpose |
|---|---|---|---|
| usage_id | INT UNSIGNED | PK, AUTO_INCREMENT | Unique interaction identifier. |
| resource_id | INT UNSIGNED | FK, NOT NULL | References `resources.resource_id`. |
| user_id | INT UNSIGNED | FK, NOT NULL | References `users.user_id`. |
| accessed_at | DATETIME | NOT NULL | Interaction date and time. |
| action_type | ENUM | NOT NULL | Viewed, Downloaded, Borrowed, or Returned. |
| feedback_rating | TINYINT UNSIGNED | NULL | Optional rating from 1 through 5. |

## Constraints and Integrity

Primary keys uniquely identify every record. Foreign keys prevent orphaned courses, resources, assignments, and usage records. Unique constraints protect institutional emails, course codes, category names, and course-resource combinations. Check constraints keep credits, week numbers, and ratings within meaningful ranges. Restrictive deletes preserve historical integrity, while selected update cascades keep foreign-key identifiers synchronized.

## Sample Data

Each spreadsheet in `Sample_Data/` contains 40 realistic records. The foreign-key values were generated to match existing parent rows, so the datasets can be imported in this order: Users, Categories, Courses, Resources, Course_Resources, and Resource_Usage.

