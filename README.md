# sqfliteflutter

# Folder Structure:

# screens:

      - homepage.dart: This UI allows users to perform CRUD operations.
      - model:
        todo_model.dart: This file defines the Todo model, including its properties such as id, title, and description. The id is auto-generated.
      - database:
        database_helper.dart: Contains code related to database creation and CRUD operations.
      - controller:
        todo_provider.dart: Acts as the bridge between the database_helper and the UI.

# How to Use:

- Integration:

1.  Ensure you have sqflite and path_provider dependencies added to your pubspec.yaml.

dependencies:
flutter:
sdk: flutter
sqflite: ^2.0.0
path_provider: ^2.0.0

2.  Setup Database:
    Copy the database_helper.dart file into your project's database directory.
    Import the file in your code where needed.

3.  Define Model:
    Define your model class similar to todo_model.dart, if you're following the same structure.

4.  Implement UI:
    Use homepage.dart as a reference to implement CRUD operations UI.

5.  Controller:
    Utilize todo_provider.dart to connect UI with database operations.
