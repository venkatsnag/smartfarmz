import 'package:flutter/material.dart';
import '../providers/crop.dart';
import './crop_item.dart';
import 'package:provider/provider.dart';
import '../providers/crops.dart';

import 'dart:ui';


class CropsGrid extends StatelessWidget {


  

  final bool showFavs;

  CropsGrid(this.showFavs);
  
  final noCropText = Text('No Crops Registered! Register crop');


  @override
  Widget build(BuildContext context) {
    final cropsData = Provider.of<Crops>(context);
    final crops = showFavs ? cropsData.favortieItems : cropsData.items;
    if(cropsData == null){
      
      return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: crops.length,
      itemBuilder: (ctx, i) => 
         ChangeNotifierProvider.value(
           value: crops[i],
                    child: CropItem(
              crops[i].id, 
              crops[i].title, 
              crops[i].imageUrl,
           ),
         ),
         
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, 
        childAspectRatio: 3/2, 
        mainAxisSpacing: 10, 
        crossAxisSpacing: 10,
        ),
    );
    }
    else{
      return noCropText;
    }
     
         /*  return ListView.builder(
               primary: false,
               
              itemCount: crops.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(left: 15.0, top: 8.0, bottom: 16.0),
                  child: InkWell(
                    child: Container(
                      
                    width: 30,
                      height:30,
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            //borderRadius: widget.iconImageBorderRadius,
                            child:  ChangeNotifierProvider.value(
                              
           value: crops[index],
                    child: CropItem(
              crops[index].id, 
              crops[index].title, 
              crops[index].imageUrl,
           ),
         ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ); */
  }
}

