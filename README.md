![Flutter](https://img.shields.io/badge/Framework-Flutter-blue) 
![Firebase](https://img.shields.io/badge/Backend-Firebase-orange) 

# 🌧️ Rainwater Harvesting Feasibility App  

A smart solution for promoting **sustainable water management** through **rainwater harvesting feasibility analysis**.  
Developed as part of **Smart India Hackathon 2025** by **Team Neural Ninjas**.  

---

## 🚀 Problem Statement  
Water scarcity is one of the most pressing issues globally. While rainwater harvesting is an effective solution, individuals and communities often struggle with **feasibility assessment**, storage planning, and long-term adoption due to lack of technical guidance.  

---

## 💡 Proposed Solution  
Our application provides:  
- 📊 **Rainwater insights**: Displays rainfall trends using weather APIs.  
- 📝 **Feasibility check**: Allows users to input roof size, slope, available area, and water demand.  
- 📑 **Detailed reports**: Generates feasibility reports including storage volume, recharge structure, runoff capacity, and cost estimation.  
- 🗂️ **Report history**: Users can access and download their past reports.  
- 🔒 **Secure authentication**: Google login using Firebase.  

---

## ✨ Innovation & Uniqueness  
- 🔹 Combines **real-time weather & rainfall data** from NASA & Visual Crossing APIs.  
- 🔹 Provides **localized feasibility analysis** customized for each user.  
- 🔹 Easy-to-understand **visualizations & interactive reports**.  
- 🔹 Encourages **community-driven adoption** of rainwater harvesting.  

---

## ⚙️ Installation & Setup  

Follow these steps to run the app locally:  

1. **Clone the repository**  
   ```bash
   git clone https://github.com/mahip004/SIH.git
   cd SIH
2. **Install Dependencies**  
   ```bash
   flutter pub get
2. **Run the App**  
   ```bash
   On Android Emulator:
   flutter run
   On Chrome (Web):
   flutter run -d chrome
   On iOS Simulator (macOS only):
   flutter run -d ios
4. **Firebase Setup**  
   Add your own google-services.json (for Android) in android/app/.

   Add GoogleService-Info.plist (for iOS) in ios/Runner/.

   Ensure Firebase Authentication & Firestore are enabled.

---

## 📱 App Flow  
1. **Login Screen** – Google Sign-In with Firebase.  
2. **Home Screen** – Quick access to Water Insights, Feasibility Check, and Reports.  
3. **Feasibility Form** – Input building & roof details.  
4. **Feasibility Report** – Provides storage, recharge, runoff, soil type & cost-benefit analysis.  
5. **Past Reports** – Retrieve and download previous reports.  

---

## 🛠️ Tech Stack  
- **Frontend**: Flutter  
- **Backend/Database**: Firebase Firestore  
- **Visualization**: 2D/3D Graphs, APIs  
- **APIs/Datasets**:  
  - [NASA Power API](https://power.larc.nasa.gov)  
  - [Visual Crossing Weather](https://www.visualcrossing.com/)  
  - [India Data Portal – Groundwater Dataset](https://ckan.dev.indiadataportal.com/dataset/groundwater)  
  - Ministry of Jal Shakti Guidelines  

---

## 📊 Features in Action  
- 🌦️ Rainfall trend visualization  
- 📝 Feasibility form & instant report generation  
- 🛢️ Storage volume & recharge structure recommendations  
- 💰 Cost-benefit analysis for water savings  

---

## 🔗 Useful Links  
- 📂 **[GitHub Repository](https://github.com/mahip004/SIH)**  
- 🌐 **[Prototype Link](https://www.figma.com/your-prototype-link-here)**  
- 🎥 **[Demo Video](https://www.youtube.com/your-demo-video-link-here)**  

