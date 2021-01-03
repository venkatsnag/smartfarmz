
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



PickedFile _imageFile;
   File _storedImage;
   String _storedImagePath;
  
  Future<String> uploadImage(dynamic filename) async {

      String version;
  for (int i = 0; i < 500; i++){
    version == i;
  }

    String pic = _addMachinery.landId + 'machinery' + _addMachinery.type + _addMachinery.model;
    String userId = _addMachinery.userId;
    String picName = pic.replaceAll("[^\\p{L}\\p{Z}]","");
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
    _addMachinery.imageUrl = imageUrl;
return  res.reasonPhrase; 
}

Future<String> updateImage(dynamic filename) async {


      
    String pic = _addMachinery.landId + 'machinery' + _addMachinery.type + _addMachinery.model;
    String userId = _addMachinery.userId;
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
return _addMachinery.imageUrl = imageUrl ; 
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
      dynamic landId = _addMachinery.landId;
      final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      final dynamic refId = routes['machineryId'];
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
await updateImage(_storedImagePath);}

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
    await uploadImage(_storedImagePath);}
    
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
            child: Text('Image'),
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
          borderRadius: BorderRadius.circular(10),
          ),
       
        child: 
        
        _storedImage != null? Image.file(_storedImage,
        fit: BoxFit.cover,
        width: double.infinity,
        ) : _addMachinery.id != null ? Image.network(_imageUrlController.text) : Text('No Image Taken'),
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
                    borderRadius: BorderRadius.all(Radius.circular(10)),
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




