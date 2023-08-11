import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wow_shopping/backend/backend.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial()) {
    on<InitializeAppEvent>(_onInitializeAppEvent);
  }

  Future<void> _onInitializeAppEvent(
    InitializeAppEvent event,
    Emitter<AppState> emit,
  ) async {
    try {
      // no need to inject backend as init is a static function
      final data = await Backend.init();

      emit(SuccessState(data));
    } catch (e) {
      emit(FailureState(e.toString()));
    }
  }
}
