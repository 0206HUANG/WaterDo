import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/task.dart';
import '../../providers/task_provider.dart';

void showAddSheet(BuildContext context, {Task? editing}) {
  final titleCtl = TextEditingController(text: editing?.title ?? '');
  DateTime? selectedDate = editing?.schedule;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              top: 24,
              left: 24,
              right: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtl,
                  decoration: const InputDecoration(labelText: 'Task'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      selectedDate == null
                          ? 'Today'
                          : DateFormat.yMMMd().format(selectedDate!),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.date_range),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final provider = context.read<TaskProvider>();
                    if (titleCtl.text.trim().isEmpty) return;

                    if (editing != null) {
                      editing.title = titleCtl.text.trim();
                      editing.schedule = selectedDate;
                      editing.save();
                      provider.notifyListeners();
                    } else {
                      provider.add(
                        Task(titleCtl.text.trim(), schedule: selectedDate),
                      );
                    }
                    Navigator.pop(context);
                  },
                  child: Text(editing == null ? 'Add' : 'Update'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
