
import 'dart:async';

import 'package:flutter/material.dart';
import '../providers/crops.dart';

import 'package:provider/provider.dart';

import '../providers/crop_sales.dart';
import 'package:intl/intl.dart';

class AddSaleScreen extends StatefulWidget {
  static const routeName = '/add-sales';
  @override
  _AddSaleScreenState createState() => _AddSaleScreenState();
}


class _AddSaleScreenState extends State<AddSaleScreen> {


final _cropIdFocusNode = FocusNode();
  final _saleAmountFocusNode = FocusNode();
  final _buyerNameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _buyerFocusNode = FocusNode();
  final _soldToFocusNode = FocusNode();
  final _totalWeightFocusNode = FocusNode();
  final _paymentDateFocusNode = FocusNode();
 
  final _form = GlobalKey<FormState>();

  
 var _addSale = SaleItemNew(
    id: '',
     cropId: '',
     orchId: '',
     type: '',
      saleAmount : 0,
      totalWeight : 0,
      units : '',
      description: '',
       buyer: '',
      sellerName :'',
      soldTo :'',
      paymentDate: DateTime.now(),
  );

      Map<String, String> _initValues = {
      'cropId':'',
      'orchId':'',
      'saleAmount' : '',
      'totalWeight' :'',
      'units' :'',
      'description': '',
      'buyer': '',
      'sellerName' :'',
      'soldTo' :'',
       'id' : '',
       'paymentDate':''
      
     // 'seedingDate':'',
      

    };
    var _isInit = true;
    var _isLoading = false;

// Unit of measurements
List<String> _uom = ['Kgs', 'Tons', 'Quintals', 'Box']; // Option 2
   String _selectedUom; 

   // Date
    
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
        return _addSale.paymentDate = picked;
    
        
      });

   //if(picked != null) setState(() => val = picked.toString());

}

  @override
  void didChangeDependencies() {

       if(_isInit){
         //final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
          
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
    _cropIdFocusNode.dispose();
    _soldToFocusNode.dispose();
    _saleAmountFocusNode.dispose();
    _buyerNameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _buyerFocusNode.dispose();
    _totalWeightFocusNode.dispose();
    _paymentDateFocusNode.dispose();
   
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
await Provider.of<Sales>(context, listen: false)
.addSales(_addSale);
await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Congratulations on Sale!!!"),
            content: Text(
                "You have sucessfully added Sale details. Its Time for celebration on sale of your product!!"),
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
     //final farmId = ModalRoute.of<Farms>(context).settings.arguments as String;
  final routes = ModalRoute.of(context).settings.arguments as Map<String, String>;
     dynamic cropIdOrch;
    dynamic cropIdCrop;
  String id = routes['id'];
  String cType = routes['type'];
  
  if(cType == 'crops'){
cropIdCrop = id;
cropIdOrch = null;
     } else{
      cropIdOrch = id;
      cropIdCrop = null;
     }
    return Scaffold(appBar: AppBar(title: Text('Add Crop Sales'),
    actions: <Widget>[
      IconButton(icon: Icon(Icons.save),
      onPressed: _saveForm,)
    ],
    
    ),
    
    body: _isLoading ? Center(child: CircularProgressIndicator(),
    ): Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        
        key: _form,
        child: SingleChildScrollView(child: Column(
          
          children: <Widget>[

          Visibility(
             maintainState: true,
            visible: false, 
                      child: TextFormField(
            initialValue: _initValues['cropId'],
            
            decoration: InputDecoration(labelText: 'cropId'),
            textInputAction: TextInputAction.next,
            enabled: false,
            readOnly: true,
            onFieldSubmitted: (_){ 
              FocusScope.of(context).requestFocus(_soldToFocusNode);},
              onSaved: (value){
                final sale = SaleItemNew( 
                  cropId: cropIdCrop,
                     orchId: cropIdOrch,
                  soldTo: _addSale.soldTo,
                  saleAmount: _addSale.saleAmount,
                  description: _addSale.description, 
                  buyer: _addSale.buyer,
                  sellerName: _addSale.sellerName,
                  totalWeight: _addSale.totalWeight,
                  paymentDate: _addSale.paymentDate,
                  units:   _addSale.units,
                  type:   cType,
                 // seedingDate: _editExpense.seedingDate,
                  id: _addSale.id,
                  );
                _addSale = sale;
              },
            ),
          ),

          Visibility(
            maintainState: true,
            visible: false, 
                      child: TextFormField(

             
            initialValue: _initValues['orchId'],
            decoration: InputDecoration(labelText: 'orchId'),
            textInputAction: TextInputAction.next,
            enabled: false,
            readOnly: true,
            onFieldSubmitted: (_){ 
              FocusScope.of(context).requestFocus(_soldToFocusNode);},
              onSaved: (value){
                final sale = SaleItemNew( 

                  
                    cropId: cropIdCrop,
                     orchId: cropIdOrch,
                  soldTo: _addSale.soldTo,
                  saleAmount: _addSale.saleAmount,
                  description: _addSale.description, 
                  buyer: _addSale.buyer,
                  sellerName: _addSale.sellerName,
                  totalWeight: _addSale.totalWeight,
                  paymentDate: _addSale.paymentDate,
                  units:   _addSale.units,
                  type:   cType,
                  id: _addSale.id,
                  );
                _addSale = sale;
                
              },
            ),
          ), 

        TextFormField(
          initialValue: _initValues['soldTo'],
          decoration: InputDecoration(labelText: 'Sold To',
          fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ),
                        ),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_){ 
            FocusScope.of(context).requestFocus(_buyerFocusNode);},
            validator: (value){
              if(value.isEmpty){
                  return 'Please provide value';
              }
              else {
                return null;
              }
            },
            onSaved: (value){
             final sale = SaleItemNew( 
                 cropId: cropIdCrop,
                     orchId: cropIdOrch,
                soldTo: value,
                saleAmount: _addSale.saleAmount,
                description: _addSale.description, 
                buyer: _addSale.buyer,
                sellerName: _addSale.sellerName,
                totalWeight: _addSale.totalWeight,
                paymentDate: _addSale.paymentDate,
                units:   _addSale.units,
                type:   cType,
               // seedingDate: _editExpense.seedingDate,
                id: _addSale.id,
                );
              _addSale = sale;
            },
          ),

          TextFormField(
          initialValue: _initValues['buyer'],
          decoration: InputDecoration(labelText: 'Buyer',
          fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ),
                        ),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_){ 
            FocusScope.of(context).requestFocus(_saleAmountFocusNode);},
            validator: (value){
              if(value.isEmpty){
                  return 'Please provide value';
              }
              else {
                return null;
              }
            },
            onSaved: (value){
             final sale = SaleItemNew( 
                 cropId: cropIdCrop,
                     orchId: cropIdOrch,
                soldTo: _addSale.soldTo,
                saleAmount: _addSale.saleAmount,
                description: _addSale.description, 
                buyer: value, 
                sellerName: _addSale.sellerName,
                totalWeight: _addSale.totalWeight,
                paymentDate: _addSale.paymentDate,
               units:   _addSale.units,
               type:   cType,
               // seedingDate: _editExpense.seedingDate,
                id: _addSale.id,
                );
              _addSale = sale;
            },
          ),

          TextFormField(
            initialValue: _initValues['saleAmount'],
          decoration: InputDecoration(labelText: 'Sale Amount',
          fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ),
                        ),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          onFieldSubmitted: (_){ 
            FocusScope.of(context).requestFocus(_buyerNameFocusNode);},
              validator: (value){
              if(value.isEmpty){
                  return 'Please provide value';
              }
              else {
                return null;
              }
            },
               onSaved: (value){
              final sale = SaleItemNew( 
                 cropId: cropIdCrop,
                     orchId: cropIdOrch,
                soldTo: _addSale.soldTo,
                buyer: _addSale.buyer,
                saleAmount: double.parse(value),
                description: _addSale.description, 
                sellerName: _addSale.sellerName,
                totalWeight: _addSale.totalWeight,
                units:   _addSale.units,
                paymentDate: _addSale.paymentDate,
                type:   cType,
               // seedingDate: _editExpense.seedingDate,
                id: _addSale.id,
                );
              _addSale = sale;
            },
          ),
         TextFormField(
            initialValue: _initValues['sellerName'],
          decoration: InputDecoration(labelText: 'Seller Name',
          fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ),
                        ),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.multiline,
          onFieldSubmitted: (_){ 
            FocusScope.of(context).requestFocus(_totalWeightFocusNode);},
              validator: (value){
              if(value.isEmpty){
                  return 'Please provide value';
              }
              else {
                return null;
              }
            },
               onSaved: (value){
              final sale = SaleItemNew( 
                 cropId: cropIdCrop,
                     orchId: cropIdOrch,
                soldTo: _addSale.soldTo,
                buyer: _addSale.buyer,
                saleAmount: _addSale.saleAmount,
                description: _addSale.description, 
                sellerName: value,
                totalWeight: _addSale.totalWeight,
               units:   _addSale.units,
                paymentDate: _addSale.paymentDate,
                type:   cType,
               // seedingDate: _editExpense.seedingDate,
                id: _addSale.id,
                );
              _addSale = sale;
            },
          ),
          
        
                  
                       Row(
                         children: <Widget>[
                           Expanded(
                                                        child: TextFormField(
                              initialValue: _initValues['totalWeight'],
          decoration: InputDecoration(labelText: 'Total Weight',
          
          fillColor: Colors.white,
                                          border: new OutlineInputBorder(
                                            borderRadius: new BorderRadius.circular(5.0),
                                            borderSide: new BorderSide(
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                          ),
                   keyboardType: TextInputType.number,
                             onFieldSubmitted: (_){ 
                              FocusScope.of(context).requestFocus(_descriptionFocusNode);},
                                validator: (value){
                                if(value.isEmpty){
                                    return 'Please provide value';
                                }
                                else {
                                  return null;
                                }
                              },
          onSaved: (value){
                                 final sale = SaleItemNew( 
                                   cropId: cropIdCrop,
                     orchId: cropIdOrch,
                                  soldTo: _addSale.soldTo,
                                  buyer: _addSale.buyer,
                                  saleAmount: _addSale.saleAmount,
                                  sellerName: _addSale.sellerName,
                                  description: _addSale.description, 
                                  totalWeight: double.parse(value),
                                  paymentDate: _addSale.paymentDate,
                                 units:   _addSale.units,
                                 type:   cType,
                                 // seedingDate: _editExpense.seedingDate,
                                  id: _addSale.id,
                                  );
                                _addSale = sale;
                              },
          ),
                           ),

                           Expanded(child: Column(
                             children: <Widget>[
                               DropdownButton(
                                 
              hint: Text('Please choose a UOM'), // Not necessary for Option 1
              value: _selectedUom,
              onChanged: (dynamic newValue) {
                setState(() {
                  _selectedUom = newValue;
                  return _addSale.units = _selectedUom;
                });
              },
              items: _uom.map((units) {
                return DropdownMenuItem(
                  child: new Text(units),
                  value: units,
                );
              }).toList(),
            ),
                             ],
                           ),)
                         ],
                       ),
                     
          
                 
         
         
          TextFormField(
            initialValue: _initValues['description'],
          decoration: InputDecoration(labelText: 'Description',
          fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ),
                        ),
          maxLines: 3,
          keyboardType: TextInputType.multiline,
          onFieldSubmitted: (_){ 
            FocusScope.of(context).requestFocus(_descriptionFocusNode);},
          onSaved: (value){
               final sale = SaleItemNew( 
                 cropId: cropIdCrop,
                     orchId: cropIdOrch,
                soldTo: _addSale.soldTo,
                buyer: _addSale.buyer,
                saleAmount: _addSale.saleAmount,
                sellerName: _addSale.sellerName,
                description: value, 
                totalWeight: _addSale.totalWeight,
                units:   _addSale.units,
                paymentDate: _addSale.paymentDate,
                type:   cType,

               // seedingDate: _editExpense.seedingDate,
                id: _addSale.id,
                );
              _addSale = sale;
            },
          ),
          /* TextFormField(
            initialValue: _initValues['paymentDate'],
          decoration: InputDecoration(labelText: 'Payment Date'),
          maxLines: 3,
          keyboardType: TextInputType.multiline,
          focusNode: _paymentDateFocusNode,
          onSaved: (value){
               final sale = SaleItemNew( 
                cropId: _addSale.cropId,
                soldTo: _addSale.soldTo,
                saleAmount: _addSale.saleAmount,
                buyerName: _addSale.buyerName,
                description: _addSale.description, 
                totalWeight: _addSale.totalWeight,
                paymentDate: selectedDate,
               // seedingDate: _editExpense.seedingDate,
                id: _addSale.id,
                );
              _addSale = sale;
              
            },), */
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: <Widget>[
                
                Text('Payment Date :' + "${selectedDate.toLocal()}".split(' ')[0]),
              ],
            ),
            SizedBox(height: 20.0,),
            RaisedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select date'),
              
              
            ),
          /* InkWell(
        onTap: () {
          _selectDate(context);   // Call Function that has showDatePicker()
        },
        child: IgnorePointer(
          child: new TextFormField(
            initialValue: _initValues['paymentDate'],
            decoration: new InputDecoration(hintText: 'Payment Date'),
            maxLength: 10,
            focusNode: _paymentDateFocusNode,
            // validator: validateDob,
            onSaved: (String val) {
              final sale = SaleItemNew( 
                cropId: _addSale.cropId,
                soldTo: _addSale.soldTo,
                saleAmount: _addSale.saleAmount,
                buyerName: _addSale.buyerName,
                description: _addSale.description, 
                totalWeight: _addSale.totalWeight,
               paymentDate: DateTime.parse(val),
                id: _addSale.id,
                );
              _addSale = sale;
            
            },
          ),
        ), */

        
      
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

          
        
      ],)),
    ),
    ),
    
    );
  }
}


