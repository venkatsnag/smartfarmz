import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../screens/edit_expense_screen.dart';
import '../providers/cropExpenses.dart' as cropExp;
import '../providers/cropExpenses.dart';
import 'package:provider/provider.dart';

class CropExpenseItem extends StatefulWidget {
  //final cropExp.CropExpenseItem cropExpense;
  final cropExp.CropExpenseItemNew items;

  CropExpenseItem(this.items);

  @override
  _CropExpenseItemState createState() => _CropExpenseItemState();
}

class _CropExpenseItemState extends State<CropExpenseItem> {
  var _exapanded = false;
  @override
  Widget build(BuildContext context) {
    final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
  
  final dynamic type = routes['type'];
    final expenseId = widget.items.id;

  Future<void> _showConfirmationDialog(String message){
   return  showDialog(context: context, 
     builder: (ctx) => AlertDialog(
      title: Text('Crop expense will be deleted!'), 
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          onPressed: (){Navigator.of(ctx).pop();
          Provider.of<CropExpenses>(context, listen: false).deleteExpense(expenseId);
          }, 
          child: Text('Okay'))
      ],
      ),
      );

  }
    Map<String, String> args = {'id': '$expenseId', 'type':'$type'};
    
    return Card(margin: EdgeInsets.all(10),
    child: Column(children: <Widget>[
      ListTile(title: Text('${widget.items.expenseType}'),
      /* subtitle: Text(DateFormat('dd/mm/yyyy hh:mm').format(widget.items.dateTime),
      ), */

         subtitle: Row(
            children: <Widget>[Text(widget.items.amount.toString()), 
            Text('Rs'),
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
              Text('Expense Type : '),
              Text(widget.items.expenseType),
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
              Text('Payment Date : '),
              Text(DateFormat().format(widget.items.paymentDate),),
            ],
          ),

          Row(children: <Widget>[
            Text('Amount Paid : '),
            Text('Rs.'),
            Text(widget.items.amount.toString(),)
          ],),
          
        

          Row(children: <Widget>[
           IconButton(icon: Icon(Icons.edit), onPressed: (){
           
           
          Navigator.of(context).pushNamed(EditExpenseScreen.routeName, arguments: args);
            
          },),
          
          IconButton(icon: Icon(Icons.delete), onPressed: (){

               const  message = 'Are you sure you want to delete this expense?';
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

