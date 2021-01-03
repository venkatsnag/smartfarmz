import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/user_profiles.dart';
import '../providers/user_profiles.dart' as userProf;
import '../providers/auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'dart:convert';
import '../widgets/user_profile_item.dart';
import '../l10n/gallery_localizations.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth.dart';

class UserProfileScreen extends StatefulWidget {
 
 static const routeName = '/user-profile-screen_new';


  @override

  
  
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen>
   

      with SingleTickerProviderStateMixin {

         String _selectedCountry;
  String _selectedState;

final apiurl = 'http://api.happyfarming.net:5000/upload';
 // final apiurl = 'http://192.168.68.100:5000';


       final _form = GlobalKey<FormState>();
      var _imageUrlController = TextEditingController();
      var _firstNameController = TextEditingController();
      var _lastNameController = TextEditingController();
      var _userEmailController = TextEditingController();
      var _userMobileController = TextEditingController();
       var _userIdController = TextEditingController();
       var _userVillageController = TextEditingController();
     
        var _editUser = UserProfieItem(
    id: null, 
    userFirstname:'', 
    userLastname: '',  
    userType: '',
    userEmail: '',
    userMobile: '',
    userVillage:'',
    userImageUrl: '',
    userId: '',
    userState: '',
    userCity : '',
    userCountry : '',
   );

/*   Map<String, String> _initValues = {
      'userFirstname' : '',
      'userLastname': '',
      'userType' :'',
      'userEmail' :'',
      'userMobile' :'',
     'userImageUrl':'',
      'userId':'',
      'state' : '',
       'city' :'',
       'country' : '',

    }; */

Map<String, String> _authData = {
    'email': '',
    'password': '',
    'firstName':'',
     'lastName':'',
     'userType':'',
     'userMobile':''
  };

List<String> _locations = ["Choose Country",'India']; // Option 2
  Map<String,String> _countryState = {
    "Choose Country" : "Choose Country",
    "Andaman and Nicobar Islands":"India",
    "Andhra Pradesh":"India",
    "Arunachal Pradesh":"India",
    "Assam":"India",
    "Telangana":"India",
    "Bihar":"India"
  };

List<String> _userType = ['Farmer', 
'Buyer', 
'Investor', 
 ]; // Option 2
   String _selectedUserType;

  List<String> _state =[];


           
 var _isLoading = false;
  @override
  String _fbUserData;

List statesList;
  String _myState;

Future<String> _getStateList() async {

  
  final String url = '$apiurl/states';
  Map<String, String> headers = {"Content-type": "application/json",
 'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE1OTk0MDU5MTU3NzEsImp3dGlkIjoibmRucnoiLCJlbWFpbGlkIjoiY2hhaUBnbWFpbC5jb20iLCJkYXRhIjoidHJ1ZSIsImV4cGlyZXMiOiIyMDIwLTEyLTE1VDE2OjI1OjE1Ljc4MVoiLCJ1c2VySWQiOiJjaGFpIiwiZXhwIjoxNTk5NDA1OTE5MzcxfQ.eWlECvg3XXj47MQo4A8AyB90tuZ8ib4vGODh79dyxck' };
  
    await http.get(url, headers: headers).then((response) {
      List<dynamic> data = json.decode(response.body);

//      print(data);
      setState(() {
        statesList = data;
      });
    });
  }

  // Get State information by API
  List citiesList;
  String _myCity;

Future<String> _getCitiesList(String id) async {

 final String url = '$apiurl/states/city/$id';
Map<String, String> headers = {"Content-type": "application/json", 
'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE1OTk0MDU5MTU3NzEsImp3dGlkIjoibmRucnoiLCJlbWFpbGlkIjoiY2hhaUBnbWFpbC5jb20iLCJkYXRhIjoidHJ1ZSIsImV4cGlyZXMiOiIyMDIwLTEyLTE1VDE2OjI1OjE1Ljc4MVoiLCJ1c2VySWQiOiJjaGFpIiwiZXhwIjoxNTk5NDA1OTE5MzcxfQ.eWlECvg3XXj47MQo4A8AyB90tuZ8ib4vGODh79dyxck'};
    await http.get(url, headers: headers).then((response) {
      List<dynamic> cityData = json.decode(response.body);

      setState(() {
        citiesList = cityData;
      });
    });
  }


  void initState() {
  Future<dynamic>.delayed(Duration.zero).then((dynamic _) async {
      setState(() {
        //_storedImage = File(_imageFile.path);
     
    
       _isLoading = true;
      });
      final userId = ModalRoute.of(context).settings.arguments;
  
      await Provider.of<UserProfiles>(context, listen: false).getusers(userId);
      
      _getStateList();
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  } 
  

    Future<void> _refreshUser() async {
      setState(() {
        //_storedImage = File(_imageFile.path);
     
    
       _isLoading = true;
      });
      final userId = ModalRoute.of(context).settings.arguments;
  
      await Provider.of<UserProfiles>(context, listen: false).getusers(userId);
      
      setState(() {
        _isLoading = false;
      });
    }

var _isInit = true;       


bool _status = true;
final FocusNode myFocusNode = FocusNode();



 

  PickedFile _imageFile;
File _storedImage;
   String _storedImagePath;
  
  Future<String> uploadImage(dynamic filename) async {
    final userId = ModalRoute.of(context).settings.arguments as String;
    dynamic picName = userId;
    final String url = '$apiurl/upload/$userId';
    Map<String,String> id = {'id':'$picName.jpg'};
    Map<String,String> folderId = {'folderId':'$userId'};
  
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.files.add(await http.MultipartFile.fromPath('picture', filename));
    request.fields['id'] = json.encode(id);
    request.fields['folderId'] = json.encode(folderId);
  
    var res = await request.send();
    request.url;
    print(res);    
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
   
    _uploadImageDialogue(context);
    //Navigator.of(context).pop();
  }

/*   Widget _setImageView() {
    if (_imageFile != null) {
      return Image.file(_imageFile, width: 500, height: 500);
    } else {
      return Text("Please select an image");
    }
  } */

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
                
              )
              
              );
            
        }
        
        );
        
  }

    Future<void> _takePicture(BuildContext context) async {
    final picker = ImagePicker();
    final _imageFile = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 600,
    );
    
    setState(() {
      _storedImage = File(_imageFile.path);
      _storedImagePath = _imageFile.path;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(_imageFile.path);
    final savedImage = await _storedImage.copy('${appDir.path}/$fileName'); 
     
   _uploadImageDialogue(context);
   //Navigator.of(context).pop();
    //widget.onSelectImage();
  }

Future<void> _saveImage() async {
    
setState(() {
  _isLoading = true;
});

if(_storedImage != null){
 
  try{

await uploadImage(_storedImagePath);

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


   Future<void> _saveForm() async {

    final isValid = _form.currentState.validate();
    if(!isValid){
      return;
    }

_form.currentState.save();
setState(() {
  _isLoading = true;
});
if(_editUser.id != null){
await Provider.of<UserProfiles>(context, listen: false).updateUser(_editUser.id, _editUser);;

if(_storedImage != null){
await uploadImage(_storedImagePath);} 
}
else{ 
  try{

await uploadImage(_storedImagePath);

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
    //final userId = ModalRoute.of(context).settings.arguments as String;
   final dynamic userData = Provider.of<UserProfiles>(context);
   

     
     return  Consumer<Auth>
      (builder: (ctx, auth, _) => new Scaffold(
      appBar: new AppBar(
            title: Row(
              children: <Widget>[
                
                new Text("My Profile")
              ],
            ),
            elevation: 4.0,
          ),
        body:  new 
        Container(
          
         
          child : auth.isAuth ? ListView.builder(itemCount: userData.items.length, itemBuilder: 
        (ctx, i) {
          
          return new Container(
      color: Colors.white,
      child: Padding(
          padding: EdgeInsets.all(10),
          
        /* child: ListView.builder(itemCount: userData.items.length, itemBuilder: 
        (ctx, i) => ProfilePageItem(userData.items[i]), ), */

        child: 
new Container(
  
      color: Colors.white,
      child: Form(
        key: _form,
                          child: new ListView(
                            shrinkWrap: true,
physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Column(
            children: <Widget>[
              new Container(
                height: 250.0,
                color: Colors.white,
                child: new Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 20.0, top: 20.0),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                          
                            Padding(
                              padding: EdgeInsets.only(left: 25.0),
                              child: new Text('MY PROFILE',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      fontFamily: 'sans-serif-light',
                                      color: Colors.black)),
                            )
                          ],
                        )),
                     Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: new Stack(fit: StackFit.loose, children: <Widget>[
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                                width: 150.0,
                                height: 150.0,
                                decoration: BoxDecoration(
                                  //border: Border.all(width: 1, color: Colors.grey),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
            image:  _storedImage != null? FileImage(_storedImage,
            scale: 10,
                              /* fit: BoxFit.cover,
                              width: double.infinity ,*/
                              ) :  '${userData.items[0].userImageUrl}' != null ? NetworkImage('${userData.items[0].userImageUrl}') : AssetImage('assets/img/as.png'),
            
          ),
                                borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 10.0,
          ),
        ),
       
                              
                              alignment: Alignment.center),
                          ], 
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 90.0, left: 120.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                               FlatButton.icon(
                                    padding: EdgeInsets.only(left: 50.0),
                                   
          icon: Icon(Icons.camera),
          label: Text('Edit Picture'),
         // textColor: Colors.blueGrey,
          onPressed: () {
          _showSelectionDialog(context);

        },
          
          

        ),
        
                                
                              ],
                            )),
                      ]),
                    )
                  ],
                ),
              ),
             
              new Container(
                color: Color(0xffFFFFFF),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 25.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Personal Information',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  _status ? _getEditIcon() : new Container(),
                                ],
                              )
                            ],
                          )),
                          
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'First Name',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                         
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              

                              new Flexible(
                                
                                child: new TextField(
                                  controller: _firstNameController..text ='${userData.items[0].userFirstname}',
                                  decoration: const InputDecoration(
                                    
                                    hintText: "Enter Your First Name",
                                  ),
                                 enabled: !_status,
                                  //autofocus: !_status,
                                  onChanged: (value){
                                    final user = UserProfieItem(
                                      id: '${userData.items[0].id}',
                                      userFirstname: value,
                                      userLastname: '${userData.items[0].userLastname}',
                                      userType: '${userData.items[0].userType}',
                                      userId: '${userData.items[0].userId}',
                                      userImageUrl: '${userData.items[0].userImageUrl}',
                                      userEmail: '${userData.items[0].userEmail}',
                                      userMobile: '${userData.items[0].userMobile}',
                                      userVillage: '${userData.items[0].userVillage}',

                                      );

                                      _editUser = user;

                                  },

                                ),
                              ),
                            ],
                          ),),
                          Container(
                          
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                          
                          Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Last Name',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              

                              new Flexible(
                                
                                child: new TextField(
                                  controller:  _lastNameController..text = '${userData.items[0].userLastname}',
                                  decoration: const InputDecoration(
                                    
                                    hintText: "Enter Your Last Name",
                                  ),
                                  enabled: !_status,
                                  //autofocus: !_status,
                          onChanged: (value){
                                    final user = UserProfieItem(
                                       id: '${userData.items[0].id}',
                                      userFirstname: '${userData.items[0].userLastname}',
                                      userLastname: value,
                                      userType: '${userData.items[0].userType}',
                                      userId: '${userData.items[0].userId}',
                                      userImageUrl: '${userData.items[0].userImageUrl}',
                                      userEmail: '${userData.items[0].userEmail}',
                                      userMobile: '${userData.items[0].userMobile}',
                                      userVillage: '${userData.items[0].userVillage}',
                                      );

                                      _editUser = user;

                                  },

                                ),
                              ),
                            ],
                          ),),
                         Container(
                          
                          height: 1.0,
                          color: Colors.grey[400],
                        ),

                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Email ID',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new TextField(
                                  controller:  _userEmailController..text = '${userData.items[0].userEmail}',
                                  decoration: const InputDecoration(
                                    
                                      hintText: "Enter Email ID"),
                                  enabled: !_status,
                                  onChanged: (value){
                                    final user = UserProfieItem(
                                       id: '${userData.items[0].id}',
                                      userFirstname: '${userData.items[0].userFirstname}',
                                      userLastname: '${userData.items[0].userLastname}',
                                      userType: '${userData.items[0].userType}',
                                      userId: '${userData.items[0].userId}',
                                      userImageUrl: '${userData.items[0].userImageUrl}',
                                      userEmail: value,
                                      userMobile: '${userData.items[0].userMobile}',
                                      userVillage: '${userData.items[0].userVillage}',
                                      );

                                      _editUser = user;

                                  },
                                ),
                              ),
                            ],
                          ),
                          ),
                          Container(
                          
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Mobile',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                         
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new TextField(
                                  controller:  _userMobileController..text = '${userData.items[0].userMobile}',
                                  decoration: const InputDecoration(
                                      hintText: "Enter Mobile Number"),
                                  enabled: !_status,
                                onChanged: (value){
                                    final user = UserProfieItem(
                                      id: '${userData.items[0].id}',
                                      userFirstname: '${userData.items[0].userFirstname}',
                                      userLastname: '${userData.items[0].userLastname}',
                                      userType: '${userData.items[0].userType}',
                                      userId: '${userData.items[0].userId}',
                                      userImageUrl: '${userData.items[0].userImageUrl}',
                                      userEmail: '${userData.items[0].userEmail}',
                                      userVillage: '${userData.items[0].userVillage}',
                                      userMobile: value,

                                      );

                                      _editUser = user;

                                  },

                                ),
                              ),
                            ],
                          ),),

                           Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _myState,
                        iconSize: 30,
                        icon: (null),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        hint: Text('Select State'),
                        onChanged: (String newValue) {
                          setState(() {
                            _myState = newValue;
                            _getCitiesList(newValue);
                            print(_myState);
                          });
                        },
                        items: statesList?.map((dynamic item) {
                              return new DropdownMenuItem(
                                child: new Text(item['state_name']),
                                value: item['state_id'].toString(),
                              );
                            })?.toList() ??
                            [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),

          //======================================================== City

          Container(
            width: 450,
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _myCity,
                        iconSize: 30,
                        icon: (null),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        hint: Text('Select City'),
                        onChanged: (String newValue) {
                          setState(() {
                            _myCity = newValue;
                            print(_myCity);
                          });
                        },
                        items: citiesList?.map((dynamic item) {
                              return new DropdownMenuItem(
                                child: new Text(item['city_name']),
                                value: item['city_id'].toString(),
                              );
                            })?.toList() ??
                            [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
       
                      /* Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: new Text(
                                    'Pin Code',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                flex: 2,
                              ),
                              Expanded(
                                child: Container(
                                  child: new Text(
                                    'State',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                flex: 2,
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: new TextField(
                                    decoration: const InputDecoration(
                                        hintText: "Enter Pin Code"),
                                    enabled: !_status,
                                  ),
                                ),
                                flex: 2,
                              ),
                              Flexible(
                                child: new TextField(
                                  decoration: const InputDecoration(
                                      hintText: "Enter State"),
                                  enabled: !_status,
                                ),
                                flex: 2,
                              ),
                            ],
                          )), */
                      !_status ? _getActionButtons() : new Container(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    ),
    
    ),

        ),
        
    );
    } 
    ) : Banner(),
        )
      )
      );


  }

       
       Widget _addStateDropdown() {
    return _selectedCountry != null
        ? DropdownButton<String>(
            value: _selectedState,
            items: _state.map((location) => DropdownMenuItem<String>(
                    child: Text(location), value: location))
                .toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedState = newValue;
              });
            })
        : Container(); // Return an empty Container instead.
  }


  //CALLING STATE API HERE
// Get State information by API
  

 @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    
    super.dispose();
  }

  Future<void> _uploadImageDialogue(BuildContext context) {
           return showDialog(
        context: context,
        builder: (BuildContext context) {
          return  AlertDialog(
                title: Text("Upload Image"),
                content: Text("Do you want to upload this image?."),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Okay"),
                    onPressed: () {
                     _saveImage();
                     
                     Navigator.of(context).pop();
                     
                    },
                    
                  ),
                  
                ],
             
              );
             
  }
           );
  }

  Widget _uploadImage(){
             return AlertDialog(
                title: Text(GalleryLocalizations.of(context).imageUpload,) ,
                content: Text(GalleryLocalizations.of(context).imageUploadDialogue,) ,
                actions: <Widget>[
                  FlatButton(
                    child: Text("Okay"),
                    onPressed: () {
                     _saveImage();
                    },
                   
                  ),
                ],
              );
              
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  _saveForm();
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }



  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}

class Banner extends StatefulWidget {
  const Banner();

  @override
  _BannerState createState() => _BannerState();
}

class _BannerState extends State<Banner> {
  
  var _showMultipleActions = true;
  var _displayBanner = true;
  var _showLeading = true;



  @override
  Widget build(BuildContext context) {
    
    return MaterialBanner(
      content: Text(GalleryLocalizations.of(context).bannerSignIn),
      leading: _showLeading
          ? CircleAvatar(
              child: Icon(Icons.account_circle),
             
            )
          : null,
      actions: [
        FlatButton(
          child: Text(GalleryLocalizations.of(context).signIn),
          onPressed: () {
            setState(() {
              _displayBanner = false;
              SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamed(context, '/login');
              });
            });
            
          },
        ),
         FlatButton(
            child: Text(GalleryLocalizations.of(context).dismiss),
            onPressed: () {
               setState(() {
                _displayBanner = false;
              });
              Navigator.pushReplacementNamed(context, '/guest_home_screen');
            },
          ),
      ],
      
    );

    
  }

  

  
}
