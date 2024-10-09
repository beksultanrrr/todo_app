import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/services/models/task_model.dart';

import 'package:todo_app/services/repositories/task_repository.dart';

part 'home_events.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TaskRepository taskRepository;
  HomeBloc(this.taskRepository) : super(const HomeState()) {
    on<InitialHomeEvent>(_initialHomeEvent);

    on<LoadTasksEvent>(_loadTaskEvent);
    on<AddTaskEvent>(_addTaskEvent);
    on<RemoveTaskEvent>(_removeTask);
    on<UpdateTaskStatusEvent>(_updateTaskStatus);
  }

  Future<void> _initialHomeEvent(InitialHomeEvent event, Emitter<HomeState> emit) async {
    if (state.isLoading) return;
    add(LoadTasksEvent());
  }

  Future<void> _loadTaskEvent(LoadTasksEvent event, Emitter<HomeState> emit) async {
    if (state.isLoading) return;
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final tasks = await taskRepository.loadTasks();
      emit(state.copyWith(tasks: tasks, status: HomeStatus.success));
    } catch (error) {
      emit(state.copyWith(
        status: HomeStatus.failure,
      ));
    }
  }

  Future<void> _saveTasks(SaveTaskEvent event, Emitter<HomeState> emit) async {
    if (state.isLoading) return;
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      await taskRepository.saveTasks(event.tasks);
      emit(state.copyWith(status: HomeStatus.success));
    } catch (error) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  Future<void> _removeTask(RemoveTaskEvent event, Emitter<HomeState> emit) async {
    if (state.isLoading) return;
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      List<TaskModel> updatedTasks = state.tasks;
      await taskRepository.removeTask(event.index, event.tasks);
      emit(state.copyWith(tasks: updatedTasks, status: HomeStatus.success));
    } catch (error) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  Future<void> _addTaskEvent(AddTaskEvent event, Emitter<HomeState> emit) async {
    if (state.isLoading) return;
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      await taskRepository.addTask(event.task);
      final updatedTasks = List<TaskModel>.from(state.tasks)..add(event.task);
      emit(state.copyWith(status: HomeStatus.success, tasks: updatedTasks));
    } catch (error) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  Future<void> _updateTaskStatus(UpdateTaskStatusEvent event, Emitter<HomeState> emit) async {
    if (state.isLoading) return;
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      List<TaskModel> updatedTasks = List.from(event.tasks);
      updatedTasks[event.index].isCompleted = !updatedTasks[event.index].isCompleted; // Переключаем статус
      await taskRepository.updateTaskStatus(event.index, updatedTasks[event.index].isCompleted, updatedTasks);
      emit(state.copyWith(tasks: updatedTasks, status: HomeStatus.success));
    } catch (error) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }
}
