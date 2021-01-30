
import 'dart:async';
import 'package:flutter/material.dart';
import '../providers/machinery.dart';
import 'package:provider/provider.dart';
import '../providers/cropNotes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'dart:convert';
import '../providers/user_profiles.dart';
import '../providers/apiClass.dart';

class AddMachineryScreen extends StatefulWidget {
  static const routeName = '/add-machinery';
  @override
  _AddMachineryScreenState createState() => _AddMachineryScreenState();
}


class _AddMachineryScreenState extends State<AddMachineryScreen> {


final apiurl = AppApi.api;


 final _typeFocusNode = FocusNode();
  final _brandFocusNode = FocusNode();
  final _modelFocusNode = FocusNode();
   final _descriptionFocusNode = FocusNode();
    final _supervisorFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
 
  final _form = GlobalKey<FormState>();

  
 var _addMachinery = MachineryItemNew(
    id: '',
     landId: '',
    type: '',
    brand: '',
     model :'',
      description :'',
       imageUrl :'',
       userId: '',
       supervisor: '',
    
    

  );

      Map<String, String> _initValues = {
     
      'landId':'',
      'type':'',
      'brand' : '',
      'model': '',
      'description' :'',
      'imageUrl' :'',
      'id' : '',
       'userId' : '',
      'supervisor':''
     

    };
    var _isInit = true;
    var _isLoading = false;
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
                                _addMachinery.imageUrl = appendedImages;
                                
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
      //String cropId = _addMachinery.cropId;
      String userId = _addMachinery.userId;
      String picName = 'mach' + '_' + image.split('/').last;
      var imageUrl = '$apiurl/images/folder/$picName.jpg';
       cropImageUrl.insert(0,imageUrl);
       
      final String url = '$apiurl/upload/folder';

      Map<String, String> id = {'id': '$picName.jpg'};
      Map<String, String> folderId = {'folderId': 'folder'};
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.files.add(await http.MultipartFile.fromPath('picture',imagePath));
      request.fields['id'] = json.encode(id);
      request.fields['folderId'] = json.encode(folderId);
      var res = await request.send();
      request.url;
      print(res);
       
       cropImageUrlString = cropImageUrl.join(",");
     
      _addMachinery.imageUrl = cropImageUrlString;
      
     
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
      //String cropId = _addMachinery.cropId;
      String userId = _addMachinery.userId;
      String picName = 'mach' + '_' + image.split('/').last;
      var imageUrl = '$apiurl/images/folder/$picName.jpg';
       cropImageUrl.insert(0,imageUrl);
       
      final String url = '$apiurl/upload/folder';

      Map<String, String> id = {'id': '$picName.jpg'};
      Map<String, String> folderId = {'folderId': 'folder'};
      var request = http.MultipartRequest('PUT', Uri.parse(url));

      request.files.add(await http.MultipartFile.fromPath('picture', imagePath));
      request.fields['id'] = json.encode(id);
      request.fields['folderId'] = json.encode(folderId);
      var res = await request.send();
      request.url;
      print(res);
       
       cropImageUrlString = cropImageUrl.join(",");
     
      _addMachinery.imageUrl = cropImageUrlString;
      
     
    }

//return;
  }


 var apiImages;




 @override
  void didChangeDependencies() {
  if(_isInit){
      
      final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      final dynamic refId = routes['id'];
      final dynamic type = routes['type'];

      if(refId != null && type == 'machinery'){
         _addMachinery = 
         Provider.of<Machinery>(context, listen: false).findById(refId);
       
      _initValues = {
      
      'landId' : _addMachinery.landId,
      'type': _addMachinery.type,
      'brand': _addMachinery.brand,
      'model': _addMachinery.model,
      'userId' : _addMachinery.userId,
      'description': _addMachinery.description,
      'supervisor' : _addMachinery.supervisor,
      'imageUrl' : '',

    };
    _imageUrlController.text = _addMachinery.imageUrl;
  _imageUrlController.text.isNotEmpty ?
        apiImages = _imageUrlController.text.split(",") : apiImages = null;
        apiImages != null ? 
        imagesFromAPI = apiImages 
        : imagesFromAPI = [];
      }
    else if(type == 'lands') {
      _addMachinery.landId = refId;
    }
     
     else if(refId == null && type == 'crops') {
       _addMachinery.landId = null;
    }
   
    }

    
    _isInit = false; 
    
    super.didChangeDependencies();
  }

 
@override
  void dispose() {
    _typeFocusNode.dispose();
    _brandFocusNode.dispose();
    _modelFocusNode.dispose();
    _descriptionFocusNode.dispose();
     _supervisorFocusNode.dispose();
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
if(_addMachinery.id.length > 0){
  if(_storedImage != null){
await updateImage(imagesFromPhone);}

await Provider.of<Machinery>(context, listen: false).updateMachinery(_addMachinery.id, _addMachinery);
await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Sucessful"),
            content: Text(
                "Your have sucessfully updated machinery details."),
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
    if(_storedImage != null){
    await uploadImage(imagesFromPhone);}
    
await  Provider.of<Machinery>(context, listen: false).addMachinery(_addMachinery);
await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Sucessful"),
            content: Text(
                "You have sucessfully added machinery details."),
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

 void initState() {
  Future<dynamic>.delayed(Duration.zero).then((dynamic _) async {
      setState(() {
        //_storedImage = File(_imageFile.path);
     
    
       _isLoading = true;
      });
      
  
      await Provider.of<UserProfiles>(context, listen: false).getusers;
      
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  } 
  
  

  @override
  Widget build(BuildContext context) {
    final dynamic userData = Provider.of<UserProfiles>(context);
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
    dynamic machineryId = routes['machineryId'];
    dynamic title = routes['title'];
    dynamic userId = '${userData.userId}';
    //dynamic orchId = routes['id'];
   if(cType == 'crops'){
cropIdCrop = id;
cropIdOrch = null;
cropIdLand = null;
     } 
     else if (machineryId != null)
     {
      cropIdLand = _addMachinery.landId;
      
     }

     else if (cType == 'lands')
     {
      cropIdLand = id;
      cropIdCrop = null;
cropIdOrch = null;
      
     }
     
    return Scaffold(appBar: AppBar(title: Text('Add/Edit Machinery'),
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

             
            initialValue: _initValues['landId'],
            decoration: InputDecoration(labelText: 'landId'),
            textInputAction: TextInputAction.next,
            enabled: false,
            readOnly: true,
           
              onSaved: (value){
                final machinery = MachineryItemNew( 

                  
                    
                    landId: cropIdLand,
                    type: _addMachinery.type,
                    brand: _addMachinery.brand,
                    model: _addMachinery.model, 
                  description: _addMachinery.description,
                  supervisor: _addMachinery.supervisor,
                  id: _addMachinery.id,
                  userId: userId,
                  imageUrl: _addMachinery.imageUrl,
                  
                  );
                _addMachinery = machinery;
                
              },
            ),
          ), 

Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(left: 10.0),
            child: Text('Machinery/Tool Type'),
            ),   
      

        Container(
          child: TextFormField(
         
          initialValue: _initValues['type'],
          decoration: InputDecoration(labelText: 'Machinery or Tool Type',
         /*  fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ), */
                        ),
          textInputAction: TextInputAction.next,
          focusNode: _typeFocusNode,
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
             final machinery = MachineryItemNew( 

                  
                    
                    landId: cropIdLand,
                    type: value,
                    brand: _addMachinery.brand,
                    model: _addMachinery.model, 
                  description: _addMachinery.description,
                  supervisor: _addMachinery.supervisor,
                  id: _addMachinery.id,
                  userId: userId,
                  imageUrl: _addMachinery.imageUrl,
                  
                  );
                _addMachinery = machinery;
                
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
            child: Text('Brand name'),
            ),   
      

        Container(
          child: TextFormField(
         
          initialValue: _initValues['brand'],
          decoration: InputDecoration(labelText: 'Brand name of machinery',
         /*  fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ), */
                        ),
          textInputAction: TextInputAction.next,
          focusNode: _brandFocusNode,
          onFieldSubmitted: (_){ 
            FocusScope.of(context).requestFocus(_modelFocusNode);},
            validator: (value){
              if(value.isEmpty){
                  return 'Please provide value';
              }
              else {
                return null;
              }
            },
            onSaved: (value){
             final machinery = MachineryItemNew( 

                  
                    
                    landId: cropIdLand,
                    type: _addMachinery.type,
                    brand: value,
                    model: _addMachinery.model, 
                  description: _addMachinery.description,
                  supervisor: _addMachinery.supervisor,
                  id: _addMachinery.id,
                  userId: userId,
                  imageUrl: _addMachinery.imageUrl,
                  
                  );
                _addMachinery = machinery;
                
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
            child: Text('Model'),
            ),      

        Container(
          child: TextFormField(
         
          initialValue: _initValues['model'],
          decoration: InputDecoration(labelText: 'ex:- model number or model',
         /*  fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ), */
                        ),
          textInputAction: TextInputAction.next,
          focusNode: _modelFocusNode,
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
             final machinery = MachineryItemNew( 

                  
                    
                    landId: cropIdLand,
                    type: _addMachinery.type,
                    brand: _addMachinery.brand,
                    model: value, 
                  description: _addMachinery.description,
                  supervisor: _addMachinery.supervisor,
                  id: _addMachinery.id,
                  userId: userId,
                  imageUrl: _addMachinery.imageUrl,
                  
                  );
                _addMachinery = machinery;
                
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
          decoration: InputDecoration(labelText: 'Description of machinery',
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
          focusNode: _descriptionFocusNode,
          onFieldSubmitted: (_){ 
            FocusScope.of(context).requestFocus(_supervisorFocusNode);},
              validator: (value){
              if(value.isEmpty){
                  return 'Please provide value';
              }
              else {
                return null;
              }
            },
               onSaved: (value){
              final machinery = MachineryItemNew( 

                  
                    
                    landId: cropIdLand,
                    type: _addMachinery.type,
                    brand: _addMachinery.brand,
                    model: _addMachinery.model, 
                  description: value,
                  supervisor: _addMachinery.supervisor,
                  id: _addMachinery.id,
                  userId: userId,
                  imageUrl: _addMachinery.imageUrl,
                  
                  );
                _addMachinery = machinery;
                
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
            child: Text('Supervisor'),
            ), 
Container(
          child:
          TextFormField(
            initialValue: _initValues['supervisor'],
          decoration: InputDecoration(labelText: 'supervisor of machinery',
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
          focusNode: _supervisorFocusNode,
          onFieldSubmitted: (_){ 
            },
              validator: (value){
              if(value.isEmpty){
                  return 'Please provide value';
              }
              else {
                return null;
              }
            },
               onSaved: (value){
              final machinery = MachineryItemNew( 

                  
                    
                    landId: cropIdLand,
                    type: _addMachinery.type,
                    brand: _addMachinery.brand,
                    model: _addMachinery.model, 
                  description: _addMachinery.description,
                  supervisor: value,
                  id: _addMachinery.id,
                  userId: userId,
                  imageUrl: _addMachinery.imageUrl,
                  
                  );
                _addMachinery = machinery;
                
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




