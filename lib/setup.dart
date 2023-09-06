import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/backend/cart_repo.dart';
import 'package:wow_shopping/backend/product_repo.dart';
import 'package:wow_shopping/backend/wishlist_repo.dart';
import 'package:wow_shopping/features/cart/notifier/cart_notifier.dart';
// import 'package:wow_shopping/features/cart/notifier/cart_notifier.dart';

import 'package:wow_shopping/features/main/notifier/bottom_nav_notifier.dart';

Future<void> setup() async {
  di.registerSingleton(BottomNavNotifier());
  di.registerSingletonAsync<ProductsRepo>(
    () => ProductsRepo.create(),
  );
  di.registerSingletonAsync<CartRepo>(
    () => CartRepo.create(),
  );
  await di.allReady();
  di.registerSingletonAsync<WishlistRepo>(
      () => WishlistRepo.create(di.get<ProductsRepo>()),
      dependsOn: [ProductsRepo]);
  di.registerSingleton(
    CartNotifier(
      di.get<CartRepo>(),
    ),
  );
}
