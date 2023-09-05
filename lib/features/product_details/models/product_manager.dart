import 'package:flutter_command/flutter_command.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/backend/product_repo.dart';
import 'package:wow_shopping/features/product_details/models/product_proxy.dart';

class ProductManager {
  late Command<void, List<ProductProxy>> updateProductsCommand;

  ProductManager() {
    updateProductsCommand = Command.createAsyncNoParam<List<ProductProxy>>(
      update,
      initialValue: [],
    );

    updateProductsCommand.execute();
  }

  Future<List<ProductProxy>> update() async {
    return di<ProductsRepo>().fetchTopSelling();
  }
}
