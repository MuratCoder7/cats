import 'package:cats/presentation/pages/upload_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/cat_list_res.dart';
import '../bloc/home_bloc.dart';
import '../widgets/item_of_cat.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeBloc homeBloc;
  ScrollController scrollController = ScrollController();

  _callUploadPage()async{
    var result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context){
          return UploadPage();
        })
    );

    if(result==true){
      homeBloc.add(RefreshCatListEvent());
    }
  }

  @override
  void initState(){
    super.initState();
    homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc.add(LoadCatListEvent());
    scrollController.addListener((){
      if(scrollController.position.maxScrollExtent<=scrollController.offset){
        homeBloc.add(LoadCatListEvent());
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:BlocConsumer<HomeBloc,HomeState>(
        listener: (context,state){},
        buildWhen: (previous,current){
          return current is HomeSuccessState;
        },
        builder:(context,state){
          if(state is HomeErrorState){
            return viewOfError(state.errorMessage);
          }else if (state is HomeSuccessState){
            var cats = state.cats;
            if(cats.isEmpty){
              return Center(
                child: Text("No Images "),
              );
            }
            return viewOfCatList(cats);
          }
          return viewOfLoading();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _callUploadPage();
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget viewOfError(String error){
    return Center(
      child: Text(error),
    );
  }

  Widget viewOfLoading(){
    return Center(
      child: CircularProgressIndicator(
        color: Colors.blue,
      ),
    );
  }

  Widget viewOfCatList(List<CatListRes> cats){
    return RefreshIndicator(
      onRefresh: ()async{
        homeBloc.add(RefreshCatListEvent());
      },
      child: ListView.builder(
        controller: scrollController,
        itemCount: cats.length,
        itemBuilder: (context,index){
          return itemOfCat(cats[index]);
        },
      ),
    );
  }
}
