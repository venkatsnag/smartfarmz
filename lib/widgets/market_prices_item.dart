import 'package:flutter/material.dart';

import 'dart:math';
import '../screens/crop_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/marketPrices2.dart' as marketPrices;

import '../providers/auth.dart';


class MarketPriceItem extends StatefulWidget {
  //final cropExp.CropExpenseItem cropExpense;
  final marketPrices.MarketPriceItemNew items;

  MarketPriceItem(this.items);

  @override
  _MarketPriceItemState createState() => _MarketPriceItemState();
}

class _MarketPriceItemState extends State<MarketPriceItem> {
  var _exapanded = false;
  @override
  Widget build(BuildContext context) {
  
    return Card(margin: EdgeInsets.all(10),
    child: Column(children: <Widget>[
      ListTile(title: Text('${widget.items.marketName}'),
      /* subtitle: Text(DateFormat('dd/mm/yyyy hh:mm').format(widget.items.dateTime),
      ), */

         subtitle: Text(widget.items.cropTitle), 
      
      
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
              Text('Market : '),
              Text(widget.items.marketName),
            ],
          ),
          Row(
            children: <Widget>[
              Text('Commodity Name : '),
              Text(widget.items.cropTitle),
            ],
          ),
           Row(
             children: <Widget>[
               Text('Rs.'),
               Text('Price : '),
               Text(widget.items.price.toString()),
             ],
           ),
          Row(
            children: <Widget>[
              Text('Per Quantity : '),
              Text(widget.items.quantity.toString()),
              Text(widget.items.units),
            ],
          ),
          
          //Text(DateFormat().format(widget.items.priceDate),),
         
          
         
          IconButton(icon: Icon(Icons.edit), onPressed: (){
           
           
          //Navigator.of(context).pushNamed(EditSaleScreen.routeName, arguments: {'id':saleId, 'type':type});
            
          },)
          
          
        ],
        ),
      ),
      
                
        
    ],
    
    
      
    ),
    );
  }
}



