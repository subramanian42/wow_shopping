import 'package:riverpod/riverpod.dart';
import 'package:wow_shopping/backend/cart_repo.dart';
import 'package:wow_shopping/backend/product_repo.dart';
import 'package:wow_shopping/backend/wishlist_repo.dart';

final backendRepoProvider = FutureProvider.autoDispose(
  (ref) async {
    await ref.read(productRepoProvider).create();
    await ref.read(wishlistRepoProvider).create();
    await ref.read(cartRepoProvider).create();
  },
);
