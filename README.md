# ECode Verifier - A Brief Description

Welcome to **ECode Verifier**, developed as part of our academic course **"Software Engineering"**. This project is built using **[Flutter]** for the front end and **[Firebase]** for the back end.

---

## 📋 Table of Contents

- [📌 Project Overview](#-project-overview)
- [✨ Features](#-features)
- [🛠️ Technology Stack](#️-technology-stack)
- [📁 Project Structure](#-project-structure)
- [⚙️ Installation](#️-installation)
- [🚀 Usage](#-usage)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

---

## 📌 Project Overview

**ECode Verifier** is a mobile application developed for both android and ios. The development process followed these phases:

- ✅ Requirement Gathering  
- ✅ Planning  
- ✅ Designing  
- ✅ Modeling  
- ✅ Coding  

> _Note: Due to time and resource constraints, the testing, evaluation, verification, and validation stages were only partially implemented._

---

## ✨ Features

- 🔐 [Two Step Authentication]
- 📦 [ECode(European Food Code) Verification through scanning]
- 📊 [Search Different ECodes]
- 📱 [Can check if the food is allergic to the user]
- 🚦 [Can check if the food is halal, haram or vegeterian]

---

## 🛠️ Technology Stack

- **Frontend:** [Flutter]
- **Backend:** [Firebase]
- **Database:** [Cloud Firestore]
- **Authentication:** [Firebase Authentication]
- **State Management:** [Getx]
- **Other Tools:** [REST Api(openfoodfacts)]

---

## 📁 Project Structure
```
ECode_Verifier_App/
├── assets/
├── lib/
│ ├── controllers/
│ ├── models/
│ ├── screens/
│ ├── services/
│ └── main.dart
├── test/
├── .gitignore
├── pubspec.yaml
├── README.md
└── LICENSE
```
---

## ⚙️ Installation

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Firebase Account: [Firebase Console](https://console.firebase.google.com/)

### Steps

1. **Clone the repository:**

   ```bash
   git clone https://github.com/sadman017/ECode_Verifier_App.git
   cd ECode_Verifier_App

2. **Install dependencies:**
    ```bash
    flutter pub get

3. **Set up Firebase:**
   - Create a new project in Firebase.

   - Add Android/iOS app to the Firebase project.

   - Download the google-services.json (for Android) or GoogleService-Info.plist (for iOS) and place it in the respective directory.

4. **Run the application:**
    ~~~bash
    flutter run
    ~~~
    
🚀 **Usage**
- Launch the app on your device or emulator.

- Register a new account or log in with existing credentials.

- Enter the electronic code to verify its authenticity.

- View the verification result and related information.


