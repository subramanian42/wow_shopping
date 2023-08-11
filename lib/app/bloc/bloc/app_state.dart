part of 'app_bloc.dart';

@immutable
sealed class AppState {}

final class AppInitial extends AppState {}

final class SuccessState extends AppState {
  SuccessState(this.data);
  final Backend data;
}

final class FailureState extends AppState {
  FailureState(this.errorMessage);

  final String errorMessage;
}
