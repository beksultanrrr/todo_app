part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  
  final HomeStatus status;
    final List<TaskModel> tasks;

  const HomeState({
    this.status = HomeStatus.initial,
    this.tasks = const []
  });

  @override
  List<Object?> get props => [status,tasks];

  bool get isInitial => status == HomeStatus.initial;
  bool get isLoading => status == HomeStatus.loading;
  bool get isSuccess => status == HomeStatus.success;
  bool get isFailure => status == HomeStatus.failure;

  HomeState copyWith({
    HomeStatus? status,
    List<TaskModel>? tasks
  }) {
    return HomeState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks
    );
  }
}



