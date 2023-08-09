part of 'wishlist_page_bloc.dart';

final class WishlistPageState {
  final List<ProductItem> wishlistItems;
  final Set<String> selectedItems;
  WishlistPageState({
    this.wishlistItems = const <ProductItem>[],
    this.selectedItems = const <String>{},
  });

  WishlistPageState copyWith({
    List<ProductItem>? wishlistItems,
    Set<String>? selectedItems,
  }) {
    return WishlistPageState(
      wishlistItems: wishlistItems ?? this.wishlistItems,
      selectedItems: selectedItems ?? this.selectedItems,
    );
  }
}
