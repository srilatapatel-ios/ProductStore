# Architecture

ProductStoreApp follows **MVVM + Repository Pattern + Dependency Injection**.

## Architecture Overview

```text
                    ┌──────────────────┐
                    │    SwiftUI View  │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │    ViewModel     │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │   Repository     │
                    └──────┬─────┬─────┘
                           │     │
                 ┌─────────┘     └─────────┐
                 ▼                         ▼
        ┌────────────────┐        ┌────────────────┐
        │   DataStore    │        │ NetworkService │
        └───────┬────────┘        └───────┬────────┘
                │                         │
                ▼                         ▼
           ┌─────────┐              ┌─────────────┐
           │SwiftData│              │   REST API  │
           └─────────┘              └─────────────┘
1. Data Flow

Product Loading

                             View
                              ↓
                          ViewModel
                              ↓
                          Repository
                              ↓
                       DataStore → SwiftData

When refreshing from the API:

                             Repository
                                 ↓
                           NetworkService
                                 ↓
                              REST API
                                 ↓
                            DataEntity
                                 ↓
                             SwiftData
                                 ↓
                            ViewEntity
                                 ↓
                               View

Favorite Synchronisation:
                                User
                                 ↓
                              ViewModel
                                 ↓
                              Repository
                                 ↓
                              DataStore
                                 ↓
                             Pending Sync
                                 ↓
                             DataSyncService
                                 ↓
                             NetworkService
                                 ↓
                               REST API


2. Image Caching: NSCache is used for memory caching and downloaded images are also stored on disk.

                           ProductImageView
                                 ↓
                            ImageLoader
                                 ↓
                            Memory Cache
                                 ↓
                            Disk Cache
                                 ↓
                              Network


3.Testing:

Protocol-based dependencies allow the use of mock implementations such as:

MockProductRepository
MockDataStore
MockNetworkService
MockNetworkMonitor


4. Dependency Injection

AppContainer creates and provides the main application dependencies.

AppContainer
 ├── DataStore
 ├── NetworkService
 ├── ProductRepository
 ├── DataSyncService
 ├── NetworkMonitor
 └── ImageLoader


