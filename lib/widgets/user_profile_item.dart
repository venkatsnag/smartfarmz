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
import '../l10n/gallery_localizations.dart';
import '../providers/apiClass.dart';

class ProfilePageItem extends StatefulWidget {
 
final userProf.UserProfieItem items;

ProfilePageItem(this.items);
  @override

  final url = AppApi.api;

  _ProfilePageItemState createState() => _ProfilePageItemState();
}

class _ProfilePageItemState extends State<ProfilePageItem>
    with SingleTickerProviderStateMixin {

       final _form = GlobalKey<FormState>();
      var _imageUrlController = TextEditingController();
      var _firstNameController = TextEditingController();
      var _lastNameController = TextEditingController();
      var _userEmailController = TextEditingController();
      var _userMobileController = TextEditingController();
       var _userIdController = TextEditingController();
     
        var _editUser = UserProfieItem(
    id: null, 
    userFirstname:'', 
    userLastname: '',  
    userType: '',
    userEmail: '',
    userMobile: '',
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

bool _status = true;
final FocusNode myFocusNode = FocusNode();

var _isInit = true;
var _isLoading = false;

 

  PickedFile _imageFile;
File _storedImage;
   String _storedImagePath;
  
  Future<String> uploadImage(dynamic filename, String url) async {
    final userId = ModalRoute.of(context).settings.arguments as String;
    dynamic picName = userId;
    //String userId = _editUser.userId;
   // Map<String,String> newMap = {'id':'$picName.jpg', 'userId' :'$userId'};
    Map<String,String> id = {'id':'$picName.jpg'};
    //Map<String,String> usId = {'usId' : '$userId'};
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.files.add(await http.MultipartFile.fromPath('picture', filename));
    request.fields['id'] = json.encode(id);
    //request.fields['usId'] = json.encode(usId);
    var res = await request.send();
    request.url;
    print(res);    
return res.reasonPhrase;
}
// Take picture
    String state = "";

    Future<void> _takePicture() async {
    final picker = ImagePicker();
    final _imageFile = await picker.getImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    
    setState(() {
      _storedImage = File(_imageFile.path);
      _storedImagePath = _imageFile.path;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(_imageFile.path);
    final savedImage = await _storedImage.copy('${appDir.path}/$fileName'); 
    _saveImage();
    //widget.onSelectImage();
  }

Future<void> _saveImage() async {
    
setState(() {
  _isLoading = true;
});

if(_storedImage != null){
 
  try{

await uploadImage(_storedImagePath, widget.url);

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
await uploadImage(_storedImagePath, widget.url);} 
}
else{ 
  try{

await uploadImage(_storedImagePath, widget.url);

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
     //final dynamic userData = Provider.of<UserProfiles>(context);

     
     return  Consumer<Auth>
      (builder: (ctx, auth, _) => new Container(
          width: 400,
          height: 600,
      color: Colors.white,
      child: auth.isAuth ? Form(
        key: _form,
                          child: new ListView(
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
            image: _storedImage != null? FileImage(_storedImage,
            scale: 10,
                              /* fit: BoxFit.cover,
                              width: double.infinity ,*/
                              ) : '${widget.items.userId}' != null ? NetworkImage('${widget.items.userImageUrl}') : AssetImage('assets/img/as.png'),
            
          ),
                                borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 10.0,
          ),
        ),
       
                              /* child: 
        
                              _storedImage != null? Image.file(_storedImage,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              ) : _editUser.id != null ? Image.network(_imageUrlController.text) : image: AssetImage('assets/images/avatar.png'), */
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
          onPressed: _takePicture,
          

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
                                  controller: _firstNameController..text ='${widget.items.userFirstname}',
                                  decoration: const InputDecoration(
                                    
                                    hintText: "Enter Your First Name",
                                  ),
                                  enabled: !_status,
                                  autofocus: !_status,
                                  onChanged: (value){
                                    final user = UserProfieItem(
                                      id: '${widget.items.id}',
                                      userFirstname: value,
                                      userLastname: '${widget.items.userLastname}',
                                      userType: '${widget.items.userType}',
                                      userId: '${widget.items.userId}',
                                      userImageUrl: '${widget.items.userImageUrl}',
                                      userEmail: '${widget.items.userEmail}',
                                      userMobile: '${widget.items.userMobile}',

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
                                  controller:  _lastNameController..text = '${widget.items.userLastname}',
                                  decoration: const InputDecoration(
                                    
                                    hintText: "Enter Your Last Name",
                                  ),
                                  enabled: !_status,
                                  autofocus: !_status,
                                  onChanged: (value){
                                    final user = UserProfieItem(
                                       id: '${widget.items.id}',
                                      userFirstname: '${widget.items.userLastname}',
                                      userLastname: value,
                                      userType: '${widget.items.userType}',
                                      userId: '${widget.items.userId}',
                                      userImageUrl: '${widget.items.userImageUrl}',
                                      userEmail: '${widget.items.userEmail}',
                                      userMobile: '${widget.items.userMobile}',
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
                                  controller:  _userEmailController..text = '${widget.items.userEmail}',
                                  decoration: const InputDecoration(
                                    
                                      hintText: "Enter Email ID"),
                                  enabled: !_status,
                                  onChanged: (value){
                                    final user = UserProfieItem(
                                       id: '${widget.items.id}',
                                      userFirstname: '${widget.items.userFirstname}',
                                      userLastname: '${widget.items.userLastname}',
                                      userType: '${widget.items.userType}',
                                      userId: '${widget.items.userId}',
                                      userImageUrl: '${widget.items.userImageUrl}',
                                      userEmail: value,
                                      userMobile: '${widget.items.userMobile}',
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
                                  controller:  _userMobileController..text = '${widget.items.userMobile}',
                                  decoration: const InputDecoration(
                                      hintText: "Enter Mobile Number"),
                                  enabled: !_status,
                                onChanged: (value){
                                    final user = UserProfieItem(
                                      id: '${widget.items.id}',
                                      userFirstname: '${widget.items.userFirstname}',
                                      userLastname: '${widget.items.userLastname}',
                                      userType: '${widget.items.userType}',
                                      userId: '${widget.items.userId}',
                                      userImageUrl: '${widget.items.userImageUrl}',
                                      userEmail: '${widget.items.userEmail}',
                                      userMobile: value,

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
                          )),
                      !_status ? _getActionButtons() : new Container(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    ) : Text(GalleryLocalizations.of(context).login_Signup,) ,
    
    ),);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
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
