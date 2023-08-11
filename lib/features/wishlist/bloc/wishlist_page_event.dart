part of 'wishlist_page_bloc.dart';

@immutable
sealed class WishlistPageEvent {}

final class SetSelected extends WishlistPageEvent {
  final ProductItem item;
  final bool selected;
  SetSelected({required this.item, required this.selected});
}

final class ToggleSelectAll extends WishlistPageEvent {}

final class _UpdateWishlistItems extends WishlistPageEvent {
  final List<ProductItem> items;

  _UpdateWishlistItems(this.items);
}

final class DeleteSelected extends WishlistPageEvent {}
