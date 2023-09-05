import 'package:flutter_command/flutter_command.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/backend/product_repo.dart';
import 'package:wow_shopping/backend/product_repo_proxy.dart';
import 'package:wow_shopping/backend/wishlist_repo.dart';
import 'package:wow_shopping/backend/wishlist_repo_proxy.dart';

import 'package:wow_shopping/features/product_details/models/product_manager.dart';
import 'package:wow_shopping/utils/command_error_filters.dart';

void setup() {
  di.registerSingleton(InteractionManager());

  di.registerSingletonAsync<ProductsRepo>(() => ProductsRepoProxy().init());
  di.registerSingletonAsync<WishlistRepo>(() => WishlistRepoProxy().init(),
      dependsOn: [ProductsRepo]);
  di.registerSingletonAsync<ProductManager>(() async => ProductManager(),
      dependsOn: [ProductsRepo]);

  Command.globalExceptionHandler = (error, stackTrace) {
    di<InteractionManager>().showMessage(error.toString());
  };
}
