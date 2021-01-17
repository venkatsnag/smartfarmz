
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

// Uppload Picture

  List<String> imagesFromAPI;
  List<String> tempImages;
  
  String patchImage;
  String _error;
  String appendedImages;
  List<dynamic> imagesFromPhone = List<dynamic>();
  /* Future<File> _imageFromPhone; */
  Widget buildGridView(BuildContext context) {
    
    return GridView.count(
      crossAxisCount: 2,
      children: 
      (_imageUrlController.text.isEmpty) ?
      List.generate(imagesFromPhone.length, (index) {
             
              return Card(
                clipBehavior: Clip.antiAlias,
                
                child:  Stack(
                  children: <Widget>[
                    Image.file(
                      imagesFromPhone[index],
        fit: BoxFit.cover,
        width: double.infinity,
        ),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: InkWell(
                        child: Icon(
                          Icons.remove_circle,
                          size: 25,
                          color: Colors.red,
                        ),
                        onTap: () {
                          setState(() {
                             
                              imagesFromPhone.replaceRange(index, index + 1, []);
                          });
                        },
                      ),
                    ),
                  ],
                ) 
              );  
            }) :
      List.generate(imagesFromAPI.length, (index) {
                  //var image = _editCrop.imageUrl[index];
                  patchImage = imagesFromAPI[index];
                 
                  return Card(
                    clipBehavior: Clip.antiAlias,

                    child: 
                   
                    
                    Stack(
                      children: <Widget>[
                        new Image.network(
                          imagesFromAPI[index],
                          width: 300,
                          height: 300,
                          fit: BoxFit.fill,
                        ),
                        Positioned(
                          right: 5,
                          top: 5,
                          child: InkWell(
                            child: Icon(
                              Icons.remove_circle,
                              size: 25,
                              color: Colors.red,
                            ),
                            onTap: () {
                              setState(() {
                                imagesFromAPI.remove(patchImage);
                                String newImageUrls = jsonEncode(imagesFromAPI);
                                imagesFromAPI.isNotEmpty
                                    ? newImageUrls
                                    : imagesFromAPI;

                               
                                appendedImages = imagesFromAPI.join(",");
                                _editField.imageUrl = appendedImages;
                                
                              });
                            },
                          ),
                        ),
                      ],
                    ) 
                  );
                   
                }),
          
           
    );
  }

  Widget newGridView(BuildContext context) {
     
      return GridView.count(
      crossAxisCount: 2,
      children: List.generate(imagesFromPhone.length, (index) {
             
              return Card(
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: <Widget>[
                  Image.file(
                     imagesFromPhone[index],
        fit: BoxFit.cover,
        width: double.infinity,
        ),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: InkWell(
                        child: Icon(
                          Icons.remove_circle,
                          size: 25,
                          color: Colors.red,
                        ),
                        onTap: () {
                          setState(() {
                            imagesFromPhone.replaceRange(index, index + 1, []);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            })
         
    );
  }
    

  Future _onAddImageClick(BuildContext context) async {
setState(() {
  _showSelectionDialog(context);
});
  }

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
    final picture = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 600,
    );
    _imageFile = picture;
    setState(() {
      _storedImage = File(_imageFile.path);
      imagesFromPhone.insert(0, _storedImage);
      _storedImagePath = _imageFile.path;
    });
    Navigator.of(context).pop();
  }

  Future<void> _openGallery(BuildContext context) async {
    final picker = ImagePicker();
    var picture = await picker.getImage(source: ImageSource.gallery,
          imageQuality: 85,
      maxWidth: 600,);
     _imageFile = picture;
    
        setState(() {
      _storedImage = File(_imageFile.path);
      imagesFromPhone.insert(0, _storedImage);
      _storedImagePath = _imageFile.path;
      
    });
    Navigator.of(context).pop();
  }


  PickedFile _imageFile;
  List<dynamic> storedImage;
  File _storedImage;
  String _storedImagePath;
  var cropImageUrlString;
String tempImage;
  Future<String> uploadImage(dynamic storedImage) async {
    List<dynamic> cropImageUrl = [];
 
   
    for (int i = 0; i < storedImage.length; i++) {
     
     
     

      var image = storedImage[i].toString();
      var imagePath = storedImage[i].path;
      
      String userId = _editField.userId;
      String picName = 'field' + '_' + image.split('/').last;
    final String url = '$apiurl/upload/$userId';
     final imageUrl = '$apiurl/images/$userId/$picName.jpg';
     cropImageUrl.insert(0,imageUrl);
    Map<String,String> id = {'id':'$picName.jpg'};
    Map<String,String> folderId = {'folderId':'$userId'};
    
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.files.add(await http.MultipartFile.fromPath('picture',  imagePath));
    request.fields['id'] = json.encode(id);
    request.fields['folderId'] = json.encode(folderId);
    //request.fields['usId'] = json.encode(usId);
    var res = await request.send();
    request.url;
    print(res);   
      print(res);
       
       cropImageUrlString = cropImageUrl.join(",");
     
      _editField.imageUrl = cropImageUrlString;
      
     
    }


  }

  Future<String> updateImage(dynamic storedImage) async {
    
    List<dynamic> cropImageUrl = [];
 
   if (imagesFromAPI.isNotEmpty) {
 tempImage = imagesFromAPI.reduce((value, element) {
  return value + "," +element;
  
        
});
_imageUrlController.text.isNotEmpty && appendedImages != null ?
       cropImageUrl.add(appendedImages) :  
       cropImageUrl.add(tempImage);
   } else{
     imagesFromAPI;
   }
   
      for (int i = 0; i < storedImage.length; i++) {
          var image = storedImage[i].toString();
var imagePath = storedImage[i].path;
      //String cropId = _forSaleCrop.cropId;
      String userId = _editField.userId;
      String picName = 'field' + '_' + image.split('/').last;
         
    final imageUrl = '$apiurl/images/$userId/$picName.jpg';
    final String url = '$apiurl/upload/$userId';
     cropImageUrl.insert(0,imageUrl);
        
    Map<String,String> id = {'id':'$picName.jpg'};
    Map<String,String> folderId = {'folderId':'$userId'};
    
    var request = http.MultipartRequest('PUT', Uri.parse(url));

    request.files.add(await http.MultipartFile.fromPath('picture',  imagePath));
    request.fields['id'] = json.encode(id);
    request.fields['folderId'] = json.encode(folderId);
    
    var res = await request.send();
    request.url;
      print(res);
       
       cropImageUrlString = cropImageUrl.join(",");
     
      _editField.imageUrl = cropImageUrlString;
      
     
    }

//return;
  }


var apiImages;
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
      _imageUrlController.text.isNotEmpty ?
        apiImages = _imageUrlController.text.split(",") : apiImages = null;
        apiImages != null ? 
        imagesFromAPI = apiImages 
        : imagesFromAPI = [];

      }
     
    }
    _isInit = false;
    super.didChangeDependencies();
  }

@override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _titleFocusNode.dispose();
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
  if(_storedImage != null){
await updateImage(imagesFromPhone);
}
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

}

else{
  try{
    await uploadImage(imagesFromPhone);
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
                        
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(left: 10.0),
                        child: Text('Images'),
                      ),

                       _imageUrlController.text.isNotEmpty && _storedImagePath != null ? 
                      Container(
                        height: 700,
                        width: 500,
                        child: Column(
                          children: <Widget>[
                           /*  Center(child: Text('Error: $_error')), */
                                               
                            Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
    imagesFromAPI.length == 3? 
    new FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.red)),
      color: Colors.white,
      textColor: Colors.red,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
          //
      },
      child: Text(
        "Max 3 images can be added",
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
    ) :
   getUpdatePicker(),
    ],
    ) ,
                           Expanded(
                              child: 
                              
                              buildGridView(context),
                            ),

                             Expanded(
                              child: 
                              
                              newGridView(context),
                            ) 

                           
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            )),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5, horizontal: 1.0),
                        margin: EdgeInsets.all(10.0),
                      ) :

                      imagesFromAPI  == null ? 
                      Container(
                        height: 500,
                        width: 500,
                        child: Column(
                          children: <Widget>[
                           getCreatePicker(),
    Expanded(
                              child: 
                              
                              buildGridView(context),
                            ),
  ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            )),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5, horizontal: 1.0),
                        margin: EdgeInsets.all(10.0),
                      ) :
                    imagesFromAPI.length == 3? 
                      Container(
                        height: 500,
                        width: 500,
                        child: Column(
                          children: <Widget>[
    new FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.red)),
      color: Colors.white,
      textColor: Colors.red,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
          //
      },
      child: Text(
        "Max 3 images can be added",
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
    ),
    
    Expanded(
                              child: 
                              
                              buildGridView(context),
                            ),
    ])) :
                      Container(
                        height: 500,
                        width: 500,
                        child: Column(
                          children: <Widget>[
                         getCreatePicker(),
                          Expanded(
                              child: 
                              
                              buildGridView(context),
                            ),
                             ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            )),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5, horizontal: 1.0),
                        margin: EdgeInsets.all(10.0),
                      ) ,
                    ],
                  ),
                ),
              ),
            ),
    );
  }
  
  Widget getUpdatePicker(){
      if(imagesFromAPI.length == 3){
return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.red)),
      color: Colors.white,
      textColor: Colors.red,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
          //
      },
      child: Text(
        "Max 3 images can be added",
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
    );
      }
else
    if(imagesFromAPI == null){
      return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.green)),
      color: Colors.white,
      textColor: Colors.green,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
          _onAddImageClick(context);
      },
      child: Text(
        "Pick Images",
        style: TextStyle(
          fontSize: 14.0,
        ),
      ));
  }
  else if (imagesFromAPI.length < 3){
    if(imagesFromPhone.length < 3 && imagesFromAPI.length <= 1 ){
       return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.green)),
      color: Colors.white,
      textColor: Colors.green,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
          _onAddImageClick(context);
      },
      child: Text(
        "Pick Images",
        style: TextStyle(
          fontSize: 14.0,
        ),
      ));

    } else {
      return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.red)),
      color: Colors.white,
      textColor: Colors.red,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
          //
      },
      child: Text(
        "Max 3 images can be added",
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
    );

    }

  }
  else {
     return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.red)),
      color: Colors.white,
      textColor: Colors.red,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
          //
      },
      child: Text(
        "Max 3 images can be added",
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
    );
    
  }
  }






  Widget getCreatePicker() {
if(imagesFromPhone?.isEmpty ?? true){
      return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.green)),
      color: Colors.white,
      textColor: Colors.green,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
          _onAddImageClick(context);
      },
      child: Text(
        "Pick Images",
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
    );
    }
    else if (imagesFromPhone.length < 3) {
 return  FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.green)),
      color: Colors.white,
      textColor: Colors.green,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
          _onAddImageClick(context);
      },
      child: Text(
        "Pick Images",
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
    );
}
    else {
 return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.red)),
      color: Colors.white,
      textColor: Colors.red,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
          //
      },
      child: Text(
        "Max 3 images can be added",
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
    );
    
}
  }
  
}

