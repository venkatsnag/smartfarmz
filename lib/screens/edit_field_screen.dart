
import 'dart:async';
import 'package:flutter/material.dart';
import '../providers/crop.dart';
import 'package:provider/provider.dart';
import '../providers/fields.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'dart:convert';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import '../providers/apiClass.dart';

class EditFieldScreen extends StatefulWidget {
  static const routeName = '/edit-fields';
  @override


  
  _EditFieldScreenState createState() => _EditFieldScreenState();
}

class _EditFieldScreenState extends State<EditFieldScreen> {

final apiurl = AppApi.api;

  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _cropMethodFocusNode = FocusNode();
  final _ownershipTypeFocusNode = FocusNode();
  final _ownerFocusNode = FocusNode();
  final _locationFocusNode = FocusNode();
  final _areaFocusNode = FocusNode();
  final _landTypeFocusNode = FocusNode();
  final _farmerFocusNode = FocusNode();
  final _seedingDateFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
    final _form = GlobalKey<FormState>();
  
  var _editField = Field(
    id: null, 
    title: '', 
    description: '',
    cropMethod: '',
    ownershipType: '',
    owner: '', 
    farmer: '',
    area: 0,
    units : '',
    userId : '',
    landType:'',
    location:'',
    imageUrl: '',);

    Map<String, String> _initValues = {
      'title' : '',
      'description': '',
      'ownershipType' :'',
      'cropMethod' :'',
      'owner' :'',
      'farmer' :'',
      
      'area' :'',
      'units' : '',
      'landType': '',
      'location':'',
      'price' : '0',
       'imageUrl' :'',

    };
    var _isInit = true;
    var _isLoading = false;



// Unit of measurements
List<String> _uom = ['Yard', 'Acer', 'Hectar', 'Gunta']; // Option 2
   String _selectedUom; 

// Crop method
List<String> _cropMethod = ['Natural Farming', 'Organic Farming', 'Conventional/Chemical Farming']; // Option 2
   String _selectedCropMethod; 

   // Crop method
List<String> _ownershipType = ['Self Owned Land', 'Leased']; // Option 2
   String _selectedOwnershipType; 

   List<String> _landType = ['Red soil', 'Black soil', 'Barren Land', ]; // Option 2
   String _selectedLandType; 

@override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

/* DateTime selectedDate = new DateTime.now();
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
        return _editField.seedingDate = picked;
    
        
      });

   //if(picked != null) setState(() => val = picked.toString());

} */
// Uppload Picture 
//final String url = 'http://192.168.39.190:3000/upload';
PickedFile _imageFile;
   File _storedImage;
   String _storedImagePath;
  
  Future<String> uploadImage(dynamic filename) async {

      
    String pic = _editField.userId + _editField.title;
    String picName = pic.replaceAll("[\\-\\+\\.\\^:,]","");
    String userId = _editField.userId;
    final String url = '$apiurl/upload/$userId';
     final imageUrl = '$apiurl/images/$userId/$picName.jpg';
    //final String url = 'http://192.168.39.190:5000/upload';
   // Map<String,String> newMap = {'id':'$picName.jpg', 'userId' :'$userId'};
    Map<String,String> id = {'id':'$picName.jpg'};
    Map<String,String> folderId = {'folderId':'$userId'};
    //Map<String,String> usId = {'usId' : '$userId'};
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.files.add(await http.MultipartFile.fromPath('picture', filename));
    request.fields['id'] = json.encode(id);
    request.fields['folderId'] = json.encode(folderId);
    //request.fields['usId'] = json.encode(usId);
    var res = await request.send();
    request.url;
    print(res);    
    _editField.imageUrl = imageUrl;
return res.reasonPhrase;
}

Future<String> updateImage(dynamic filename) async {

   String version;
  for (int i = 0; i < 500; i++){
    version == i;
  }
      
    String pic = _editField.userId + _editField.title + _editField.id;
    String userId = _editField.userId;
    String picName = pic.replaceAll("[^\\p{L}\\p{Z}]","");
    final String url = '$apiurl/upload/$userId';
    final imageUrl = '$apiurl/images/$userId/$picName.jpg';
        //final String url = 'http://192.168.39.190:5000/upload';
   // Map<String,String> newMap = {'id':'$picName.jpg', 'userId' :'$userId'};
    Map<String,String> id = {'id':'$picName.jpg'};
    Map<String,String> folderId = {'folderId':'$userId'};
    //Map<String,String> usId = {'usId' : '$userId'};
    var request = http.MultipartRequest('PUT', Uri.parse(url));

    request.files.add(await http.MultipartFile.fromPath('picture', filename));
    request.fields['id'] = json.encode(id);
    request.fields['folderId'] = json.encode(folderId);
    //request.fields['usId'] = json.encode(usId);
    var res = await request.send();
    request.url;
    print(res);    
        _editField.imageUrl = imageUrl;
return res.reasonPhrase;
}
// Take picture
    String state = "";

    // Images camera selection
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
      final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      dynamic cType = routes['type'];
    dynamic fieldId = routes['id'];
      
      if(fieldId != null){
         _editField = 
         Provider.of<Fields>(context, listen: false).findById(fieldId);
       
      _initValues = {
      'title' : _editField.title,
      'description': _editField.description,
      'otherTitle': _editField.cropMethod,
       'ownershipType': _editField.ownershipType,
       'owner': _editField.owner,
      'farmer' : _editField.farmer,
      'location': _editField.location,
      'cropMethod': _editField.cropMethod,
      'landType':_editField.landType,
      'area' : _editField.area.toString(),
      'imageUrl' : '',

    };
    _imageUrlController.text = _editField.imageUrl;

      }
     
    }
    _isInit = false;
    super.didChangeDependencies();
  }

@override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _titleFocusNode.dispose();
    _areaFocusNode.dispose();
    _farmerFocusNode.dispose();
    _ownerFocusNode.dispose();
    _cropMethodFocusNode.dispose();
    _areaFocusNode.dispose();
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
if(_editField.id != null){
await Provider.of<Fields>(context, listen: false).updateField(_editField.id, _editField);
 await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Sucessful"),
            content: Text(
                "You have sucessfully edited Field details."),
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
if(_storedImage != null){
await updateImage(_storedImagePath);}
}

else{
  try{
await Provider.of<Fields>(context, listen: false)
.addField(_editField);
 await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Sucessful"),
            content: Text(
                "You have sucessfully added new Field!. Start adding crops cultivated in this field!"),
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
await uploadImage(_storedImagePath);

  } catch(error){
await showDialog<void>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("An Error Occured"),
                content: Text("Something went wrong. Either Image is not added or failed to upload data to server!"),
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
    final loadedFields = Provider.of<Fields>(context);
    final userId = loadedFields.userId;
    return Scaffold(appBar: AppBar(title: Text('Add/ Edit Fields'),
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

          /* Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Title : ',
              style: TextStyle(fontSize: 20)
              
              , ),
              DropdownButton(
                                     
                  hint: Text('Please choose crop Title'), // Not necessary for Option 1
                  value: _selectedTitle,
                  onChanged: (dynamic newValue) {
                    setState(() {
                      _selectedTitle = newValue;
                      return _editCrop.title = _selectedTitle;
                    });
                  },
                  items: _title.map((title) {
                    return DropdownMenuItem(
                      child: new Text(title),
                      value: title,
                    );
                  }).toList(),
                ),
            ],
          ), */

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
          
          textInputAction: TextInputAction.next,
         
            validator: (value){
              if(value.isEmpty){
                  return 'Please provide value';
              }
              else {
                return null;
              }
            },
            onSaved: (value){
              final field = Field( 
                title: _editField.title,
                description: _editField.description, 
                cropMethod: _editField.cropMethod,
                ownershipType:_editField.ownershipType,
                owner: _editField.owner,
                farmer: _editField.farmer,
                 location: _editField.location,
                landType: _editField.landType,
                area: _editField.area,
                 units: _editField.units,
                imageUrl: _editField.imageUrl,
              
                id: _editField.id,
                userId: value,
                );
              _editField = field;
            },
            
          ), ),

          


 Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(left: 10.0),
            child: Text('Title'),
            ),   
      

        Container(
          child: TextFormField(
          initialValue: _initValues['title'],
          decoration: InputDecoration(labelText: 'Give this field a name', 
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
            FocusScope.of(context).requestFocus(_titleFocusNode);},
            validator: (value){
               if(value.isEmpty){
                  return 'Please provide value';
              }
              else {
                return null;
              }
            },
            onSaved: (value){
              final field = Field( 
                title: value,
                description: _editField.description, 
                cropMethod: _editField.cropMethod,
                ownershipType:_editField.ownershipType,
                owner: _editField.owner,
                farmer: _editField.farmer,
                 location: _editField.location,
                landType: _editField.landType,
                area: _editField.area,
                 units: _editField.units,
                imageUrl: _editField.imageUrl,
              
                id: _editField.id,
                userId: _editField.userId,
                );
              _editField = field;
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
            child: Text('Crop method used in this land'),
            ),

 Container(
            width: 500,
           child:
                           
                        Column(
                             children: <Widget>[
                               DropdownButton(
                                 
              hint: _editField.cropMethod.isEmpty ?  Text('Crop Method') : Text('${_editField.cropMethod}'), // Not necessary for Option 1
              value: _selectedCropMethod,
              onChanged: (dynamic newValue) {
                setState(() {
                  _selectedCropMethod = newValue;
                  return _editField.cropMethod = _selectedCropMethod;
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
          decoration: InputDecoration(labelText: 'Description'),
          maxLines: 3,
          keyboardType: TextInputType.multiline,
          focusNode: _descriptionFocusNode,
          onSaved: (value){
              final field = Field( 
                title: _editField.title,
                description: value, 
                cropMethod: _editField.cropMethod,
                ownershipType:_editField.ownershipType,
                owner: _editField.owner,
                farmer: _editField.farmer,
                 location: _editField.location,
                landType: _editField.landType,
                area: _editField.area,
                 units: _editField.units,
                imageUrl: _editField.imageUrl,
              
                id: _editField.id,
                userId: _editField.userId,
                );
              _editField = field;
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
            child: Text('Ownership type'),
            ),
Container(
            width: 500,
           child:
                           
                        Column(
                             children: <Widget>[
                               DropdownButton(
                                 
              hint: _editField.ownershipType.isEmpty ? Text('Land Ownership Type') : Text('${_editField.ownershipType}') , // Not necessary for Option 1
              value: _selectedOwnershipType,
              onChanged: (dynamic newValue) {
                setState(() {
                  _selectedOwnershipType = newValue;
                  return _editField.ownershipType = _selectedOwnershipType;
                });
              },
              items: _ownershipType.map((ownershipType) {
                return DropdownMenuItem(
                  child: new Text(ownershipType),
                  value: ownershipType,
                );
              }).toList(),
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
      
      Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(left: 10.0),
            child: Text('Land Owner'),
            ),
Container(
          child:
          TextFormField(
          initialValue: _initValues['owner'],
          decoration: InputDecoration(labelText: 'Enter land owner name', 
      /*     fillColor: Colors.white,
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
            FocusScope.of(context).requestFocus(_ownerFocusNode);},
            validator: (value){
              if(value.isEmpty){
                  return 'Please provide value';
              }
              else {
                return null;
              }
            },
            onSaved: (value){
              final field = Field( 
                title: _editField.title,
                description: _editField.description, 
                cropMethod: _editField.cropMethod,
                ownershipType:_editField.ownershipType,
                owner: value,
                farmer: _editField.farmer,
                 location: _editField.location,
                landType: _editField.landType,
                area: _editField.area,
                 units: _editField.units,
                imageUrl: _editField.imageUrl,
              
                id: _editField.id,
                userId: _editField.userId,
                );
              _editField = field;
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
            child: Text('Farmer'),
            ),  
           

Container(
 child:
          TextFormField(
            initialValue: _initValues['farmer'],
          decoration: InputDecoration(labelText: 'farmer',
/*           fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ), */
                        ),
          textInputAction: TextInputAction.next,
          
          focusNode: _farmerFocusNode,
          onFieldSubmitted: (_){ 
            FocusScope.of(context).requestFocus(_areaFocusNode);},
               onSaved: (value){
              final field = Field( 
                title: _editField.title,
                description: _editField.description, 
                cropMethod: _editField.cropMethod,
                ownershipType:_editField.ownershipType,
                owner: _editField.owner,
                farmer: value,
                 location: _editField.location,
                landType: _editField.landType,
                area: _editField.area,
                 units: _editField.units,
                imageUrl: _editField.imageUrl,
              
                id: _editField.id,
                userId: _editField.userId,
                );
              _editField = field;
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
            child: Text('Land Area'),
            ), 

Container(
           child:Row(
                         children: <Widget>[
                           Expanded(
                                                        child: 
          TextFormField(
            initialValue: _initValues['area'],
          decoration: InputDecoration(labelText: 'area',
/*           fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          gapPadding: 10.0,
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
            FocusScope.of(context).requestFocus(_descriptionFocusNode);},
               onSaved: (value){
             final field = Field( 
                title: _editField.title,
                description: _editField.description, 
                cropMethod: _editField.cropMethod,
                ownershipType:_editField.ownershipType,
                owner: _editField.owner,
                farmer: _editField.farmer,
                 location: _editField.location,
                landType: _editField.landType,
                area: double.parse(value),
                 units: _editField.units,
                imageUrl: _editField.imageUrl,
              
                id: _editField.id,
                userId: _editField.userId,
                );
              _editField = field;            },
          ),
                           ),
                           Expanded(child: Column(
                             children: <Widget>[
                               DropdownButton(
                                 
              hint: _editField.units.isNotEmpty ? Text('${_editField.units}') : Text('Choose Units'), // Not necessary for Option 1
              value: _selectedUom,
              onChanged: (dynamic newValue) {
                setState(() {
                  _selectedUom = newValue;
                  return _editField.units = _selectedUom;
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
                           ),
                           )
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


          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(left: 10.0),
            child: Text('Location'),
            ),  

Container(
          child: 
          TextFormField(
            initialValue: _initValues['location'],
          decoration: InputDecoration(labelText: 'Enter land location',
    /*       fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          gapPadding: 10.0,
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ), */
                        ),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          focusNode: _locationFocusNode,
          validator: (value){
              if(value.isEmpty){
                  return 'Please enter location, with district & state';
              }
              else {
                return null;
              }
            },
          onFieldSubmitted: (_){ 
            FocusScope.of(context).requestFocus(_landTypeFocusNode);},
            
               onSaved: (value)
               {
              final field = Field( 
                title: _editField.title,
                description: _editField.description, 
                cropMethod: _editField.cropMethod,
                ownershipType:_editField.ownershipType,
                owner: _editField.owner,
                farmer: _editField.farmer,
                 location: value,
                landType: _editField.landType,
                area: _editField.area,
                 units: _editField.units,
                imageUrl: _editField.imageUrl,
              
                id: _editField.id,
                userId: _editField.userId,
                );
              _editField = field;
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
            child: Text('Type of Soil'),
            ),  
         
Container(
            width: 500,
           child:
                           
                        Column(
                             children: <Widget>[
                               DropdownButton(
                                 
              hint: _editField.landType.isNotEmpty ? Text('${_editField.landType}') : Text('Land Type'), // Not necessary for Option 1
              value: _selectedLandType,
              onChanged: (dynamic newValue) {
                setState(() {
                  _selectedLandType = newValue;
                  return _editField.landType = _selectedLandType;
                });
              },
              items: _landType.map((landType) {
                return DropdownMenuItem(
                  child: new Text(landType),
                  value: landType,
                );
              }).toList(),
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

          
            
        

          Container(
             child:  
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
          

                Container(width: 100, 
        height: 100, 
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          ),
       
        child: 
        
        _storedImage != null? Image.file(_storedImage,
        fit: BoxFit.cover,
        width: double.infinity,
        ) : _editField.id != null ? Image.network(_imageUrlController.text) : Text('No Image Taken'),
        alignment: Alignment.center),
        SizedBox(width:10,),
        Expanded(child: FlatButton.icon(
          icon: Icon(Icons.camera),
          label: Text('Take Pickture'),
          textColor: Color(0xFFFF9000),
          onPressed: () {
          _showSelectionDialog(context);

        },
          

        ),
        ),

          ],
          ),   decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.blue,
                      width: 1,
                    )),
                     padding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 1.0),
                      margin: EdgeInsets.all(10.0),
), 
      ],),),
      
    ),
    ),
    
    );
  }
}

