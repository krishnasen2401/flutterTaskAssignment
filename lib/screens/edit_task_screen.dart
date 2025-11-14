import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class EditTaskScreen extends StatefulWidget {
  final ParseObject task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  DateTime? dueDate;
  bool isCompleted = false;
  bool saving = false;

  @override
  void initState() {
    super.initState();

    titleController =
        TextEditingController(text: widget.task.get<String>('title') ?? "");
    descriptionController =
        TextEditingController(text: widget.task.get<String>('description') ?? "");
    dueDate = widget.task.get<DateTime>('dueDate');
    isCompleted = widget.task.get<bool>('isCompleted') ?? false;
  }

  Future<void> pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: dueDate ?? DateTime.now(),
    );

    if (picked != null) setState(() => dueDate = picked);
  }

  Future<void> updateTask() async {
    if (titleController.text.trim().isEmpty) {
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

    widget.task
      ..set('title', titleController.text.trim())
      ..set('description', descriptionController.text.trim())
      ..set('dueDate', dueDate!)
      ..set('isCompleted', isCompleted);

    final response = await widget.task.save();

    setState(() => saving = false);

    if (response.success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error?.message ?? "Update failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Task")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
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
                onPressed: updateTask,
                child: saving
                    ? const CircularProgressIndicator()
                    : const Text("Update Task"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
