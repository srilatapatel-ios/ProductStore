# 🛍️ ProductStoreApp

An **offline-first marketplace application** built with SwiftUI, SwiftData, Swift Concurrency, and MVVM architecture.

The application allows users to browse products, view product details, add products locally, manage favorites, and synchronize favorite changes when network connectivity is available.

---

## ✨ Features

- 📦 Product listing and product details
- ➕ Add new products locally
- ❤️ Favorite / unfavorite products
- 💾 Local persistence using SwiftData
- 🔄 Favorite synchronization
- 🌐 Network availability monitoring
- 🖼️ PhotosPicker for product images
- ⚡ Memory and disk image caching
- 📊 Support for 200+ products
- 🧪 Unit tests with mock dependencies
- 🧹 SwiftLint integration

---

## 🛠 Tech Stack

| Technology | Usage |
|---|---|
| **Swift** | Primary language |
| **SwiftUI** | User interface |
| **SwiftData** | Local persistence |
| **Swift Concurrency** | Async operations |
| **REST API** | Remote product data |
| **NSCache** | In-memory image caching |
| **XCTest** | Unit testing |
| **SwiftLint** | Code quality |
| **PhotosUI** | Product image selection |

---

## 🏗️ Architecture

The application follows:

**MVVM + Repository Pattern + Dependency Injection**

```text
SwiftUI View
     ↓
ViewModel
     ↓
Repository
   ↙     ↘
DataStore  NetworkService
   ↓          ↓
SwiftData   REST API
