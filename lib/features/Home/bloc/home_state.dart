part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeSuccess extends HomeState {
  final HomeModel homeData;

  HomeSuccess({required this.homeData});
}

final class HomeError extends HomeState {}
