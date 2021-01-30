import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/http_extension.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../style/theme.dart' as Theme;
import '../providers/auth.dart';
import 'package:provider/provider.dart';
import '../utils/bubble_indication_painter.dart';
import './user_profile_screen.dart';
import './main_home_screen.dart';

enum AuthMode { Signup, Login }
class AuthCard extends StatefulWidget {
  AuthCard({Key key}) : super(key: key);

  static const routeName = '/login';

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
 final _form = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey1 = GlobalKey();
  final GlobalKey<FormState> _formKey2 = GlobalKey();
AuthMode _authMode = AuthMode.Login;
Map<String, String> _authData = {
    'email': '',
    'password': '',
    'firstName':'',
     'lastName':'',
     'userType':'',
     'userMobile':''
  };

  

List<String> _userType = ['Farmer', 
'Buyer', 
'Investor',
'Hobby/DYIFarmer',  
 ]; // Option 2
   String _selectedUserType;
  var _isLoading = false;
  final _passwordController = TextEditingController();
  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();
  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  //TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController =
      new TextEditingController();

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

Future<void> _showErrorDialog(String message){
   return  showDialog(context: context, 
     builder: (ctx) => AlertDialog(
      title: Text('There is an Error occured'), 
      content: Text(message),
      actions: <Widget>[
        FlatButton(
         
          child: Text('Okay'),
           onPressed: (){
             setState(() {
      _isLoading = false;
    });
             Navigator.of(ctx).pop();
             }, )
      ],
      ),
      );

  }

  Future<void> _showSucessDialog(String message){
    
  return showDialog(context: context, 
     builder: (ctx) => AlertDialog(
      title: Text('Sucess'), 
      content: Text(message),
      actions: <Widget>[
        FlatButton(
         
          child: Text('Okay'),
           onPressed: (){
              
             //_userProfilePage();
           Navigator.of(ctx).pushReplacementNamed('/main_home_screen');
           // Navigator.push<dynamic>(context, MaterialPageRoute<dynamic>(builder: (_) => MainHomePage()));
           setState(() {
           
           
      _isLoading = false;
    }); 
             }, ),
             
             
      ],
      ),
      );

  }

    Future<void> _showSucessLoginDialog(String message){
      
  return showDialog(context: context, 
     builder: (ctx) => AlertDialog(
      title: Text('Sucess'), 
      content: Text(message),
      actions: <Widget>[
        
        FlatButton(
         
          child: Text('Okay'),
          
           onPressed: (){
            
            
            Navigator.of(ctx).pushReplacementNamed('/main_home_screen');
             /*      setState(() {
      _isLoading = false;
    });  */
             }, 
             )
      ],
      ),
      );

  }

//FB login
  Future<void> _fbLoginSubmit() async {
     setState(() {
      _isLoading = true;
    });
 await  Provider.of<Auth>(context, listen: false).loginWithFB(context);
 setState(() {
      _isLoading = false;
      Navigator.of(context).pop('Login sucess');
    });
 return ;
 //return Navigator.push(context, MaterialPageRoute(builder: (_) => GuestHomeScreen()));
 
/* setState(() {
      _isLoading = true;
    });
 */


 
  }

void _userProfilePage(){

dynamic userData = Provider.of<Auth>(context, listen: false);
/* Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SecondRoute()),
  ); */
 Navigator.pushReplacementNamed(context, '/user-profile-screen', arguments: userData.userId);
  }
   

  //FirebaseLogin
  Future<dynamic> _submit() async {

    dynamic isValid;

    if (_authMode == AuthMode.Login){
      isValid =  _formKey1.currentState.validate();
      _formKey1.currentState.save();} 
      else {
        isValid = _formKey2.currentState.validate();
        _formKey2.currentState.save();
      }
    
    if(!isValid){
      return;
    }



    setState(() {
      _isLoading = true;
    });
    try{
if (_authMode == AuthMode.Login) {
      // Log user in
   final dynamic auth = await Provider.of<Auth>(context, listen: false).login(_authData['email'], _authData['password'],      
    
      );
       
     var message = 'You have sucessfully logged in.';
     _showSucessLoginDialog(message);
 
 /* auth['userType'] == 'Farmer' ?  
            Navigator.pushNamed(context, '/farmer_home_screen') 
            : auth['userType'] == 'Buyer' ? 
           Navigator.pushNamed(context, '/buyer_home_screen'): Navigator.pushNamed(context, '/investor_home_screen');
           */
  /* setState(() {
      
    
             _isLoading = false;
             //Navigator.of(context).pop('Login sucess');
     
     //Navigator.push<dynamic>(context, MaterialPageRoute<dynamic>(builder: (_) => UserProfileScreen()));
     
    }); */
 
      
      
    } 
    
    
    else {
      // Sign user up
   await Provider.of<Auth>(context, listen: false).signup(_authData['email'], _authData['password'], _authData['userType'], _authData['userMobile'], _authData['firstName'], _authData['lastName'] 
   
    );
     
      var message = 'Signup sucessful! Welcome to SmartFarmZ. Please complete your profile before we can give you access.';
     _showSucessDialog(message);
   
/* showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Sucessful"),
            content: Text(
                "Signup sucessful! Welcome to SmartFarmZ. Please complete your profile before we can give you access."),
            actions: <Widget>[
              FlatButton(
                child: Text("Okay"),
                onPressed: () {
               return Navigator.pushReplacementNamed(context, '/user-profile-screen_new');
                },
              ),
            ],
          ),
        );  */
    }
     } on HttpException catch(error){
       var errorMessage = 'Authentication failed';
       if(error.message.contains('emailid already exists')){
       return _showErrorDialog('EMAIL_EXISTS! Please go to Login or Register with new Email');
       }
       
       else if (error.message.contains('INVALID_EMAIL')){
      return   _showErrorDialog('INVALID_EMAIL');
       }
        else if (error.message.contains('INVALID_PASSWORD')){
      return   _showErrorDialog('INVALID_PASSWORD');
      
        }
         else if (error.message.contains('Username or password is incorrect')){
      return   _showErrorDialog('Username or password is incorrect');
      
         }
       _showErrorDialog(errorMessage);
       } 
       
       
      
     

  /*     _isLoading
              ? CircularProgressIndicator()
              : _isLoading = false; */



//return;

    }
    

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }


  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      //key: _formKey1,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child:  SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height >= 1500.0
                    ? MediaQuery.of(context).size.height
                    : 1500.0,
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        Theme.Colors.loginGradientEnd,
                        Theme.Colors.loginGradientStart
                        
                      ], 
                      
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 75.0),
                      child: new Image(
                          width: 230.0,
                          height: 230.0,
                          fit: BoxFit.fill,
                         //image: new AssetImage('assets/img/Final Logo A.png')),
                         image: new AssetImage('assets/img/SmartFarms.png')),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: _buildMenuBar(context),
                    ),
                    Expanded(
                      flex: 2,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (i) {
                          if (i == 0) {
                            setState(() {
                              right = Colors.white;
                              left = Colors.black;
                            });
                          } else if (i == 1) {
                            setState(() {
                              right = Colors.black;
                              left = Colors.white;
                            });
                          }
                        },
                        children: <Widget>[
                          new ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: _buildSignIn(context),
                          ),
                          new ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: _buildSignUp(context),
                          ),
                          
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    
    );
  }

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  /* void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _formKey.currentState?.removeCurrentSnackBar();
    _formKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
  } */

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Text(
                  "Existing",
                  style: TextStyle(
                      color: left,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "New",
                  style: TextStyle(
                      color: right,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return 
  
    Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Form(
        key: _formKey1,
              child:   
    
  Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              overflow: Overflow.visible,
              children: <Widget>[
                  _isLoading
              ? CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                strokeWidth: 3,
              )
              : 
                Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: 
                  Container(
                    width: 300.0,
                    height: 190.0,
                     
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            //focusNode: myFocusNodeEmailLogin,
                           // controller: loginEmailController,
                            keyboardType: TextInputType.emailAddress,
                             validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                    },
                    onSaved: (String value) {
                      _authData['email'] = value;
                    },
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.envelope,
                                color: Colors.black,
                                size: 22.0,
                              ),
                              hintText: "Email Address",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                            ),
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: myFocusNodePasswordLogin,
                            controller: _passwordController,
                            obscureText: _obscureTextLogin,
                            validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                    },
                    onSaved: (value) {
                      _authData['password'] = value;
                    },
                    
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                size: 22.0,
                                color: Colors.black,
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                              suffixIcon: GestureDetector(
                                onTap: _toggleLogin,
                                child: Icon(
                                  _obscureTextLogin
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 170.0),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Theme.Colors.loginGradientStart,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                      BoxShadow(
                        color: Theme.Colors.loginGradientEnd,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                    ],
                    gradient: new LinearGradient(
                        colors: [
                          Theme.Colors.loginGradientEnd,
                          Theme.Colors.loginGradientStart
                        ],
                        begin: const FractionalOffset(0.2, 0.2),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: 
                 
                  MaterialButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.white,
                      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 42.0),
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 25.0,
                              fontFamily: "WorkSansBold"),
                        ),
                      ),
                      onPressed: 
                        
                          _submit,
                          

                      )
                      
                      ,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/forgot-password');
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: "WorkSansMedium"),
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [
                            Colors.white10,
                            Colors.white,
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    width: 100.0,
                    height: 1.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Text(
                      "Or",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: "WorkSansMedium"),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white10,
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    width: 100.0,
                    height: 1.0,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0, right: 0.0),
                  child: GestureDetector(
                    onTap: _fbLoginSubmit,
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: new Icon(
                        FontAwesomeIcons.facebook,
                        color: Color(0xFF0084ff),
                      ),
                    ),
                  ),
                ),
                /* Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: GestureDetector(
                    onTap: () => showInSnackBar("Google button pressed"),
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: new Icon(
                        FontAwesomeIcons.google,
                        color: Color(0xFF0084ff),
                      ),
                    ),
                  ),
                ), */
              ],
            ),
          ],
        ),
      ),
    );
  }




  

 Widget _buildSignUp(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      
      child:
  
    Form(
        key: _formKey2,
              child:  Column(
              children: <Widget>[
              Stack(
              alignment: Alignment.topCenter,
              overflow: Overflow.visible,
              children: <Widget>[
                      _isLoading
              ? CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                strokeWidth: 3,
              )
              : 
                Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: 300.0,
                    height: 660.0,
                     
                    child:  Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            //focusNode: myFocusNodeEmailLogin,
                           // controller: loginEmailController,
                            keyboardType: TextInputType.text,
                             validator: (value) {
                      if (value.isEmpty) {
                        return 'First name cant be empty';
                      }
                      },
                     onSaved: (String value) {
                      _authData['firstName'] = value;
                      },
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.user,
                                color: Colors.black,
                                size: 22.0,
                              ),
                              hintText: "First Name",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                            ),
                          ),
                        ),
                          Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            //focusNode: myFocusNodeEmailLogin,
                           // controller: loginEmailController,
                            keyboardType: TextInputType.text,
                             validator: (value) {
                      if (value.isEmpty) {
                        return 'Last name cant be empty';
                      }
                      },
                     onSaved: (String value) {
                      _authData['lastName'] = value;
                      },
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.user,
                                color: Colors.black,
                                size: 22.0,
                              ),
                              hintText: "Last Name",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                            ),
                          ),
                        ),
                          Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            //focusNode: myFocusNodeEmailLogin,
                           // controller: loginEmailController,
                            keyboardType: TextInputType.emailAddress,
                             validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                      },
                     onSaved: (String value) {
                      _authData['email'] = value;
                      },
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.envelope,
                                color: Colors.black,
                                size: 22.0,
                              ),
                              hintText: "Email Address",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                            ),
                          ),
                        ),
                        Container(
                          width: 220.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 4.0, right: 25.0),
                          child: Column(
                             children: <Widget>[
                               Row(children: <Widget>[],),
                               DropdownButton<dynamic>(
                                
                                 
              hint: Text('Please choose what you are'), // Not necessary for Option 1
              value: _selectedUserType,
              onChanged: (dynamic newValue) {
                setState(() {
                  _selectedUserType = newValue;
                  return _authData['userType'] = _selectedUserType;
                });
              },
              items: _userType.map((dynamic userType) {
                return DropdownMenuItem<dynamic>(
                  child: new Text(userType),
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

                           Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            //focusNode: myFocusNodeEmailLogin,
                           // controller: loginEmailController,
                            keyboardType: TextInputType.number,
                        /*      validator: (value) {
                      if (value.isEmpty) {
                        return 'Last name cant be empty';
                      }
                      }, */
                     onSaved: (String value) {
                      _authData['userMobile'] = value;
                      },
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              
                              icon: Icon(
                                FontAwesomeIcons.user,
                                color: Colors.black,
                                size: 22.0,
                              ),
                              hintText: "Mobile Number",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                            ),
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),

                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            //focusNode: myFocusNodePasswordLogin,
                            controller: _passwordController,
                            obscureText: _obscureTextSignup,
                            validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                     },
                      onSaved: (value) {
                      _authData['password'] = value;
                      },
                    
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                size: 22.0,
                                color: Colors.black,
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                              suffixIcon: GestureDetector(
                                onTap: _toggleSignup,
                                child: Icon(
                                  _obscureTextSignup
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            //focusNode: myFocusNodePasswordLogin,
                            controller: signupConfirmPasswordController,
                            obscureText: _obscureTextSignupConfirm,
                            validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                          }
                        : null,
                    
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                size: 22.0,
                                color: Colors.black,
                              ),
                              hintText: "Repeat password",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                              suffixIcon: GestureDetector(
                                onTap: _toggleSignupConfirm,
                                child: Icon(
                                  _obscureTextSignupConfirm
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          
                        ),
                        
                      ],
                    ),
                   
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 620.0),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Theme.Colors.loginGradientStart,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                      BoxShadow(
                        color: Theme.Colors.loginGradientEnd,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                    ],
                    gradient: new LinearGradient(
                        colors: [
                          Theme.Colors.loginGradientEnd,
                          Theme.Colors.loginGradientStart
                        ],
                        begin: const FractionalOffset(0.2, 0.2),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: MaterialButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.white,
                      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 42.0),
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 25.0,
                              fontFamily: "WorkSansBold"),
                        ),
                      ),
                      onPressed: _submit,),
                ),
              ],
              ),
                
           
          ],
        ),
      ),
    );
  }
  
  
    Widget _buildProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
        _switchAuthMode();
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
        _switchAuthMode();
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }
}