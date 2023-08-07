part of 'wishlist_button_bloc.dart';

@immutable
sealed class WishlistButtonEvent {}

final class TogglePressed extends WishlistButtonEvent {
  final bool value;

  TogglePressed({required this.value});
}

final class WishlistToggleStarted extends WishlistButtonEvent {}
