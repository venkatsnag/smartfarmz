
import 'dart:async';

import 'package:flutter/material.dart';
import '../providers/crops.dart';

import 'package:provider/provider.dart';

import '../providers/marketPrices2.dart';

class AddMarketPricesScreen extends StatefulWidget {
  
  static const routeName = '/add-market-prices';
  @override
  _AddMarketPricesScreenState createState() => _AddMarketPricesScreenState();
}


class _AddMarketPricesScreenState extends State<AddMarketPricesScreen> {


final _marketNameFocusNode = FocusNode();
  final _cropTitleFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _quantityFocusNode = FocusNode();
  final _unitFocusNode = FocusNode();
  
 
  final _form = GlobalKey<FormState>();

  
 var _addMarketPrices = MarketPriceItemNew(
    id: '',
     marketName: '',
    cropTitle: '',
      price : 0,
      quantity: 0,
      units :'',
      city:'',
      priceDate: DateTime.now(),
    

  );

      Map<String, String> _initValues = {
      'marketName':'',
      'cropTitle' : '',
      'price': '',
      'quantity' :'',
      'unit' :'',
      'id' : '',
      'city':'',
      'priceDate':''
     

    };
    var _isInit = true;
    var _isLoading = false;

// Unit of measurements
List<String> _uom = ['Kgs', 'Tons', 'Quintals']; // Option 2
   String _selectedUom; 

// Markets
List<String> _markets = ['Kothapet', 'Boinpally', 'Guntur']; // Option 2
String _selectedMarket; 
// crops
List<String> _cropTitles = ['Tomato', 'Brinjal', 'Watermelon']; // Option 2
String _selectedCropTitle; 

List<String> _city = ['Hyderabad', 'Vijayawada', 'Guntur']; // Option 2
String _selectedCity; 

DateTime selectedDate = new DateTime.now();
  Future _selectDate(BuildContext context) async {
  //final DateTime _date = DateTime.now();
  final _date = new DateTime.now();
  final DateTime picked = await showDatePicker(context: context, 
  
  initialDate: _date, 
  firstDate: DateTime(2020), 
  lastDate: DateTime(2999),);

if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
            print(selectedDate);
        return _addMarketPrices.priceDate = picked;
    
        
      });else{
return _addMarketPrices.priceDate = _date;
      }
      
      

   //if(picked != null) setState(() => val = picked.toString());

}

  @override
  void didChangeDependencies() {

       if(_isInit){
         
          
      //final expenseId = Provider.of<Expenses>(context);
     // final expenseId = ModalRoute.of(context).settings.arguments;
     
   /* if(expenseId != null){
        _addExpense = 
         Provider.of<CropExpenses>(context, listen: false).findById(expenseId); 
       
      _initValues = {
        'cropId': _addExpense.cropId,
      'amount' : _addExpense.amount.toString(),
      'description': _addExpense.description,
      'workerName' : _addExpense.workerName,
      'expenseType': _addExpense.expenseType,
      'id':_addExpense.id,
       // 'seedingDate': _editExpense.seedingDate.toIso8601String(),
   
    };
    
      }  */
     
    }
    _isInit = false;
    super.didChangeDependencies();
  }

@override
  void dispose() {



    _marketNameFocusNode.dispose();
    _cropTitleFocusNode.dispose();
    _priceFocusNode.dispose();
    _quantityFocusNode.dispose();
    _unitFocusNode.dispose();
    
   
    super.dispose();
  }

  Future<void> _saveForm() async {

    final isValid = _form.currentState.validate();
    if(!isValid){
      return;
    }

_form.currentState.save();
setState(() {
  _isLoading = true;
});
/* if(_editExpense.id != null){
await Provider.of<CropExpenses>(context, listen: false).updateExpense(_editExpense.id, _editExpense);;


}
else{  */
  try{
await Provider.of<MarketPrices2>(context, listen: false)
.addMarketPrice(_addMarketPrices);

  } catch(error)
  {
await showDialog<void>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("An Error Occured"),
                content: Text("Something went wrong."),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Okay"),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              ),
            ); 
          }
          

setState(() {
  _isLoading = false;
}); 
Navigator.of(context).pop();

}

  @override
  Widget build(BuildContext context) {
//Color method for text fields
    Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }
     //final farmId = ModalRoute.of<Farms>(context).settings.arguments as String;
     
     
    return Scaffold(appBar: AppBar(title: Text('Add Market Prices'),
    actions: <Widget>[
      IconButton(icon: Icon(Icons.save),
      onPressed: _saveForm,)
    ],
    
    ),
    
    body: _isLoading ? Center(child: CircularProgressIndicator(),
    ): Padding(
      padding: const EdgeInsets.all(20.0),
      
      child: Form(
        key: _form,
        child: SingleChildScrollView(child: Column(
          
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[

         /*  Visibility(
            maintainState: true,
            visible: false, 
                      child: TextFormField(
              
            initialValue: cropId,
            decoration: InputDecoration(labelText: 'cropId'),
            textInputAction: TextInputAction.next,
            enabled: false,
            readOnly: true,
            onFieldSubmitted: (_){ 
              FocusScope.of(context).requestFocus(_expenseTypeFocusNode);},
              onSaved: (value){
                final expense = CropExpenseItemNew( 
                  cropId: cropId,
                  expenseType: _addExpense.expenseType,
                  amount: _addExpense.amount,
                  description: _addExpense.description, 
                  workerName: _addExpense.workerName,
                paymentDate: _addExpense.paymentDate,
                  id: _addExpense.id,
                  type:   cType,
                  );
                _addExpense = expense;
                
              },
            ),
          ), */

//Choode Market
Container(
             child:
          Row(
                         children: <Widget>[ Expanded(child: Column(
                             children: <Widget>[
                               Row(children: <Widget>[
                                 Text('Market')
                               ],),
                               DropdownButton(
                                 
              hint: Text('Choose Market'), // Not necessary for Option 1
              value: _selectedMarket,
              onChanged: (dynamic newValue) {
                setState(() {
                  _selectedMarket = newValue;
                  return _addMarketPrices.marketName = _selectedMarket;
                });
              },
              items: _markets.map((marketName) {
                return DropdownMenuItem(
                  child: new Text(marketName),
                  value: marketName,
                );
              }).toList(),
            ),
                             ],
                           ),),
                           ],
                           ),
                                     decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.blue,
                      width: 1,
                    )),
                     padding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 1.0),
                      margin: EdgeInsets.all(10.0),
), 

Container(
             child:
          Row(
                         children: <Widget>[ Expanded(child: Column(
                             children: <Widget>[
                               Row(children: <Widget>[
                                 Text('City')
                               ],),
                               DropdownButton(
                                 
              hint: Text('Choose City'), // Not necessary for Option 1
              value: _selectedCity,
              onChanged: (dynamic newValue) {
                setState(() {
                  _selectedCity = newValue;
                  return _addMarketPrices.city = _selectedCity;
                });
              },
              items: _city.map((city) {
                return DropdownMenuItem(
                  child: new Text(city),
                  value: city,
                );
              }).toList(),
            ),
                             ],
                           ),),
                           ],
                           ),
                                     decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.blue,
                      width: 1,
                    )),
                     padding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 1.0),
                      margin: EdgeInsets.all(10.0),
), 

//Choode crop titile
Container(
             child: 
 Row(
                         children: <Widget>[
                           Expanded(child: Column(
                             children: <Widget>[
                               Row(children: <Widget>[
                                 Text('Commodity Name')
                               ],),
                               DropdownButton(
                                 
              hint: Text('Choose Commodity Name'), // Not necessary for Option 1
              value: _selectedCropTitle,
              onChanged: (dynamic newValue) {
                setState(() {
                  _selectedCropTitle = newValue;
                  return _addMarketPrices.cropTitle = _selectedCropTitle;
                });
              },
              items: _cropTitles.map((cropTitle) {
                return DropdownMenuItem(
                  child: new Text(cropTitle),
                  value: cropTitle,
                );
              }).toList(),
            ),
                             ],
                           ),),],
                           ),
                                     decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.blue,
                      width: 1,
                    )),
                     padding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 1.0),
                      margin: EdgeInsets.all(10.0),
), 

Container(
             child: 
       
          TextFormField(
            initialValue: _initValues['price'],
          decoration: InputDecoration(labelText: 'Current Price',
       /*    fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ), */
                        ),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          focusNode: _priceFocusNode,
          onFieldSubmitted: (_){ 
            FocusScope.of(context).requestFocus(_quantityFocusNode);},
              validator: (value){
              if(value.isEmpty){
                  return 'Please provide value';
              }
              else {
                return null;
              }
            },
               onSaved: (value){
              final marketPrice = MarketPriceItemNew( 
                marketName: _addMarketPrices.marketName,
                 cropTitle: _addMarketPrices.cropTitle,
                price: double.parse(value),
                 quantity: _addMarketPrices.quantity,
               units: _addMarketPrices.units,
               priceDate: _addMarketPrices.priceDate,
                 id: _addMarketPrices.id,
                 city: _addMarketPrices.city,
                
                );
                           _addMarketPrices = marketPrice;
                      
            },
          ),
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.blue,
                      width: 1,
                    )),
                     padding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 1.0),
                      margin: EdgeInsets.all(10.0),
), 

//Quantity
Container(
  //width: 352,
             child: 
          Row(
                         children: <Widget>[
                           Expanded(
                                                        child:
                                                        TextFormField(
            initialValue: _initValues['quantity'],
          decoration: InputDecoration(labelText: 'Per Quantity',
         /*  fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ), */
                        ),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          focusNode: _quantityFocusNode,
          onFieldSubmitted: (_){ 
            FocusScope.of(context).requestFocus(_unitFocusNode);},
              validator: (value){
              if(value.isEmpty){
                  return 'Please provide value';
              }
              else {
                return null;
              }
            },
               onSaved: (value){
              final marketPrice = MarketPriceItemNew( 
                marketName: _addMarketPrices.marketName,
                 cropTitle: _addMarketPrices.cropTitle,
                price: _addMarketPrices.price,
                 quantity: double.parse(value),
               units: _addMarketPrices.units,
               priceDate: _addMarketPrices.priceDate,
                 id: _addMarketPrices.id,
                 city: _addMarketPrices.city,
                
                );
                           _addMarketPrices = marketPrice;
                      
            },
          ),
          ),

                           Flexible(child: 
                               DropdownButton(
                                 
              hint: Text('Please choose a UOM'), // Not necessary for Option 1
              value: _selectedUom,
              isExpanded: true,
              onChanged: (dynamic newValue) {
                setState(() {
                  _selectedUom = newValue;
                  return _addMarketPrices.units = _selectedUom;
                });
              },
              items: _uom.map((units) {
                return DropdownMenuItem(
                  child: new Text(units),
                  value: units,
                );
              }).toList(),
            ),
                             )
                         ],
                       ),
                                 decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.blue,
                      width: 1,
                    )),
                     padding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 1.0),
                      margin: EdgeInsets.all(10.0),
), 

Container(
             child: 
           Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: <Widget>[
                
                Text('Price Date :' + "${selectedDate.toLocal()}".split(' ')[0]),
                 SizedBox(height: 20.0,),
            RaisedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select date'),
              
              
            ),
              ],
            ),
            decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.blue,
                      width: 1,
                    )),
                     padding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 1.0),
                      margin: EdgeInsets.all(10.0),
), 
           
         /*  Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
            Container(
              width: 100,
              height: 100,
              margin: EdgeInsets.only(top: 8, right: 10,),
              
              decoration: BoxDecoration(border: Border.all(width: 1,
               color: Colors.grey, ),
               ),
               child: _imageUrlController.text.isEmpty ? Text('Enter Image Url') : FittedBox(child: Image.network(_imageUrlController.text),
               fit: BoxFit.cover,),
            ),
            Expanded(
                          child: TextFormField(
                           
                decoration: InputDecoration(labelText: 'Image Url'),
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                controller: _imageUrlController,
                focusNode: _imageUrlFocusNode,
                onFieldSubmitted: (_){_saveForm();},
                 onSaved: (value){
              _editExpense = Expense( 
                title: _editExpense.title,
                price: _editExpense.price,
                description: _editExpense.description, 
                area: _editExpense.area,
                imageUrl: value,
                farmer: _editExpense.farmer,
                investor: _editExpense.investor,
                expenseMethod: _editExpense.expenseMethod,
               // seedingDate: _editExpense.seedingDate,
                id: _editExpense.id,
                isFavorite: _editExpense.isFavorite );
            },
                ),
            ),

          ],
          ), */
      ],
      ),
      

      ),
      
    ),
    ),
    
    );
  }
}


