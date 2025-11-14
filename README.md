# Task Manager App (Flutter + Back4App)

This is a simple task manager application built with Flutter.
Back4App (Parse Server) is used as the backend to store user accounts and tasks.
## Features
* User registration and login
* Create new tasks
* Edit existing tasks
* Delete tasks
* Mark tasks as completed
* Select task due date
* Only logged-in user can access their tasks
* All task data stored on Back4App
## Tech Stack
* Flutter
* Dart
* Back4App (Parse Server SDK)

## Back4App Task Class Structure

```

| Field       | Type    | Description                   |
| ----------- | ------- | ----------------------------- |
| title       | String  | Task title (required)         |
| description | String  | Optional description          |
| dueDate     | Date    | Required due date             |
| isCompleted | Boolean | Default: false                |
| owner       | Pointer | Pointer to `_User` (required) |

```

## Project Structure
```
lib/
  main.dart
  services/
      parse_config.dart
  screens/
      login_screen.dart
      register_screen.dart
      task_list_screen.dart
      create_task_screen.dart
      edit_task_screen.dart
```

## Setup Instructions

### 1. Install Flutter Packages

```
flutter pub get
```

### 2. Configure Back4App Keys

Edit the file:

`lib/services/parse_config.dart`

Add your Back4App App ID, Client Key, and Server URL:

```dart
static const String appId = "YOUR_APP_ID";
static const String clientKey = "YOUR_CLIENT_KEY";
static const String serverUrl = "https://parseapi.back4app.com";
```

### 3. Run the App

```
flutter run
```

> Recommended: Use Android or Windows Desktop.
> Flutter Web is not supported by the Parse Flutter SDK.
## How to Use
1. Register a new user
2. Login
3. Add a new task
4. Select a due date
5. Mark tasks as completed using the checkbox
6. Edit or delete tasks
7. Logout when done
## Screenshots (Add your own)
* Login screen
* Register screen
* Task list
* Create task
* Edit task
## Notes

* Each task is linked to the authenticated user through the **owner** pointer.
* ACL ensures only the task owner can read/update/delete their tasks.
* Internet connection is required for the app to work.

---

If you need a **PPT**, **video script**, or a **GitHub description section**, tell me — I can generate those too.
