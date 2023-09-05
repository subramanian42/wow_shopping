import 'package:wow_shopping/features/product_details/models/product_proxy.dart';

abstract class WishlistRepo {
  List<ProductProxy> get currentWishlistItems;
  Stream<List<ProductProxy>> get streamWishlistItems;

  bool isInWishlist(ProductProxy item);

  Stream<bool> streamIsInWishlist(ProductProxy item);

  void addToWishlist(String productId);

  void removeToWishlist(String productId);
}
