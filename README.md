# **ENT Insight - Flutter App**  

ENT Insight is a mobile application designed for analyzing Medical images related to ENT (Ear, Nose, and Throat) conditions using Deep learning APIs.
 

## **Table of Contents**  
1. [Getting Started](#getting-started)  
2. [Features](#features)  
3. [Installation](#installation)  
4. [Configuration](#configuration)  
5. [Ngrok Setup for Backend API](#ngrok-setup-for-backend-api)  
6. [Screenshots](#screenshots)  
7. [License](#license)  
 

## **Getting Started**  

These instructions will help you set up and run the ENT Insight Flutter app on your local machine for development and testing purposes.
 

## **Features**  

- Upload and analyze Medical images.  
- Real-time prediction and analysis results.  
- User-friendly interface.  
 

## **Installation**  

### **Prerequisites**  

1. **Flutter SDK** (Latest Version): [Install Flutter](https://flutter.dev/docs/get-started/install)  
2. **Android Studio/VSCode** (IDE)  
3. **Ngrok** for backend API tunneling: [Install Ngrok](https://ngrok.com/download)  

### **Clone the Repository**  
```bash
git clone https://github.com/24-25J-097/ent-disease-detection-mobile-app.git

cd ent-disease-detection-mobile-app
```
To see any misconfigurations in flutter instaltion
```bash
flutter doctor
```
### Install Dependencies
```bash
flutter pub get
```

### **Ngrok Setup for Backend API**

### Step 1: Create an Account
  - Register an account and log in to the Ngrok dashboard [official site](https://ngrok.com/signup?ref=downloads).
### Step 2: Install Ngrok
  - Download and install Ngrok from the [official site](https://download.ngrok.com/windows).
### Step 3: Connect Ngrok to Your Account
  - Run the following command to authenticate Ngrok on your system:

```bash
ngrok config add-authtoken <token>
```
### Step 4: Start the Backend Server
  - Start your local [Node.js backend API server](https://github.com/24-25J-097/ent-disease-detection-api).
```bash
cd <path to ent-disease-detection-api>

npm start
```
### Step 5: Start Ngrok Tunnel
  - Read the instruction in [DL Model Repo](https://github.com/24-25J-097/ent-disease-detection-dl-models)
```bash
ngrok http --domain=monarch-witty-platypus.ngrok-free.app 4000
```
> Replace 4000 with your backend’s port. Ngrok will provide a public URL like https://<your-ngrok-url>.ngrok.io.

## **Configuration**
### Change Base URL
  - Open the file lib/config.dart (or wherever the API URL is configured).
  - Update the BASE_URL value:

```dart
// lib/config.dart
const String BASE_URL = "https://<your-ngrok-url>.ngrok.io";
```

## **Run the App 😊**
```bash
flutter run
```

## **Screenshots**
### Sinuitis Water's View X-Ray
<img src="https://github.com/user-attachments/assets/781f9bc8-470f-44d1-9f6b-79071c0673fe" height="500">
<img src="https://github.com/user-attachments/assets/a96a809d-86ba-44d3-b12c-69ddc8238d99" height="500">
<img src="https://github.com/user-attachments/assets/1c8bc6c0-a4b4-48d2-b9f9-81346030e5ee" height="500">
 

### Pharyngitis View X-Ray
<img src="https://github.com/user-attachments/assets/31f72d1c-d90f-4eff-a5d9-7f63f5279d96" height="500">
<img src="https://github.com/user-attachments/assets/76e149b8-a337-4eed-b4bb-dc51a3fee225" height="500">
<img src="https://github.com/user-attachments/assets/f32f7081-ce7b-40db-97ec-b79c46d5adc0" height="500">
 

### Cholesteatoma
<img src="https://github.com/user-attachments/assets/a62c955f-dbf3-4b89-9c32-eab729fed7c4" height="500">
 
### Foreign Body
<img src="https://github.com/user-attachments/assets/a17e7931-c180-48d0-87ad-6816b77bee84" height="500">
 
## **License**  

Copyright (c) 2024 24-25J-097 

All rights reserved. No part of this software may be reproduced, distributed, or transmitted in any form or by any means, including photocopying, recording, or other electronic or mechanical methods, without prior written permission from the author, except for brief quotations in reviews or academic references.

**Unauthorized use, modification, or distribution is strictly prohibited.**

 

