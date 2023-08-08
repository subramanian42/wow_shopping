import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

part 'connection_monitor_event.dart';
part 'connection_monitor_state.dart';

class ConnectionMonitorBloc
    extends Bloc<ConnectionMonitorEvent, ConnectionMonitorState> {
  ConnectionMonitorBloc({
    required Connectivity connectivity,
  })  : _connectivity = connectivity,
        super(const ConnectionMonitorState()) {
    on<ConnectivityStarted>(_onConnectivityStarted);
    add(ConnectivityStarted());
  }
  final Connectivity _connectivity;

  Future<void> _onConnectivityStarted(
    ConnectivityStarted event,
    Emitter<ConnectionMonitorState> emit,
  ) async {
    if (event.isInitial) {
      final result = await _connectivity.checkConnectivity();
      emit(
        state.copyWith(result),
      );
    } else {
      await emit.onEach(
        _connectivity.onConnectivityChanged,
        onData: (result) => emit(
          state.copyWith(result),
        ),
      );
    }
  }
}
