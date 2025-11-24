Project Plan: UIC Event Demographics App

Here is a comprehensive plan covering the data structure, platform choice, and technology stack for your project.

1. Class Diagram

To build a scalable and maintainable app, we first need to define the "nouns" of your system. These are the core data models.

Here is a class diagram that models your application, including the plan to scale to other schools.

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
  +authId: String
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
  ' ... other fields
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

User: This is the base for everyone. The userType field differentiates between a regular Attendee and an Organizer. We use schoolId and email to ensure they belong to UIC (and later, other schools).

Demographics: This is a separate object linked to a User. An attendee only has to fill this out once. When they check into any event, the app can pull this single, reusable profile for reporting. This is much better than asking for demographics at every event.

School: This model is key for your scaling plan. You start by adding UIC, and later you can add other schools, each with its own emailDomain for verification.

Organization: This links Users (Organizers) and Events to a specific student org. This is how you'll be able to show an organizer a dashboard of their org's events.

Event: This is the core object created by an Organizer (on behalf of an Organization). It contains the all-important checkInCode. The QR code will simply be this code embedded in a URL (e.g., https://yourapp.com/check-in/XYZ123).

CheckIn: This is the "join" object. It's a simple record that says "This User checked into this Event at this Timestamp." To get demographics for an event, you will:

Find all CheckIn records for the eventId.

For each CheckIn, get the attendeeUserId.

For each attendeeUserId, get their Demographics record.

Aggregate this data into an anonymized report.

2. Website vs. Mobile App: (The Recommendation)

You should build a Progressive Web App (PWA), which is a website built with modern technology to look and feel exactly like a native mobile app.

Winner: Progressive Web App (PWA)

Why? The "Friction" Problem.

Native App (The Bad Choice): Imagine an attendee at your event. You ask them to check in. They scan a QR code, and it takes them to the App Store. They have to wait to download, install, and then open the app. You will lose a massive percentage of your attendees at this step. It's too much "friction."

PWA (The Good Choice): The attendee scans the QR code. It opens their phone's web browser to a URL. They can immediately enter the 6-digit code or (if already logged in) are instantly checked in. The process is over in seconds.

A PWA gives you the best of both worlds:

Zero Installation: Works instantly through any phone's browser.

App-like Feel: Can be designed to be mobile-first and look identical to a native app.

QR Code Scanning: Modern browsers can access the phone's camera for QR scanning (using the getUserMedia API).

"Add to Homescreen": Users can still add your app to their homescreen, where it will function just like a native app (with an icon, no browser bar, etc.).

3. Recommended Tech Stack

Based on your needs for scalability, speed, and modern features, I recommend a serverless, JavaScript-based stack.

Frontend (The PWA): React (with Next.js)

Why: React is the industry standard for building fast, interactive user interfaces. Using the Next.js framework on top gives you high performance, a great developer experience, and simple deployment.

UI: Tailwind CSS. A utility-first CSS framework that will let you build a beautiful, responsive, mobile-first design very quickly.

QR Scanning: html5-qrcode or react-qr-scanner libraries.

QR Generation: qrcode.react library to display the QR in the organizer dashboard.

Backend & Database: Firebase (Google)

Why: This is an all-in-one "Backend as a Service" (BaaS) that is perfect for this project. It's built to scale from one user to millions.

Authentication: Firebase Authentication. It will handle all user sign-up and log-in. You can easily add a rule to only allow sign-ups from the uic.edu email domain.

Database: Firestore. A NoSQL, real-time database that maps perfectly to the class diagram above. When a new person checks in, the organizer's dashboard can update live without them even refreshing the page.

Serverless Logic: Cloud Functions for Firebase. For any secure logic you need, such as generating the unique 6-character checkInCode or (most importantly) securely aggregating the demographic data for reports. You never want the app to fetch all user data; you want a secure function to do that and only return an anonymized summary.

Hosting: Firebase Hosting. You can deploy your Next.js PWA with a single command.

This stack is modern, highly in-demand, and lets you build and launch your idea much faster than traditional methods.