import 'package:flutter/material.dart';
import 'package:wow_shopping/features/connection_monitor/connection_monitor.dart';
import 'package:wow_shopping/features/main/cubit/cubit/main_screen_cubit.dart';
import 'package:wow_shopping/features/main/widgets/bottom_nav_bar.dart';
export 'package:wow_shopping/models/nav_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  // static MainScreenState of(BuildContext context) {
  //   return context.findAncestorStateOfType<MainScreenState>()!;
  // }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainScreenCubit(),
      child: const MainView(),
    );
  }
}

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final mainState = context.watch<MainScreenCubit>().state;
    return SizedBox.expand(
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ConnectionMonitor(
                child: IndexedStack(
                  index: mainState.selected.index,
                  children: [
                    for (final item in NavItem.values) //
                      item.builder(),
                  ],
                ),
              ),
            ),
            BottomNavBar(
              onNavItemPressed: context.read<MainScreenCubit>().gotoSection,
              selected: mainState.selected,
            ),
          ],
        ),
      ),
    );
  }
}
