import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'task.dart';

class TaskDatabase extends ChangeNotifier {
  static late Isar isar;

  final List<Task> currentTasks = [];

  // initialize database
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      isar = await Isar.open(
        [TaskSchema],
        directory: dir.path,
      );
    } else {
      isar = Isar.getInstance()!;
    }
  }

  // CREATE
  Future<void> addTask(String title) async {
    final newTask = Task()..title = title;

    await isar.writeTxn(() async {
      await isar.tasks.put(newTask);
    });

    await fetchTasks();
  }

  // READ
  Future<void> fetchTasks() async {
    final fetchedTasks = await isar.tasks.where().findAll();

    currentTasks.clear();
    currentTasks.addAll(fetchedTasks);
    notifyListeners();
  }

  // UPDATE
  Future<void> toggleTask(Task task) async {
    task.isDone = !task.isDone;

    await isar.writeTxn(() async {
      await isar.tasks.put(task);
    });

    await fetchTasks();
  }

  Future<void> updateTitle(int id, String newTitle) async {
  final task = await isar.tasks.get(id);

  if (task != null) {
    task.title = newTitle;

    await isar.writeTxn(() async {
      await isar.tasks.put(task);
    });

    await fetchTasks();
  }
}

  // DELETE
  Future<void> deleteTask(int id) async {
    await isar.writeTxn(() async {
      await isar.tasks.delete(id);
    });

    await fetchTasks();
  }
}