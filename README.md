[![Watch the Video](https://img.youtube.com/vi/yqlnvYfVnQc/0.jpg)]([https://www.youtube.com/watch?v=_5tFXJQIzi4](https://youtu.be/yqlnvYfVnQc))

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
title       - String  - Task title (required)         
description - String  - Optional description          
dueDate     - Date    - Required due date             
isCompleted - Boolean - Default: false                
owner       - Pointer - Pointer to `_User` (required) 

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
## Screenshots
Login
<img width="1220" height="2712" alt="login" src="https://github.com/user-attachments/assets/9dce9bab-0ee3-4d96-a87f-4bc0be94afe2" />
edit task
<img width="1220" height="2712" alt="edittask" src="https://github.com/user-attachments/assets/590bd084-d9ad-4577-a7ba-327b4a4308f4" />
create task
<img width="1220" height="2712" alt="createtask" src="https://github.com/user-attachments/assets/35d0f886-14b6-4862-8850-c5d28114c7f9" />
tasklist
<img width="1220" height="2712" alt="tasklist" src="https://github.com/user-attachments/assets/77d8825a-4898-4f2d-a5f6-d069b333528a" />
registration
<img width="1220" height="2712" alt="registration" src="https://github.com/user-attachments/assets/face05f4-e1ab-4646-bec9-7780968b7d06" />
## Notes

* Each task is linked to the authenticated user through the **owner** pointer.
* ACL ensures only the task owner can read/update/delete their tasks.
* Internet connection is required for the app to work.
