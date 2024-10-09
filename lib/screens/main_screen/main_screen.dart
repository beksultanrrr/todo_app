import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/services/constants/color_constant.dart';

import 'package:todo_app/services/models/task_model.dart';
import 'package:todo_app/screens/main_screen/bloc/home_bloc.dart';
import 'package:todo_app/screens/widgets/task_item.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ScrollController _firstController = ScrollController();
  List<bool> selectedBoxes = [];
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(InitialHomeEvent());
  }

  void _showAddTaskModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autofocus: true,
                  controller: _taskController,
                  decoration: const InputDecoration(
                    hintText: 'Add new task',
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColors.primary)),
                    onPressed: () {
                      if (_taskController.text.isNotEmpty) {
                        context.read<HomeBloc>().add(AddTaskEvent(TaskModel(title: _taskController.text)));
                        _taskController.clear();
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text(
                      'Add Task',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String get greeting {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 6) {
      greeting = 'Good Night';
    } else if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 18) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }
    return greeting;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
            backgroundColor: const Color(0xFFF0F4F3),
            body: Column(
              children: [
                Expanded(
                  child: Container(
                    color: const Color(0xFF50C2C9),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Image.asset('assets/images/cirlceAvater.png'),
                        const SizedBox(height: 30),
                        const Text(
                          "Welcome",
                          style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            greeting,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(90)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: SvgPicture.asset('assets/images/clock.svg'),
                        ),
                        const Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'Task list',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Daily task',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      iconSize: 25,
                                      color: const Color(0xFF50C2C9),
                                      onPressed: () {
                                        _showAddTaskModal(context);
                                      },
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Scrollbar(
                                    thickness: 3.0,
                                    radius: const Radius.circular(20),
                                    thumbVisibility: true,
                                    controller: _firstController,
                                    child: ListView.builder(
                                      padding: const EdgeInsets.symmetric(vertical: 0),
                                      controller: _firstController,
                                      itemCount: state.tasks.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        final taskItem = state.tasks[index];
                                        return TaskItem(
                                            task: taskItem,
                                            onDeleted: () {
                                              context.read<HomeBloc>().add(RemoveTaskEvent(index, state.tasks));
                                            },
                                            onCompleted: (value) {
                                              context.read<HomeBloc>().add(UpdateTaskStatusEvent(index, state.tasks));
                                            });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }
}
