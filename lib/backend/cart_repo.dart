import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/models/cart_item.dart';
import 'package:wow_shopping/models/cart_storage.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;
import 'package:wow_shopping/models/product_item.dart';
import 'package:wow_shopping/backend/wishlist_repo.dart';

/// FIXME: Very similar to the [WishlistRepo] and should be refactored out and simplified

final cartRepoProvider = Provider<CartRepo>((ref) {
  return CartRepo._(ref);
});

class CartRepo {
  CartRepo._(this.ref);
  Ref ref;
  late final File _file;
  late CartStorage _storage;
  late StreamController<List<CartItem>> _cartController;
  Timer? _saveTimer;

  Future<void> create() async {
    CartStorage storage;
    try {
      final dir = await path_provider.getApplicationDocumentsDirectory();
      final file = File(path.join(dir.path, 'cart.json'));
      if (await file.exists()) {
        storage = CartStorage.fromJson(
          json.decode(await file.readAsString()),
        );
        _storage = storage;
      } else {
        _storage = CartStorage.empty;
      }

      _cartController = StreamController<List<CartItem>>.broadcast(
        onListen: () => _emitCart(),
      );
    } catch (error, stackTrace) {
      print('$error\n$stackTrace'); // Send to server?
      rethrow;
    }
  }

  void _emitCart() {
    _cartController.add(currentCartItems);
  }

  List<CartItem> get currentCartItems => _storage.items;

  Stream<List<CartItem>> get streamCartItems => _cartController.stream;

  CartItem cartItemForProduct(ProductItem item) {
    return _storage.items //
        .firstWhere((el) => el.product.id == item.id,
            orElse: () => CartItem.none);
  }

  bool cartContainsProduct(ProductItem item) {
    return cartItemForProduct(item) != CartItem.none;
  }

  void addToCart(ProductItem item,
      {ProductOption option = ProductOption.none}) {
    final existingItem = cartItemForProduct(item);
    if (existingItem != CartItem.none) {
      updateQuantity(item.id, existingItem.quantity + 1);
      return;
    }
    _storage = _storage.copyWith(
      items: {
        ..._storage.items,
        CartItem(
          product: item,
          option: option,
          deliveryFee: Decimal.zero,
          // FIXME: where from?
          deliveryDate: DateTime.now(),
          // FIXME: where from?
          quantity: 1,
        ),
      },
    );
    _emitCart();
    _saveCart();
  }

  void updateQuantity(String productId, int quantity) {
    _storage = _storage.copyWith(
      items: _storage.items.map((item) {
        if (item.product.id == productId) {
          return item.copyWith(quantity: quantity);
        } else {
          return item;
        }
      }),
    );
    _emitCart();
    _saveCart();
  }

  void removeToCart(String productId) {
    _storage = _storage.copyWith(
      items: _storage.items.where((el) => el.product.id != productId),
    );
    _emitCart();
    _saveCart();
  }

  void _saveCart() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 1), () async {
      await _file.writeAsString(json.encode(_storage.toJson()));
    });
  }
}
