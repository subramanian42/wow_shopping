import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/models/product_item.dart';

part 'wishlist_button_event.dart';
part 'wishlist_button_state.dart';

class WishlistButtonBloc
    extends Bloc<WishlistButtonEvent, WishlistButtonState> {
  WishlistButtonBloc(
      {required WishlistRepo wishlistRepo, required ProductItem item})
      : _wishlistRepo = wishlistRepo,
        _item = item,
        super(WishlistButtonState(
            isWishlisted: wishlistRepo.isInWishlist(item))) {
    on<TogglePressed>(_onTogglePressed);
    _wishlistSubscription = _wishlistRepo
        .streamIsInWishlist(item)
        .listen((value) => add(TogglePressed(value: value)));
  }
  late final StreamSubscription<bool> _wishlistSubscription;
  final ProductItem _item;
  final WishlistRepo _wishlistRepo;
  Future<void> _onTogglePressed(
    TogglePressed event,
    Emitter<WishlistButtonState> emit,
  ) async {
    if (event.value) {
      _wishlistRepo.addToWishlist(_item.id);
    } else {
      _wishlistRepo.removeToWishlist(_item.id);
    }
    emit(state.copyWith(event.value));
  }

  @override
  Future<void> close() {
    _wishlistSubscription.cancel();
    return super.close();
  }
}
