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
import 'package:searchable_dropdown/searchable_dropdown.dart';
import '../providers/apiClass.dart';

class UserProfileScreen extends StatefulWidget {
  static const routeName = '/user-profile-screen';

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  final apiurl = AppApi.api;

  final _form = GlobalKey<FormState>();
  var _imageUrlController = TextEditingController();
  var _firstNameController = TextEditingController();
  var _lastNameController = TextEditingController();
  var _userEmailController = TextEditingController();
  var _userMobileController = TextEditingController();
  var _userIdController = TextEditingController();
  var _userVillageController = TextEditingController();

  var _editUser = UserProfieItem(
    id: '',
    userFirstname: '',
    userLastname: '',
    userType: '',
    userEmail: '',
    userMobile: '',
    userVillage: '',
    userImageUrl: '',
    userId: '',
    userState: '',
    userCity: '',
    userCountry: '',
    countryDialCode: '',
  );

  Map<String, String> _initValues = {
    'userFirstname': '',
    'userLastname': '',
    'userType': '',
    'userEmail': '',
    'userMobile': '',
    'userVillage': '',
    'userImageUrl': '',
    'userId': '',
    'userState': '',
    'userCity': '',
    'userCountry': '',
    'countryDialCode': '',
  };

  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'firstName': '',
    'lastName': '',
    'userType': '',
    'userMobile': ''
  };


  List<String> _userType = [
    'Farmer',
    'Buyer',
    'Investor',
    'Hobby/DYIFarmer',
    
  ]; // Option 2
  String _selectedUserType;

  List<String> _state = [];

  String _selectedLocation;

  var _isLoading = false;
  @override
  String _fbUserData;

  List statesList;
  List<dynamic> countriesList;
  List<dynamic> countriesDialcodeList;
  String _myState;
  String _myCountry;
  String _myDialCode;
  String authToken;
  List<dynamic>  usersData;

  Future<String> _getStateList() async {
    final String url = '$apiurl/states';
    Map<String, String> headers = {
      "Content-type": "application/json",
      'Authorization': 'Bearer $authToken'
    };

    await http.get(url, headers: headers).then((response) {
      List<dynamic> data = json.decode(response.body);

//      print(data);
      setState(() {
        statesList = data;
      });
    });
  }

  Future<UserProfieItem> _getCountries() async {
    final String url = '$apiurl/countries';
    Map<String, String> headers = {
      "Content-type": "application/json",
      'Authorization': 'Bearer $authToken'
    };

    await http.get(url, headers: headers).then((response) {
      List<dynamic> data = json.decode(response.body);
      List<dynamic> countryList =
          data.map<dynamic>((dynamic m) => m['country']).toList();
      List<dynamic> dialingCodeList =
          data.map<dynamic>((dynamic m) => m['dial_code']).toList();
//      print(data);
      setState(() {
        countriesList = countryList;
        countriesDialcodeList = dialingCodeList;
      });
    });
  }

  // Get State information by API
  List citiesList;
  String _myCity;

  Future<String> _getCitiesList(String id) async {
    final String url = '$apiurl/states/city/$id';
    Map<String, String> headers = {
      "Content-type": "application/json",
      'Authorization': 'Bearer $authToken'
    };
    await http.get(url, headers: headers).then((response) {
      List<dynamic> cityData = json.decode(response.body);

      setState(() {
        citiesList = cityData;
      });
    });
  }

  Future<String> _getStatesList(String id) async {
    final String url = '$apiurl/countries/states/$id';
    Map<String, String> headers = {
      "Content-type": "application/json",
      'Authorization': 'Bearer $authToken'
    };
    await http.get(url, headers: headers).then((response) {
      List<dynamic> stateData = json.decode(response.body);

      setState(() {
        statesList = stateData;
      });
    });
  }

  void initState() {
    Future<dynamic>.delayed(Duration.zero).then((dynamic _) async {
      setState(() {
        //_storedImage = File(_imageFile.path);

        //_isLoading = true;
      });
      final userId = ModalRoute.of(context).settings.arguments;

      var users = await Provider.of<UserProfiles>(context, listen: false).getusers(userId);
      usersData = users;
      final token = await Provider.of<Auth>(context, listen: false).token;
      authToken = token;
      //_getStateList();
      _getCountries();
      setState(() {
        //_isLoading = false;
      });
    });
    super.initState();
  }

  Future<void> _refreshUser() async {
    setState(() {
      //  _storedImage = File(_imageFile.path);

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
    //final dynamic userData = Provider.of<UserProfiles>(context);
    final userId = ModalRoute.of(context).settings.arguments as String;
    dynamic picName = userId;
    final String url = '$apiurl/upload/$userId';
    Map<String, String> id = {'id': '$picName.jpg'};
    Map<String, String> folderId = {'folderId': '$userId'};
    final imageUrl = '$apiurl/images/$userId/$picName.jpg';

    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.files.add(await http.MultipartFile.fromPath('picture', filename));
    request.fields['id'] = json.encode(id);
    request.fields['folderId'] = json.encode(folderId);

    var res = await request.send();
    request.url;
    //print(res);

    _editUser.userImageUrl = imageUrl;
    _editUser.id = userId;
    return res.reasonPhrase;
  }

  Future<String> updateImage(dynamic filename) async {
    final userId = ModalRoute.of(context).settings.arguments as String;
    dynamic picName = userId;
    final String url = '$apiurl/upload/$userId';
    Map<String, String> id = {'id': '$picName.jpg'};
    Map<String, String> folderId = {'folderId': '$userId'};
    final imageUrl = '$apiurl/images/$userId/$picName.jpg';
    //final String url = 'http://192.168.39.190:5000/upload';
    // Map<String,String> newMap = {'id':'$picName.jpg', 'userId' :'$userId'};

    //Map<String,String> usId = {'usId' : '$userId'};
    var request = http.MultipartRequest('PUT', Uri.parse(url));

    request.files.add(await http.MultipartFile.fromPath('picture', filename));
    request.fields['id'] = json.encode(id);
    request.fields['folderId'] = json.encode(folderId);
    //request.fields['usId'] = json.encode(usId);
    var res = await request.send();
    request.url;
   // print(res);
    
    _editUser.userImageUrl = imageUrl;
    _editUser.id = userId;
    return res.reasonPhrase;
  }

// Take picture
  String state = "";

  // Images camera selection
  void _openGallery(BuildContext context) async {
    final picker = ImagePicker();
    var picture = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 600,
    );
    _imageFile = picture;

    setState(() {
      _storedImage = File(_imageFile.path);
      _storedImagePath = _imageFile.path;
    });
    //_saveImage();
    _uploadImageDialogue(context);
   // Navigator.of(context).pop();
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
        });
        
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
    //_saveImage();

    _uploadImageDialogue(context);
   //Navigator.of(context).pop();
    //widget.onSelectImage();
  }

  @override
  void didChangeDependencies() {
    _initValues = {
      'userFirstname': _editUser.userFirstname,
      'userLastname': _editUser.userLastname,
      'userType': _editUser.userType,
      'userEmail': _editUser.userEmail,
      'userMobile': _editUser.userMobile,
      'userVillage': _editUser.userVillage,
      'userImageUrl': _editUser.userImageUrl,
      'userId': _editUser.userId.toString(),
      'userState': _editUser.userState,
      'userCity': _editUser.userCity,
      'userCountry': _editUser.userCountry,
    };

    super.didChangeDependencies();
  }

  Future<void> _saveImage() async {
    setState(() {
      _isLoading = true;
    });

    if (_storedImage != null) {
      try {
        await uploadImage(_storedImagePath);
        //final dynamic userData = Provider.of<UserProfiles>(context);
        // _editUser.id = '${userData.items[0].id}';
        await Provider.of<UserProfiles>(context, listen: false)
            .patchUser(_editUser.id, _editUser.userImageUrl);
        ;
      } catch (error) {
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
    if (!isValid) {
      return;
    }

    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editUser.id != null) {
      await Provider.of<UserProfiles>(context, listen: false)
          .updateUser(_editUser.id, _editUser);
      ;

      if (_storedImage != null) {
        await updateImage(_storedImagePath);
      }
    } else {
      try {
        await Provider.of<UserProfiles>(context, listen: false)
            .updateUser(_editUser.id, _editUser);
        ;
      } catch (error) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An Error Occured"),
            content: Text(
                "Something went wrong. You either dint provide your Picture or wecouldnt upload it to server. Try again uploading new picture! "),
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
    // WidgetsBinding.instance.addPostFrameCallback((_) => _refreshUser());
    //final userId = ModalRoute.of(context).settings.arguments as String;
    final dynamic userData = Provider.of<UserProfiles>(context, listen: false);
    final crops =  userData.items;

    return Consumer<Auth>(
        builder: (ctx, auth, _) => new Scaffold(
            appBar: new AppBar(
              title: Row(
                children: <Widget>[new Text("My Profile")],
              ),
              elevation: 4.0,
            ),
            body: new Container(
              child: auth.isAuth
                  ? ListView.builder(
                      itemCount: userData.items.length,
                      itemBuilder: (ctx, i) {
                        return new Container(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(10),

                            /* child: ListView.builder(itemCount: userData.items.length, itemBuilder: 
        (ctx, i) => ProfilePageItem(userData.items[i]), ), */

                            child: new Container(
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
                                              /* Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 20.0, top: 20.0),
                                                  child: new Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 25.0),
                                                        child: new Text(
                                                            'MY PROFILE',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20.0,
                                                                fontFamily:
                                                                    'sans-serif-light',
                                                                color: Colors
                                                                    .black)),
                                                      )
                                                    ],
                                                  )), */
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10.0),
                                                child: new Stack(
                                                    fit: StackFit.loose,
                                                    children: <Widget>[
                                                      new Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          new Container(
                                                              width: 250.0,
                                                              height: 220.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                //border: Border.all(width: 1, color: Colors.grey),
                                                                image:
                                                                    DecorationImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image: _storedImage !=
                                                                          null
                                                                      ? FileImage(
                                                                          _storedImage,
                                                                          scale:
                                                                              10,
                                                                          /* fit: BoxFit.cover,
                              width: double.infinity ,*/
                                                                        )
                                                                       : crops[i].userImageUrl != 'null'
                                                                          ? NetworkImage(
                                                                              crops[i].userImageUrl,
                                                                            )
                                                                          : NetworkImage(
                                                                              "$apiurl/images/folder/buyer.jpg",
                                                                              scale: 0.5),
                                                                ),
                                                                /*      borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            70.0),
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 10.0,
                                                                ), */
                                                              ),
                                                              alignment:
                                                                  Alignment
                                                                      .center),
                                                        ],
                                                      ),
                                                    ]),
                                              )
                                            ],
                                          ),
                                        ),
                                        new Container(
                                          height: 25,
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 1.0, left: 120.0),
                                              child: new Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  FlatButton.icon(
                                                    padding: EdgeInsets.only(
                                                        left: 94.0),

                                                    icon: Icon(Icons.camera),
                                                    label: Text('Edit Picture'),
                                                    // textColor: Colors.blueGrey,
                                                    onPressed: () {
                                                      _showSelectionDialog(
                                                          context);
                                                         
                                                    },
                                                  ),
                                                ],
                                              )),
                                        ),
                                        new Container(
                                          color: Color(0xffFFFFFF),
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 25.0),
                                            child: new Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 25.0,
                                                        right: 25.0,
                                                        top: 25.0),
                                                    child: new Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: <Widget>[
                                                        new Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            new Text(
                                                              'Personal Information',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                        new Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            _status
                                                                ? _getEditIcon()
                                                                : new Container(),
                                                          ],
                                                        )
                                                      ],
                                                    )),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 25.0,
                                                        right: 25.0,
                                                        top: 25.0),
                                                    child: new Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: <Widget>[
                                                        new Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            new Text(
                                                              'First Name',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 2.0),
                                                  child: new Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: <Widget>[
                                                      new Flexible(
                                                        child:
                                                            new TextFormField(
                                                          initialValue:
                                                              '${userData.items[0].userFirstname}',
                                                          // controller:
                                                          //_firstNameController
                                                          //..text =
                                                          //  '${userData.items[0].userFirstname}',
                                                          decoration:
                                                              const InputDecoration(
                                                            hintText:
                                                                "Enter Your First Name",
                                                          ),
                                                          enabled: !_status,
                                                          //autofocus: !_status,
                                                          onSaved: (value) {
                                                            setState(() {
                                                              _editUser
                                                                      .userFirstname =
                                                                  value;
                                                              final user =
                                                                  UserProfieItem(
                                                                id: '${userData.items[0].id}',
                                                                userId:
                                                                    '${userData.items[0].userId}',
                                                                userImageUrl:
                                                                _storedImage == null? 
                                                                    '${userData.items[0].userImageUrl}' : null,
                                                                userFirstname:
                                                                    value,
                                                                userLastname: _editUser
                                                                            .userLastname !=
                                                                        null
                                                                    ? _editUser
                                                                        .userLastname
                                                                    : '${userData.items[0].userLastname}',
                                                                userType: _editUser
                                                                        .userType
                                                                        .isNotEmpty
                                                                    ? _editUser
                                                                        .userType
                                                                    : '${userData.items[0].userType}',
                                                                userEmail: _editUser
                                                                            .userEmail !=
                                                                        null
                                                                    ? _editUser
                                                                        .userEmail
                                                                    : '${userData.items[0].userEmail}',
                                                                countryDialCode:
                                                                    _myDialCode !=
                                                                            null
                                                                        ? _myDialCode
                                                                        : '${userData.items[0].countryDialCode}',
                                                                userMobile: _editUser
                                                                            .userMobile !=
                                                                        null
                                                                    ? _editUser
                                                                        .userMobile
                                                                    : '${userData.items[0].userMobile}',
                                                                userVillage: _editUser
                                                                            .userVillage !=
                                                                        null
                                                                    ? _editUser
                                                                        .userVillage
                                                                    : '${userData.items[0].userVillage}',
                                                                userCountry:
                                                                    _myCountry !=
                                                                            null
                                                                        ? _myCountry
                                                                        : '${userData.items[0].userCountry}',
                                                                userCity: _myCity !=
                                                                        null
                                                                    ? _myCity
                                                                    : '${userData.items[0].userCity}',
                                                                userState: _myState !=
                                                                        null
                                                                    ? _myState
                                                                    : '${userData.items[0].userState}',
                                                                userCrops: _editUser
                                                                            .userCrops !=
                                                                        null
                                                                    ? _editUser
                                                                        .userCrops
                                                                    : '${userData.items[0].userCrops}',
                                                              );

                                                              _editUser = user;
                                                            });
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
                                                        left: 25.0,
                                                        right: 25.0,
                                                        top: 25.0),
                                                    child: new Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: <Widget>[
                                                        new Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            new Text(
                                                              'Last Name',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 2.0),
                                                  child: new Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: <Widget>[
                                                      new Flexible(
                                                        child:
                                                            new TextFormField(
                                                          initialValue:
                                                              '${userData.items[0].userLastname}',
                                                          //controller:
                                                          // _lastNameController
                                                          //  ..text =
                                                          //    '${userData.items[0].userLastname}',
                                                          decoration:
                                                              const InputDecoration(
                                                            hintText:
                                                                "Enter Your Last Name",
                                                          ),
                                                          enabled: !_status,
                                                          //autofocus: !_status,
                                                          onSaved: (value) {
                                                            setState(() {
                                                              _editUser
                                                                      .userLastname =
                                                                  value;
                                                              final user =
                                                                  UserProfieItem(
                                                                id: '${userData.items[0].id}',
                                                                userId:
                                                                    '${userData.items[0].userId}',
                                                               userImageUrl:
                                                                _storedImage == null? 
                                                                    '${userData.items[0].userImageUrl}' : null,
                                                                userFirstname: _editUser
                                                                            .userFirstname !=
                                                                        null
                                                                    ? _editUser
                                                                        .userFirstname
                                                                    : '${userData.items[0].userFirstname}',
                                                                userLastname:
                                                                    value,
                                                                userType: _editUser
                                                                        .userType
                                                                        .isNotEmpty
                                                                    ? _editUser
                                                                        .userType
                                                                    : '${userData.items[0].userType}',
                                                                userEmail: _editUser
                                                                            .userEmail !=
                                                                        null
                                                                    ? _editUser
                                                                        .userEmail
                                                                    : '${userData.items[0].userEmail}',
                                                                countryDialCode:
                                                                    _myDialCode !=
                                                                            null
                                                                        ? _myDialCode
                                                                        : '${userData.items[0].countryDialCode}',
                                                                userMobile: _editUser
                                                                            .userMobile !=
                                                                        null
                                                                    ? _editUser
                                                                        .userMobile
                                                                    : '${userData.items[0].userMobile}',
                                                                userVillage: _editUser
                                                                            .userVillage !=
                                                                        null
                                                                    ? _editUser
                                                                        .userVillage
                                                                    : '${userData.items[0].userVillage}',
                                                                userCountry:
                                                                    _myCountry !=
                                                                            null
                                                                        ? _myCountry
                                                                        : '${userData.items[0].userCountry}',
                                                                userCity: _myCity !=
                                                                        null
                                                                    ? _myCity
                                                                    : '${userData.items[0].userCity}',
                                                                userState: _myState !=
                                                                        null
                                                                    ? _myState
                                                                    : '${userData.items[0].userState}',
                                                                userCrops: _editUser
                                                                            .userCrops !=
                                                                        null
                                                                    ? _editUser
                                                                        .userCrops
                                                                    : '${userData.items[0].userCrops}',
                                                              );

                                                              _editUser = user;
                                                            });
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
                                                        left: 25.0,
                                                        right: 25.0,
                                                        top: 25.0),
                                                    child: new Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: <Widget>[
                                                        new Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            new Text(
                                                              'Email ID',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 2.0),
                                                  child: new Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: <Widget>[
                                                      new Flexible(
                                                        child:
                                                            new TextFormField(
                                                          initialValue:
                                                              '${userData.items[0].userEmail}',
                                                          //controller:
                                                          //  _userEmailController
                                                          //  ..text =
                                                          //    '${userData.items[0].userEmail}',
                                                          decoration:
                                                              const InputDecoration(
                                                                  hintText:
                                                                      "Enter Email ID"),
                                                          enabled: !_status,
                                                          onSaved: (value) {
                                                            setState(() {
                                                              _editUser
                                                                      .userEmail =
                                                                  value;
                                                              final user =
                                                                  UserProfieItem(
                                                                id: '${userData.items[0].id}',
                                                                userId:
                                                                    '${userData.items[0].userId}',
                                                                userImageUrl:
                                                                _storedImage == null? 
                                                                    '${userData.items[0].userImageUrl}' : null,
                                                                userFirstname: _editUser
                                                                            .userFirstname !=
                                                                        null
                                                                    ? _editUser
                                                                        .userFirstname
                                                                    : '${userData.items[0].userFirstname}',
                                                                userLastname: _editUser
                                                                            .userLastname !=
                                                                        null
                                                                    ? _editUser
                                                                        .userLastname
                                                                    : '${userData.items[0].userLastname}',
                                                                userType: _editUser
                                                                        .userType
                                                                        .isNotEmpty
                                                                    ? _editUser
                                                                        .userType
                                                                    : '${userData.items[0].userType}',
                                                                userEmail:
                                                                    value,
                                                                countryDialCode:
                                                                    _myDialCode !=
                                                                            null
                                                                        ? _myDialCode
                                                                        : '${userData.items[0].countryDialCode}',
                                                                userMobile: _editUser
                                                                            .userMobile !=
                                                                        null
                                                                    ? _editUser
                                                                        .userMobile
                                                                    : '${userData.items[0].userMobile}',
                                                                userVillage: _editUser
                                                                            .userVillage !=
                                                                        null
                                                                    ? _editUser
                                                                        .userVillage
                                                                    : '${userData.items[0].userVillage}',
                                                                userCountry:
                                                                    _myCountry !=
                                                                            null
                                                                        ? _myCountry
                                                                        : '${userData.items[0].userCountry}',
                                                                userCity: _myCity !=
                                                                        null
                                                                    ? _myCity
                                                                    : '${userData.items[0].userCity}',
                                                                userState: _myState !=
                                                                        null
                                                                    ? _myState
                                                                    : '${userData.items[0].userState}',
                                                                userCrops: _editUser
                                                                            .userCrops !=
                                                                        null
                                                                    ? _editUser
                                                                        .userCrops
                                                                    : '${userData.items[0].userCrops}',
                                                              );

                                                              _editUser = user;
                                                            });
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
                                                        left: 25.0,
                                                        right: 25.0,
                                                        top: 25.0),
                                                    child: new Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: <Widget>[
                                                        //Dialcode

                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            new Text(
                                                              'Mobile',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 2.0),
                                                  child: new Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Column(
                                                          children: <Widget>[
                                                            DropdownButtonHideUnderline(
                                                              child:
                                                                  ButtonTheme(
                                                                alignedDropdown:
                                                                    true,
                                                                child: SearchableDropdown<
                                                                        String>.single(
                                                                    value:
                                                                        _myDialCode,
                                                                    iconSize:
                                                                        10,
                                                                    icon:
                                                                        (null),
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                    hint: '${userData.items[0].countryDialCode}' !=
                                                                            null
                                                                        ? Text(
                                                                            '${userData.items[0].countryDialCode}')
                                                                        : Text(
                                                                            'Dialing code'),
                                                                    //value: _myDialCode,
                                                                    onChanged:
                                                                        (dynamic
                                                                            newValue) {
                                                                      setState(
                                                                          () {
                                                                        _myDialCode =
                                                                            newValue;
                                                                        return _editUser.countryDialCode =
                                                                            _myDialCode;
                                                                      });
                                                                    },
                                                                    items: countriesDialcodeList?.map((dynamic
                                                                            item) {
                                                                          return DropdownMenuItem(
                                                                            child:
                                                                                new Text(item),
                                                                            value:
                                                                                item.toString(),
                                                                          );
                                                                        })?.toList() ??
                                                                        []),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      new Flexible(
                                                        child:
                                                            new TextFormField(
                                                          initialValue:
                                                              '${userData.items[0].userMobile}',
                                                          // controller:
                                                          //   _userMobileController
                                                          //   ..text =
                                                          //     '${userData.items[0].userMobile}',
                                                          decoration:
                                                              const InputDecoration(
                                                                  hintText:
                                                                      "Enter Mobile Number"),
                                                          enabled: !_status,
                                                          onSaved: (value) {
                                                            setState(() {
                                                              _editUser
                                                                      .userMobile =
                                                                  value;
                                                              final user =
                                                                  UserProfieItem(
                                                                id: '${userData.items[0].id}',
                                                                userId:
                                                                    '${userData.items[0].userId}',
                                                                userImageUrl:
                                                                _storedImage == null? 
                                                                    '${userData.items[0].userImageUrl}' : null,
                                                                userFirstname: _editUser
                                                                            .userFirstname !=
                                                                        null
                                                                    ? _editUser
                                                                        .userFirstname
                                                                    : '${userData.items[0].userFirstname}',
                                                                userLastname: _editUser
                                                                            .userLastname !=
                                                                        null
                                                                    ? _editUser
                                                                        .userLastname
                                                                    : '${userData.items[0].userLastname}',
                                                                userType: _editUser
                                                                        .userType
                                                                        .isNotEmpty
                                                                    ? _editUser
                                                                        .userType
                                                                    : '${userData.items[0].userType}',
                                                                userEmail: _editUser
                                                                            .userEmail !=
                                                                        null
                                                                    ? _editUser
                                                                        .userEmail
                                                                    : '${userData.items[0].userEmail}',
                                                                userVillage: _editUser
                                                                            .userVillage !=
                                                                        null
                                                                    ? _editUser
                                                                        .userVillage
                                                                    : '${userData.items[0].userVillage}',
                                                                countryDialCode:
                                                                    _myDialCode !=
                                                                            null
                                                                        ? _myDialCode
                                                                        : '${userData.items[0].countryDialCode}',
                                                                userMobile:
                                                                    value,
                                                                userCountry:
                                                                    _myCountry !=
                                                                            null
                                                                        ? _myCountry
                                                                        : '${userData.items[0].userCountry}',
                                                                userCity: _myCity !=
                                                                        null
                                                                    ? _myCity
                                                                    : '${userData.items[0].userCity}',
                                                                userState: _myState !=
                                                                        null
                                                                    ? _myState
                                                                    : '${userData.items[0].userState}',
                                                                userCrops: _editUser
                                                                            .userCrops !=
                                                                        null
                                                                    ? _editUser
                                                                        .userCrops
                                                                    : '${userData.items[0].userCrops}',
                                                              );

                                                              _editUser = user;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: 230.0,
                                                  height: 1.0,
                                                  color: Colors.grey[400],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 20.0,
                                                      bottom: 20.0,
                                                      left: 25.0,
                                                      right: 25.0),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Text(
                                                            'User Type',
                                                            style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      DropdownButton<String>(
                                                        hint: '${userData.items[0].userType}'
                                                                .isNotEmpty
                                                            ? Text(
                                                                '${userData.items[0].userType}')
                                                            : Text(
                                                                'Please choose what you are'), // Not necessary for Option 1
                                                        //value: _selectedUserType,

                                                        value:
                                                            _selectedUserType,
                                                        onChanged:
                                                            (String newValue) {
                                                          setState(() {
                                                            _selectedUserType =
                                                                newValue;
                                                            final user =
                                                                UserProfieItem(
                                                              id: '${userData.items[0].id}',
                                                              userId:
                                                                  '${userData.items[0].userId}',
                                                              userImageUrl:
                                                                _storedImage == null? 
                                                                    '${userData.items[0].userImageUrl}' : null,
                                                              userFirstname: _editUser
                                                                          .userFirstname !=
                                                                      null
                                                                  ? _editUser
                                                                      .userFirstname
                                                                  : '${userData.items[0].userFirstname}',
                                                              userLastname: _editUser
                                                                          .userLastname !=
                                                                      null
                                                                  ? _editUser
                                                                      .userLastname
                                                                  : '${userData.items[0].userLastname}',
                                                              userType:
                                                                  _selectedUserType,
                                                              userEmail: _editUser
                                                                          .userEmail !=
                                                                      null
                                                                  ? _editUser
                                                                      .userEmail
                                                                  : '${userData.items[0].userEmail}',
                                                              countryDialCode:
                                                                  _myDialCode !=
                                                                          null
                                                                      ? _myDialCode
                                                                      : '${userData.items[0].countryDialCode}',
                                                              userMobile: _editUser
                                                                          .userMobile !=
                                                                      null
                                                                  ? _editUser
                                                                      .userMobile
                                                                  : '${userData.items[0].userMobile}',
                                                              userVillage: _editUser
                                                                          .userVillage !=
                                                                      null
                                                                  ? _editUser
                                                                      .userVillage
                                                                  : '${userData.items[0].userVillage}',
                                                              userCountry:
                                                                  _myCountry !=
                                                                          null
                                                                      ? _myCountry
                                                                      : '${userData.items[0].userCountry}',
                                                              userCity: _myCity !=
                                                                      null
                                                                  ? _myCity
                                                                  : '${userData.items[0].userCity}',
                                                              userState: _myState !=
                                                                      null
                                                                  ? _myState
                                                                  : '${userData.items[0].userState}',
                                                              userCrops: _editUser
                                                                          .userCrops !=
                                                                      null
                                                                  ? _editUser
                                                                      .userCrops
                                                                  : '${userData.items[0].userCrops}',
                                                            );

                                                            _editUser = user;
                                                            //return _authData['userType'] = _selectedUserType;

                                                            // return _editUser.userType = _selectedUserType;
                                                          });
                                                        },
                                                        items: _userType
                                                            .map((userType) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            child: new Text(
                                                                userType),
                                                            value: userType,
                                                          );
                                                        }).toList(),
                                                        icon: Icon(
                                                          FontAwesomeIcons.user,
                                                          color: Colors.black,
                                                          size: 22.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                //Countries
                                                Container(
                                                  height: 1.0,
                                                  color: Colors.grey[400],
                                                ),

                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 25.0,
                                                        right: 25.0,
                                                        top: 25.0),
                                                    child: new Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: <Widget>[
                                                        new Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            new Text(
                                                              'Country',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )),

                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 25.0),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 70.0,
                                                    child: new Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Expanded(
                                                          child:
                                                              DropdownButtonHideUnderline(
                                                            child: ButtonTheme(
                                                              alignedDropdown:
                                                                  true,
                                                              child: SearchableDropdown<
                                                                  String>.single(
                                                                value:
                                                                    _myCountry,
                                                                iconSize: 30,
                                                                icon: (null),
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 16,
                                                                ),
                                                                hint: '${userData.items[0].userCountry}' !=
                                                                        null
                                                                    ? Text(
                                                                        '${userData.items[0].userCountry}')
                                                                    : Text(
                                                                        'Please choose you Country'),
                                                                onChanged: (String
                                                                    newValue) {
                                                                  setState(() {
                                                                    _myCountry =
                                                                        newValue;

                                                                    final user =
                                                                        UserProfieItem(
                                                                      id: '${userData.items[0].id}',
                                                                      userId:
                                                                          '${userData.items[0].userId}',
                                                                    userImageUrl:
                                                                _storedImage == null? 
                                                                    '${userData.items[0].userImageUrl}' : null,
                                                                      userFirstname: _editUser.userFirstname !=
                                                                              null
                                                                          ? _editUser
                                                                              .userFirstname
                                                                          : '${userData.items[0].userFirstname}',
                                                                      userLastname: _editUser.userLastname !=
                                                                              null
                                                                          ? _editUser
                                                                              .userLastname
                                                                          : '${userData.items[0].userLastname}',
                                                                      userType: _editUser
                                                                              .userType
                                                                              .isNotEmpty
                                                                          ? _editUser
                                                                              .userType
                                                                          : '${userData.items[0].userType}',
                                                                      userEmail: _editUser.userEmail !=
                                                                              null
                                                                          ? _editUser
                                                                              .userEmail
                                                                          : '${userData.items[0].userEmail}',
                                                                      countryDialCode: _myDialCode !=
                                                                              null
                                                                          ? _myDialCode
                                                                          : '${userData.items[0].countryDialCode}',
                                                                      userMobile: _editUser.userMobile !=
                                                                              null
                                                                          ? _editUser
                                                                              .userMobile
                                                                          : '${userData.items[0].userMobile}',
                                                                      userVillage: _editUser.userVillage !=
                                                                              null
                                                                          ? _editUser
                                                                              .userVillage
                                                                          : '${userData.items[0].userVillage}',
                                                                      userCountry:
                                                                          newValue,
                                                                      userCity: _myCity !=
                                                                              null
                                                                          ? _myCity
                                                                          : '${userData.items[0].userCity}',
                                                                      userState: _myState !=
                                                                              null
                                                                          ? _myState
                                                                          : '${userData.items[0].userState}',
                                                                      userCrops: _editUser.userCrops !=
                                                                              null
                                                                          ? _editUser
                                                                              .userCrops
                                                                          : '${userData.items[0].userCrops}',
                                                                    );
                                                                    _getStatesList(
                                                                        newValue);
                                                                    _editUser =
                                                                        user;

                                                                    // return _editUser.userState = _myState;
                                                                  });
                                                                },
                                                                items: countriesList?.map(
                                                                        (dynamic
                                                                            item) {
                                                                      return new DropdownMenuItem(
                                                                        child: new Text(
                                                                            item),
                                                                        value: item
                                                                            .toString(),
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
                                                ),
                                                //States
                                                Container(
                                                  height: 1.0,
                                                  color: Colors.grey[400],
                                                ),

                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 25.0,
                                                        right: 25.0,
                                                        top: 25.0),
                                                    child: new Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: <Widget>[
                                                        new Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            new Text(
                                                              'State',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )),

                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 25.0),
                                                  child: Container(
                                                    height: 70.0,
                                                    child: new Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Expanded(
                                                          child:
                                                              DropdownButtonHideUnderline(
                                                            child: ButtonTheme(
                                                              alignedDropdown:
                                                                  true,
                                                              child: SearchableDropdown<
                                                                  String>.single(
                                                                value: _myState,
                                                                iconSize: 30,
                                                                icon: (null),
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 16,
                                                                ),
                                                                hint: '${userData.items[0].userState}' !=
                                                                        null
                                                                    ? Text(
                                                                        '${userData.items[0].userState}')
                                                                    : Text(
                                                                        'Please choose you State'),
                                                                onChanged: (String
                                                                    newValue) {
                                                                  setState(() {
                                                                    _myState =
                                                                        newValue;

                                                                    final user =
                                                                        UserProfieItem(
                                                                      id: '${userData.items[0].id}',
                                                                      userId:
                                                                          '${userData.items[0].userId}',
                                                                     userImageUrl:
                                                                _storedImage == null? 
                                                                    '${userData.items[0].userImageUrl}' : null,
                                                                      userFirstname: _editUser.userFirstname !=
                                                                              null
                                                                          ? _editUser
                                                                              .userFirstname
                                                                          : '${userData.items[0].userFirstname}',
                                                                      userLastname: _editUser.userLastname !=
                                                                              null
                                                                          ? _editUser
                                                                              .userLastname
                                                                          : '${userData.items[0].userLastname}',
                                                                      userType: _editUser
                                                                              .userType
                                                                              .isNotEmpty
                                                                          ? _editUser
                                                                              .userType
                                                                          : '${userData.items[0].userType}',
                                                                      userEmail: _editUser.userEmail !=
                                                                              null
                                                                          ? _editUser
                                                                              .userEmail
                                                                          : '${userData.items[0].userEmail}',
                                                                      countryDialCode: _myDialCode !=
                                                                              null
                                                                          ? _myDialCode
                                                                          : '${userData.items[0].countryDialCode}',
                                                                      userMobile: _editUser.userMobile !=
                                                                              null
                                                                          ? _editUser
                                                                              .userMobile
                                                                          : '${userData.items[0].userMobile}',
                                                                      userVillage: _editUser.userVillage !=
                                                                              null
                                                                          ? _editUser
                                                                              .userVillage
                                                                          : '${userData.items[0].userVillage}',
                                                                      userCountry: _myCountry !=
                                                                              null
                                                                          ? _myCountry
                                                                          : '${userData.items[0].userCountry}',
                                                                      userCity:
                                                                          '${userData.items[0].userCity}',
                                                                      userState:
                                                                          newValue,
                                                                      userCrops: _editUser.userCrops !=
                                                                              null
                                                                          ? _editUser
                                                                              .userCrops
                                                                          : '${userData.items[0].userCrops}',
                                                                    );
                                                                    _getCitiesList(
                                                                        newValue);
                                                                    _editUser =
                                                                        user;

                                                                    // return _editUser.userState = _myState;
                                                                  });
                                                                },
                                                                items: statesList?.map(
                                                                        (dynamic
                                                                            item) {
                                                                      return new DropdownMenuItem(
                                                                        child: new Text(
                                                                            item['state_name']),
                                                                        value: item['state_name']
                                                                            .toString(),
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
                                                ),
                                                Container(
                                                  height: 1.0,
                                                  color: Colors.grey[400],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 25.0,
                                                        right: 25.0,
                                                        top: 25.0),
                                                    child: new Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: <Widget>[
                                                        new Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            new Text(
                                                              'City',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 25.0,
                                                        right: 25.0,
                                                        top: 25.0),
                                                    child: Container(
                                                      height: 70.0,
                                                      child: new Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Expanded(
                                                            child:
                                                                DropdownButtonHideUnderline(
                                                              child:
                                                                  ButtonTheme(
                                                                alignedDropdown:
                                                                    true,
                                                                child: SearchableDropdown<
                                                                    String>.single(
                                                                  value:
                                                                      _myCity,
                                                                  iconSize: 30,
                                                                  icon: (null),
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                  hint: '${userData.items[0].userCity}' !=
                                                                          null
                                                                      ? Text(
                                                                          '${userData.items[0].userCity}')
                                                                      : Text(
                                                                          'Please choose you City'),
                                                                  onChanged: (String
                                                                      newValue) {
                                                                    setState(
                                                                        () {
                                                                      _myCity =
                                                                          newValue;
                                                                      final user =
                                                                          UserProfieItem(
                                                                        id: '${userData.items[0].id}',
                                                                        userId:
                                                                            '${userData.items[0].userId}',
                                                                        userImageUrl:
                                                                _storedImage == null? 
                                                                    '${userData.items[0].userImageUrl}' : null,
                                                                        userFirstname: _editUser.userFirstname !=
                                                                                null
                                                                            ? _editUser.userFirstname
                                                                            : '${userData.items[0].userFirstname}',
                                                                        userLastname: _editUser.userLastname !=
                                                                                null
                                                                            ? _editUser.userLastname
                                                                            : '${userData.items[0].userLastname}',
                                                                        userType: _editUser.userType.isNotEmpty
                                                                            ? _editUser.userType
                                                                            : '${userData.items[0].userType}',
                                                                        userEmail: _editUser.userEmail !=
                                                                                null
                                                                            ? _editUser.userEmail
                                                                            : '${userData.items[0].userEmail}',
                                                                        countryDialCode: _myDialCode !=
                                                                                null
                                                                            ? _myDialCode
                                                                            : '${userData.items[0].countryDialCode}',
                                                                        userMobile: _editUser.userMobile !=
                                                                                null
                                                                            ? _editUser.userMobile
                                                                            : '${userData.items[0].userMobile}',
                                                                        userVillage:
                                                                            '${userData.items[0].userVillage}',
                                                                        userCountry: _myCountry !=
                                                                                null
                                                                            ? _myCountry
                                                                            : '${userData.items[0].userCountry}',
                                                                        userCity:
                                                                            _myCity,
                                                                        userState: _myState !=
                                                                                null
                                                                            ? _myState
                                                                            : '${userData.items[0].userState}',
                                                                        userCrops: _editUser.userCrops !=
                                                                                null
                                                                            ? _editUser.userCrops
                                                                            : '${userData.items[0].userCrops}',
                                                                      );

                                                                      _editUser =
                                                                          user;
                                                                      // return _editUser.userCity = _myCity;
                                                                    });
                                                                  },
                                                                  items: citiesList?.map(
                                                                          (dynamic
                                                                              item) {
                                                                        return new DropdownMenuItem(
                                                                          child:
                                                                              new Text(item['city_name']),
                                                                          value:
                                                                              item['city_name'].toString(),
                                                                        );
                                                                      })?.toList() ??
                                                                      [],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                Container(
                                                  height: 1.0,
                                                  color: Colors.grey[400],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 25.0,
                                                        right: 25.0,
                                                        top: 25.0),
                                                    child: new Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: <Widget>[
                                                        new Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            new Text(
                                                              'Village',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 2.0),
                                                  child: new Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: <Widget>[
                                                      new Flexible(
                                                        child: TextFormField(
                                                          initialValue:
                                                              '${userData.items[0].userVillage}',
                                                          //controller:
                                                          //  _userVillageController
                                                          //  ..text =
                                                          //    '${userData.items[0].userVillage}',
                                                          decoration:
                                                              const InputDecoration(
                                                                  hintText:
                                                                      "Enter your village name"),
                                                          enabled: !_status,
                                                          onSaved: (value) {
                                                            final user =
                                                                UserProfieItem(
                                                              id: '${userData.items[0].id}',
                                                              userId:
                                                                  '${userData.items[0].userId}',
                                                             userImageUrl:
                                                                _storedImage == null? 
                                                                    '${userData.items[0].userImageUrl}' : null,
                                                              userFirstname: _editUser
                                                                          .userFirstname !=
                                                                      null
                                                                  ? _editUser
                                                                      .userFirstname
                                                                  : '${userData.items[0].userFirstname}',
                                                              userLastname: _editUser
                                                                          .userLastname !=
                                                                      null
                                                                  ? _editUser
                                                                      .userLastname
                                                                  : '${userData.items[0].userLastname}',
                                                              userType: _editUser
                                                                      .userType
                                                                      .isNotEmpty
                                                                  ? _editUser
                                                                      .userType
                                                                  : '${userData.items[0].userType}',
                                                              userEmail: _editUser
                                                                          .userEmail !=
                                                                      null
                                                                  ? _editUser
                                                                      .userEmail
                                                                  : '${userData.items[0].userEmail}',
                                                              countryDialCode:
                                                                  _myDialCode !=
                                                                          null
                                                                      ? _myDialCode
                                                                      : '${userData.items[0].countryDialCode}',
                                                              userMobile: _editUser
                                                                          .userMobile !=
                                                                      null
                                                                  ? _editUser
                                                                      .userMobile
                                                                  : '${userData.items[0].userMobile}',
                                                              userVillage:
                                                                  value,
                                                              userCountry:
                                                                  _myCountry !=
                                                                          null
                                                                      ? _myCountry
                                                                      : '${userData.items[0].userCountry}',
                                                              userCity: _myCity !=
                                                                      null
                                                                  ? _myCity
                                                                  : '${userData.items[0].userCity}',
                                                              userState: _myState !=
                                                                      null
                                                                  ? _myState
                                                                  : '${userData.items[0].userState}',
                                                              userCrops: _editUser
                                                                          .userCrops !=
                                                                      null
                                                                  ? _editUser
                                                                      .userCrops
                                                                  : '${userData.items[0].userCrops}',
                                                            );

                                                            _editUser = user;
                                                            //return _editUser.userVillage = value;
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
                                                        left: 25.0,
                                                        right: 25.0,
                                                        top: 25.0),
                                                    child: new Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: <Widget>[
                                                        new Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            '${userData.items[0].userType}' ==
                                                                    'Farmer' || '${userData.items[0].userType}' ==  'Hobby/DYIFarmer'
                                                                ? Text(
                                                                    'Which crops you can grow?',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16.0,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )
                                                                : ('${userData.items[0].userType}' ==
                                                                        'Buyer'
                                                                    ? new Text(
                                                                        'Which crops you want to buy?',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16.0,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      )
                                                                    : new Text(
                                                                        'Which crops you want to invest in?',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16.0,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ))
                                                          ],
                                                        ),
                                                      ],
                                                    )),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 2.0),
                                                  child: new Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: <Widget>[
                                                      new Flexible(
                                                        child: TextFormField(
                                                          initialValue:
                                                              '${userData.items[0].userCrops}',
                                                          //controller:
                                                          //  _userVillageController
                                                          //  ..text =
                                                          //    '${userData.items[0].userVillage}',
                                                          decoration:
                                                              const InputDecoration(
                                                                  hintText:
                                                                      "Enter your list of crop variety seperated by comma,.."),
                                                          enabled: !_status,
                                                          onSaved: (value) {
                                                            final user =
                                                                UserProfieItem(
                                                              id: '${userData.items[0].id}',
                                                              userId:
                                                                  '${userData.items[0].userId}',
                                                             userImageUrl:
                                                                _storedImage == null? 
                                                                    '${userData.items[0].userImageUrl}' : null,
                                                              userFirstname: _editUser
                                                                          .userFirstname !=
                                                                      null
                                                                  ? _editUser
                                                                      .userFirstname
                                                                  : '${userData.items[0].userFirstname}',
                                                              userLastname: _editUser
                                                                          .userLastname !=
                                                                      null
                                                                  ? _editUser
                                                                      .userLastname
                                                                  : '${userData.items[0].userLastname}',
                                                              userType: _editUser
                                                                      .userType
                                                                      .isNotEmpty
                                                                  ? _editUser
                                                                      .userType
                                                                  : '${userData.items[0].userType}',
                                                              userEmail: _editUser
                                                                          .userEmail !=
                                                                      null
                                                                  ? _editUser
                                                                      .userEmail
                                                                  : '${userData.items[0].userEmail}',
                                                              countryDialCode:
                                                                  _myDialCode !=
                                                                          null
                                                                      ? _myDialCode
                                                                      : '${userData.items[0].countryDialCode}',
                                                              userMobile: _editUser
                                                                          .userMobile !=
                                                                      null
                                                                  ? _editUser
                                                                      .userMobile
                                                                  : '${userData.items[0].userMobile}',
                                                              userVillage: _editUser
                                                                          .userVillage !=
                                                                      null
                                                                  ? _editUser
                                                                      .userVillage
                                                                  : '${userData.items[0].userVillage}',
                                                              userCountry:
                                                                  _myCountry !=
                                                                          null
                                                                      ? _myCountry
                                                                      : '${userData.items[0].userCountry}',
                                                              userCity: _myCity !=
                                                                      null
                                                                  ? _myCity
                                                                  : '${userData.items[0].userCity}',
                                                              userState: _myState !=
                                                                      null
                                                                  ? _myState
                                                                  : '${userData.items[0].userState}',
                                                              userCrops: value,
                                                            );

                                                            _editUser = user;
                                                            //return _editUser.userVillage = value;
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
                                                !_status
                                                    ? _getActionButtons()
                                                    : new Container(),
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
                      })
                  : Banner(),
            )));
  }

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
          return AlertDialog(
            title: Text("Image Saved"),
            content: Text("Your Image has been saved."),
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
        });
  }

  Widget _uploadImage() {
    return AlertDialog(
      title: Text(
        GalleryLocalizations.of(context).imageUpload,
      ),
      content: Text(
        GalleryLocalizations.of(context).imageUploadDialogue,
      ),
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
            Navigator.pushReplacementNamed(context, '/main_home_screen');
          },
        ),
      ],
    );
  }
}
