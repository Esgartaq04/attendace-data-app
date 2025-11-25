#!/bin/bash

# 1. Configuration - Change these to your desired values
PROJECT_ID="attendance-app-1871"
REGION="us-central1"
BILLING_ACCOUNT_ID="017E75-88C7E4-5A46F2" # Run 'gcloud billing accounts list' to find this

echo ">>> Starting GCP Project Setup for $PROJECT_ID..."

# 2. Create the Project
gcloud projects create $PROJECT_ID --name="UIC Event Tracker"

# 3. Link Billing (Required for many GCP services)
echo ">>> Linking Billing Account..."
gcloud billing projects link $PROJECT_ID --billing-account=$BILLING_ACCOUNT_ID

# 4. Set the current project context
gcloud config set project $PROJECT_ID

# 5. Enable Necessary Google Cloud APIs
echo ">>> Enabling APIs (Firestore, Cloud Build, Identity Toolkit)..."
gcloud services enable firestore.googleapis.com \
                       cloudbuild.googleapis.com \
                       identitytoolkit.googleapis.com \
                       firebase.googleapis.com \
                       firebasehosting.googleapis.com

# 6. Initialize Firestore (Native Mode)
echo ">>> Creating Firestore Database..."
gcloud firestore databases create --location=$REGION --type=firestore-native

# 7. configure Firebase for the project (Requires Firebase CLI usually, but we enable the integration here)
echo ">>> Project $PROJECT_ID is ready!"
echo ">>> Next Step: Run 'npm install -g firebase-tools' and 'firebase login' to prepare for deployment."