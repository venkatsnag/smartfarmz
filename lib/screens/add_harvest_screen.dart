
import 'dart:async';
import 'package:flutter/material.dart';
import '../providers/crops.dart';
import 'package:provider/provider.dart';
import '../providers/cropHarvest.dart';

class AddHarvestScreen extends StatefulWidget {
  static const routeName = '/add-cropHarvest';
  @override
  _AddHarvestScreenState createState() => _AddHarvestScreenState();
}


class _AddHarvestScreenState extends State<AddHarvestScreen> {


final _cropIdFocusNode = FocusNode();
final _descriptionFocusNode = FocusNode();
  final _totalOutputFocusNode = FocusNode();
  final _supervisorNameFocusNode = FocusNode();
  
  final _totalWorkersFocusNode = FocusNode();
  final _harvestDateFocusNode = FocusNode();
 
  final _form = GlobalKey<FormState>();

  
 var _addHarvest = CropHarvestItemNew(
    id: '',
    cropId: '',
    description: '',
    totalOutput :'',
    units :'',
    supervisorName :'',
    totalWorkers :'',
    harvestDate: DateTime.now(),
    

  );

      Map<String, String> _initValues = {
        'id' : '',
      'cropId':'',
     'description': '',
      'totalOutput' :'',
      'units' :'',
      'supervisorName' :'',
      'totalWorkers' :'',
      
      'harvestDate':''
     

    };
    var _isInit = true;
    var _isLoading = false;

// Unit of measurements
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
        return _addHarvest.harvestDate = picked;
    
        
      });

   //if(picked != null) setState(() => val = picked.toString());

}

  @override
  void didChangeDependencies() {

       if(_isInit){

     
    }
    _isInit = false;
    super.didChangeDependencies();
  }


@override
  void dispose() {
    _cropIdFocusNode.dispose();
    _totalOutputFocusNode.dispose();
    _supervisorNameFocusNode.dispose();
    _totalWorkersFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _harvestDateFocusNode.dispose();
   
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
await Provider.of<CropHarvest>(context, listen: false)
.addHarvest(_addHarvest);
await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Congratulations"),
            content: Text(
                "You have sucessfully added harvest details. Its time for celebration on your Harvest!"),
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
    return Scaffold(appBar: AppBar(title: Text('Add Harvest'),
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
              FocusScope.of(context).requestFocus(_descriptionFocusNode);},
              onSaved: (value){
                final harvest = CropHarvestItemNew( 
                  id: _addHarvest.id,
                cropId: cropIdCrop,
                description: _addHarvest.description, 
                totalOutput: _addHarvest.totalOutput,
                units: _addHarvest.units,
                 supervisorName: _addHarvest.supervisorName,
                  totalWorkers: _addHarvest.totalWorkers,
                   harvestDate: _addHarvest.harvestDate,
                 
                  
                  );
                _addHarvest = harvest;
                
              },
            ),
          ), 

           

           Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(left: 10.0),
            child: Text('Description'),
            ),      

        Container(
          child: TextFormField(
         
          initialValue: _initValues['description'],
          decoration: InputDecoration(labelText: 'description',
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
            FocusScope.of(context).requestFocus(_totalOutputFocusNode);},
            validator: (value){
              if(value.isEmpty){
                  return 'Please provide value';
              }
              else {
                return null;
              }
            },
           onSaved: (value){
                final harvest = CropHarvestItemNew( 
                  id: _addHarvest.id,
                cropId: cropIdCrop,
                description: value, 
                totalOutput: _addHarvest.totalOutput,
                units: _addHarvest.units,
                 supervisorName: _addHarvest.supervisorName,
                  totalWorkers: _addHarvest.totalWorkers,
                   harvestDate: _addHarvest.harvestDate,
                 
                  
                  );
                _addHarvest = harvest;
             
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

Row(
children: <Widget>[
Expanded(
child: TextFormField(
 initialValue: _initValues['totalOutput'],
 decoration: InputDecoration(labelText: 'Total Output',
          
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
                              FocusScope.of(context).requestFocus(_supervisorNameFocusNode);},
                                validator: (value){
                                if(value.isEmpty){
                                    return 'Please provide value';
                                }
                                else {
                                  return null;
                                }
                              },
          onSaved: (value){
                final harvest = CropHarvestItemNew( 
                  id: _addHarvest.id,
                cropId: cropIdCrop,
                description: _addHarvest.description, 
                totalOutput: value,
                units: _addHarvest.units,
                 supervisorName: _addHarvest.supervisorName,
                  totalWorkers: _addHarvest.totalWorkers,
                   harvestDate: _addHarvest.harvestDate,
                 
                  
                  );
                _addHarvest = harvest;
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
                  return _addHarvest.units = _selectedUom;
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

/* Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(left: 10.0),
            child: Text('Total Output'),
            ),   
Container(
          child:
          TextFormField(
            initialValue: _initValues['totalOutput'],
          decoration: InputDecoration(labelText: 'Total Output',
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
          focusNode: _totalOutputFocusNode,
          onFieldSubmitted: (_){ 
            FocusScope.of(context).requestFocus(_supervisorNameFocusNode);},
              validator: (value){
              if(value.isEmpty){
                  return 'Please provide value';
              }
              else {
                return null;
              }
            },
               onSaved: (value){
                final harvest = CropHarvestItemNew( 
                  id: _addHarvest.id,
                cropId: cropIdCrop,
                description: _addHarvest.description, 
                totalOutput: value,
                units: _addHarvest.units,
                 supervisorName: _addHarvest.supervisorName,
                  totalWorkers: _addHarvest.totalWorkers,
                   harvestDate: _addHarvest.harvestDate,
                 
                  
                  );
                _addHarvest = harvest;
                      
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
),  */

Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(left: 10.0),
            child: Text('Supervisor Name'),
            ),   

Container(
          child:
          TextFormField(
            initialValue: _initValues['supervisorName'],
          decoration: InputDecoration(labelText: 'Supervisor Name',
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
          focusNode: _supervisorNameFocusNode,
          onFieldSubmitted: (_){ 
            FocusScope.of(context).requestFocus(_totalWorkersFocusNode);},
              validator: (value){
              if(value.isEmpty){
                  return 'Please provide value';
              }
              else {
                return null;
              }
            },
               onSaved: (value){
                final harvest = CropHarvestItemNew( 
                  id: _addHarvest.id,
                cropId: cropIdCrop,
                description: _addHarvest.description, 
                totalOutput: _addHarvest.totalOutput,
                units: _addHarvest.units,
                 supervisorName: value,
                  totalWorkers: _addHarvest.totalWorkers,
                   harvestDate: _addHarvest.harvestDate,
                 
                  
                  );
                _addHarvest = harvest;
                
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
            child: Text('Total Workers Engaged'),
            ),   
        Container(
          child: 
          TextFormField(
            initialValue: _initValues['totalWorkers'],
          decoration: InputDecoration(labelText: 'Workers eganged',
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
                final harvest = CropHarvestItemNew( 
                  id: _addHarvest.id,
                cropId: cropIdCrop,
                description: _addHarvest.description, 
                totalOutput: _addHarvest.totalOutput,
                units: _addHarvest.units,
                 supervisorName:  _addHarvest.supervisorName,
                  totalWorkers: value,
                   harvestDate: _addHarvest.harvestDate,
                 
                  
                  );
                _addHarvest = harvest;
               
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
            child: Text('Date of Harvest'),
            ),  
           Container(
             child:
           Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: <Widget>[
                
                Text('Harvest Date :' + "${selectedDate.toLocal()}".split(' ')[0]),
              
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


