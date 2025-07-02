import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/home_bloc.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  _goBack(){
    Navigator.of(context).pop(true);
  }


  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 300,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: BlocConsumer<HomeBloc,HomeState>(
              listener: (context,state)async{
                if(state is UploadSuccessState){
                  await Future.delayed(Duration(seconds: 4));
                  _goBack();
                }
              },
              builder: (context,state){
                if(state is HomeErrorState){
                  return viewOfError(state.errorMessage);
                }else if(state is PickImageSuccessState){
                  var image = state.image;
                  return viewOfPickedImage(image);
                }else if(state is HomeLoadingState){
                  return viewOfLoading();
                }else if(state is UploadSuccessState){
                  return viewOfSuccess();
                }
                return Center(
                  child: Text("No Image Selected"),
                );
              },
            ),
          ),
          SizedBox(height:50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: (){
                  context.read<HomeBloc>().add(PickImageFromGalleryEvent());
                },
                color:Colors.green,
                textColor: Colors.white,
                child: Text("Pick Image"),
              ),
              SizedBox(width:10),
              BlocBuilder<HomeBloc,HomeState>(
                  builder:(context,state){
                    return MaterialButton(
                      onPressed: state is HomeLoadingState ? (){}:(){
                        context.read<HomeBloc>().add(UploadCatImageEvent());
                      },
                      textColor: Colors.white,
                      color: Colors.blue,
                      child:Text("Upload an Image"),
                    );
                  }
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget viewOfLoading(){
    return Center(
      child: CircularProgressIndicator.adaptive(
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget viewOfError(String errorMessage){
    return Center(
      child: Text(errorMessage),
    );
  }

  Widget viewOfPickedImage(XFile? image){
    return Image.file(
      File(image!.path),
      fit:BoxFit.cover,
    );
  }

  Widget viewOfSuccess(){
    return Center(
      child: Icon(
          Icons.check,
          color: Colors.green,
          size:38
      ),
    );
  }
}
