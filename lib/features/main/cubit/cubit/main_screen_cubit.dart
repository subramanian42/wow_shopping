import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wow_shopping/features/main/main_screen.dart';

part 'main_screen_cubit_state.dart';

class MainScreenCubit extends Cubit<MainScreenCubitState> {
  MainScreenCubit() : super(const MainScreenCubitState());

  void gotoSection(NavItem item) {
    emit(MainScreenCubitState(selected: item));
  }
}
