# 🌦️ Weather App

A Flutter application that displays real-time weather, air quality, and pollen data using the Open-Meteo API.  
It supports location-based weather, multi-city tracking, and a 7-day forecast, showcasing clean architecture and state management with Riverpod.

---

## 📌 Features

- Auto-detects your current location
- Add and track multiple cities
- Current weather data: temperature, rainfall, UV index, air quality (PM10), pollen count (Europe only)
- 7-day forecast view with weekday labels
- Pull-to-refresh support
- Swipe to delete added cities
- Tooltip notice about pollen availability
- Error fallback with retry behavior
- Clean UI with icons for every metric

---

## 📌 Setup Instructions

1. Install Flutter & Dart ([Flutter Install Guide](https://docs.flutter.dev/get-started/install))
2. Clone the Repository:
   ```bash
   git clone https://github.com/SVG21/weather_app.git
   cd weather_app
   ```
3. Install Dependencies:
   ```sh
   flutter pub get
   ```
4. Run the Application:
   ```sh
   flutter run
   ```

---

## 📌 Folder Structure

```
lib/
├── constants/         # API base URLs and other constants
├── controllers/       # Riverpod providers and logic (location, weather)
├── models/            # Data models (CurrentWeatherData, ForecastData)
├── services/          # API service classes (weather, geocoding, location storage)
├── views/             # UI screens (Home, Forecast)
├── widgets/           # Reusable UI components (WeatherCard, ForecastCard, etc.)
├── integration_test/  # Integration test scripts for end-to-end feature validation
└── main.dart          # Entry point
```

---

## 📌 Integration Tests

Make sure:
- An emulator or physical device is connected
- Location permissions are granted

To run tests:
```sh
flutter test integration_test/app_test.dart
```

---

## 📌 Packages Used & Why

- `flutter_riverpod` – Efficient, boilerplate-free state management
- `http` – To make REST API calls to Open-Meteo
- `geolocator` – To get current latitude & longitude
- `intl` – For date formatting (weekday labels in forecast)
- `shared_preferences` – To locally save and retrieve added locations
- `integration_test` – Full UI and user flow testing

---

## 📌 Technical Choices & Architecture

### State Management: Riverpod

- Riverpod is used for its simplicity, safety, and flexibility in managing state across the app.
- Providers manage weather data, location, and city lists, ensuring reactive updates throughout the UI.

### API Integration

- Fetches real-time weather, air quality, and pollen data from the Open-Meteo API.
- Geocoding and location services are abstracted in service classes for modularity.

### UI Handling

- Displays icons for each weather metric.
- Shows tooltips for features with limited data (e.g., pollen in Europe only).
- Implements swipe-to-delete for city management and pull-to-refresh for data updates.

### Error Handling

- Provides error messages with a retry button for network or API failures.
- Uses fallback UI for missing or incomplete data.

### Integration Testing

- End-to-end tests simulate real user flows including adding/removing locations, navigation, and error handling.
- Ensures reliable behavior and UI consistency through Riverpod-powered state changes.

---

## 📌 Assumptions & Trade-offs

| Assumption / Trade-off | Justification |
|------------------------|---------------|
| Riverpod over Bloc or Provider | Simpler, more modern, and less boilerplate for state management |
| No local caching of weather data | Always displays the most up-to-date information |
| Minimal UI customization | Focus is on clarity and usability over complex animations |
| Pollen data only for Europe | Reflects Open-Meteo API limitations |
| No infinite scrolling in city list | App designed for a manageable number of tracked cities |

---

## 📌 Credits

- [Open-Meteo API](https://open-meteo.com/)
- [Flutter Documentation](https://flutter.dev)
