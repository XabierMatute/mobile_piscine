# Mobile Piscine

## Overview

**Mobile Piscine** is a pedagogical project designed to introduce students to mobile application development using **Flutter**. This piscine provides a structured learning experience, covering essential concepts such as UI design, state management, API integration, and cross-platform development. The project is currently incomplete but serves as a foundation for exploring mobile development and building functional applications for Android, iOS, and other platforms.

The piscine includes multiple exercises, each focusing on specific aspects of mobile development. These exercises range from creating simple applications to implementing advanced features like weather APIs and geolocation. The modular structure of the project allows learners to progressively build their skills while experimenting with Flutter's capabilities.

## Features

### Core Topics Covered
- **Flutter Basics**:
  - Setting up a Flutter project.
  - Understanding widgets and layouts.
- **State Management**:
  - Managing app state using `setState`.
- **API Integration**:
  - Fetching data from weather APIs.
  - Handling errors and displaying dynamic content.
- **Cross-Platform Development**:
  - Building applications for Android, iOS, Linux, and web platforms.
- **Geolocation**:
  - Determining user location and updating weather data based on coordinates.

### Exercises
#### Module 00: Introduction to Flutter
- **Exercise 00**: Basic Flutter setup and UI design.
- **Exercise 01**: Creating simple interactive applications.
- **Exercise 02**: Experimenting with layouts and widgets.
- **Exercise 03**: Implementing basic navigation.

#### Module 01: Intermediate Features
- **Exercise 00**: Building a weather app with static data.
- **Exercise 01**: Adding interactivity and dynamic content.
- **Exercise 02**: Integrating APIs for real-time weather updates.

#### Module 02: Advanced Features
- **Exercise 00**: Medium weather app with geolocation.
- **Exercise 01**: Error handling and user feedback.
- **Exercise 02**: Web and mobile compatibility.
- **Exercise 03**: Weekly weather forecast with advanced UI.

#### Module 03: Cross-Platform Development
- **Exercise 00**: Advanced weather app with Linux and web support.

## Code Structure

### Core Files
- **Main Application**:
  - [`main.dart`](mobile_piscine/m02/ex02/medium_weather_app/lib/main.dart): Entry point for the Flutter application.
- **API Integration**:
  - Functions for fetching weather data and handling responses.
- **Geolocation**:
  - Scripts for determining user location and updating weather data.

### Platform-Specific Configurations
- **Android**:
  - [`build.gradle.kts`](mobile_piscine/m02/ex01/medium_weather_app/android/app/build.gradle.kts): Configures Android-specific settings.
- **iOS**:
  - [`AppDelegate.swift`](mobile_piscine/m02/ex01/medium_weather_app/ios/Runner/AppDelegate.swift): Configures iOS-specific settings.
- **Linux**:
  - [`my_application.cc`](mobile_piscine/m03/ex00/advanced_weather_app/linux/runner/my_application.cc): Implements Linux-specific functionality.
- **Web**:
  - [`manifest.json`](mobile_piscine/m02/ex02/medium_weather_app/web/manifest.json): Configures web-specific settings.

### UI Components
- **Widgets**:
  - Custom widgets for displaying weather data and user feedback.
- **Layouts**:
  - Responsive designs for mobile and web platforms.

## Competencies Involved

### Technical Skills
- **Flutter Development**: Building modular and scalable applications using Flutter.
- **API Integration**: Fetching and processing data from external APIs.
- **Cross-Platform Development**: Ensuring compatibility across mobile, desktop, and web platforms.
- **Geolocation**: Implementing location-based features.

### Problem-Solving
- **Error Handling**: Managing API errors and providing user feedback.
- **UI/UX Design**: Creating intuitive and user-friendly interfaces.
- **Optimization**: Structuring code for efficient performance.

### Collaboration
- **Code Organization**: Structuring the project for readability and maintainability.
- **Documentation**: Writing clear comments and a comprehensive README.

## Status

This project is a **work-in-progress**. Current focus areas include:
- Completing advanced exercises in Module 03.
- Enhancing UI/UX for weather apps.
- Expanding cross-platform compatibility.

## Reflections

Participating in the **Mobile Piscine** has been an enriching experience. Revisiting foundational concepts in mobile development has reinforced my understanding of Flutter and reminded me of the excitement of learning new technologies. While the project is incomplete, it has provided valuable insights and skills that I look forward to applying in future projects.

## How to Run

1. Clone the repository.
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Run the application:
   ```sh
   flutter run
   ```

## Acknowledgments

Special thanks to the **42 School** for organizing this piscine and to the Flutter community for their resources and support.