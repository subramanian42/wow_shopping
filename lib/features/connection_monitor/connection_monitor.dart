import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow_shopping/features/connection_monitor/bloc/connection_monitor_bloc.dart';
import 'package:wow_shopping/widgets/common.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

@immutable
class ConnectionMonitor extends StatelessWidget {
  const ConnectionMonitor({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConnectionMonitorBloc(
        connectivity: Connectivity(),
      )..add(ConnectivityStarted(isInitial: true)),
      child: ConnectionMonitorView(
        child: child,
      ),
    );
  }
}

class ConnectionMonitorView extends StatelessWidget {
  const ConnectionMonitorView({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectionMonitorBloc, ConnectionMonitorState>(
      builder: (context, state) {
        if (state.connectivityResult == null) {
          return emptyWidget;
        }
        return ConnectivityStatus(
          result: state.connectivityResult!,
          child: child,
        );
      },
    );
  }
}

class ConnectivityStatus extends StatelessWidget {
  const ConnectivityStatus({
    super.key,
    required this.child,
    required this.result,
  });

  final Widget child;
  final ConnectivityResult result;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: double.infinity,
              height: result != ConnectivityResult.none ? 0.0 : null,
              child: Material(
                color: Colors.red,
                child: Padding(
                  padding: verticalPadding4 + horizontalPadding12,
                  child: const Text(
                    'Please check your internet connection',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
