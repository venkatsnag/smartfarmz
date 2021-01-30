
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../providers/apiClass.dart';
import '../providers/chats.dart';
import '../providers/user_profiles.dart';
import 'package:provider/provider.dart';

class  ContactUsItem {
String name;
String email;
String message;




  ContactUsItem({
  this.name,  
  this.email, 
  this.message, 

  
   });
 
}

class ContactUsPop extends StatefulWidget {
  static const routeName = '/contact';
  @override
  _ContactUsPopState createState() => _ContactUsPopState();
}

class _ContactUsPopState extends State<ContactUsPop> {
  final apiurl = AppApi.api;

  var _contactUs = UserProfieItem(
    userName: '',
    userEmail: '',
    message: '',
    
  );
  Map<String, String> _initValues = {
    'name': '',
    'email': '',
    'message': '',
    
  };
 var _isInit = true;
  var _isLoading = false;
  final _formKey = GlobalKey<FormState>();

Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
   
      try {
     
        await Provider.of<Chats>(context, listen: false).createSupportTicket(_contactUs);
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Sucessful"),
            content: Text("You have message is sucessfully sent."),
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
      } catch (error) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An Error Occured"),
            content: Text(
                "Something went wrong. Please try after sometime."),
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
     
    
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }



  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text("Contact Us"),
      ),
      body: 
                   AlertDialog(
                    content: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Positioned(
                          right: -30.0,
                          top: -30.0,
                          child: InkResponse(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: CircleAvatar(
                              child: Icon(Icons.close),
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                  child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              
                               
                                 Padding(
                                padding: EdgeInsets.all(10.0),
                                child: new Row(
                                  crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Center(
                                      child:  Padding(
                                padding: EdgeInsets.all(10.0),
  child: Container(
    
    
    child: Align(
                                            alignment: Alignment(0.2, 0.6),
                                            child:  Icon(
                                              MaterialIcons.face,
                                             
                                             )),
  ),),
),
                                            
                                       
          Flexible(
            child: new 
                                TextFormField(
                                   decoration: InputDecoration(
               // icon: Icon(Icons.account_circle),
                hintText: 'Name',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                ),
              ),
              onSaved: (value) {
                            final message = UserProfieItem(

                              userName:value,
                               userEmail: _contactUs.userEmail,
                                message: _contactUs.message
                              );
                               _contactUs = message;
                          },
                                ),
          ),
        ]
                                ),
                              ),
                               
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: new Row(
                                  crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Center(
                                      child:  Padding(
                                padding: EdgeInsets.all(10.0),
  child: Container(
    
    
    child: Align(
                                            alignment: Alignment(0.2, 0.6),
                                            child: Icon(
                                             MaterialIcons.contact_mail,
                                             )),
  ),),
),
                                            
                                       
          Flexible(
            child: new 
                                TextFormField(
                                   decoration: InputDecoration(
               // icon: Icon(Icons.account_circle),
                hintText: 'Email',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                ),
              ),
               onSaved: (value) {
                            final message = UserProfieItem(

                              userName:_contactUs.userName,
                               userEmail: value,
                                message: _contactUs.message
                              );
                               _contactUs = message;
                          },
                                ),
          ),
        ]
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: new Row(
                                  crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Center(
                                      child:  Padding(
                                padding: EdgeInsets.all(10.0),
  child: Container(
    
    
    child: Align(
                                            alignment: Alignment(0.2, 0.6),
                                            child: Icon(
                                               MaterialIcons.mail_outline,
                                             )),
  ),),
),
                                            
                                       
          Flexible(
            child: new 
                                TextFormField(
                                   maxLines: 8,
                          keyboardType: TextInputType.multiline,
                                   decoration: InputDecoration(
               // icon: Icon(Icons.account_circle),
                hintText: 'Message',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                ),
              ),
               onSaved: (value) {
                            final message = UserProfieItem(

                              userName:_contactUs.userName,
                               userEmail: _contactUs.userEmail,
                                message: value
                              );
                               _contactUs = message;
                          },
                                ),
          ),
        ]
                                ),
                              ),
                            
                               Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
    FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Colors.green)),
      color: Colors.green,
      textColor: Colors.white,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
                                   _saveForm();
      },
      child: Text(
        "Send Message",
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
    ),
    ],
    ),
                           
                            
                            ],
                          ),
                        ),
                        ),
                      ],
                    ),
                  ),
               
    );
  }
}