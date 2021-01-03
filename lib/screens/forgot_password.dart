import 'package:flutter/material.dart';
import '../providers/user_profiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/apiClass.dart';

class  ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgot-password';
  @override

final apiurl = AppApi.api;

  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
  
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final _form = GlobalKey<FormState>();

  var _editUser = UserProfieItem(
    id: null, 
    userEmail: '',
 
   );
 var _isLoading = false;
  @override
String userEmail;
  bool _status = true;
final FocusNode myFocusNode = FocusNode();

Future<void> _saveForm() async {
setState(() {
  _isLoading = true;
});

if(_editUser.userEmail != null){
await Provider.of<UserProfiles>(context, listen: false).updatePassword(_editUser.userEmail, _editUser);;


  {
await showDialog<void>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("Please check your mail"),
                content: Text("A mail has been sent to your given mail id. Please follow instructions in mail to reset your password."),
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
    return Scaffold(
      appBar: AppBar(title: Text('Reset your Password'),),
      body: Container(
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
                                  //controller:  _userEmailController..text = '${userData.items[0].userEmail}',
                                  decoration: const InputDecoration(
                                    
                                      hintText: "Enter Email ID"),
                                  //enabled: !_status,
                                  onChanged: (value){
                                    final user = UserProfieItem(
                                      
                                      userEmail: value,
                                     
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

