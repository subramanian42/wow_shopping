part of 'main_screen_cubit.dart';

@immutable
class MainScreenCubitState {
  const MainScreenCubitState({this.selected = NavItem.home});

  final NavItem selected;
}
