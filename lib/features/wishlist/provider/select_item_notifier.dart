import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/backend/wishlist_repo.dart';
import 'package:wow_shopping/models/product_item.dart';

final selectItemsState = NotifierProvider<SelectItemsNotifier, Set<String>>(
    () => SelectItemsNotifier());

// Helps us notify whenever there're changes in the holded value
class SelectItemsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    return {};
  }

  bool isSelected(ProductItem item) {
    //return _selectedItems.contains(item.id);
    return false;
  }

  void setSelected(ProductItem item, bool selected) {
    final selectedItems = {...state};
    if (selected) {
      selectedItems.add(item.id);
    } else {
      selectedItems.remove(item.id);
    }
    state = selectedItems;
  }

  void toggleSelectAll() {
    final wishlistItems = ref.read(wishlistRepoProvider).currentWishlistItems;
    final allIds = wishlistItems.map((el) => el.id).toList();
    final selectedItems = {...state};
    if (selectedItems.containsAll(allIds)) {
      selectedItems.clear();
    } else {
      selectedItems.addAll(allIds);
    }
    state = selectedItems;
  }

  void removeSelected() {
    final selectedItems = {...state};
    final wishlistRepo = ref.read(wishlistRepoProvider);
    for (final selected in selectedItems) {
      wishlistRepo.removeToWishlist(selected);
    }
    state = {};
  }
}
