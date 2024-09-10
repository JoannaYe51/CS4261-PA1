# CS4261-PA1

## WeSplit - SwiftUI Application with Node.js Backend

This project is a SwiftUI application called **WeSplit** that includes user authentication via a backend built with Node.js and MongoDB. The backend provides routes for user sign-up and login using JWT (JSON Web Tokens).

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Setup Instructions](#setup-instructions)
- [Running the SwiftUI App](#running-the-swiftui-app)

## Features

- **SwiftUI App**: A simple UI for managing user registration and login, and help user spliting their bills.
- **Node.js Backend**: Provides API endpoints for user authentication with MongoDB.
- **JWT Authentication**: JSON Web Tokens used for secure authentication.

## Requirements

To run this project, you'll need:

- Xcode (for the SwiftUI app)
- Node.js and npm (for the backend)
- MongoDB (for database connection)

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/JoannaYe51/CS4261-PA1.git
cd CS4261-PA1
```

### 2. SwiftUI Application Setup
Open the **WeSplitApp.xcodeproj** file in Xcode.
Ensure your development environment (iOS Simulator or device) is properly set up.
Follow the instructions below for the backend setup before running the app.

### 3. Node.js Backend Setup
The backend (**server.js**) is a Node.js server that connects to a MongoDB instance. Users will need to install their own MongoDB locally (via Homebrew or MongoDB’s website).

```bash
brew tap mongodb/brew
brew install mongodb-community@6.0
brew services start mongodb/brew/mongodb-community@6.0

node server.js
```

You should see the message Server is running on port 5001 if the server starts successfully.

## Running the SwiftUI App
Make sure the backend is running before launching the SwiftUI app.
In Xcode, double click **WeSplit.xcodeproj** to open the application. 
Select the target device (Simulator or physical device).
Click **Run** (**⌘ + R**) to build and run the app.
Test the app by signing up or logging in. The app communicates with the backend for user authentication.
