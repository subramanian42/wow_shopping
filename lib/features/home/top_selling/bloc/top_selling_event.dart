part of 'top_selling_bloc.dart';

@immutable
abstract class TopSellingEvent {}

final class TopSellingFetchRequested extends TopSellingEvent {}
