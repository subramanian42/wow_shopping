import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wow_shopping/backend/wishlist_repo.dart';
import 'package:wow_shopping/models/product_item.dart';

part 'wishlist_page_event.dart';
part 'wishlist_page_state.dart';

class WishlistPageBloc extends Bloc<WishlistPageEvent, WishlistPageState> {
  WishlistPageBloc(WishlistRepo wishlistRepo)
      : _wishlistRepo = wishlistRepo,
        super(WishlistPageState()) {
    on<SetSelected>(_onSetSelected);
    on<ToggleSelectAll>(_onToggleSelectAll);
    on<DeleteSelected>(_onDeleteSelected);
    on<_UpdateWishlistItems>(_onUpdateWishlistItems);
    _productItemsSubscription = _wishlistRepo.streamWishlistItems.listen(
      (items) => add(
        _UpdateWishlistItems(items),
      ),
    );
  }
  late final StreamSubscription<List<ProductItem>> _productItemsSubscription;
  final WishlistRepo _wishlistRepo;

  void _onSetSelected(
    SetSelected event,
    Emitter<WishlistPageState> emit,
  ) async {
    if (event.selected) {
      emit(
        state.copyWith(
          selectedItems: //
              Set.from(state.selectedItems)..add(event.item.id),
        ),
      );
    } else {
      emit(
        state.copyWith(
          selectedItems: //
              Set.from(state.selectedItems)..remove(event.item.id),
        ),
      );
    }
  }

  void _onToggleSelectAll(
    ToggleSelectAll event,
    Emitter<WishlistPageState> emit,
  ) async {
    final allIds = state.wishlistItems.map((el) => el.id).toList();

    if (state.selectedItems.containsAll(allIds)) {
      emit(
        state.copyWith(
          selectedItems: {},
        ),
      );
    } else {
      emit(
        state.copyWith(
          selectedItems: Set.from(allIds),
        ),
      );
    }
  }

  void _onDeleteSelected(
    DeleteSelected event,
    Emitter<WishlistPageState> emit,
  ) async {
    for (final selected in state.selectedItems) {
      _wishlistRepo.removeToWishlist(selected);
    }
    emit(
      state.copyWith(
        selectedItems: {},
      ),
    );
  }

  void _onUpdateWishlistItems(
    _UpdateWishlistItems event,
    Emitter<WishlistPageState> emit,
  ) async {
    emit(state.copyWith(wishlistItems: event.items));
  }

  bool isSelected(ProductItem item) {
    return state.selectedItems.contains(item.id);
  }

  @override
  Future<void> close() {
    _productItemsSubscription.cancel();
    return super.close();
  }
}
