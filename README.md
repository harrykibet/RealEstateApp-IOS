# 🏠 RealEstateApp iOS

An iOS version of the RealEstateApp — a powerful, user-centric real estate listing platform designed for seamless property browsing, landlord listings, and tenant management. This version is written in Swift using SwiftUI, and adheres to scalable, modular architecture principles.

---

## 🚀 Features

- 🔍 Explore and filter properties based on price, location, type, etc.
- 🏘️ List properties for rent/sale with image uploads and descriptions.
- 📍 Integrated MapKit support for location-based browsing.
- ❤️ Save favorite properties.
- 🔐 Secure authentication using FirebaseAuth.
- 📊 Admin dashboard for property analytics (future).
- 📷 FFmpegKit support for media optimization (planned).

---

## 🛠️ Tech Stack

- **Language:** Swift 5
- **UI Framework:** SwiftUI
- **Architecture:** MVVM + Clean Modular Design
- **Database:** Firebase Firestore
- **Storage:** Firebase Storage
- **Maps:** MapKit + CoreLocation
- **Media Processing:** [FFmpegKit](https://github.com/arthenica/ffmpeg-kit)
- **Push Notifications:** Firebase Cloud Messaging (FCM)

---

## 📁 Project Structure

```bash
RealEstateApp-IOS/
│
├── RealEstateApp/              # Main iOS App
│   ├── Features/               # Modular feature packages
│   ├── Core/                   # Reusable utilities and components
│   ├── Resources/              # Assets, localization files
│   └── App/                    # Entry point and environment setup
│
├── README.md
└── .gitignore
=======
# RealEstateApp-IOS
A IOS application used for managing or searching for properties. It is useful for tenants and property owners, as for tenants it solves the problem of finding a new place to live and as for property owners it solves the problem of finding tenants for properties and also managing multiple properties.
