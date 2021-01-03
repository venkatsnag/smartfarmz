import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../screens/edit_expense_screen.dart';
import '../providers/crop_sales.dart' as cropSales;
import '../screens/edit_sale_screen.dart';
import '../providers/crop_sales.dart';
import 'package:provider/provider.dart';

class SaleItem extends StatefulWidget {
  //final cropExp.CropExpenseItem cropExpense;
  final cropSales.SaleItemNew items;

  SaleItem(this.items);

  @override
  _SaleItemState createState() => _SaleItemState();
}

class _SaleItemState extends State<SaleItem> {
  var _exapanded = false;
  @override
  Widget build(BuildContext context) {
    final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
  
  final dynamic type = routes['type'];
    final saleId = widget.items.id;

  Future<void> _showConfirmationDialog(String message){
   return  showDialog(context: context, 
     builder: (ctx) => AlertDialog(
      title: Text('Crop sale will be deleted!'), 
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          onPressed: (){Navigator.of(ctx).pop();
            Provider.of<Sales>(context, listen: false).deleteSale(saleId);
          }, 
          child: Text('Okay'))
      ],
      ),
      );

  }
    Map<String, String> args = {'id': '$saleId', 'type':'$type'};
    return Card(margin: EdgeInsets.all(10),
    child: Column(children: <Widget>[
      ListTile(title: Text('${widget.items.soldTo}'),
      /* subtitle: Text(DateFormat('dd/mm/yyyy hh:mm').format(widget.items.dateTime),
      ), */

        subtitle: Row(
            children: <Widget>[Text(widget.items.saleAmount.toString()), 
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
      if(_exapanded)Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical:10 ),
        //height: min(widget.items.length * 20.00 + 100, 180),
        height: min(200, 180),
        child: ListView(
          
          children: <Widget>[
          Row(
            
            children: <Widget>[
              Text('SoldTo : '),
              Text(widget.items.soldTo),
            ],
          ),
          Row(
            children: <Widget>[
              Text('Buyer Name : '),
              Text(widget.items.sellerName),
            ],
          ),
           Row(
             children: <Widget>[
               Text('Total Weight : '),
               Text(widget.items.totalWeight.toString()),
             ],
           ),
          Row(
            children: <Widget>[
              Text('Sale Amount : '),
              Text(widget.items.saleAmount.toString()),
            ],
          ),
           Row(
            children: <Widget>[
              Text('Description : '),
              Text(widget.items.description),
            ],
          ),
           Row(
            children: <Widget>[
              Text('Payment Date : '),
               Text(DateFormat().format(widget.items.paymentDate),),
            ],
          ),

          
         
         
          Row(children: <Widget>[
            Text('Rs.'),
            Text(widget.items.saleAmount.toString(),)
          ],),
         Row(children: <Widget>[
           IconButton(icon: Icon(Icons.edit), onPressed: (){
           
           
          Navigator.of(context).pushNamed(EditSaleScreen.routeName, arguments: args);
            
          },),
          
          IconButton(icon: Icon(Icons.delete), onPressed: (){
           
           
        
             const  message = 'Are you sure you want to delete this Sale?';
          _showConfirmationDialog(message);
          },),
         ],)
        ],
        ),
      ),
      
                
        
    ],
    
    
      
    ),
    );
  }
}

