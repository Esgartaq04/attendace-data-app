Project Plan: UIC Event Demographics App

Here is a comprehensive plan covering the data structure, platform choice, technology stack, and cloud infrastructure for your project.

1. Class Diagram

To build a scalable and maintainable app, we first need to define the "nouns" of your system. These are the core data models.

Here is a class diagram that models your application.

@startuml
!theme spacelab

skinparam classAttributeIconSize 0
skinparam defaultFontName "Inter"
skinparam monochrome false
skinparam shadowing true

' Define Classes
class User {
  +userId: String (PK)
  +schoolId: String (FK)
  +email: String (Unique, e.g., "user@uic.edu")
  +firstName: String
  +lastName: String
  +userType: Enum ("ATTENDEE", "ORGANIZER")
}

class Demographics {
  +demographicsId: String (PK)
  +userId: String (FK)
  +dateOfBirth: Date
  +gradeLevel: String
  +race: String
  +genderIdentity: String
  +college: String
}

class School {
  +schoolId: String (PK)
  +name: String (e.g., "University of Illinois Chicago")
  +emailDomain: String (e.g., "@uic.edu")
}

class Organization {
  +organizationId: String (PK)
  +schoolId: String (FK)
  +name: String (e.g., "Computer Science Society")
}

class Event {
  +eventId: String (PK)
  +organizationId: String (FK)
  +creatorUserId: String (FK)
  +name: String
  +description: String
  +eventDate: Timestamp
  +checkInCode: String (6-char, Unique)
}

class CheckIn {
  +checkInId: String (PK)
  +attendeeUserId: String (FK)
  +eventId: String (FK)
  +timestamp: Timestamp
}

' Define Relationships
User "1" -- "0..1" Demographics : "provides"
User "1" -- "1" School : "attends"
User "many" -- "many" Organization : "is member/organizer for"

School "1" -- "many" Organization : "has"

Organization "1" -- "many" Event : "hosts"
User "1" -- "many" Event : "creates"

Event "1" -- "many" CheckIn : "has"
User "1" -- "many" CheckIn : "performs (as attendee)"
@enduml


Explanation of Models:

User: The base entity. We use email validation (must end in @uic.edu) to ensure security.

Demographics: A separate table linked to User. Attendees fill this out once. It allows for reusable, anonymized reporting across all events.

Organization: Links Organizers and Events. Enables scalability to multiple student orgs.

Event: The core object. Contains the unique checkInCode (e.g., "XYZ123") used for QR generation.

CheckIn: A high-volume transaction table recording that a specific user attended a specific event.

2. Platform Strategy: Progressive Web App (PWA)

Decision: We are building a PWA, not a native app.

Why?

Zero Friction: Attendees scan a QR code and are checked in instantly via browser. No App Store download required.

Cross-Platform: Works on iOS, Android, and Desktop immediately.

Hardware Access: Modern PWAs can access the camera for QR scanning just like native apps.

3. Tech Stack & Cloud Infrastructure

To handle high burst traffic (e.g., 500 students checking in within 5 minutes), we are using a containerized microservices architecture hosted on Google Cloud Platform (GCP).

A. The Frontend (Client)

Framework: Next.js (React)

Role: Renders the UI, handles routing, and manages PWA offline capabilities.

Styling: Tailwind CSS (Utility-first styling for speed).

Scanning: html5-qrcode library for in-browser camera access.

B. The Backend (API)

Runtime: Node.js

Framework: Fastify

Role: A high-performance web framework (faster than Express) designed to handle high concurrency with low overhead. It handles the API logic for check-ins and reports.

C. The Data Layer

Primary Database: Google Cloud SQL (PostgreSQL)

Role: The source of truth. Stores Users, Events, and Organizations relations. Relational SQL is chosen over NoSQL for better data integrity and structured reporting queries.

Caching Layer: Google Cloud Memorystore (Redis)

Role: The Burst Handler. Active event codes and check-in statuses are cached here. When 500 students scan at once, the API hits Redis (milliseconds latency) instead of overloading the main database.

D. Infrastructure & Deployment (GCP)

Containerization: Docker

Both Frontend and Backend are containerized into lightweight images.

Orchestration: Google Cloud Run

Role: Serverless container hosting. It automatically scales from 0 instances (when idle/costing $0) to 20+ instances (during an event rush) and back down.

Build Pipeline: Google Cloud Build

Automates the process of building Docker images and pushing them to the Artifact Registry.

4. MVP Development Timeline (6 Weeks)

Week 1: Foundation & Infrastructure

Initialize GCP Project & Cloud SQL.

Set up local Docker environment (Docker Compose).

Implement Google Authentication (restrict to @uic.edu).

Week 2: Attendee Onboarding

Build "Role Selection" and "Demographic Profile" screens.

Implement Database Schema in PostgreSQL.

Week 3: Organizer Dashboard

Build Event Creation UI.

Implement QR Code Generation logic in backend.

Week 4: The Check-In Engine (High Traffic)

Implement Fastify API for check-ins.

Integrate Redis caching to handle burst requests.

Build Client-side QR Scanner.

Week 5: Reporting & Visualization

Build the Data Aggregation Service (SQL queries for demographics).

Implement Charts (Recharts) on the Organizer Frontend.

Week 6: Testing & Deployment

Deploy containers to Cloud Run.

Load test the check-in endpoint.

Final UI Polish & Pitch Preparation.