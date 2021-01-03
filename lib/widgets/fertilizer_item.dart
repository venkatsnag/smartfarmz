import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../screens/edit_expense_screen.dart';
import '../providers/fertilizers.dart' as cropFerti;
import '../screens/edit_pesticides_screen.dart';
import 'package:provider/provider.dart';
import '../providers/fertilizers.dart';

class FertiPestiItem extends StatefulWidget {
  //final cropExp.CropExpenseItem cropExpense;
  final cropFerti.FertiPestiItemNew items;

  FertiPestiItem(this.items);

  @override
  _FertiPestiItemState createState() => _FertiPestiItemState();
}

class _FertiPestiItemState extends State<FertiPestiItem> {
  var _exapanded = false;
  @override
  Widget build(BuildContext context) {
    final fertilizerId = widget.items.id;
    
    Future<void> _showConfirmationDialog(String message){
   return  showDialog(context: context, 
     builder: (ctx) => AlertDialog(
      title: Text('Fertilizer/Pesticide will be deleted!'), 
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          onPressed: (){Navigator.of(ctx).pop();
            Provider.of<FertiPestis>(context, listen: false).deleteFertilizer(fertilizerId);
          }, 
          child: Text('Okay'))
      ],
      ),
      );

  }
    
    final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
  
  final dynamic type = routes['type'];
  Map<String, String> args = {'id': '$fertilizerId', 'type':'$type'};
    return Card(margin: EdgeInsets.all(10),
    child: Column(children: <Widget>[
      ListTile(title: Text('${widget.items.type}'),
      /* subtitle: Text(DateFormat('dd/mm/yyyy hh:mm').format(widget.items.dateTime),
      ), */

         subtitle: Text(widget.items.description), 
      
      
      trailing: IconButton(icon: Icon(_exapanded ? Icons.expand_less : Icons.expand_more),
      onPressed: (){
        setState(() {
          _exapanded = !_exapanded;
        });

      },),
      ),
      if(_exapanded) Container(
        
        padding: EdgeInsets.symmetric(horizontal: 15, vertical:20 ),
        //height: min(widget.items.length * 20.00 + 100, 180),
        height: min(200, 180),
        width: MediaQuery.of(context).size.width,
        child: ListView(children: <Widget>[
          Row(
            children: <Widget>[
              Text('Fetilizer/Pesticide : '),
              Text(widget.items.type),
            ],
          ),
          Wrap(
            children: <Widget>[
              Text('Description : '),
              
              Text(widget.items.description),
            ],
          ),
          
          Row(
            children: <Widget>[
              Text('Worker Name : '),
              Text(widget.items.workerName),
            ],
          ),
          Row(
            children: <Widget>[
              Text('Brand : '),
              Text(widget.items.brand),
            ],
          ),
          
          Row(
            children: <Widget>[
              Text('Spray Date : '),
              Text(DateFormat().format(widget.items.date),),
            ],
          ),
          /* Row(children: <Widget>[
            Text('Rs.'),
            Text(widget.items.amount.toString(),)
          ],), */
        

           Row(children: <Widget>[
           IconButton(icon: Icon(Icons.edit), onPressed: (){
           
           
          Navigator.of(context).pushNamed(EditFertiPestiScreen.routeName, arguments: args);
            
          },),
          
          IconButton(icon: Icon(Icons.delete), onPressed: (){
           
           
           const  message = 'Are you sure you want to delete this entry?';
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

