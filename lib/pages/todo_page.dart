import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../models/task_database.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final textController = TextEditingController();

  void updateTask(Task task) {
  textController.text = task.title;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit Task'),
      content: TextField(
        controller: textController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            clearInput();
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            final newTitle = textController.text.trim();
            if (newTitle.isEmpty) return;

            await context.read<TaskDatabase>().updateTitle(
                  task.id,
                  newTitle,
                );

            clearInput();
            if (mounted) Navigator.pop(context);
          },
          child: const Text('Update'),
        ),
      ],
    ),
  );
}

  @override
  void initState() {
    super.initState();
    readTasks();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void readTasks() {
    context.read<TaskDatabase>().fetchTasks();
  }

  void clearInput() {
    textController.clear();
  }

  void createTask() {
    clearInput();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Enter task title',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              clearInput();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = textController.text.trim();
              if (title.isEmpty) return;

              await context.read<TaskDatabase>().addTask(title);
              clearInput();

              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskDatabase = context.watch<TaskDatabase>();
    final List<Task> currentTasks = taskDatabase.currentTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple To-Do List'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createTask,
        child: const Icon(Icons.add),
      ),
      body: currentTasks.isEmpty
          ? const Center(
              child: Text('No tasks yet'),
            )
          : ListView.builder(
              itemCount: currentTasks.length,
              itemBuilder: (context, index) {
                final task = currentTasks[index];

                return ListTile(
                  leading: Checkbox(
                    value: task.isDone,
                    onChanged: (_) {
                      context.read<TaskDatabase>().toggleTask(task);
                    },
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                       icon: const Icon(Icons.edit),
                        onPressed: () => updateTask(task),
                       ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<TaskDatabase>().deleteTask(task.id);
                         },
                        ),
                       ],
                      ),
                );
              },
            ),
    );
  }
}
