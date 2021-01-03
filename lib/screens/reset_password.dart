import 'package:flutter/material.dart';
import '../providers/user_profiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/apiClass.dart';

class  ResetPasswordScreen extends StatefulWidget {
  static var routeName = '/reset-password';
  @override

final apiurl = AppApi.api;
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
  
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {

  // Form
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  

  var _editUser = UserProfieItem(
    id: null, 
    userEmail: '',
     newPwd: '',
 
   );
 var _isLoading = false;
  @override
String userEmail;
bool _status = true;
final FocusNode myFocusNode = FocusNode();

 void initState() {
  Future<dynamic>.delayed(Duration.zero).then((dynamic _) async {
      setState(() {
        //_storedImage = File(_imageFile.path);
     
    
       _isLoading = true;
      });
      
  
      await Provider.of<UserProfiles>(context, listen: false);
      
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  } 

Future<void> _saveForm() async {
setState(() {
  _isLoading = true;
});

if(_editUser.userEmail != null){
await Provider.of<UserProfiles>(context, listen: false).resetPassword(_editUser.userEmail, _editUser);
await Provider.of<Auth>(context, listen: false).logout();

  {
await showDialog<void>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("Please login again"),
                content: Text("Your password has been sucessfuly reset. Please use new password to login"),
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
      final dynamic userData = Provider.of<Auth>(context);
      userEmail = '${userData.userEmail}';
    return Scaffold(
      appBar: AppBar(title: Text('Reset your Password'),),
      body: Container(
        child: Form(
          key: _form,
          child: Column(
          children: <Widget>[
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
                                    'New Password',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )
                          ),
                          
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new TextFormField(
                                  controller: _pass,
                                  validator: (val){
                              if(val.isEmpty)
                                   return 'Value cannot be empty';
                              return null;
                              },
                                  //controller:  _userEmailController..text = '${userData.items[0].userEmail}',
                                  decoration: const InputDecoration(
                                    
                                      hintText: "Enter New Password"),
                                  //enabled: !_status,
                                 /*  onChanged: (value){
                                    final user = UserProfieItem(
                                      
                                      userEmail: value,
                                     
                                      );

                                      _editUser = user;

                                  }, */
                                ),
                              ),
                            ],
                          ),
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
                                    'Repeat New Password',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )
                          ),
                          
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new TextFormField(
                                  controller: _confirmPass,
                                  validator: (value){
                              if(value.isEmpty){
                                   return 'Value cannot be Empty';}
                              if(value != _pass.text){
                                   return 'Password doesnt Match';}
                              return null;
                              },
                                  //controller:  _userEmailController..text = '${userData.items[0].userEmail}',
                                  decoration: const InputDecoration(
                                    
                                      hintText: "Repeat New Password"),
                                  //enabled: !_status,
                                  onChanged: (value){
                                    final user = UserProfieItem(
                                      
                                      //userEmail: _editUser.userEmail,
                                      newPwd: value,
                                      userEmail : userEmail,
                                      );

                                      _editUser = user;

                                  },
                                ),
                              ),
                            ],
                          ),
                          ),

                          
                          _getActionButtons(),
          ],
      ),
      ),
      ),
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
                child: new Text("Submit"),
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
          
        ],
      ),
    );
  }
}

