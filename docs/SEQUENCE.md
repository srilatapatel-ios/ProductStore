# Sequence Diagram

The following sequence shows how a favourite change is stored locally and synchronised with the server.

```mermaid
sequenceDiagram
    actor User
    participant View as SwiftUI View
    participant VM as ViewModel
    participant Repo as ProductRepository
    participant Store as DataStore
    participant Sync as DataSyncService
    participant Network as NetworkService
    participant API as REST API

    User->>View: Toggle favourite
    View->>VM: toggleFavourite()
    VM->>Repo: updateFavourite()
    Repo->>Store: Update favourite
    Store->>Store: Save pending sync change

    Note over Sync,Network: Synchronisation triggered

    Sync->>Store: Fetch pending changes
    Store-->>Sync: Pending changes
    Sync->>Network: POST favorite change
    Network->>API: Send request
    API-->>Network: Response
    Network-->>Sync: Sync result
    Sync->>Store: Update sync status