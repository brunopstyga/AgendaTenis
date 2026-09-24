#  Tennis Scheduler

Cross-platform application built with **Flutter** designed for the comprehensive management of schedules, availability, and tennis class bookings for coaches and students. The system allows managing time slots, capacity limits, class types with differentiated pricing, and user roles (Coach and Student) synchronized in real-time with Firebase.

**Try the app on the Web:** [https://tennis-schedulle.web.app](https://tennis-schedulle.web.app)

---

## Screenshots
*(Screenshots of the main views of the application will be added soon)*

* **Classes List / Main Dashboard (`lessons_pages`):** [ Image placeholder ]
* **Schedule Grid View (`lessons_grid_page`):** [ Image placeholder ]
* **Daily Schedule (`daily_schedule_page`):** [ Image placeholder ]
* **Working Hours Configuration (`configure_availability_page`):** [ Image placeholder ]

---

##  Key Features

* **Multi-role (Coach and Student):**
  * **Coach:** Full access to configure weekly availability, view daily income and occupied/free hours, and delete bookings directly from session cards.
  * **Student:** Views available classes and bookings, hiding management tools exclusive to the coach.
* **Availability & Pricing Management:** Configuration of working days, start and end times, and custom rates according to class type (*Group* with a maximum of 4 people, *Individual*, and *Exclusive Individual*).
* **Visual Grid Indicators (`lessons_grid_page`):** Time slots change color based on occupancy (Red when the 4 maximum spots are filled, Green when spots are still available).
* **Onboarding & Enrollment Flow:** Dedicated screen (`onboarding_page`) to register sessions by specifying the date, time slot, student details (name, phone, last name), skill level, and price.
* **Real-time Synchronization:** All information is stored and updated directly via **Cloud Firestore**.

---

##Tech Stack & Architecture

* **Framework:** [Flutter](https://flutter.dev/) (Supports Android, iOS, and Web)
* **Architecture:** Clean Architecture with an **MVI (Model-View-Intent)** approach and state management via `flutter_bloc`.
* **Dependency Injection:** `get_it` and `injectable`.
* **Backend / Database:** [Firebase](https://firebase.google.com/) (Firebase Auth and Cloud Firestore).

---

##Project Structure

The project follows a clear separation of layers oriented toward Clean Architecture:

```text
lib/
├── core/                   # Constants, dependency injection (di), utilities, and result handling
├── features/
│   └── profile/            # Main management feature module
│       ├── data/           # Repositories and Firebase implementations
│       ├── domain/         # Entities, repository contracts, and use cases
│       └── presentation/   # Presentation layer (Blocs, components, pages, and widgets)
│           ├── pages/      # configure_availability_page, daily_schedule_page, lessons_grid_page, lessons_pages, login_page, onboarding_page
│           └── widgets/    # Reusable elements (app_drawer, cells, metric cards)
└── main.dart
