# 🏫 Smart Classroom IOT 🚀

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge)

A cutting-edge IoT solution for modern classrooms. Monitor environmental conditions, track student presence, and control hardware in real-time with a premium, high-performance mobile dashboard.

---

## ✨ Key Features

### 📊 Real-time Monitoring
- **Live Environmental Tracking**: Instant updates on Temperature (°C) and Humidity (%).
- **Student Analytics**: Real-time counter of students currently in the classroom.
- **Smart Lighting**: Visual status of the classroom lighting system.

### 💡 Interactive Control
- **Remote Light Toggle**: Switch classroom lights ON/OFF directly from the mobile app with ultra-low latency via Firebase Realtime Database.

### 📈 Data Visualization & Recording
- **Historical Trends**: Beautifully rendered line charts (powered by `fl_chart`) showing temperature and humidity fluctuations over time.
- **Automated Recording**: Every sensor update is automatically logged into a history timeline for future analysis.

### 🎨 Premium User Experience
- **Modern UI/UX**: Clean, card-based dashboard with vibrant gradients and smooth micro-animations.
- **Developer Portfolio**: Integrated "Meet the Developer" section with interactive social links.
- **Responsive Design**: Optimized for a seamless experience across iOS and Android.

---

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (v3.x)
- **State Management**: [BLoC / Cubit](https://pub.dev/packages/flutter_bloc) for clean, predictable state transitions.
- **Database**: [Firebase Realtime Database](https://firebase.google.com/products/realtime-database) for live data synchronization.
- **Charts**: [fl_chart](https://pub.dev/packages/fl_chart) for high-performance data visualization.
- **Architecture**: Clean Architecture principles with Repository pattern.

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
| ![Dashboard](https://via.placeholder.com/200x400?text=Dashboard) | ![Charts](https://via.placeholder.com/200x400?text=Trends) | ![Developer](https://via.placeholder.com/200x400?text=Developer) |

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
