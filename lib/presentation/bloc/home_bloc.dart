import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/cat_list_res.dart';
import '../../data/remote/http_service.dart';


part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent,HomeState>{
  HomeBloc():super(HomeInitialState()){
    on<LoadCatListEvent>(_onLoadCatList);
    on<UploadCatImageEvent>(_onUploadCatImage);
    on<PickImageFromGalleryEvent>(_onPickImageFromGallery);
    on<RefreshCatListEvent>(_onRefreshCatList);
  }

  List<CatListRes> cats = [];
  final _picker = ImagePicker();
  XFile? _image;
  int currentPage = 0;

  _loadCatListAndEmit(Emitter<HomeState> emit,{bool isRefresh=false})async{
    if(isRefresh){
      cats.clear();
      currentPage=0;
    }
    emit(HomeLoadingState());
    try{
      var response = await HttpService.GET(HttpService.API_CAT_GET,HttpService.paramsCatList(currentPage: currentPage));
      if(response!=null){
        var result = HttpService.parseCatList(response);
        cats.addAll(result);
        currentPage++;
        return emit(HomeSuccessState(cats: cats));
      }
    } catch(e){
      return emit(HomeErrorState(errorMessage: "Something went wrong $e"));
    }
  }

  // EVENT HANDLERs
  _onLoadCatList(LoadCatListEvent event,Emitter<HomeState>emit)async{
    await _loadCatListAndEmit(emit);
  }

  _onPickImageFromGallery(PickImageFromGalleryEvent event,Emitter<HomeState>emit)async{
    emit(HomeLoadingState());
    try{
      _image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if(_image!=null){
        await Future.delayed(Duration(seconds: 1));
        return emit(PickImageSuccessState(image: _image));
      }
    }catch(e){
      return emit(HomeErrorState(errorMessage: "Something went wrong $e"));
    }
  }

  _onUploadCatImage(UploadCatImageEvent event,Emitter<HomeState>emit)async{
    emit(HomeLoadingState());
    try{
      if(_image==null){
        return emit(HomeErrorState(errorMessage: "Please choose an Image"));
      }
      if(_image!=null){
        var imageFile = File(_image!.path);
        await HttpService.MUL(
            HttpService.API_CAT_UPLOAD,
            imageFile,HttpService.paramsEmpty()
        );
        return emit(UploadSuccessState());
      }
    }catch(e){
      return emit(HomeErrorState(errorMessage: "Something went wrong $e"));
    }
  }

  _onRefreshCatList(RefreshCatListEvent event,Emitter<HomeState>emit)async{
    await _loadCatListAndEmit(emit,isRefresh: true);
  }

}