import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/backend/cart_repo.dart';
import 'package:wow_shopping/models/cart_item.dart';
import 'package:wow_shopping/models/product_item.dart';

class CartNotifier extends ChangeNotifier {
  CartNotifier() {
    _cartItems = di.get<CartRepo>().currentCartItems;
    di.get<CartRepo>().streamCartItems.listen((items) {
      _cartItems = items;
      notifyListeners();
    });
    notifyListeners();
  }
  late List<CartItem> _cartItems;
  List<CartItem> get cartItems => _cartItems;
  // List<CartItem> get currentCartItems => _cartRepo.currentCartItems;

  Decimal get currentCartTotal => di.get<CartRepo>().currentCartTotal;

  CartItem cartItemForProduct(ProductItem item) {
    return di.get<CartRepo>().cartItemForProduct(item);
  }

  bool cartContainsProduct(ProductItem item) {
    return di.get<CartRepo>().cartContainsProduct(item);
  }

  void addToCart(ProductItem item,
      {ProductOption option = ProductOption.none}) {
    di.get<CartRepo>().addToCart(item, option: option);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    di.get<CartRepo>().updateQuantity(productId, quantity);
    notifyListeners();
  }

  void removeToCart(String productId) {
    di.get<CartRepo>().removeToCart(productId);
    notifyListeners();
  }
}
