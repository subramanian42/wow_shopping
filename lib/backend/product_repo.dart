import 'package:wow_shopping/features/product_details/models/product_proxy.dart';

abstract class ProductsRepo {
  List<ProductProxy> get cachedItems;

  Future<List<ProductProxy>> fetchTopSelling();

  /// Find product from the top level products cache
  ///
  /// [id] for the product to fetch.
  ProductProxy findProduct(String id);
}
