
import 'dart:async';

import 'package:flutter/material.dart';
import '../providers/crops.dart';

import 'package:provider/provider.dart';

import '../providers/fertilizers.dart';

class EditFertiPestiScreen extends StatefulWidget {
  static const routeName = '/edit-pesticides';
  @override
  _EditFertiPestiScreenState createState() => _EditFertiPestiScreenState();
}


class _EditFertiPestiScreenState extends State<EditFertiPestiScreen> {


final _cropIdFocusNode = FocusNode();
  final _amountFocusNode = FocusNode();
  final _workerNameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _typeFocusNode = FocusNode();
  final _brandFocusNode = FocusNode();
  final _dateFocusNode = FocusNode();
 
  final _form = GlobalKey<FormState>();

  
 var _editFertiPesti = FertiPestiItemNew(
    id: '',
     cropId: '',
     orchId:'',
     cType: '',
      amount : 0,
       units : '',
      description: '',
      workerName :'',
      type :'',
      brand :'',
      date: DateTime.now(),
    
    //seedingDate: DateTime.now(),
  );

      Map<String, String> _initValues = {
      'id' : '',
      'cropId':'',
      'orchId' : '',
      'type' :'',
      'amount' : '',
      'units' :'',
      'description': '',
      'workerName' :'',
      'brand' :'',
      
      'date' :'',
      
     // 'seedingDate':'',
      

    };
    var _isInit = true;
    var _isLoading = false;

List<String> _uom = ['MilliLiters', 'Liters', 'Grams' ]; // Option 2
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
        return _editFertiPesti.date = picked;
    
        
      });

   //if(picked != null) setState(() => val = picked.toString());

}
  @override
  void didChangeDependencies() {

       if(_isInit){
         // final cropData = Provider.of<Crops>(context);
      //final expenseId = Provider.of<Expenses>(context);
      //final fertiId = ModalRoute.of(context).settings.arguments;
     final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
  final dynamic fertiId = routes['id'];
  
   if(fertiId != null){
        _editFertiPesti = 
         Provider.of<FertiPestis>(context, listen: false).findById(fertiId); 
       
      _initValues = {
        'cropId': _editFertiPesti.cropId,
        'orchId': _editFertiPesti.orchId,
      'amount' : _editFertiPesti.amount.toString(),
      'description': _editFertiPesti.description,
      'workerName' : _editFertiPesti.workerName,
      'units' : _editFertiPesti.units,
      'type': _editFertiPesti.type,
      'brand': _editFertiPesti.brand,
      'id':_editFertiPesti.id,
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
    _typeFocusNode.dispose();
    _amountFocusNode.dispose();
    _workerNameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _brandFocusNode.dispose();
   
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
if(_editFertiPesti.id != null){
await Provider.of<FertiPestis>(context, listen: false).updateFertilizer(_editFertiPesti.id, _editFertiPesti);;

 await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Sucessful"),
            content: Text(
                "You have sucessfully edited Fertilizer/Pesticide details."),
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
await Provider.of<FertiPestis>(context, listen: false)
.addFertilizer(_editFertiPesti);
await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Sucessful"),
            content: Text(
                "You have sucessfully added Fertilizer/Pesticide details."),
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
  
  dynamic cropType = routes['type'];

       dynamic cropIdOrch;
    dynamic cropIdCrop;
  String id = routes['id'];
  
  
  if(cropType == 'crops'){
cropIdCrop = _editFertiPesti.cropId;
cropIdOrch = null;
     } else{
      cropIdOrch = _editFertiPesti.orchId;
      cropIdCrop = null;
     }
     
    return Scaffold(appBar: AppBar(title: Text('Edit Fertilizer/ Pestiside'),
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
            initialValue: _editFertiPesti.cropId,
            decoration: InputDecoration(labelText: 'cropId'),
            textInputAction: TextInputAction.next,
             readOnly: true,
            
              onSaved: (value){
                final ferti = FertiPestiItemNew( 
                   cropId: cropIdCrop,
                     orchId: cropIdOrch,
                  type: _editFertiPesti.type,
                  amount: _editFertiPesti.amount,
                   units: _editFertiPesti.units,
                  description: _editFertiPesti.description, 
                  workerName: _editFertiPesti.workerName,
                 date: _editFertiPesti.date,
                  id: _editFertiPesti.id,
                  cType:  cropType,
                  );
                _editFertiPesti = ferti;
              },
            ),
          ),
//Expense ID
          Visibility(
             maintainState: true,
            visible: false, 
                      child: TextFormField(
            initialValue: _initValues['id'],
            decoration: InputDecoration(labelText: 'ExpenseId'),
            textInputAction: TextInputAction.next,
             readOnly: true,
            onFieldSubmitted: (_){ 
              FocusScope.of(context).requestFocus(_typeFocusNode);},
              onSaved: (value){
                final ferti = FertiPestiItemNew( 
                  cropId: cropIdCrop,
                     orchId: cropIdOrch,
                  type: _editFertiPesti.type,
                  amount: _editFertiPesti.amount,
                  units: _editFertiPesti.units,
                  description: _editFertiPesti.description, 
                  workerName: _editFertiPesti.workerName,
                    brand: _editFertiPesti.brand,
                 date: _editFertiPesti.date,
                  id: _editFertiPesti.id,
                  cType:  cropType,
                  );
                _editFertiPesti = ferti;
              },
            ),
          ),
Container(
             child:
        TextFormField(
          initialValue: _initValues['type'],
          decoration: InputDecoration(labelText: 'Type',fillColor: Colors.white,
       /*                  border: new OutlineInputBorder(
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
              final ferti = FertiPestiItemNew( 
                type: value,
                 cropId: cropIdCrop,
                     orchId: cropIdOrch,
                amount: _editFertiPesti.amount,
                units: _editFertiPesti.units,
                description: _editFertiPesti.description, 
                workerName: _editFertiPesti.workerName,
                 brand: _editFertiPesti.brand,
               date: _editFertiPesti.date,
                id: _editFertiPesti.id,
                cType:  cropType,
                );
             _editFertiPesti = ferti;
             
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
                                                        child:
          TextFormField(
            initialValue: _initValues['amount'],
          decoration: InputDecoration(labelText: 'Quantity',
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
              final ferti = FertiPestiItemNew( 

               amount: double.parse(value),
               units: _editFertiPesti.units,
              cropId: cropIdCrop,
                     orchId: cropIdOrch,
               type: _editFertiPesti.type,
                description: _editFertiPesti.description,
               workerName: _editFertiPesti.workerName,
                brand: _editFertiPesti.brand,
               date: _editFertiPesti.date,
                id: _editFertiPesti.id,
                cType:  cropType,
                );
                           _editFertiPesti = ferti;
            },
          ),
),

                           Expanded(child: Column(
                             children: <Widget>[
                               DropdownButton(
                                 
              hint: _editFertiPesti.units != null ? Text('${_editFertiPesti.units}') : Text('Please choose a UOM'), // Not necessary for Option 1
              value: _selectedUom,
              onChanged: (dynamic newValue) {
                setState(() {
                  _selectedUom = newValue;
                  return _editFertiPesti.units = _selectedUom;
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
            initialValue: _initValues['workerName'],
          decoration: InputDecoration(labelText: 'WorkerName',
       /*    fillColor: Colors.white,
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
            FocusScope.of(context).requestFocus(_brandFocusNode);},
              validator: (value){
              if(value.isEmpty){
                  return 'Please provide value';
              }
              else {
                return null;
              }
            },
               onSaved: (value){
              final ferti = FertiPestiItemNew( 
                workerName: value,
                cropId: cropIdCrop,
                     orchId: cropIdOrch,
                type: _editFertiPesti.type,
                amount: _editFertiPesti.amount,
                units: _editFertiPesti.units,
                 brand: _editFertiPesti.brand,
                description: _editFertiPesti.description, 
                
              date: _editFertiPesti.date,
                id: _editFertiPesti.id, 
                cType:  cropType,
                );
                _editFertiPesti = ferti;
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
            initialValue: _initValues['brand'],
          decoration: InputDecoration(labelText: 'Brand',
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
          focusNode: _brandFocusNode,
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
              final ferti = FertiPestiItemNew( 
                description: _editFertiPesti.description, 
                 cropId: cropIdCrop,
                     orchId: cropIdOrch,
             type: _editFertiPesti.type,
                amount: _editFertiPesti.amount,
                units: _editFertiPesti.units,
                 brand: value,
                workerName: _editFertiPesti.workerName,
               date: _editFertiPesti.date,
                id: _editFertiPesti.id,
                cType:  cropType,
                );
               _editFertiPesti = ferti;
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
              final ferti = FertiPestiItemNew( 
                description: value, 
                 cropId: cropIdCrop,
                     orchId: cropIdOrch,
             type: _editFertiPesti.type,
                amount: _editFertiPesti.amount,
                units: _editFertiPesti.units,
                 brand: _editFertiPesti.brand,
                workerName: _editFertiPesti.workerName,
               date: _editFertiPesti.date,
                id: _editFertiPesti.id,
                cType:  cropType,
                );
               _editFertiPesti = ferti;
            },
          ), decoration: BoxDecoration(
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
              Text('Date :' + "${_editFertiPesti.date.toLocal()}".split(' ')[0]),
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
      ],)),
    ),
    ),
    
    );
  }
}


