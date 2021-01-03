
import 'dart:async';

import 'package:flutter/material.dart';
import '../providers/crops.dart';
import 'package:provider/provider.dart';
import '../providers/cropExpenses.dart';

class EditExpenseScreen extends StatefulWidget {
  static const routeName = '/edit-expenses';
  @override
  _EditExpenseScreenState createState() => _EditExpenseScreenState();
}


class _EditExpenseScreenState extends State<EditExpenseScreen> {


final _cropIdFocusNode = FocusNode();
  final _amountFocusNode = FocusNode();
  final _workerNameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _expenseTypeFocusNode = FocusNode();
 
  final _form = GlobalKey<FormState>();

  
 var _editExpense = CropExpenseItemNew(
    id: '',
     cropId: '',
     orchId:'',
     landId:'',
     type: '',
      amount : 0,
      description: '',
      workerName :'',
      expenseType :'',
       paymentDate: DateTime.now(),
    
    //seedingDate: DateTime.now(),
  );

      Map<String, String> _initValues = {
      'cropId':'',
      'amount' : '',
      'orchId' : '',
      'landId' : '',
      'description': '',
      'workerName' :'',
      'expenseType' :'',
      'id' : '',
     'paymentDate':''
      

    };
    var _isInit = true;
    var _isLoading = false;

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
        return _editExpense.paymentDate = picked;
    
        
      });

   //if(picked != null) setState(() => val = picked.toString());

}

  @override
  void didChangeDependencies() {

       if(_isInit){
         // final cropData = Provider.of<Crops>(context);
      //final expenseId = Provider.of<Expenses>(context);
      
       final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
  final dynamic expenseId = routes['id'];
  
     
   if(expenseId != null){
        _editExpense = 
         Provider.of<CropExpenses>(context, listen: false).findById(expenseId); 
       
      _initValues = {
      'cropId': _editExpense.cropId,
      'orchId': _editExpense.orchId,
      'landId': _editExpense.landId,
      'amount' : _editExpense.amount.toString(),
      'description': _editExpense.description,
      'workerName' : _editExpense.workerName,
      'expenseType': _editExpense.expenseType,
      'paymentDate': _editExpense.paymentDate.toString(),
      'id':_editExpense.id,
       // 'seedingDate': _editExpense.seedingDate.toIso8601String(),
   
    };
    
      } 
     
    }
    _isInit = false;
    super.didChangeDependencies();
  }

@override
  void dispose() {
    _cropIdFocusNode.dispose();
    _expenseTypeFocusNode.dispose();
    _amountFocusNode.dispose();
    _workerNameFocusNode.dispose();
    _descriptionFocusNode.dispose();
   
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
if(_editExpense.id != null){
await Provider.of<CropExpenses>(context, listen: false).updateExpense(_editExpense.id, _editExpense);;
 await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Sucessful"),
            content: Text(
                "You have sucessfully edited expense details."),
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
await Provider.of<CropExpenses>(context, listen: false)
.addExpense(_editExpense, );
 await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Sucessful"),
            content: Text(
                "You have sucessfully added expense details."),
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
     String cropIdLand;
     dynamic cropIdOrch;
    dynamic cropIdCrop;
  String id = routes['id'];
  String cType = routes['type'];
  
  if(cType == 'crops'){
cropIdCrop = _editExpense.cropId;
cropIdOrch = null;
cropIdLand = null;
     } else if (cType == 'orchards'){
      cropIdOrch = _editExpense.orchId;
      cropIdCrop = null;
      cropIdLand = null;
     }
     else 
     {
      cropIdLand = _editExpense.landId;
      cropIdCrop = null;
      cropIdCrop = null;
     }
    return Scaffold(appBar: AppBar(title: Text('Edit Expense'),
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
            visible: false,
                      child: TextFormField(
            initialValue: _editExpense.cropId,
            decoration: InputDecoration(labelText: 'cropId'),
            textInputAction: TextInputAction.next,
             readOnly: true,
            onFieldSubmitted: (_){ 
              FocusScope.of(context).requestFocus(_expenseTypeFocusNode);},
              onSaved: (value){
                final expense = CropExpenseItemNew( 
                 cropId: cropIdCrop,
                     orchId: cropIdOrch,
                      landId: cropIdLand,
                  expenseType: _editExpense.expenseType,
                  amount: _editExpense.amount,
                  description: _editExpense.description, 
                  workerName: _editExpense.workerName,
                 paymentDate: _editExpense.paymentDate,
                  id: _editExpense.id,
                   type:   cType,
                  );
                _editExpense = expense;
              },
            ),
          ),
//Expense ID
          Visibility(
            visible: false,
                      child: TextFormField(
            initialValue: _initValues['id'],
            decoration: InputDecoration(labelText: 'ExpenseId',
            fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ),
                        ),
            textInputAction: TextInputAction.next,
             readOnly: true,
            onFieldSubmitted: (_){ 
              FocusScope.of(context).requestFocus(_expenseTypeFocusNode);},
              onSaved: (value){
                final expense = CropExpenseItemNew( 
                  cropId: cropIdCrop,
                     orchId: cropIdOrch,
                      landId: cropIdLand,
                  expenseType: _editExpense.expenseType,
                  amount: _editExpense.amount,
                  description: _editExpense.description, 
                  workerName: _editExpense.workerName,
                 paymentDate: _editExpense.paymentDate,
                  id: value,
                   type:   cType,
                  );
                _editExpense = expense;
              },
            ),
          ),

Container(
          child: 
        TextFormField(
          initialValue: _initValues['expenseType'],
          decoration: InputDecoration(labelText: 'expenseType',
         /*  fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ), */
                        ),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_){ 
            FocusScope.of(context).requestFocus(_amountFocusNode);},
            validator: (value){
              if(value.isEmpty){
                  return 'Please provide value';
              }
              else {
                return null;
              }
            },
            onSaved: (value){
              final expense = CropExpenseItemNew( 
                expenseType: value,
                cropId: cropIdCrop,
                     orchId: cropIdOrch,
                      landId: cropIdLand,
                amount: _editExpense.amount,
                description: _editExpense.description, 
                workerName: _editExpense.workerName,
               paymentDate: _editExpense.paymentDate,
                id: _editExpense.id,
                 type:   cType,
                );
             _editExpense = expense;
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
            initialValue: _initValues['amount'],
          decoration: InputDecoration(labelText: 'amount',
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
          focusNode: _amountFocusNode,
          onFieldSubmitted: (_){ 
            FocusScope.of(context).requestFocus(_workerNameFocusNode);},
              validator: (value){
              if(value.isEmpty){
                  return 'Please provide value';
              }
              else {
                return null;
              }
            },
               onSaved: (value){
              final expense = CropExpenseItemNew( 

               amount: double.parse(value),
                cropId: cropIdCrop,
                     orchId: cropIdOrch,
                      landId: cropIdLand,
                expenseType: _editExpense.expenseType,
                description: _editExpense.description,
               workerName: _editExpense.workerName,
               paymentDate: _editExpense.paymentDate,
                id: _editExpense.id,
                 type:   cType,
                );
                           _editExpense = expense;
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
            initialValue: _initValues['workerName'],
          decoration: InputDecoration(labelText: 'workerName',
          fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ),
                        ),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          focusNode: _workerNameFocusNode,
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
              final expense = CropExpenseItemNew( 
                workerName: value,
               cropId: cropIdCrop,
                     orchId: cropIdOrch,
                      landId: cropIdLand,
                 expenseType: _editExpense.expenseType,
                amount: _editExpense.amount,
                description: _editExpense.description, 
                
               paymentDate: _editExpense.paymentDate,
                id: _editExpense.id, 
                 type:   cType,
                );
                _editExpense = expense;
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
          focusNode: _descriptionFocusNode,
          onSaved: (value){
              final expense = CropExpenseItemNew( 
                description: value, 
               cropId: cropIdCrop,
                     orchId: cropIdOrch,
                      landId: cropIdLand,
             expenseType: _editExpense.expenseType,
                amount: _editExpense.amount,
                
                workerName: _editExpense.workerName,
               paymentDate: _editExpense.paymentDate,
                id: _editExpense.id,
                 type:   cType,
                );
               _editExpense = expense;
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
              Text('Payment Date :' + "${_editExpense.paymentDate.toLocal()}".split(' ')[0]),
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
           
         
      ],)),
      
    ),
    ),
    
    );
  }
}


