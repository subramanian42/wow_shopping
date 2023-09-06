import 'package:flutter/material.dart';
import 'package:wow_shopping/backend/api_service.dart';
import 'package:wow_shopping/backend/auth_repo.dart';

export 'package:wow_shopping/backend/product_repo.dart';
export 'package:wow_shopping/backend/wishlist_repo.dart';

extension BackendBuildContext on BuildContext {
  Backend get backend => BackendInheritedWidget.of(this, listen: false);

  AuthRepo get authRepo => backend.authRepo;
}

extension BackendState<T extends StatefulWidget> on State<T> {
  AuthRepo get authRepo => context.authRepo;
}

class Backend {
  Backend._(
    this.authRepo,
  );

  final AuthRepo authRepo;

  static Future<Backend> init() async {
    late AuthRepo authRepo;
    final apiService = ApiService(() async => authRepo.token);
    authRepo = await AuthRepo.create(apiService);
    authRepo.retrieveUser();
    return Backend._(
      authRepo,
    );
  }
}

@immutable
class BackendInheritedWidget extends InheritedWidget {
  const BackendInheritedWidget({
    Key? key,
    required this.backend,
    required Widget child,
  }) : super(key: key, child: child);

  final Backend backend;

  static Backend of(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context
          .dependOnInheritedWidgetOfExactType<BackendInheritedWidget>()!
          .backend;
    } else {
      return context
          .getInheritedWidgetOfExactType<BackendInheritedWidget>()!
          .backend;
    }
  }

  @override
  bool updateShouldNotify(BackendInheritedWidget oldWidget) {
    return backend != oldWidget.backend;
  }
}
