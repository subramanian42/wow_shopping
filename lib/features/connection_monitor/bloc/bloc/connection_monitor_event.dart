part of 'connection_monitor_bloc.dart';

@immutable
sealed class ConnectionMonitorEvent {}

final class ConnectivityStarted extends ConnectionMonitorEvent {
  final bool isInitial;
  ConnectivityStarted({this.isInitial = false});
}

// final class _UpdateConnection extends ConnectionMonitorEvent {
//   final ConnectivityResult connectionResult;

//   _UpdateConnection({required this.connectionResult});
// }
