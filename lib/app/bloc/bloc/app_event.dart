part of 'app_bloc.dart';

@immutable
sealed class AppEvent {}

final class InitializeAppEvent extends AppEvent {}
