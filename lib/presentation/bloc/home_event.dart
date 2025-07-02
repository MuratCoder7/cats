


part of 'home_bloc.dart';

@immutable
abstract class HomeEvent{}

final class LoadCatListEvent extends HomeEvent{}

final class UploadCatImageEvent extends HomeEvent{}
final class PickImageFromGalleryEvent extends HomeEvent{}
final class RefreshCatListEvent extends HomeEvent{}

