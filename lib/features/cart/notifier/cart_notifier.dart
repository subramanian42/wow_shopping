import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:wow_shopping/backend/cart_repo.dart';
import 'package:wow_shopping/models/cart_item.dart';
import 'package:wow_shopping/models/product_item.dart';

class CartNotifier extends ChangeNotifier {
  final CartRepo _cartRepo;

  CartNotifier(this._cartRepo) {
    _cartItems = _cartRepo.currentCartItems;
    _cartRepo.streamCartItems.listen((items) {
      _cartItems = items;
      notifyListeners();
    });
    notifyListeners();
  }
  late List<CartItem> _cartItems;
  List<CartItem> get cartItems => _cartItems;
  // List<CartItem> get currentCartItems => _cartRepo.currentCartItems;

  Decimal get currentCartTotal => _cartRepo.currentCartTotal;

  CartItem cartItemForProduct(ProductItem item) {
    return _cartRepo.cartItemForProduct(item);
  }

  bool cartContainsProduct(ProductItem item) {
    return _cartRepo.cartContainsProduct(item);
  }

  void addToCart(ProductItem item,
      {ProductOption option = ProductOption.none}) {
    _cartRepo.addToCart(item, option: option);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    _cartRepo.updateQuantity(productId, quantity);
    notifyListeners();
  }

  void removeToCart(String productId) {
    _cartRepo.removeToCart(productId);
    notifyListeners();
  }
}
