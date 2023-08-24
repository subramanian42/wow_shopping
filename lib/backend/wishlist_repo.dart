import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/backend/product_repo.dart';

import 'package:wow_shopping/models/product_item.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;
import 'package:wow_shopping/models/wishlist_storage.dart';

final wishlistRepoProvider = Provider<WishlistRepo>((ref) {
  return WishlistRepo._(ref);
});

// Provides state
final wishlistStorageProvider = StateProvider<WishlistStorage>((ref) {
  return const WishlistStorage(items: {});
});

class WishlistRepo {
  WishlistRepo._(this.ref);

  final Ref ref;
  late final File _file;

  late StreamController<List<ProductItem>> _wishlistController;
  Timer? _saveTimer;

  Future<void> create() async {
    WishlistStorage wishlistStorage;
    try {
      final dir = await path_provider.getApplicationDocumentsDirectory();
      _file = File(path.join(dir.path, 'wishlist.json'));
      if (await _file.exists()) {
        wishlistStorage = WishlistStorage.fromJson(
          json.decode(await _file.readAsString()),
        );
      } else {
        wishlistStorage = WishlistStorage.empty;
      }
      ref
          .read(wishlistStorageProvider.notifier)
          .update((state) => wishlistStorage);
      // _wishlistController = StreamController<List<ProductItem>>.broadcast(
      //   onListen: () => _emitWishlist(),
      // );
    } catch (error, stackTrace) {
      print('$error\n$stackTrace'); // Send to server?
      rethrow;
    }
  }

  // void _emitWishlist() {
  //   _wishlistController.add(currentWishlistItems);
  // }

  List<ProductItem> get currentWishlistItems => ref
      .read(wishlistStorageProvider)
      .items
      .map(ref.read(productRepoProvider).findProduct)
      .toList();

  Stream<List<ProductItem>> get streamWishlistItems =>
      _wishlistController.stream;

  bool isInWishlist(ProductItem item) {
    return ref.read(wishlistStorageProvider).items.contains(item.id);
  }

  Stream<bool> streamIsInWishlist(ProductItem item) async* {
    bool last = isInWishlist(item);
    yield last;
    await for (final list in streamWishlistItems) {
      final current = list.any((product) => product.id == item.id);
      if (current != last) {
        yield current;
        last = current;
      }
    }
  }

  void addToWishlist(String productId) {
    final wishlist = ref.read(wishlistStorageProvider);

    if (wishlist.items.contains(productId)) {
      return;
    }
    final updatedWishlist = wishlist.copyWith(
      items: {...wishlist.items, productId},
    );
    ref
        .read(wishlistStorageProvider.notifier)
        .update((state) => updatedWishlist);
    _saveWishlist();
  }

  void removeToWishlist(String productId) {
    final wishlist = ref.read(wishlistStorageProvider);

    final updatedwishlist = wishlist.copyWith(
      items: wishlist.items.where((el) => el != productId),
    );
    ref
        .read(wishlistStorageProvider.notifier)
        .update((state) => updatedwishlist);
    _saveWishlist();
  }

  void _saveWishlist() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 1), () async {
      await _file.writeAsString(
          json.encode(ref.read(wishlistStorageProvider).toJson()));
    });
  }
}
