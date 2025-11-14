import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final title = TextEditingController();
  final description = TextEditingController();
  DateTime? dueDate;
  bool isCompleted = false;

  bool saving = false;

  Future<void> pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (picked != null) setState(() => dueDate = picked);
  }

  Future<void> saveTask() async {
    if (title.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Title is required")));
      return;
    }

    if (dueDate == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Due date is required")));
      return;
    }

    setState(() => saving = true);

    final user = await ParseUser.currentUser();

    final task = ParseObject('Task')
      ..set('title', title.text.trim())
      ..set('description', description.text.trim())
      ..set('isCompleted', isCompleted)
      ..set('dueDate', dueDate!)
      ..set('owner', user);

    task.setACL(ParseACL(owner: user));

    final response = await task.save();

    setState(() => saving = false);

    if (response.success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.error?.message ?? "Save failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Task")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: description,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              value: isCompleted,
              onChanged: (v) => setState(() => isCompleted = v ?? false),
              title: const Text("Mark as completed"),
            ),
            Row(
              children: [
                Text(
                  dueDate == null
                      ? "No due date selected"
                      : "Due Date: ${dueDate!.toLocal().toString().split(' ')[0]}",
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: pickDueDate,
                  child: const Text("Pick Date"),
                )
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveTask,
                child: saving
                    ? const CircularProgressIndicator()
                    : const Text("Save Task"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
