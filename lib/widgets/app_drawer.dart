import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../screens/user_crops_screen.dart';
import '../screens/user_fields_screen.dart';
import '../screens/reset_password.dart';
import '../screens/user_crops_sale_screen.dart';
import '../providers/auth.dart';
import '../providers/user_profiles.dart';


class AppDrwaer extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
     final dynamic userData = Provider.of<UserProfiles>(context);
     String userType = '${userData.userType}';
    
    Future<void> _showErrorDialog(String message){
   return  showDialog(context: context, 
     builder: (ctx) => AlertDialog(
      title: Text('An Error occured! Try later or contact support.'), 
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          onPressed: (){Navigator.of(ctx).pop();}, 
          child: Text('Okay'))
      ],
      ),
      );

  }

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
      (builder: (ctx, auth, _) => Drawer(
      child: Column(
        children: <Widget>[
          AppBar(title: Text('Hello ' + '${userData.userId}'+ '!'),
          automaticallyImplyLeading: false,),

         Divider(),
         ListTile(
           leading: Icon(Icons.home),
           title: Text('Home'),
           onTap: (){
             //Navigator.of(context).pushReplacementNamed('/guest_home_screen');
           
           },
           
         ),
        
           
         
         /*  Divider(),
         ListTile(
           leading: Icon(Icons.edit),
           title: Text('Manage Products'),
           onTap: (){
             Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);

           },
         ), */
        Divider(),

        userType == 'Farmer'?
         ListTile(
           leading: Icon(Icons.edit),
           title: Text('Manage Crop Sale Anouncements'),
           onTap: (){
             Navigator.of(context).pushNamed(UserCropsSaleScreen.routeName);

           },
         ) : ListTile(
           leading: Icon(Icons.edit),
           title: Text('Reset your password!'),
           onTap: (){
             Navigator.of(context).pushNamed(ResetPasswordScreen.routeName);

           },
         ),
           Divider(),
           userType == 'Farmer'?
         ListTile(
           leading: Icon(Icons.edit),
           title: Text('Manage Crops'),
           onTap: (){
             Navigator.of(context).pushNamed(UserCropsScreen.routeName);

           },
         ) : SizedBox(),

         Divider(),
         userType == 'Farmer'?
         ListTile(
           leading: Icon(Icons.edit),
           title: Text('Manage Lands'),
           onTap: (){
             Navigator.of(context).pushNamed(UserFieldsScreen.routeName);

           },
         ) : SizedBox(),

         Divider(),

         userType == 'Farmer'?
         ListTile(
           leading: Icon(Icons.edit),
           title: Text('Reset your password!'),
           onTap: (){
             Navigator.of(context).pushNamed(ResetPasswordScreen.routeName);

           },
         ) : SizedBox(),
         
           Divider(),

           auth.isAuth ?
         ListTile(
           leading: Icon(Icons.exit_to_app),
           title: Text('Log out'),
           onTap: (){
             Navigator.of(context).pop();
             //Navigator.of(context).pushReplacementNamed('/');
             //Navigator.of(context).pushReplacementNamed(UserSelfProfileScreen.routeName);
             Provider.of<Auth>(context, listen: false).logout();
const  message = 'Logged out';
_showLogoffDialog(message);
           },
         ) : 
            ListTile(
           leading: Icon(Icons.exit_to_app),
           title: Text('Log in'),
           onTap: (){
             Navigator.pushNamed(context, '/login');
             //Navigator.of(context).pushReplacementNamed('/');
             //Navigator.of(context).pushReplacementNamed(UserSelfProfileScreen.routeName);
             
           },
         ), 

        ]
      ),
      
    ),);
  }
}

