

part of 'home_bloc.dart';

@immutable
abstract class HomeState{}
final class HomeInitialState extends HomeState{}
final class HomeLoadingState extends HomeState{}
final class HomeSuccessState extends HomeState{
  final List<CatListRes> cats;
  HomeSuccessState({
    required this.cats,
  });
}

final class HomeErrorState extends HomeState{
  final String errorMessage;
  HomeErrorState({
    required this.errorMessage
  });
}

final class PickImageSuccessState extends HomeState{
  final XFile? image;
  PickImageSuccessState({
    required this.image
  });
}

final class UploadSuccessState extends HomeState{}
