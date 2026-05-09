# 🏫 Smart Classroom IOT

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![MQTT](https://img.shields.io/badge/MQTT-Mosquitto-3C3C3C?style=for-the-badge&logo=eclipse-mosquitto&logoColor=white)](https://mosquitto.org)

## 📱 App Showcase

<p align="center">
  <img src="screenshots/drawer.png" width="30%" alt="Zoom Drawer" />
  <img src="screenshots/mqtt_control.png" width="30%" alt="MQTT Control" />
  <img src="screenshots/simulator.png" width="30%" alt="IoT Simulator" />
</p>

<p align="center">
  <i>Modern UI with Zoom Drawer, Real-time MQTT Control, and Integrated Simulator</i>
</p>

---

![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge)


A cutting-edge IoT solution for modern classrooms. Monitor environmental conditions, track student presence, and control hardware in real-time with a premium, high-performance mobile dashboard.

![Showcase](assets/screenshots/showcase.png)


---

## 📄 Project Report
A comprehensive report detailing the requirements, architecture, and testing strategy for this project is available.

👉 **[View Project Report](Project_Report.md)**

---

## ✨ Key Features

### 📊 Multi-Protocol Dashboard
- **Dual Connectivity**: Seamlessly switches between **Firebase Real-time** and **MQTT (Mosquitto)**.
- **Live Environmental Tracking**: Instant updates on Temperature, Humidity, and Student Analytics.
- **Bi-directional Control**: Send commands and receive status updates for Mode (Auto/Manual) and Lighting.

### 🎨 Premium UI/UX
- **Zoom Drawer Navigation**: A modern side-menu experience for fluid navigation.
- **Interactive Analytics**: High-performance line charts (fl_chart) for historical trends.
- **Glassmorphism Design**: High-end visuals with gradients, smooth shadows, and micro-animations.

### 🛠 Integrated Testing Tools
- **Mobile IoT Simulator**: Built-in screen to simulate sensor data locally from within the app.
- **Professional Web Simulator**: A dedicated web dashboard for laptop-to-app testing via WebSockets.

<p align="center">
  <img src="screenshots/web_simulator.png" width="80%" alt="Web Simulator" />
</p>

---

## 🛠 Tech Stack
- **Frontend**: Flutter (Dart)
- **State Management**: BLoC / Cubit
- **Cloud Backend**: Firebase Real-time Database
- **IoT Protocol**: MQTT (Mosquitto Broker)
- **Visuals**: FL Chart & Google Fonts

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed on your machine.
- A Firebase project set up.

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/AbdelmenamAdel/Smart-Classroom-IOT.git
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Run `flutterfire configure` to set up your project.
   - Ensure you have a `classroom` node in your Realtime Database.

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 📸 Screenshots

| Dashboard | History & Trends | Meet Developer |
| :---: | :---: | :---: |
| ![Dashboard](assets/screenshots/dashboard.png) | ![Charts](assets/screenshots/trends.png) | ![Developer](assets/screenshots/developer.png) |

---

## 👨‍💻 About the Developer

**Abdelmoneim Adel**
*Software Mobile Application Engineer*

Passionate about building high-quality, user-centric mobile applications using Flutter.

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/abdelmoneim-adel)
[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/AbdelmenamAdel/)
[![Facebook](https://img.shields.io/badge/Facebook-1877F2?style=for-the-badge&logo=facebook&logoColor=white)](https://www.facebook.com/abdelmenam.adel.10)

---

## 📝 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
