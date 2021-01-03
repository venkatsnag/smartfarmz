
import 'dart:async';

import 'package:flutter/material.dart';
import '../providers/crops.dart';

import 'package:provider/provider.dart';

import '../providers/crop_sales.dart';

class EditSaleScreen extends StatefulWidget {
  static const routeName = '/edit-sales';
  @override
  _EditSaleScreenState createState() => _EditSaleScreenState();
}


class _EditSaleScreenState extends State<EditSaleScreen> {


final _cropIdFocusNode = FocusNode();
  final _saleAmountFocusNode = FocusNode();
  final _sellerNameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _buyerFocusNode = FocusNode();
  final _soldToFocusNode = FocusNode();
  final _totalWeightFocusNode = FocusNode();
 
  final _form = GlobalKey<FormState>();

  
 var _editSale = SaleItemNew(
    id: '',
     cropId: '',
     orchId:'',
     type: '',
     units: '',
      saleAmount : 0,
      description: '',
      buyer: '',
      sellerName :'',
      soldTo :'',
      totalWeight :0,
      paymentDate: DateTime.now(),
    
    //seedingDate: DateTime.now(),
  );

      Map<String, String> _initValues = {
        'id' : '',
      'cropId':'',
      'orchId' : '',
      'soldTo' :'',
      'saleAmount' : '',
      'units' :'',
      'description': '',
      'buyer': '',
      'sellerName' :'',
      'totalWeight' :'',
            'paymentDate':''
      
     // 'seedingDate':'',
      

    };
    var _isInit = true;
    var _isLoading = false;

  List<String> _uom = ['Kgs', 'Tons', 'Quintals', 'Box']; // Option 2
   String _selectedUom; 

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
        return _editSale.paymentDate = picked;
    
        
      });

   //if(picked != null) setState(() => val = picked.toString());

}

  @override
  void didChangeDependencies() {

       if(_isInit){
         // final cropData = Provider.of<Crops>(context);
      //final expenseId = Provider.of<Expenses>(context);
      final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
  final dynamic saleId = routes['id'];
      
     
   if(saleId != null){
        _editSale = 
         Provider.of<Sales>(context, listen: false).findById(saleId); 
       
      _initValues = {
         'id':_editSale.id,
      'cropId': _editSale.cropId,
       'orchId': _editSale.orchId,
      'saleAmount' : _editSale.saleAmount.toString(),
      'totalWeight' : _editSale.totalWeight.toString(),
      'units' : _editSale.units,
      'description': _editSale.description,
      'buyer': _editSale.buyer,
      'sellerName' : _editSale.sellerName,
      'soldTo': _editSale.soldTo,
      'paymentDate': _editSale.paymentDate.toString(),
     
      
   
    };
    
      } 
     
    }
    _isInit = false;
    super.didChangeDependencies();
  }

@override
  void dispose() {
    _cropIdFocusNode.dispose();
    _soldToFocusNode.dispose();
    _saleAmountFocusNode.dispose();
    _sellerNameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _buyerFocusNode.dispose();
    _totalWeightFocusNode.dispose();
   
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
if(_editSale.id != null){
await Provider.of<Sales>(context, listen: false).updateSales(_editSale.id, _editSale);;
await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Sucessful"),
            content: Text(
                "You have sucessfully edited sale details."),
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
else{ 
  try{
await Provider.of<Sales>(context, listen: false)
.addSales(_editSale);
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
          
}
setState(() {
  _isLoading = false;
}); 
Navigator.of(context).pop();

}


  @override
  Widget build(BuildContext context) {

     final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
  
  dynamic cType = routes['type'];
    dynamic cropIdOrch;
    dynamic cropIdCrop;
  String id = routes['id'];
  
  
  if(cType == 'crops'){
cropIdCrop = _editSale.cropId;
cropIdOrch = null;
     } else{
      cropIdOrch = _editSale.orchId;
      cropIdCrop = null;
     }
     
    return Scaffold(appBar: AppBar(title: Text('Edit Crop Sales'),
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
        child: SingleChildScrollView(child: Column(children: <Widget>[

          Visibility(
              maintainState: true,
            visible: false, 
                      child: TextFormField(
            initialValue: _editSale.cropId,
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
                  soldTo: _editSale.soldTo,
                  saleAmount: _editSale.saleAmount,
                  description: _editSale.description, 
                  paymentDate: _editSale.paymentDate,
                  buyer: _editSale.buyer, 
                  sellerName: _editSale.sellerName,
                  totalWeight: _editSale.totalWeight,
                  type:   cType,
                  units: _editSale.units,
                 // seedingDate: _editExpense.seedingDate,
                  id: _editSale.id,
                  );
                _editSale = sale;
              },
            ),
          ),
Container(
             child:
        TextFormField(
          initialValue: _initValues['soldTo'],
          decoration: InputDecoration(labelText: 'Sold To'),
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
                soldTo: value,
                saleAmount: _editSale.saleAmount,
                description: _editSale.description, 
                paymentDate: _editSale.paymentDate,
                buyer: _editSale.buyer, 
                sellerName: _editSale.sellerName,
                totalWeight: _editSale.totalWeight,
                 units: _editSale.units,
               id: _editSale.id,
               type:   cType,
                );
              _editSale = sale;
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

Container(
             child:
          TextFormField(
            initialValue: _initValues['saleAmount'],
          decoration: InputDecoration(labelText: 'Sale Amount'),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          onFieldSubmitted: (_){ 
            FocusScope.of(context).requestFocus(_sellerNameFocusNode);},
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
                soldTo: _editSale.soldTo,
                saleAmount: double.parse(value),
                paymentDate: _editSale.paymentDate,
                buyer: _editSale.buyer, 
                description: _editSale.description, 
                sellerName: _editSale.sellerName,
                totalWeight: _editSale.totalWeight,
                 units: _editSale.units,
                type:   cType,
               // seedingDate: _editExpense.seedingDate,
                id: _editSale.id,
                );
              _editSale = sale;
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
Container(
             child:
          TextFormField(
            initialValue: _initValues['sellerName'],
          decoration: InputDecoration(labelText: 'Seller Name'),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.multiline,
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
                soldTo: _editSale.soldTo,
                saleAmount: _editSale.saleAmount,
                paymentDate: _editSale.paymentDate,
                buyer: _editSale.buyer, 
                sellerName: value,
                description: _editSale.description, 
                totalWeight: _editSale.totalWeight,
                 units: _editSale.units,
                type:   cType,
               // seedingDate: _editExpense.seedingDate,
                id: _editSale.id,
                );
              _editSale = sale;
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
Container(
             child:
          TextFormField(
            initialValue: _initValues['buyer'],
          decoration: InputDecoration(labelText: 'Buyer'),
          textInputAction: TextInputAction.next,
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
                soldTo: _editSale.soldTo,
                saleAmount: _editSale.saleAmount,
                paymentDate: _editSale.paymentDate,
                buyer: value, 
                sellerName: _editSale.sellerName,
                description: _editSale.description, 
                totalWeight: _editSale.totalWeight,
                 units: _editSale.units,
                type:   cType,
               // seedingDate: _editExpense.seedingDate,
                id: _editSale.id,
                );
              _editSale = sale;
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
     Container(
             child:     
          
           Row(
                         children: <Widget>[
                           Expanded(
                                                        child:TextFormField(
            initialValue: _initValues['totalWeight'],
          decoration: InputDecoration(labelText: 'Total Weight'),
          maxLines: 3,
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
                soldTo: _editSale.soldTo,
                saleAmount: _editSale.saleAmount,
                paymentDate: _editSale.paymentDate,
                buyer: _editSale.buyer, 
                sellerName: _editSale.sellerName,
                description: _editSale.description, 
                totalWeight: double.parse(value),
                 units: _editSale.units,
                type:   cType,
               // seedingDate: _editExpense.seedingDate,
                id: _editSale.id,
                );
              _editSale = sale;
            },
          ),
          ),

                           Expanded(child: Column(
                             children: <Widget>[
                               DropdownButton(
                                 
              hint: _editSale.units != null ? Text('${_editSale.units}') : Text('Please choose a UOM'), // Not necessary for Option 1
              value: _selectedUom,
              onChanged: (dynamic newValue) {
                setState(() {
                  _selectedUom = newValue;
                  return _editSale.units = _selectedUom;
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
            initialValue: _initValues['description'],
          decoration: InputDecoration(labelText: 'Description'),
          maxLines: 3,
          keyboardType: TextInputType.multiline,
          focusNode: _descriptionFocusNode,
          onSaved: (value){
               final sale = SaleItemNew( 
                cropId: cropIdCrop,
                     orchId: cropIdOrch,
                soldTo: _editSale.soldTo,
                saleAmount: _editSale.saleAmount,
                paymentDate: _editSale.paymentDate,
                buyer: _editSale.buyer, 
                sellerName: _editSale.sellerName,
                description: value, 
                totalWeight: _editSale.totalWeight,
                 units: _editSale.units,
                type:   cType,
               // seedingDate: _editExpense.seedingDate,
                id: _editSale.id,
                );
              _editSale = sale;
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
Container(
             child:
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Payment Date :' + "${_editSale.paymentDate.toLocal()}".split(' ')[0]),
            SizedBox(height: 20.0,),
            RaisedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select date'),
              
            ), ],
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
      ],)),
    ),
    ),
    
    );
  }
}


