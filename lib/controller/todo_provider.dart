// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:sqfliteflutter/model/todo_model.dart';

// // class TaskNotifier extends StateNotifier<List<Todo>> {
// //   TaskNotifier() : super([]) {
// //     fetchTodos();
// //   }

// //   final HiveRepository hiveDatabase = HiveRepository();
// //   Future<void> fetchTodos() async {
// //     state = await hiveDatabase.getTodos();
// //   }

// //   void addTodo(Todo todo) async {
// //     await hiveDatabase.addTodo(todo);
// //     fetchTodos();
// //   }

// //   void putTodo(Todo todo, int key) async {
// //     await hiveDatabase.putTodo(todo, key);
// //     fetchTodos();
// //   }

// //   void deleteTodo(int index) async {
// //     await hiveDatabase.deleteTodo(index);
// //     fetchTodos();
// //   }

// //   void updateTodo(Todo todo, int index) async {
// //     await hiveDatabase.updateTodo(todo, index);
// //     fetchTodos();
// //   }

// //   void clearDatabase() async {
// //     await hiveDatabase.clearDatabase();
// //   }
// // }

// // final todosDataProvider =
// //     StateNotifierProvider<TaskNotifier, List<Todo>>((ref) => TaskNotifier());

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sqfliteflutter/database/db_helper.dart';
// import 'package:sqfliteflutter/model/todo_model.dart';

// class TaskNotifier extends StateNotifier<List<Todo>> {
//   TaskNotifier() : super([]) {
//     fetchTodos();
//   }

//   final LocalDatabase localDatabase = LocalDatabase.instance;

//   Future<void> fetchTodos() async {
//     final todos = await localDatabase.readTodo();
//     print('fetch : ${todos.last.id}');
//     state = todos.where((todo) => todo != null).cast<Todo>().toList();

//     // state = todos.cast<Todo>().toList();
//     //  print(state);
//   }

//   Future<int> addTodo(Todo todo) async {
//     final id = await localDatabase.createTodo(todo);
//     final updatedtodo = todo.copyWith(id: id);
//     state = [...state, updatedtodo];
//     print('upd ${updatedtodo.toMap()}');
//     fetchTodos();
//     return id;
//   }

//   Future<void> updateTodo(Todo todo) async {
//     await localDatabase.updateTodo(todo);
//     fetchTodos();
//   }

//   Future<void> deleteTodo(int id) async {
//     await localDatabase.deleteTodo(id);
//     fetchTodos();
//   }

//   Future<void> clearDatabase() async {
//     // await localDatabase.close();
//     await localDatabase.clearDatabase();
//     await localDatabase.initDB(); // Reinitialize the database
//     fetchTodos();
//   }
// }

// final todosDataProvider =
//     StateNotifierProvider<TaskNotifier, List<Todo>>((ref) => TaskNotifier());

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqfliteflutter/database/db_helper.dart';
import 'package:sqfliteflutter/model/todo_model.dart';

class TaskNotifier extends StateNotifier<List<Todo>> {
  TaskNotifier() : super([]) {
    fetchTodos();
  }

  final DatabaseHelper _localDatabase = DatabaseHelper();

  Future<void> fetchTodos() async {
    try {
      final todos = await _localDatabase.getAllTodos();
      state = todos.where((todo) => todo != null).cast<Todo>().toList();
    } catch (e) {
      print('Error fetching todos: $e');
    }
  }

  Future<void> addTodo(Todo todo) async {
    try {
      await _localDatabase.insertTodo(todo);

      fetchTodos();
    } catch (e) {
      print('Error adding todo: $e');
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      await _localDatabase.updateTodo(todo);
      fetchTodos();
    } catch (e) {
      print('Error updating todo: $e');
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      await _localDatabase.deleteTodo(id);
      fetchTodos();
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }

  Future<void> clearDatabase() async {
    try {
      await _localDatabase.clearTableData();
      fetchTodos();
    } catch (e) {
      print('Error clearing database: $e');
    }
  }
}

final todosDataProvider =
    StateNotifierProvider<TaskNotifier, List<Todo>>((ref) => TaskNotifier());
