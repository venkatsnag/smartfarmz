
import 'dart:async';
import 'package:flutter/material.dart';
import '../providers/crops.dart';
import 'package:provider/provider.dart';
import '../providers/cropExpenses.dart';

class AddExpenseScreen extends StatefulWidget {
  static const routeName = '/add-expenses';
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}


class _AddExpenseScreenState extends State<AddExpenseScreen> {


final _cropIdFocusNode = FocusNode();
  final _amountFocusNode = FocusNode();
  final _workerNameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _expenseTypeFocusNode = FocusNode();
  final _paymentDateFocusNode = FocusNode();
 
  final _form = GlobalKey<FormState>();

  
 var _addExpense = CropExpenseItemNew(
    id: '',
     cropId: '',
     orchId: '',
      landId: '',
    type: '',
      amount : 0,
      description: '',
      workerName :'',
      expenseType :'',
      paymentDate: DateTime.now(),
    

  );

      Map<String, String> _initValues = {
      'cropId':'',
        'orchId':'',
        'landId':'',
      'amount' : '',
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
        return _addExpense.paymentDate = picked;
    
        
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

 /* Future<void> _refreshCrops(BuildContext context) async {
   String cropId;
   if(this._addExpense.type == 'crops'){
     cropId = this._addExpense.cropId;
   }
   else{
     cropId = this._addExpense.orchId;
   }
 
   String type = this._addExpense.type;
await Provider.of<CropExpenses>(context,listen: false).fetchAndSetCropExpenses(cropId, type);
  } */
@override
  void dispose() {
    _cropIdFocusNode.dispose();
    _expenseTypeFocusNode.dispose();
    _amountFocusNode.dispose();
    _workerNameFocusNode.dispose();
    _descriptionFocusNode.dispose();
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
await Provider.of<CropExpenses>(context, listen: false)
.addExpense(_addExpense);
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
//_refreshCrops(context);
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
     final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    
    String cropIdLand;
    String cropIdOrch;
    String cropIdCrop;
    dynamic cType = routes['type'];
    dynamic id = routes['id'];
    //dynamic orchId = routes['id'];
   if(cType == 'crops'){
cropIdCrop = id;
cropIdOrch = null;
cropIdLand = null;
     } else if (cType == 'orchards'){
      cropIdOrch = id;
      cropIdCrop = null;
      cropIdLand = null;
     }
     else 
     {
      cropIdLand = id;
      cropIdCrop = null;
      cropIdCrop = null;
     }
    return Scaffold(appBar: AppBar(title: Text('Add Expenses'),
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
              FocusScope.of(context).requestFocus(_expenseTypeFocusNode);},
              onSaved: (value){
                final expense = CropExpenseItemNew( 

                  
                    cropId: cropIdCrop,
                     orchId: cropIdOrch,
                     landId: cropIdLand,
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
              FocusScope.of(context).requestFocus(_expenseTypeFocusNode);},
              onSaved: (value){
                final expense = CropExpenseItemNew( 

                  
                    cropId: cropIdCrop,
                     orchId: cropIdOrch,
                     landId: cropIdLand,
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
          ), 

           Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(left: 10.0),
            child: Text('Expense Type'),
            ),      

        Container(
          child: TextFormField(
         
          initialValue: _initValues['expenseType'],
          decoration: InputDecoration(labelText: 'ex:- labour charges, tractor expenses, fertilizer etc',
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

           decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    )),
                     padding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 1.0),
                      margin: EdgeInsets.all(10.0),
), 

Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(left: 10.0),
            child: Text('Expense Amount'),
            ),   
Container(
          child:
          TextFormField(
            initialValue: _initValues['amount'],
          decoration: InputDecoration(labelText: 'amount',
        /*   fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ), */
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
                expenseType: _addExpense.expenseType,
                description: _addExpense.description,
               workerName: _addExpense.workerName,
               paymentDate: _addExpense.paymentDate,
                id: _addExpense.id,
                type:   cType,
                );
                           _addExpense = expense;
                      
            },
          ),
           decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    )),
                     padding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 1.0),
                      margin: EdgeInsets.all(10.0),
), 

Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(left: 10.0),
            child: Text('Expense Paid to'),
            ),   

Container(
          child:
          TextFormField(
            initialValue: _initValues['workerName'],
          decoration: InputDecoration(labelText: 'workerName',
        /*   fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ), */
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
                 expenseType: _addExpense.expenseType,
                amount: _addExpense.amount,
                description: _addExpense.description, 
                
               paymentDate: _addExpense.paymentDate,
                id: _addExpense.id, 
                type:   cType,
                );
                _addExpense = expense;
                
            },
          ),
           decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    )),
                     padding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 1.0),
                      margin: EdgeInsets.all(10.0),
), 
          
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(left: 10.0),
            child: Text('Description'),
            ),   
        Container(
          child: 
          TextFormField(
            initialValue: _initValues['description'],
          decoration: InputDecoration(labelText: 'Describe more about expenses',
         /*  fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ), */
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
                expenseType: _addExpense.expenseType,
                amount: _addExpense.amount,
                workerName: _addExpense.workerName,
               paymentDate: _addExpense.paymentDate,
                id: _addExpense.id,
                type:   cType,
                );
               _addExpense = expense;
               
            },
          ),
           decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    )),
                     padding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 1.0),
                      margin: EdgeInsets.all(10.0),
), 


          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(left: 10.0),
            child: Text('Date of Payment'),
            ),  
           Container(
             child:
           Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: <Widget>[
                
                Text('Payment Date :' + "${selectedDate.toLocal()}".split(' ')[0]),
              
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
                      color: Colors.black,
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


