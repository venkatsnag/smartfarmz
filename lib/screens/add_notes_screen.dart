
import 'dart:async';
import 'package:flutter/material.dart';
import '../providers/crops.dart';
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

class AddNotesScreen extends StatefulWidget {
  static const routeName = '/add-notes';
  @override
  _AddNotesScreenState createState() => _AddNotesScreenState();
}


class _AddNotesScreenState extends State<AddNotesScreen> {


final apiurl = AppApi.api;

final _cropIdFocusNode = FocusNode();
 final _subjectFocusNode = FocusNode();
  final _workerNameFocusNode = FocusNode();
  final _notesFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
 
  final _form = GlobalKey<FormState>();

  
 var _addNote = CropLandNotesItemNew(
    id: '',
     cropId: '',
    landId: '',
    subject: '',
    notes: '',
     workerName :'',
      cropTitle :'',
       imageUrl :'',
       userId: '',
      date: DateTime.now(),
    

  );

      Map<String, String> _initValues = {
      'cropId':'',
      'landId':'',
      'subject':'',
      'notes' : '',
      'cropTitle': '',
      'workerName' :'',
      'imageUrl' :'',
      'id' : '',
       'userId' : '',
      'date':''
     

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
        return _addNote.date = picked;
    
        
      });

   //if(picked != null) setState(() => val = picked.toString());

}

PickedFile _imageFile;
   File _storedImage;
   String _storedImagePath;
  
  Future<String> uploadImage(dynamic filename) async {

      String version;
  for (int i = 0; i < 500; i++){
    version == i;
  }

    String pic = _addNote.cropId + 'notes' + _addNote.subject;
    String userId = _addNote.userId;
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
    _addNote.imageUrl = imageUrl;
return  res.reasonPhrase; 
}

Future<String> updateImage(dynamic filename) async {


      
    String pic = _addNote.cropId + 'notes' + _addNote.subject;
    String userId = _addNote.userId;
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
return _addNote.imageUrl = imageUrl ; 
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
      dynamic landId = _addNote.landId;
      final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      final dynamic refId = routes['noteId'];
      final dynamic type = routes['type'];

      if(refId != null && type == 'notes'){
         _addNote = 
         Provider.of<CropLandNotes>(context, listen: false).findById(refId);
       
      _initValues = {
      'cropId' : _addNote.cropId,
      'landId' : _addNote.landId,
      'cropTitle': _addNote.cropTitle,
      'notes': _addNote.notes,
      'subject': _addNote.subject,
      'userId' : _addNote.userId,
      'date': _addNote.date.toIso8601String(),
      'workerName' : _addNote.workerName,
      'imageUrl' : '',

    };
    _imageUrlController.text = _addNote.imageUrl;

      }
    else if(type == 'lands') {
      _addNote.landId = refId;
    }
     
     else if(refId == null && type == 'crops') {
       _addNote.landId = null;
    }
   
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
    _subjectFocusNode.dispose();
    _workerNameFocusNode.dispose();
    _notesFocusNode.dispose();
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
if(_addNote.id.length > 0){
  if(_storedImage != null){
await updateImage(_storedImagePath);}

await Provider.of<CropLandNotes>(context, listen: false).updateNote(_addNote.id, _addNote);
await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Sucessful"),
            content: Text(
                "You have sucessfully updated notes details."),
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
    
await  Provider.of<CropLandNotes>(context, listen: false).addNote(_addNote);
await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Sucessful"),
            content: Text(
                "Your have sucessfully added notes details."),
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
    dynamic noteId = routes['noteId'];
    dynamic title = routes['title'];
    dynamic userId = '${userData.userId}';
    //dynamic orchId = routes['id'];
   if(cType == 'crops'){
cropIdCrop = id;
cropIdOrch = null;
cropIdLand = null;
     } 
     else if (noteId != null)
     {
      cropIdCrop = _addNote.cropId;
      title = _addNote.cropTitle;
     }
     
    return Scaffold(appBar: AppBar(title: Text('Add Notes'),
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
           
              onSaved: (value){
                final note = CropLandNotesItemNew( 

                  
                    cropId: cropIdCrop,
                    landId: cropIdLand,
                   cropTitle: title,
                    subject: _addNote.subject,
                  imageUrl: _addNote.imageUrl,
                  notes: _addNote.notes, 
                  workerName: _addNote.workerName,
                date: _addNote.date,
                  id: _addNote.id,
                  userId: userId,
                  type:   cType,
                  );
                _addNote = note;
                
              },
            ),
          ), 

      
             Visibility(
            maintainState: true,
            visible: false, 
                      child: TextFormField(

             
            initialValue: _initValues['cropTitle'],
            decoration: InputDecoration(labelText: 'cropTitle'),
            textInputAction: TextInputAction.next,
            enabled: false,
            readOnly: true,
           
              onSaved: (value){
                final note = CropLandNotesItemNew( 

                  
                    cropId: cropIdCrop,
                    landId: cropIdLand,
                    cropTitle: title,
                    subject: _addNote.subject,
                  imageUrl: _addNote.imageUrl,
                  notes: _addNote.notes, 
                  workerName: _addNote.workerName,
                date: _addNote.date,
                  id: _addNote.id,
                  userId: userId,
                  type:   cType,
                  );
                _addNote = note;
                
              },
            ),
          ), 

        

Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(left: 10.0),
            child: Text('subject'),
            ),   
      

        Container(
          child: TextFormField(
         
          initialValue: _initValues['subject'],
          decoration: InputDecoration(labelText: 'Give subject ex:- identified disease in crop',
         /*  fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ), */
                        ),
          textInputAction: TextInputAction.next,
          focusNode: _subjectFocusNode,
          onFieldSubmitted: (_){ 
            FocusScope.of(context).requestFocus(_notesFocusNode);},
            validator: (value){
              if(value.isEmpty){
                  return 'Please provide value';
              }
              else {
                return null;
              }
            },
            onSaved: (value){
             final note = CropLandNotesItemNew( 

                  
                    cropId: cropIdCrop,
                    landId: cropIdLand,
                    subject: value,
                   cropTitle: title,
                  imageUrl: _addNote.imageUrl,
                  notes: _addNote.notes, 
                  workerName: _addNote.workerName,
                date: _addNote.date,
                  id: _addNote.id,
                  userId: userId,
                  type:   cType,
                  );
                _addNote = note;
                
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
            child: Text('Notes'),
            ),      

        Container(
          child: TextFormField(
         
          initialValue: _initValues['notes'],
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
          focusNode: _notesFocusNode,
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
             final note = CropLandNotesItemNew( 

                  
                    cropId: cropIdCrop,
                    landId: cropIdLand,
                    subject: _addNote.subject,
                   cropTitle: title,
                  imageUrl: _addNote.imageUrl,
                  notes: value, 
                  workerName: _addNote.workerName,
                date: _addNote.date,
                  id: _addNote.id,
                  userId: userId,
                  type:   cType,
                  );
                _addNote = note;
                
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
            child: Text('Recorded by'),
            ),   
Container(
          child:
          TextFormField(
            initialValue: _initValues['workerName'],
          decoration: InputDecoration(labelText: 'Recorded by',
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
              final note = CropLandNotesItemNew( 

                  
                    cropId: cropIdCrop,
                    landId: cropIdLand,
                   cropTitle: title,
                    subject: _addNote.subject,
                  imageUrl: _addNote.imageUrl,
                  notes: _addNote.notes, 
                  workerName: value,
                date: _addNote.date,
                  id: _addNote.id,
                  userId: userId,
                  type:   cType,
                  );
                _addNote = note;
                
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
            child: Text('Recorded date:-'),
            ),  
           Container(
             child:
           Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: <Widget>[
                
                Text('Recorded date :' + "${selectedDate.toLocal()}".split(' ')[0]),
              
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
        ) : _addNote.id != null ? Image.network(_imageUrlController.text) : Text('No Image Taken'),
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




