
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class FacebookAuth with ChangeNotifier {

  DateTime _expiryDate;
  String _token;
  String fbUserId;
  
  bool isLoggedIn = false;
  Map userProfile;
  final facebookLogin = FacebookLogin();

  /* bool get isAuth{

return token != null;

}

String get token{

  if(_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null){
    return _token;
  }
  return null;
} */

String get userId{
  return fbUserId;
}

  dynamic loginWithFB(BuildContext context) async{

    
    final dynamic result = await facebookLogin.logIn(['email']);
print(result);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final dynamic token = result.accessToken.token;
        _token = result.accessToken.token;
        dynamic fbUserId = result.accessToken.userId;
        final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final dynamic profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
   
          userProfile = profile;
          fbUserId = profile['id'];
          _expiryDate = result.accessToken.expires;
          isLoggedIn = true;
         notifyListeners();
        break;

      case FacebookLoginStatus.cancelledByUser:
      return isLoggedIn = false;
       // setState(() => _isLoggedIn = false );
        break;
      case FacebookLoginStatus.error:
       return isLoggedIn = false;
       // setState(() => _isLoggedIn = false );
        break;
    }

  }

 dynamic  logout(){
    facebookLogin.logOut();
     return isLoggedIn = false;
    /* setState(() {
      _isLoggedIn = false;
    }); */
  }

  Future<bool> tryAutoLogin() async {

  }
}


/* final fbResponse = {name: Venkat Kondaveeti, picture: 
{data: {height: 50, is_silhouette: false, 
url: https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=10219825238614044&height=50&width=50&ext=1591355104&hash=AeTV-Q3g_Aal8qgU, width: 50}}, 
email: venkatsnag@gmail.com, id: 10219825238614044}; */