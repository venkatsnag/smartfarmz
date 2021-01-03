import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../screens/edit_harvest_screen.dart';
import '../providers/cropHarvest.dart' as cropHarv;
import '../providers/cropHarvest.dart';
import 'package:provider/provider.dart';

class CropHarvestItem extends StatefulWidget {
  //final cropExp.CropExpenseItem cropExpense;
  final cropHarv.CropHarvestItemNew items;

  CropHarvestItem(this.items);

  @override
  _CropHarvestItemState createState() => _CropHarvestItemState();
}

class _CropHarvestItemState extends State<CropHarvestItem> {
  var _exapanded = false;

  
  @override
  Widget build(BuildContext context) {



    final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
  
  final dynamic type = routes['type'];
    final harvestId = widget.items.id;

  Future<void> _showConfirmationDialog(String message){
   return  showDialog(context: context, 
     builder: (ctx) => AlertDialog(
      title: Text('Crop Harvest will be deleted!'), 
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          onPressed: (){Navigator.of(ctx).pop();
          Provider.of<CropHarvest>(context, listen: false).deleteHarvest(harvestId);
          }, 
          child: Text('Okay'))
      ],
      ),
      );

  }
    Map<String, String> args = {'id': '$harvestId', 'type':'$type'};
    
    return Card(margin: EdgeInsets.all(10),
    child: Column(children: <Widget>[
      ListTile(title: Text('${widget.items.description}'),
      /* subtitle: Text(DateFormat('dd/mm/yyyy hh:mm').format(widget.items.dateTime),
      ), */

         subtitle:   Row(
            children: <Widget>[
              Text(widget.items.totalOutput),
              Text(widget.items.units),
            ],
          ),
         
      
      
      trailing: IconButton(icon: Icon(_exapanded ? Icons.expand_less : Icons.expand_more),
      onPressed: (){
        setState(() {
          _exapanded = !_exapanded;
        });

      },),
      ),
      if(_exapanded) Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical:10 ),
        /* height: min(widget.items.length * 20.00 + 100, 180), */
        height: min(200, 180),
        child: ListView(children: <Widget>[
         
          Row(
            children: <Widget>[
              Text('Description : '),
              Expanded(child: Text(widget.items.description),)
              ,
            ],
          ),
           Row(
            children: <Widget>[
              Text('Total Output : '),
              Text(widget.items.totalOutput),
              
              Text(widget.items.units),
            ],
          ),          
          
          Row(
            children: <Widget>[
              Text('Supervisor Name : '),
              Text(widget.items.supervisorName),
            ],
          ),
          
          Row(
            children: <Widget>[
              Text('Total workers engaged : '),
              Text(widget.items.totalWorkers),
            ],
          ),

          Row(
            children: <Widget>[
              Text('Harvest Date : '),
              Text(DateFormat().format(widget.items.harvestDate),),
            ],
          ),

         
          
        

          Row(children: <Widget>[
           IconButton(icon: Icon(Icons.edit), onPressed: (){
           
           
          Navigator.of(context).pushNamed(EditHarvestScreen.routeName, arguments: args);
            
          },),
          
          IconButton(icon: Icon(Icons.delete), onPressed: (){
           
           const  message = 'Are you sure you want to delete Harvest?';
          _showConfirmationDialog(message);
          
            
          },),
         ],)
          
          
        ],
        ),
      )
                
        
    ],
    
    
      
    ),
    );
  }
}

