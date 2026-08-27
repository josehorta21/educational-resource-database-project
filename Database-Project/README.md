# Educational Resource Management System

**Course Deliverable:** Quarterly Database Project — Final Implementation and Presentation
**Team Members:** Anudari Undrakh and Jose Antonio Horta Herrera
**Database Platform:** MySQL 8.0.16 or later

## Project Overview

The Educational Resource Management System is a normalized relational database designed to centralize academic materials that are often scattered across spreadsheets, websites, email, shared folders, and paper records. The system allows students to discover resources connected to their courses, instructors to assign required or recommended materials, resource administrators to manage availability, and academic coordinators to analyze usage and feedback. It supports physical books, PDFs, websites, videos, audio, software, equipment, and datasets. Primary keys, foreign keys, unique constraints, and validation rules protect data integrity, while views and indexes make common reports easier and more efficient.

## Primary Users

- **Students:** Find course resources and access learning materials.
- **Instructors:** Assign required or recommended resources to courses.
- **Resource Administrators:** Create resources and manage availability.
- **Academic Coordinators:** Review resource usage, activity, and feedback.

## Database Design

The database contains six normalized tables:

| Table | Purpose |
|---|---|
| `users` | Stores students, instructors, resource administrators, and academic coordinators. |
| `courses` | Stores course information and references the assigned instructor. |
| `categories` | Organizes resources into consistent academic categories. |
| `resources` | Stores learning materials, formats, locations, availability, and creators. |
| `course_resources` | Resolves the many-to-many relationship between courses and resources. |
| `resource_usage` | Records user interactions, dates, actions, and feedback ratings. |

### Important Relationships

- One instructor can teach many courses.
- One category can contain many resources.
- One user can create many resources.
- Courses and resources have a many-to-many relationship resolved by `course_resources`.
- One user can create many resource-usage records.
- One resource can appear in many resource-usage records.

## Implementation Highlights

- 6 normalized tables in Third Normal Form (3NF)
- 7 foreign-key relationships
- 40 sample records per table, for 240 total records
- 6 targeted indexes for common filters, joins, and chronological reports
- 2 reusable views
- 6 business-focused test queries
- Primary keys, foreign keys, `UNIQUE` constraints, and `CHECK` constraints
- Row-count and referential-integrity validation queries

## Views

### `vw_course_resource_catalog`

Combines courses, instructors, assigned resources, categories, and assignment information into one reusable course-resource catalog.

### `vw_resource_usage_summary`

Combines resources, categories, and usage activity to calculate views, downloads, loans, returns, average ratings, and the most recent access date.

## Key SQL Demonstrations

1. Display active courses with their instructors and assigned resources using multiple `JOIN` operations.
2. Count available resources by format and calculate each format's share using `GROUP BY`, aggregate functions, and a subquery.
3. Summarize student activity and feedback using `CASE`, `HAVING`, `COUNT`, `SUM`, and `AVG`.
4. Retrieve highly rated and recently accessed resources from a view using filtering and date formatting.

## Repository Structure

```text
Database-Project/
├── README.md
├── Database/
│   ├── Quarterly_Database_Project_Part_3.sql
│   └── educational_resource_schema.sql
├── Documentation/
│   └── Database_Design_Explanation.md
├── ERD/
│   ├── EER_Diagram.mmd
│   ├── EER_Diagram.pdf
│   └── EER_Diagram.png
├── Presentation/
│   └── Educational_Resource_Final_Presentation.pptx
└── Sample_Data/
    ├── Categories_Data.xlsx
    ├── Course_Resources_Data.xlsx
    ├── Courses_Data.xlsx
    ├── Resource_Usage_Data.xlsx
    ├── Resources_Data.xlsx
    └── Users_Data.xlsx
```

## How to Run the Database

1. Open MySQL Workbench and connect to a MySQL 8.0 server.
2. Open `Database-Project/Database/Quarterly_Database_Project_Part_3.sql`.
3. Execute the complete script.
4. Refresh the **SCHEMAS** panel and open `educational_resource_db`.
5. Run the numbered queries individually to review their results.

The script safely drops and recreates the classroom database, creates all tables and relationships, inserts the sample data, creates the views and indexes, and runs validation queries.

## Final Presentation

The presentation deck is available in the `Presentation` folder. The final recorded presentation is submitted separately through Canvas and demonstrates the EER diagram, four key SQL queries, one reporting view, lessons learned, and the main design challenge.

## Repository

[Educational Resource Database Project](https://github.com/josehorta21/educational-resource-database-project)
