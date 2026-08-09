# Educational Resource Management System

**Team:** Anudari Undrakh, Jose Antonio Horta Herrera, and Louis Ngonzo  
**Course Deliverable:** Quarterly Database Project - Part 2: Design

The Educational Resource Management System centralizes learning materials that are currently scattered across spreadsheets, folders, email, websites, and paper records. The design uses six normalized tables: Users, Courses, Categories, Resources, Course_Resources, and Resource_Usage. Users stores students, instructors, resource administrators, and academic coordinators in one structure. Courses references its assigned instructor, while Resources references both its category and creator. Course_Resources resolves the many-to-many relationship between courses and learning materials and records whether each item is required and when it is used. Resource_Usage records student and staff interactions for future reporting. Primary and foreign keys protect data integrity, and unique constraints reduce duplicate accounts, courses, categories, and assignments. The main design challenge was supporting many resource formats without repeating course or user information. The model keeps the system searchable, maintainable, and ready for later SQL implementation.

## Repository Contents

- `ERD/`: EER diagram in PDF and PNG, plus Mermaid source.
- `Sample_Data/`: Six Excel files containing 40 sample records per table.
- `Documentation/`: Detailed design explanation and data dictionary.
- `Database/`: MySQL 8.0 schema that can be imported into MySQL Workbench.

