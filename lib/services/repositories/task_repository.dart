import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/services/models/task_model.dart';

class TaskRepository {
  Future<void> saveTasks(List<TaskModel> tasks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskTitles = tasks.map((task) => task.title).toList();
    await prefs.setStringList('task_titles', taskTitles);
    List<String> taskStatuses = tasks.map((task) => task.isCompleted.toString()).toList();
    await prefs.setStringList('task_statuses', taskStatuses);
  }

  Future<List<TaskModel>> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? taskTitles = prefs.getStringList('task_titles');

    List<String>? taskStatuses = prefs.getStringList('task_statuses');

    if (taskTitles == null || taskStatuses == null) {
      return [];
    }
    List<TaskModel> tasks = [];

    for (int i = 0; i < taskTitles.length; i++) {
      tasks.add(TaskModel(
        title: taskTitles[i],
        isCompleted: taskStatuses[i] == 'true',
      ));
    }

    return tasks;
  }

  Future<void> removeTask(int index, List<TaskModel> tasks) async {
    tasks.removeAt(index);
    await saveTasks(tasks);
  }

  Future<void> addTask(TaskModel newTask) async {
    List<TaskModel> tasks = await loadTasks();
    tasks.add(newTask);
    await saveTasks(tasks);
  }

  Future<void> updateTaskStatus(int index, bool isCompleted, List<TaskModel> tasks) async {
    tasks[index].isCompleted = isCompleted;
    await saveTasks(tasks);
  }
}
