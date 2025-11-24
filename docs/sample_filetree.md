
uic-event-app/
├── client/                           # FRONTEND: Next.js Progressive Web App
│   ├── public/                       # Static assets
│   │   ├── icons/                    # App icons for PWA (manifest)
│   │   ├── manifest.json             # PWA Manifest file
│   │   └── vercel.svg
│   ├── src/
│   │   ├── app/                      # Next.js App Router
│   │   │   ├── layout.js             # Root layout (includes fonts/meta)
│   │   │   ├── page.js               # Login / Landing page
│   │   │   ├── setup/                # Onboarding flows
│   │   │   │   ├── role/page.js
│   │   │   │   └── profile/page.js
│   │   │   ├── attendee/             # Attendee Dashboard
│   │   │   │   └── page.js
│   │   │   └── organizer/            # Organizer Dashboard
│   │   │       ├── page.js
│   │   │       ├── create/page.js
│   │   │       └── event/[id]/page.js
│   │   ├── components/               # Reusable UI components
│   │   │   ├── QRScanner.js          # Camera logic
│   │   │   ├── QRCodeDisplay.js      # Generator logic
│   │   │   ├── LoginForm.js
│   │   │   └── Charts.js             # Recharts wrapper for reports
│   │   ├── lib/                      # Utilities
│   │   │   ├── firebase.js           # Firebase Client SDK init
│   │   │   └── api.js                # Helpers to call your Backend API
│   │   └── styles/
│   │       └── globals.css           # Tailwind directives
│   ├── .dockerignore
│   ├── .gitignore
│   ├── Dockerfile                    # Defined in previous step
│   ├── next.config.js
│   ├── package.json
│   ├── postcss.config.js
│   └── tailwind.config.js
│
├── server/                           # BACKEND: Node.js (Fastify) API
│   ├── config/
│   │   ├── db.js                     # Cloud SQL (Postgres) connection
│   │   └── redis.js                  # Redis (Memorystore) connection
│   ├── routes/
│   │   ├── auth.js                   # Auth verification routes
│   │   └── events.js                 # Event creation & check-in routes
│   ├── services/
│   │   ├── checkInService.js         # Logic for validating codes/Redis
│   │   └── reportService.js          # Logic for aggregating DB data
│   ├── .dockerignore
│   ├── .gitignore
│   ├── Dockerfile                    # Defined in previous step
│   ├── index.js                      # Entry point (Fastify server)
│   └── package.json
│
├── docs/                             # PROJECT DOCUMENTATION
│   ├── UIC_Event_App_Plan.md         # From Step 1
│   ├── UIC_Event_App_Wireframes.md   # From Step 2
│   └── uic_event_connect_pitch.html  # From Step 3
│
├── .gitignore                        # Root gitignore (excludes node_modules, etc.)
└── docker-compose.yml                # Local dev orchestration (Defined in previous step)