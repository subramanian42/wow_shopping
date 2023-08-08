part of 'connection_monitor_bloc.dart';

@immutable
final class ConnectionMonitorState {
  final ConnectivityResult? connectivityResult;

  const ConnectionMonitorState({this.connectivityResult});

  ConnectionMonitorState copyWith(ConnectivityResult? result) =>
      ConnectionMonitorState(connectivityResult: result ?? connectivityResult);
}
