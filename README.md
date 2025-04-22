# Swift ToDo Calendar App

This demo project highlights the pattern of **Clean architecture**, **Modular with Swift Package Manager**, **Programmatic Layout with UIKit**, **MVVM** and the usage of **SQLite.swift** for local storage. With support of **ReSwift** for state management, **RxSwift** for data binding, and local persistence via **JSON**

## 🚀 Features

- User authentication (Login) - Stored in **SQLite**
- Create, update, delete ToDo items - **ReSwift** is applied here
- View calendar with visual badges for tasks
- MVVM-C architecture with clean modular separation - (Created only single coordinator)
- Local JSON-based data persistence per user
- `RxSwift` usage on Login and Calendar with Input/Output Method.

---

## 🏗 Architecture
Clean Architecture structured by:
* Domain: Business logic and entities
* Data: Repository interfaces and data sources
* Infrastructure: Implementations (SQLite, JSON, etc.)
* Presentation: UI layer, view controllers, coordinators

### 🧱 Tech Stack Breakdown

| Feature                         | Tech Used           | Responsible Classes / Layers                            |
|---------------------------------|----------------------|----------------------------------------------------------|
| UI Layout                       | UIKit + SnapKit      | `AddToDoViewController`, `ToDoListViewController`, etc.  |
| State Management                | ReSwift              | `AppState`, `ToDoAction`, `StoreProvider`, `ToDoReducer`, `ToDoViewController`, |
| Reactive Programming            | RxSwift              | `CalendarViewModel`, `CalendarViewController`, `LoginViewController`, `LoginViewModel`          |
| Persistence (Primary)           | SQLite               | `SQLiteHelper`, `UserLocalDataSourceImpl`, `ToDoLocalDataSourceImpl`                    |
| Persistence (Secondary/Backup) | JSON                 | `ToDoJSONHelper`,                                     |
| MVVM-C Pattern                  | MVVM + Coordinator   | `AppCoordinator`                    |
| Calendar Integration            | UICalendarView             | `CalendarViewController`, `EventStoreManager`            |
| Text Input Error UI             | Custom View          | `TextFieldError`                                         |
