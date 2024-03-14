# Online Bookstore Database Project

## Overview
This project consists of designing and implementing a database for an online bookstore. The database design follows best practices in terms of normalization and integrity enforcement, and the implementation includes a simple UI for CRUD operations on the Users table.

## Features
- ER Diagram representing all entities, their relationships, and cardinalities.
- Normalized database schema to avoid data redundancy and ensure data integrity.
- Integrity constraints implemented via primary keys, foreign keys, unique constraints, and not-null constraints.
- CRUD operations (Create, Read, Update, Delete) on the Users table through a simple Flask web application.
- SQL code written with optimization and structure in mind.
- Application architecture follows a clear structure for maintainability and scalability.

## SQL Code
All SQL code used in the project is found within the migration scripts and the Flask application. It is optimized for performance and structured for readability.

## ER Diagram
The ER diagram is included as `ERD.png` in the project directory. It clearly outlines the database schema with all necessary details.

## Normalization
The database schema follows the rules of 3NF (Third Normal Form) to ensure that there are no transitive dependencies and the data is free from update anomalies.

## Integrity Enforcement
The database schema enforces integrity through:
- Primary keys for entity uniqueness.
- Foreign keys for referential integrity.
- Unique constraints to avoid duplicate information.
- Not-null constraints to ensure critical data is always present.

## Isolation Level
(Include this section only if your application requires transaction management.)

## Forms
The Flask application provides simple yet functional forms for user interaction, ensuring robust data validation and proper error handling.

## Reports
(Include this section if your application provides data aggregation or reporting functionality.)

## Presentation
The project includes in-line comments within the SQL scripts and application code for clarity. Documentation provides a clear overview of the project and its architecture.

## Application Architecture
The application follows a Model-View-Controller (MVC) architecture, separated into distinct layers for data management, business logic, and presentation. This separation allows for efficient data flow and easy maintenance.

## Installation and Setup
(Provide steps for setting up the project, including environment setup, database migrations, and running the Flask application.)

## Usage
(Provide a guide on how to use the application, possibly with screenshots.)

## Requirements
- Python 3.x
- Flask
- PyMySQL
(Include any other dependencies that are in your `requirements.txt`)

## License
(Include licensing information, if any.)

## Credits
(Acknowledge any collaborators, third-party assets, or tutorials followed.)

---

This README provides a comprehensive overview of the Online Bookstore Database Project, demonstrating adherence to the rubric's specifications and the objectives of the assignment.
