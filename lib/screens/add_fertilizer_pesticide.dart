
import 'dart:async';
import 'package:flutter/material.dart';
import '../providers/crops.dart';
import 'package:provider/provider.dart';
import '../providers/fertilizers.dart';

class AddFertiPestiScreen extends StatefulWidget {
  static const routeName = '/add-fertilizers';
  @override
  _AddFertiPestiScreen createState() => _AddFertiPestiScreen();
}


class _AddFertiPestiScreen extends State<AddFertiPestiScreen> {


final _cropIdFocusNode = FocusNode();
  final _amountFocusNode = FocusNode();
  final _workerNameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _typeFocusNode = FocusNode();
  final _brandFocusNode = FocusNode();
  final _dateFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  
 var _addFerti = FertiPestiItemNew(
    id: '',
     cropId: '',
      orchId: '',
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
      'cropId':'',
       'orchId':'',
            'amount' : '',
            'units' :'',
      'description': '',
      'workerName' :'',
      'type' :'',
      'id' : '',
      'brand' : '',
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
        return _addFerti.date = picked;
    
        
      });

   //if(picked != null) setState(() => val = picked.toString());

}

  @override
  void didChangeDependencies() {

       if(_isInit){
          //final cropData = Provider.of<Crops>(context);
      
     
    }
    _isInit = false;
    super.didChangeDependencies();
  }

@override
  void dispose() {
    _cropIdFocusNode.dispose();
    _typeFocusNode.dispose();
    _brandFocusNode.dispose();
    _amountFocusNode.dispose();
    _workerNameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _dateFocusNode.dispose();
   
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
await Provider.of<FertiPestis>(context, listen: false)
.addFertilizer(_addFerti);
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
          

setState(() {
  _isLoading = false;
}); 
Navigator.of(context).pop();

}

  @override
  Widget build(BuildContext context) {
     //final farmId = ModalRoute.of<Farms>(context).settings.arguments as String;
         final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
  
  dynamic cropType = routes['type'];

   String cropIdOrch;
    String cropIdCrop;
    dynamic cType = routes['type'];
    dynamic id = routes['id'];
     
      if(cType == 'crops'){
cropIdCrop = id;
cropIdOrch = null;
     } else{
      cropIdOrch = id;
      cropIdCrop = null;
     }
    return Scaffold(appBar: AppBar(title: Text('Add Fertilizer/Pesticides'),
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
            initialValue: _initValues['cropId'],
            decoration: InputDecoration(labelText: 'cropId'),
            textInputAction: TextInputAction.next,
            enabled: false,
            readOnly: true,
            onFieldSubmitted: (_){ 
              FocusScope.of(context).requestFocus(_typeFocusNode);},
              onSaved: (value){
                final ferti = FertiPestiItemNew( 
                  cropId: cropIdCrop,
                  orchId: cropIdOrch,
                  type: _addFerti.type,
                  amount: _addFerti.amount,
                  description: _addFerti.description, 
                  workerName: _addFerti.workerName,
                  brand: _addFerti.brand,
                date: _addFerti.date,
                  id: _addFerti.id,
                  units: _addFerti.units,
                  cType: cropType,
                  );
                _addFerti = ferti;
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
              FocusScope.of(context).requestFocus(_typeFocusNode);},
              onSaved: (value){
                final ferti = FertiPestiItemNew( 
                  cropId: cropIdCrop,
                  orchId: cropIdOrch,
                  type: _addFerti.type,
                  amount: _addFerti.amount,
                  description: _addFerti.description, 
                  workerName: _addFerti.workerName,
                  brand: _addFerti.brand,
                date: _addFerti.date,
                  id: _addFerti.id,
                  units: _addFerti.units,
                  cType: cropType,
                  );
                _addFerti = ferti;
              },
            ),
          ),
 
Container(
             child: 
        TextFormField(
          initialValue: _initValues['type'],
          decoration: InputDecoration(labelText: 'Type',
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
                amount: _addFerti.amount,
                description: _addFerti.description, 
                workerName: _addFerti.workerName,
                brand: _addFerti.brand,
               date: _addFerti.date,
                id: _addFerti.id,
                cType: cropType,
                units: _addFerti.units,
                );
             _addFerti = ferti;
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
          decoration: InputDecoration(labelText: 'Quantity'
       /*    ,fillColor: Colors.white,
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
                cropId: cropIdCrop,
                     orchId: cropIdOrch,
                type: _addFerti.type,
                description: _addFerti.description,
               workerName: _addFerti.workerName,
              date: _addFerti.date,
                id: _addFerti.id,
                cType: cropType,
                units: _addFerti.units,
                );
                           _addFerti = ferti;
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
                  return _addFerti.units = _selectedUom;
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
          decoration: InputDecoration(labelText: 'Worker Name',
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
                 type: _addFerti.type,
                amount: _addFerti.amount,
                description: _addFerti.description, 
                brand: _addFerti.brand,
               date: _addFerti.date,
                id: _addFerti.id, 
                cType: cropType,
                units: _addFerti.units,
                );
                _addFerti = ferti;
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
            FocusScope.of(context).requestFocus(_descriptionFocusNode);},
            onSaved: (value){
              final ferti = FertiPestiItemNew( 
                 cropId: cropIdCrop,
                     orchId: cropIdOrch,
                type: _addFerti.type,
                amount: _addFerti.amount,
                description: _addFerti.description, 
                workerName: _addFerti.workerName,
               date: _addFerti.date,
                brand: value,
                id: _addFerti.id,
                cType: cropType,
                units: _addFerti.units,
                );
              _addFerti = ferti;
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
              final ferti = FertiPestiItemNew( 
                description: value, 
                 cropId: cropIdCrop,
                     orchId: cropIdOrch,
                type: _addFerti.type,
                amount: _addFerti.amount,
                brand: _addFerti.brand,
                workerName: _addFerti.workerName,
               date: _addFerti.date,
                id: _addFerti.id,
                cType: cropType,
                units: _addFerti.units,
                );
               _addFerti = ferti;
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
           Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: <Widget>[
                
                Text('Date :' + "${selectedDate.toLocal()}".split(' ')[0]),
                SizedBox(height: 20.0,),
            RaisedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select date'),
              
              
            ),
              ],
            ),
          
         
      ],
      ),
      ),
    ),
    ),
    
    );
  }
}


