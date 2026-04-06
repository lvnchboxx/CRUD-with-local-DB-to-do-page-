# CRUD-with-local-DB-to-do-page-
a simple to do list manager app built with CRUD local DB
# 📝 Simple To-Do List (Flutter + Isar)

A simple **Flutter CRUD application** using a **local database (Isar)** and **Provider** for state management.

This project demonstrates how to build a clean, structured app with an **MVC-like architecture**.

---

## 🚀 Features

-  Add new tasks (Create)
-  View all tasks (Read)
-  Mark tasks as done (Update)
-  Delete tasks (Delete)
-  Persistent local storage using Isar

---

## 🧱 Project Structure

```text
lib/
├─ main.dart                 # App entry point
├─ models/
│  └─ task.dart             # Task data model
├─ services/
│  └─ task_database.dart    # Database + CRUD logic
├─ pages/
│  └─ todo_page.dart        # UI and user interaction
