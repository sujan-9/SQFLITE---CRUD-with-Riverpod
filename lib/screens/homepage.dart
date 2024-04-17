import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqfliteflutter/controller/todo_provider.dart';
import 'package:sqfliteflutter/model/todo_model.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  fetchTodo() async {
    ref.read(todosDataProvider.notifier).fetchTodos();
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(todosDataProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sqflite'),
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                            'Are you sure you want to delete whole data permanently?'),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(todosDataProvider.notifier)
                                    .clearDatabase();
                                Navigator.pop(context);
                              },
                              child: const Text('Delete')),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Nevermind'))
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.remove_circle_outline_rounded))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Enter data'),
                  actions: [
                    BuildTextfield(
                      controller: titleController,
                      hintText: 'Title',
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    BuildTextfield(
                      controller: descController,
                      hintText: 'Description',
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (titleController.text.isNotEmpty &&
                              descController.text.isNotEmpty) {
                            final notifier =
                                ref.read(todosDataProvider.notifier);
                            notifier.addTodo(
                              Todo(
                                title: titleController.text.trim(),
                                body: descController.text.trim(),
                              ),
                            );

                            titleController.clear();
                            descController.clear();
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Save'))
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
      body: data.isEmpty
          ? const Center(
              child: Text(
                "No Data",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          : Consumer(builder: (context, ref, _) {
              final todos = ref.watch(todosDataProvider);

              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return Card(
                    child: ListTile(
                      leading: Text(todo.id.toString()),
                      title: Text(todo.title),
                      subtitle: Text(todo.body),
                      trailing: SizedBox(
                        width: 120,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        titleController.text = todo.title;
                                        descController.text = todo.body;
                                        return AlertDialog(
                                          title: const Text('Update data'),
                                          actions: [
                                            BuildTextfield(
                                              controller: titleController,
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            BuildTextfield(
                                              controller: descController,
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      ref
                                                          .read(
                                                              todosDataProvider
                                                                  .notifier)
                                                          .updateTodo(
                                                            Todo(
                                                                title:
                                                                    titleController
                                                                        .text
                                                                        .trim(),
                                                                body:
                                                                    descController
                                                                        .text
                                                                        .trim(),
                                                                id: todo.id),
                                                          );
                                                      titleController.clear();
                                                      descController.clear();
                                                      Navigator.pop(context);
                                                    },
                                                    child:
                                                        const Text('Update')),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      titleController.clear();
                                                      descController.clear();
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Cancel'))
                                              ],
                                            )
                                          ],
                                        );
                                      });
                                },
                                icon: const Icon(Icons.edit_note_sharp)),
                            IconButton(
                                onPressed: () {
                                  ref
                                      .read(todosDataProvider.notifier)
                                      .deleteTodo(todo.id ?? index);
                                },
                                icon: const Icon(Icons.delete_forever_rounded)),
                          ],
                        ),
                      ),
                      // Implement update and delete logic here
                    ),
                  );
                },
              );
            }),
    );
  }
}

class BuildTextfield extends StatelessWidget {
  const BuildTextfield({
    super.key,
    required this.controller,
    this.hintText,
    this.index,
  });
  final TextEditingController controller;
  final String? hintText;
  final int? index;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
          focusedBorder: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder()),
    );
  }
}
