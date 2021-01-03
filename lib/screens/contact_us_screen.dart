import 'package:flutter/material.dart';
import '../providers/auth.dart';
import '../l10n/gallery_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import '../providers/user_profiles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:flutter/gestures.dart';

class  ContactUs extends StatelessWidget {

  void launchWhatsApp(
    {@required String phone,
    @required String message,
    }) async {
  String url() {
    if (Platform.isIOS) {
      return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
    } else {
      return "whatsapp://send?phone=91$phone&text=${Uri.parse(message)}";
    }
  }

  if (await canLaunch(url())) {
    await launch(url());
  } else {
    throw 'Could not launch ${url()}';
  }
}

    static const routeName = '/contact-us';
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        //title: Text(GalleryLocalizations.of(context).mainTitle),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        new Container(
          
         width: 200,
         height: 75,
         child: Image.asset('assets/img/SmartFarmZ_Name_Only.png',)
          
        )
      ],),
      ),
    body: Container(
      width: 500,
      
      child:  
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
                RichText(


                     text: TextSpan(
                      
                      text: 'For Technical issues please send mail to :- ',
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: 'tech@happyfarming.net'),
                  ],
                  ),
            
                      
            ),

            RichText(


                     text: TextSpan(
                      
                      text: 'For crop investment related queries please send mail to :- ',
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: 'cropinvestments@happyfarming.net'),
                  
                  ],
                  ),
            
                      
            ),

                 RichText(


                     text: TextSpan(
                      
                      text: 'For urgent queries please whatsApp on this number :- ',
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children:[
      
                  TextSpan(text: '+919010400400', 
                   recognizer: TapGestureRecognizer()..onTap = (){
                      launchWhatsApp(phone: "9010400400", message: "Hello");}
                 ),
                 WidgetSpan(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: IconButton(
            icon: FaIcon(FontAwesomeIcons.whatsapp),
            onPressed: () {
               launchWhatsApp(phone: "9010400400", message: "Hello");
            },)
        ),
      ),
                   ],
                  ),
            
                      
            ),

      ],
      ),),
      
    ),
     bottomNavigationBar: BottomAppBar(
      
      child: _buildTabsBar(context),
      
     /*  new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,), */
      
      ), 
    );
  }
}

Widget _buildTabsBar(dynamic context) {
  
final loadedUser = Provider.of<UserProfiles>(context, listen: false);
     
   Future<void> _showLogoffDialog(String message){
   return  showDialog(context: context, 
     builder: (ctx) => AlertDialog(
      title: Text('You have been sucessfully Logged Off'), 
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          onPressed: (){Navigator.of(ctx).pushReplacementNamed('/guest_home_screen');}, 
          child: Text('Okay'))
      ],
      ),
      );

  }
    return  Consumer<Auth>
      (builder: (ctx, auth, _) => Container(
      height: 70,
      color: Color.fromRGBO(21, 32, 43, 1.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SingleChildScrollView(
  child:Column(
  mainAxisSize: MainAxisSize.max,
         children: <Widget>[
         IconButton(icon:FaIcon(MaterialIcons.home, color: Theme.of(context).accentColor,
          
          ),
          onPressed: (){
            Navigator.pushNamed(context, '/guest_home_screen');
          },), 
          Text('Home',
          style: TextStyle(color: Colors.white),)
          ],
          ),),

      
 auth.isAuth ?
          SingleChildScrollView(
  child:Column(
  mainAxisSize: MainAxisSize.min,
         children: <Widget>[
          IconButton(icon:FaIcon(FontAwesomeIcons.userAlt, color: Colors.grey[100]),
          onPressed: (){
             Navigator.pushNamed(context, '/user-profile-screen', arguments: loadedUser.userId);
          },),
           Text('My Profile',
          style: TextStyle(color: Colors.white),)
          ],
          ),) :
        SingleChildScrollView(
  child:Column(
  mainAxisSize: MainAxisSize.max,
         children: <Widget>[

          IconButton(icon:FaIcon(FontAwesomeIcons.userShield, color: Colors.grey[100]),
          onPressed: (){
             Navigator.pushNamed(context, '/login');
          },), Text('Login',
          style: TextStyle(color: Colors.white),)
          ],
          ),)  ,
                auth.isAuth ?
     SingleChildScrollView(
  child:Column(
  mainAxisSize: MainAxisSize.max,
         children: <Widget>[

       IconButton(icon:Icon(Icons.exit_to_app_rounded, color: Colors.grey[100]),
          onPressed: (){
              Navigator.of(context).pop();
             //Navigator.of(context).pushReplacementNamed('/');
             //Navigator.of(context).pushReplacementNamed(UserSelfProfileScreen.routeName);
             Provider.of<Auth>(context, listen: false).logout();
const  message = 'Logged out';
_showLogoffDialog(message);
           },), Text('Logout',
          style: TextStyle(color: Colors.white),)
          ],
          ),) : SizedBox(),
          
       ],
      ),
    ),);
  }
