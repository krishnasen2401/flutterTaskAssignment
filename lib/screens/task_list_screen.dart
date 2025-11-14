import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'create_task_screen.dart';
import 'edit_task_screen.dart';
import 'login_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<ParseObject> tasks = [];
  bool loading = false;

  Future<void> fetchTasks() async {
    setState(() => loading = true);

    final user = await ParseUser.currentUser();

    final query = QueryBuilder<ParseObject>(ParseObject('Task'))
      ..whereEqualTo('owner', user)
      ..orderByAscending('isCompleted')
      ..orderByDescending('createdAt');

    final response = await query.query();

    setState(() => loading = false);

    if (response.success && response.results != null) {
      tasks = response.results!.cast<ParseObject>();
      setState(() {});
    }
  }

  Future<void> toggleComplete(ParseObject task) async {
    final current = task.get<bool>('isCompleted') ?? false;

    task.set('isCompleted', !current);

    final response = await task.save();

    if (response.success) {
      fetchTasks();
    }
  }

  Future<void> logout() async {
    final user = await ParseUser.currentUser();
    await user.logout();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          )
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchTasks,
              child: tasks.isEmpty
                  ? ListView(children: const [
                      SizedBox(height: 200),
                      Center(child: Text("No tasks yet"))
                    ])
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (_, i) {
                        final t = tasks[i];
                        final completed = t.get<bool>('isCompleted') ?? false;

                        return ListTile(
                          leading: Checkbox(
                            value: completed,
                            onChanged: (_) => toggleComplete(t),
                          ),
                          title: Text(
                            t.get<String>('title') ?? "",
                            style: TextStyle(
                              decoration: completed
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t.get<String>('description') ?? ""),
                              Text(
                                "Due: ${t.get<DateTime>('dueDate')?.toLocal().toString().split(' ')[0] ?? 'N/A'}",
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                completed ? "Completed" : "Pending",
                                style: TextStyle(
                                  color: completed ? Colors.green : Colors.orange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await t.delete();
                              fetchTasks();
                            },
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditTaskScreen(task: t),
                            ),
                          ).then((_) => fetchTasks()),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateTaskScreen()),
        ).then((_) => fetchTasks()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
