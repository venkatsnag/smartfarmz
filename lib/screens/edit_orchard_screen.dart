
import 'dart:async';
import 'package:flutter/material.dart';
import '../providers/orchard.dart';
import 'package:provider/provider.dart';
import '../providers/orchards.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'dart:convert';
import 'package:searchable_dropdown/searchable_dropdown.dart';


class EditOrchardScreen extends StatefulWidget {
  static const routeName = '/edit-orchards';
  @override

final String url = 'http://api.happyfarming.net:5000/upload';
  _EditOrchardScreenState createState() => _EditOrchardScreenState();
}

class _EditOrchardScreenState extends State<EditOrchardScreen> {

final _titleFocusNode = FocusNode();
final _otherTitleFocusNode = FocusNode();
final _farmerFocusNode = FocusNode();
final _investorFocusNode = FocusNode();
final _priceFocusNode = FocusNode();
final _areaFocusNode = FocusNode();
final  _totalPlantsFocusNode = FocusNode();
final _varietyFocusNode = FocusNode();
final _descriptionFocusNode = FocusNode();
final _imageUrlController = TextEditingController();
final _imageUrlFocusNode = FocusNode();
final _form = GlobalKey<FormState>();
  
var _editOrchard = Orchard(
    id: null, 
    title: '', 
    otherTitle: '', 
    farmer: '', 
    cropMethod:'',
    userId: '', 
    price: 0,  
    description: '',
    investor:'',
    area: 0,
    units: '',
    totalPlants: 0,
    variety: '',
    plantingDate:DateTime.now(),
    expectedHarvestDate:DateTime.now(),
    imageUrl: '',);

Map<String, String> _initValues = {
      'title' : '',
      'otherTitle' : '',
      'farmer' : '',
      'userId' : '',
      'description': '',
      'cropMethod': '',
      'area' :'',
      'units' :'',
      'price' : '',
      'investor' : '',
      'totalPlants':'',
      'variety':'',
      'plantingDate':'',
      'expectedHarvestDate':'',
       'imageUrl' :'',

    };
var _isInit = true;
var _isLoading = false;


List<String> _title = ['Apple', 'Grapes', 'Coconut', 'Cashew', 'Coffee', 'Orange', 'Banana',  'Mango', 'Others']; // Option 2
String _selectedTitle; 

// Unit of measurements
List<String> _uom = ['Yard', 'Acer', 'Hectar', 'Gunta']; // Option 2
   String _selectedUom; 


   // Crop method
List<String> _cropMethod = ['Natural Farming', 'Organic Farming', 'Conventional/Chemical Farming']; // Option 2
   String _selectedCropMethod; 

@override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }
// Date selection
  DateTime selectedDateHarvestDate = new DateTime.now();
  Future _selectDateHarvestDate(BuildContext context) async {
  //final DateTime _date = DateTime.now();
  final _date = new DateTime.now();
  final DateTime picked = await showDatePicker(context: context, 
  
  initialDate: _date, 
  firstDate: DateTime(2020), 
  lastDate: DateTime(2999),);

if (picked != null && picked != selectedDateHarvestDate)
      setState(() {
        selectedDateHarvestDate = picked;
            print(selectedDateHarvestDate);
        return _editOrchard.expectedHarvestDate = picked;
        
    
        
      });

    

   //if(picked != null) setState(() => val = picked.toString());

}

// Date selection
  DateTime selectedDatePlantingDate = new DateTime.now();
  Future _selectDatePlantingDate(BuildContext context) async {
  //final DateTime _date = DateTime.now();
final _date = new DateTime.now();
final DateTime picked = await showDatePicker(context: context, 
  
  initialDate: _date, 
  firstDate: DateTime(2020), 
  lastDate: DateTime(2999),);

if (picked != null && picked != selectedDatePlantingDate)
      setState(() {
        selectedDatePlantingDate = picked;
            print(selectedDatePlantingDate);
        return _editOrchard.plantingDate = picked;
        
    
        
      });

    

   //if(picked != null) setState(() => val = picked.toString());

}


// Uppload Picture 
//final String url = 'http://192.168.39.190:3000/upload';
PickedFile _imageFile;
File _storedImage;
String _storedImagePath;
  
Future<String> uploadImage(dynamic filename, String url) async {
    
final String picName = _editOrchard.userId + _editOrchard.title;
    Map<String,String> newMap = {'id':'$picName.jpg'};
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.files.add(await http.MultipartFile.fromPath('picture', filename));
    request.fields['id'] = json.encode(newMap);
    var res = await request.send();
    request.url;
    print(res);    
return res.reasonPhrase;
}
// Take picture
    String state = "";
void _openGallery(BuildContext context) async {
    final picker = ImagePicker();
    var picture = await picker.getImage(source: ImageSource.gallery, 
    imageQuality: 85,
      maxWidth: 600,);
     _imageFile = picture;
    
         
   

        setState(() {
      _storedImage = File(_imageFile.path);
      _storedImagePath = _imageFile.path;
    });
    Navigator.of(context).pop();
  }

/*  Widget _setImageView() {
    if (_imageFile != null) {
      return Image.file(_imageFile, width: 500, height: 500);
    } else {
      return Text("Please select an image");
    }
  }  */

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        _takePicture(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }
    Future<void> _takePicture(BuildContext context) async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 600,
    );
    setState(() {
      _storedImage = File(imageFile.path);
      _storedImagePath = imageFile.path;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await _storedImage.copy('${appDir.path}/$fileName'); 
    //widget.onSelectImage();
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
      final orchardId = ModalRoute.of(context).settings.arguments;
      if(orchardId != null){
         _editOrchard = 
         Provider.of<Orchards>(context, listen: false).findById(orchardId);
       
      _initValues = {
      'title' : _editOrchard.title,
      'farmer' : _editOrchard.farmer,
      'investor': _editOrchard.investor,
      'description': _editOrchard.description,
      'price' : _editOrchard.price.toString(),
      'area' : _editOrchard.area.toString(),
      'totalPlants' : _editOrchard.totalPlants.toString(),
      'variety' : _editOrchard.variety,
      'plantingDate' : _editOrchard.plantingDate.toIso8601String(),
      'expectedHarvestDate' : _editOrchard.expectedHarvestDate.toIso8601String(),
      'imageUrl' : '',

    };
    _imageUrlController.text = _editOrchard.imageUrl;

      }
     
    }
    _isInit = false;
    super.didChangeDependencies();
  }

@override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _titleFocusNode.dispose();
    _otherTitleFocusNode.dispose();
     _farmerFocusNode.dispose();
      _investorFocusNode.dispose();
    _priceFocusNode.dispose();
    _areaFocusNode.dispose();
    _totalPlantsFocusNode.dispose();
    _varietyFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }
void _updateImageUrl(){
  if(!_imageUrlFocusNode.hasFocus){
setState(() {
  
});
  }

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
if(_editOrchard.id != null){
await Provider.of<Orchards>(context, listen: false).updateOrchard(_editOrchard.id, _editOrchard);
if(_storedImage != null){
await uploadImage(_storedImagePath, widget.url);}
}

else{
  try{
await Provider.of<Orchards>(context, listen: false)
.addOrchard(_editOrchard);
await uploadImage(_storedImagePath, widget.url);
  } catch(error){
await showDialog<void>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("An Error Occured"),
                content: Text("Something went wrong. Either Image is not added or failed to upload image to server!"),
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
          /* finally{
            setState(() {
  _isLoading = false;
});
Navigator.of(context).pop();

          } */
  }
setState(() {
  _isLoading = false;
}); 
Navigator.of(context).pop();

  

}

  

  @override
  Widget build(BuildContext context) {
    final loadedOrchads = Provider.of<Orchards>(context);
    final userId = loadedOrchads.userId;
    return Scaffold(appBar: AppBar(title: Text('Add/ Edit Orchard'),
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
          initialValue: userId,
          decoration: InputDecoration(labelText: 'useId', 
          fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          gapPadding: 10.0,
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(20)
                        ),
          
          
         
         
            onSaved: (value){
              final orchard = Orchard( 
                title: _editOrchard.title,
                otherTitle:_editOrchard.otherTitle,
                variety: _editOrchard.variety,
                price: _editOrchard.price,
                description: _editOrchard.description, 
                farmer: _editOrchard.farmer,
                investor: _editOrchard.investor,
                cropMethod: _editOrchard.cropMethod,
                area: _editOrchard.area,
                 units: _editOrchard.units,
                imageUrl: _editOrchard.imageUrl,
              plantingDate: _editOrchard.plantingDate,
              expectedHarvestDate: _editOrchard.expectedHarvestDate,
                id: _editOrchard.id,
                userId: value,
                isFavorite: _editOrchard.isFavorite );
              _editOrchard = orchard;
            },
            
          ), ),

       Container(
            width: 500,
           child:
                           
                        Column(
                             children: <Widget>[
                               


            SearchableDropdown<dynamic>.single(
        //items: items,
        value: _selectedTitle,
        hint: "Select crop title",
        searchHint: "type name to search",
        onChanged: (dynamic newValue) {
                setState(() {
                  _selectedTitle = newValue;
                  return _editOrchard.title = _selectedTitle;
                });
              },
              items: _title.map((title) {
                return DropdownMenuItem(
                  child: new Text(title),
                  value: title,
                );
              }).toList(),
            
                            
        isExpanded: true,
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


 Visibility(
            maintainState: true,
            visible: true,  
            child: Container(
          child: TextFormField(
          initialValue: _initValues['otherTitle'],
          decoration: InputDecoration(labelText: 'Other crops Title', 
        /*   fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          gapPadding: 10.0,
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(20) */
                        ),
          
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_){ 
            FocusScope.of(context).requestFocus(_otherTitleFocusNode);},
           validator: (value){
              if(_selectedTitle == 'Others'){
                  return 'Please provide crop Name';
              }
              else {
                return null;
              }
            },
            onSaved: (value){
              final orchard = Orchard( 
                title:  _editOrchard.title,
                otherTitle: value,
                variety: _editOrchard.variety,
                price: _editOrchard.price,
                description: _editOrchard.description, 
                farmer: _editOrchard.farmer,
                investor: _editOrchard.investor,
                cropMethod: _editOrchard.cropMethod,
                area: _editOrchard.area,
                 units: _editOrchard.units,
                imageUrl: _editOrchard.imageUrl,
              plantingDate: _editOrchard.plantingDate,
              expectedHarvestDate: _editOrchard.expectedHarvestDate,
                id: _editOrchard.id,
                userId: value,
                isFavorite: _editOrchard.isFavorite );
              _editOrchard = orchard;
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
),), 


Container(
          child:
          TextFormField(
          initialValue: _initValues['farmer'],
          decoration: InputDecoration(labelText: 'Farmer Name',
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
            FocusScope.of(context).requestFocus(_investorFocusNode);},
            validator: (value){
              if(value.isEmpty){
                  return 'Please provide name of farmer';
              }
              else {
                return null;
              }
            },
            onSaved: (value){
              _editOrchard = Orchard( 
                title: _editOrchard.title,
                otherTitle:_editOrchard.otherTitle,
                price: _editOrchard.price,
                description: _editOrchard.description, 
                farmer: value,
               cropMethod: _editOrchard.cropMethod,
               userId: _editOrchard.userId,
                area: _editOrchard.area,
                units: _editOrchard.units,
                investor: _editOrchard.investor,
                totalPlants: _editOrchard.totalPlants,
                variety: _editOrchard.variety,
                expectedHarvestDate: _editOrchard.expectedHarvestDate,
                plantingDate: _editOrchard.plantingDate,
                imageUrl: _editOrchard.imageUrl,
                id: _editOrchard.id,
                isFavorite: _editOrchard.isFavorite );
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
          child:  TextFormField(
          initialValue: _initValues['investor'],
          decoration: InputDecoration(labelText: 'Investor Name',
          /* fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ), */
                        ),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_){ 
            FocusScope.of(context).requestFocus(_priceFocusNode);},
            validator: (value){
              if(value.isEmpty){
                  return 'Please provide name of Investor';
              }
              else {
                return null;
              }
            },
            onSaved: (value){
              _editOrchard = Orchard( 
                title: _editOrchard.title,
                otherTitle:_editOrchard.otherTitle,
                price: _editOrchard.price,
                description: _editOrchard.description, 
                farmer: _editOrchard.farmer,
               cropMethod: _editOrchard.cropMethod,
               userId: _editOrchard.userId,
                area: _editOrchard.area,
                units: _editOrchard.units,
                investor: value,
                totalPlants: _editOrchard.totalPlants,
                variety: _editOrchard.variety,
                expectedHarvestDate: _editOrchard.expectedHarvestDate,
                plantingDate: _editOrchard.plantingDate,
                imageUrl: _editOrchard.imageUrl,
                id: _editOrchard.id,
                isFavorite: _editOrchard.isFavorite );
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
          child:TextFormField(
            initialValue: _initValues['price'],
          decoration: InputDecoration(labelText: 'Price',
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
          focusNode: _priceFocusNode,
          onFieldSubmitted: (_){ 
            FocusScope.of(context).requestFocus(_areaFocusNode);},
              validator: (value){
              if(value.isEmpty){
                  return 'Please provide value';
              }
              else {
                return null;
              }
            },
               onSaved: (value){
              _editOrchard = Orchard( 
                title: _editOrchard.title,
                otherTitle:_editOrchard.otherTitle,
                price: double.parse(value),
                variety: _editOrchard.variety,
                 farmer: _editOrchard.farmer,
               cropMethod: _editOrchard.cropMethod,
               userId: _editOrchard.userId,
                expectedHarvestDate: _editOrchard.expectedHarvestDate,
                plantingDate: _editOrchard.plantingDate,
                description: _editOrchard.description, 
                area: _editOrchard.area,
                units: _editOrchard.units,
                investor: _editOrchard.investor,
                totalPlants: _editOrchard.totalPlants,
                imageUrl: _editOrchard.imageUrl,
                id: _editOrchard.id,
                isFavorite: _editOrchard.isFavorite );
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
                         children: <Widget>[
                           Expanded(
                                                        child: 
           TextFormField(
            initialValue: _initValues['area'],
          decoration: InputDecoration(labelText: 'Total area',
          /* fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ), */
                        ),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          focusNode: _areaFocusNode,
          onFieldSubmitted: (_){ 
            FocusScope.of(context).requestFocus(_totalPlantsFocusNode);},
                validator: (value){
              if(value.isEmpty){
                  return 'Please provide value';
              }
              else {
                return null;
              }
            },
               onSaved: (value){
              _editOrchard = Orchard( 
                title: _editOrchard.title,
                otherTitle:_editOrchard.otherTitle,
                price: _editOrchard.price,
                area: double.parse(value),
                 farmer: _editOrchard.farmer,
               cropMethod: _editOrchard.cropMethod,
               userId: _editOrchard.userId,
                units: _editOrchard.units,
                investor: _editOrchard.investor,
                totalPlants: _editOrchard.totalPlants,
                variety: _editOrchard.variety,
                expectedHarvestDate: _editOrchard.expectedHarvestDate,
                plantingDate: _editOrchard.plantingDate,
                description: _editOrchard.description, 
                imageUrl: _editOrchard.imageUrl,
                id: _editOrchard.id,
                isFavorite: _editOrchard.isFavorite );
            },
          ),
          
                           ),
                           Expanded(child: Column(
                             children: <Widget>[
                               DropdownButton(
                                 
              hint: Text('Choose Units'), // Not necessary for Option 1
              value: _selectedUom,
              onChanged: (dynamic newValue) {
                setState(() {
                  _selectedUom = newValue;
                  return _editOrchard.units = _selectedUom;
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
  width: 500,
  
          child:
                           
                        Column(
                             children: <Widget>[
                               DropdownButton(
                                 
              hint: Text('Crop Method'), // Not necessary for Option 1
              value: _selectedCropMethod,
              onChanged: (dynamic newValue) {
                setState(() {
                  _selectedCropMethod = newValue;
                  return _editOrchard.cropMethod = _selectedCropMethod;
                });
              },
              items: _cropMethod.map((cropMethod) {
                return DropdownMenuItem(
                  child: new Text(cropMethod),
                  value: cropMethod,
                );
              }).toList(),
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


         Container(
                                                        child: TextFormField(
            initialValue: _initValues['totalPlants'],
          decoration: InputDecoration(labelText: 'Number of Plants',
          /* fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ), */
                        ),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          focusNode: _totalPlantsFocusNode,
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
              _editOrchard = Orchard( 
                title: _editOrchard.title,
                otherTitle:_editOrchard.otherTitle,
                price: _editOrchard.price,
                area: _editOrchard.area,
                 farmer: _editOrchard.farmer,
               cropMethod: _editOrchard.cropMethod,
               userId: _editOrchard.userId,
                units: _editOrchard.units,
                investor: _editOrchard.investor,
                totalPlants: double.parse(value),
                variety: _editOrchard.variety,
                expectedHarvestDate: _editOrchard.expectedHarvestDate,
                plantingDate: _editOrchard.plantingDate,
                description: _editOrchard.description, 
                imageUrl: _editOrchard.imageUrl,
                id: _editOrchard.id,
                isFavorite: _editOrchard.isFavorite );
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
             child:  TextFormField(
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
            validator: (value){
              if(value.isEmpty){
                  return 'Please provide value';
              }
              else {
                return null;
              }
            },
          onSaved: (value){
              _editOrchard = Orchard( 
                title: _editOrchard.title,
                otherTitle:_editOrchard.otherTitle,
                price: _editOrchard.price,
                description: value, 
                area: _editOrchard.area,
                 farmer: _editOrchard.farmer,
               cropMethod: _editOrchard.cropMethod,
               userId: _editOrchard.userId,
                units: _editOrchard.units,
                investor: _editOrchard.investor,
                variety: _editOrchard.variety,
                expectedHarvestDate: _editOrchard.expectedHarvestDate,
                plantingDate: _editOrchard.plantingDate,
                totalPlants: _editOrchard.totalPlants,
                imageUrl: _editOrchard.imageUrl,
                id: _editOrchard.id,
                isFavorite: _editOrchard.isFavorite );
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
            initialValue: _initValues['variety'],
          decoration: InputDecoration(labelText: 'Crop Variety/ Seed type',
          /* fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ), */
                        ),
          maxLines: 3,
         
          focusNode: _varietyFocusNode,
           validator: (value){
              if(value.isEmpty){
                  return 'Please provide value';
              }
              else {
                return null;
              }
            },
          onSaved: (value){
              _editOrchard = Orchard( 
                title: _editOrchard.title,
                otherTitle:_editOrchard.otherTitle,
                price: _editOrchard.price,
                description: _editOrchard.description, 
                area: _editOrchard.area,
                 farmer: _editOrchard.farmer,
               cropMethod: _editOrchard.cropMethod,
               userId: _editOrchard.userId,
                units: _editOrchard.units,
                investor: _editOrchard.investor,
                variety: value,
                expectedHarvestDate: _editOrchard.expectedHarvestDate,
                plantingDate: _editOrchard.plantingDate,
                totalPlants: _editOrchard.totalPlants,
                imageUrl: _editOrchard.imageUrl,
                id: _editOrchard.id,
                isFavorite: _editOrchard.isFavorite );
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
              Text('Planting Date :' + "${_editOrchard.plantingDate.toLocal()}".split(' ')[0]), 
              
               SizedBox(height: 20.0,),
            RaisedButton(
              onPressed: () => _selectDatePlantingDate(context),
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


         Container(
             child:  
            Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Expected Harvesting Date :' + "${_editOrchard.expectedHarvestDate.toLocal()}".split(' ')[0]), 
              
               SizedBox(height: 20.0,),
            RaisedButton(
              onPressed: () => _selectDateHarvestDate(context),
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
          
Container(
             child: 
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
           
           Container(width: 100, 
        height: 100, decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey),),
        child: _storedImage != null? Image.file(_storedImage,
        fit: BoxFit.cover,
        width: double.infinity,
        ) : _editOrchard.id != null ? Image.network(_imageUrlController.text) : Text('No Image Taken'),
        alignment: Alignment.center),
        SizedBox(width:10,),
        Expanded(child: FlatButton.icon(
          icon: Icon(Icons.camera),
          label: Text('Take Pickture'),
          textColor: Colors.black,
          onPressed: () {
          _showSelectionDialog(context);

        },

        ),
        ),
          ],),         padding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 1.0),
                      margin: EdgeInsets.all(10.0),
), 
      ],
      ),),
      
    ),
    ),
    
    );
  }
}



