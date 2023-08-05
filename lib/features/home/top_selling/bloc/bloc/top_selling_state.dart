part of 'top_selling_bloc.dart';

@immutable
sealed class TopSellingState {}

final class TopSellingInitial extends TopSellingState {}

final class TopSellingLoading extends TopSellingState {}

final class TopSellingLoaded extends TopSellingState {
  final List<ProductItem> items;

  TopSellingLoaded({required this.items});
}

final class TopSellingFailure extends TopSellingState {}
