// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class InitialHomeEvent extends HomeEvent {}

class LoadTasksEvent extends HomeEvent {}

class RemoveTaskEvent extends HomeEvent {
  final int index;
  final List<TaskModel> tasks;
  const RemoveTaskEvent(this.index, this.tasks);
}

class AddTaskEvent extends HomeEvent {
  final TaskModel task;
  const AddTaskEvent(this.task);
}

class SaveTaskEvent extends HomeEvent {
  final List<TaskModel> tasks;
  const SaveTaskEvent(this.tasks);
}

class UpdateTaskStatusEvent extends HomeEvent {
  final int index;
  final List<TaskModel> tasks;

  const UpdateTaskStatusEvent(this.index, this.tasks);
}
