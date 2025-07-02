import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/models/cat_list_res.dart';




Widget itemOfCat(CatListRes cats){
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0,horizontal:  16.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: cats.url,
        imageBuilder: (context,imageProvider)=>Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit:BoxFit.cover,
              filterQuality: FilterQuality.low,
            ),
          ),
        ),
        placeholder: (context,url){
          return Container(
            height: 250,
            width: double.infinity,
            color: Colors.grey.shade300,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            ),
          );
        },
        errorWidget: (context,url,error)=>Icon(Icons.error),
        memCacheWidth: 300,
        memCacheHeight: 300,
      ),
    ),
  );
}