import 'package:flutter/material.dart';
import 'package:todo_app/services/constants/color_constant.dart';
import 'package:todo_app/services/models/task_model.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  final Function(bool?) onCompleted;
  final Function() onDeleted;

  const TaskItem({super.key, required this.onCompleted, required this.task, required this.onDeleted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: ClipRect(
        child: Dismissible(
            key: Key(UniqueKey().toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              onDeleted();
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Checkbox(
                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                      activeColor: AppColors.primary,
                      value: task.isCompleted,
                      onChanged: onCompleted, // Передаем булево значение
                    ),
                    const SizedBox(width: 10, height: 30),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => onCompleted(!task.isCompleted),
                        child: Text(
                          textAlign: TextAlign.justify,
                          task.title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
