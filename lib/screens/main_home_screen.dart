import 'package:flutter/material.dart';
import './crops_overview_screen.dart';

import '../l10n/gallery_localizations.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';
import '../providers/user_profiles.dart';
import '../widgets/app_drawer.dart';
import '../providers/auth.dart';
import '../providers/apiClass.dart';


class MainHomePage extends StatefulWidget {
  static const routeName = '/main_home_screen';
 
  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {

   final apiurl = AppApi.api;
    var userType;
    var userId;
    var userLetter;
     List<dynamic> userData;
    var _isLoading;
    var _isInit = true;
   @override
 


  Future<void> _showSelectionDialog(BuildContext context) {

     // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      //Navigator.pushNamed(context, '/guest_home_screen');
     },
  );

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(GalleryLocalizations.of(context).onlyFarmersTitle,),
              content: Text(GalleryLocalizations.of(context).onlyFarmersText,),
    actions: [
      okButton,
    ],);
        });
  }

  Future<void> _showUserProfileIncompleteDialog(BuildContext context) {

     // set up the button
  Widget okButton = FlatButton(
    child: Text("Go to profile page"),
    onPressed: () {
     Navigator.pushNamed(context, '/user-profile-screen');
     },
  );

  Widget dismissButton = FlatButton(
    child: Text("Dismiss"),
    onPressed: () {
     Navigator.pop(context);
     },
  );

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Complete your Profile'),
              content: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[

                          Text(GalleryLocalizations.of(context).profileCompReminder,
                          style: TextStyle(
                                          color: Colors.black.withOpacity(0.6),
                                          fontWeight: FontWeight.bold),
                          ),
                                      
                                    
                      ]),
    actions: [
      okButton,
      dismissButton,
    ],);
        });
  }

  void refreshUserprofileDialogue() {
    Future<dynamic>.delayed(Duration.zero).then((dynamic _) async {
      setState(() {
       

        _isLoading = true;
      });
      var users = await Provider.of<UserProfiles>(context, listen: false).getusers(userId);
      userData = users;
      var userVillage = '${users[0].userVillage}';
      var userState = '${users[0].userState}';
      var userCrops = '${users[0].userCrops}';
     if(userVillage == 'NA' || userState == 'NA' || userCrops == 'NA'){
       _showUserProfileIncompleteDialog(context);
     }
      
      setState(() {
        _isLoading = false;
      });
    });
   
  }

    void initState() {
    Future<dynamic>.delayed(Duration.zero).then((dynamic _) async {
      setState(() {
       

        _isLoading = true;
      });
      var users = await Provider.of<UserProfiles>(context, listen: false).getusers(userId);
      userData = users;
      var userVillage = '${users[0].userVillage}';
      var userState = '${users[0].userState}';
      var userCrops = '${users[0].userCrops}';
     if(userVillage == 'NA' || userState == 'NA' || userCrops == 'NA'){
       _showUserProfileIncompleteDialog(context);
     }
      
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    //WidgetsBinding.instance.addPostFrameCallback((_) => refreshUserprofileDialogue());
   
    final dynamic userData = Provider.of<Auth>(context);
    String id = '${userData.userId}';
    //String initial = '${userData.userId[0]}';
     String   user = '${userData.userType}';
     
      userType = user;
      userId = id;
     // userLetter = initial;
    
    return  Consumer<Auth>
      (builder: (ctx, auth, _) => Scaffold(
      appBar: new AppBar(
        
            title: 
            Row(
              children: <Widget>[
             /*    Container(
                  child: CircleAvatar(
                    child: new Text(userLetter),
                    radius: 15.0,
                  ),
                  margin: EdgeInsets.only(right: 30.0),
                ), */
                new Text(GalleryLocalizations.of(context).mainTitle, textAlign: TextAlign.center,),
              ],
            ),
            elevation: 4.0,
          ),
          drawer:  AppDrwaer(),
      body:
       
       GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        childAspectRatio: 1,
        children: [
         ( userType == 'Farmer' ||  userType == 'Hobby/DYIFarmer') ?
 GridTile(
      
      child: Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: ()async {
          //route: _GridTitleText(photo.route);
          userType == 'Farmer' ||  userType == 'Hobby/DYIFarmer' ?
          
          await Navigator.pushNamed(context,'/crops-overview',
    arguments: {
      'type': 'na',
      
    },) : _showSelectionDialog(context) ;
        },
              child:Image.network(
		"$apiurl/images/folder/crops.jpg",
	fit:BoxFit.cover,),
      ),
    ),
      footer: Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            clipBehavior: Clip.antiAlias,
            child:  GridTileBar(
      backgroundColor: Colors.black54,
       title: Text(GalleryLocalizations.of(context).myCropTitle,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white)
      ),),)
            ) : 
         ( userType == 'Buyer'?
GridTile(
      
      child: Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: ()async {
          //route: _GridTitleText(photo.route);
          userType == 'Buyer'?
          
          await Navigator.pushNamed(context,'/all-farmers-overview',
    arguments: {
      'type': 'na',
      
    },) : _showSelectionDialog(context) ;
        },
              child:Image.network(
		"$apiurl/images/folder/farmers_all.jpg",
	fit:BoxFit.cover,),
      ),
    ),
      footer: Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            clipBehavior: Clip.antiAlias,
            child:  GridTileBar(
      backgroundColor: Colors.black54,
       title: Text(GalleryLocalizations.of(context).allFarmers,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white)
      ),),)
            ) :
         
            GridTile(
      
      child: Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: ()async {
          //route: _GridTitleText(photo.route);
          userType == 'Investor'?
          
          await Navigator.pushNamed(context,'/crops-overview',
    arguments: {
      'type': 'na',
      
    },) : _showSelectionDialog(context) ;
        },
              child:Image.network(
		"$apiurl/images/folder/crops.jpg",
	fit:BoxFit.cover,),
      ),
    ),
      footer: Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            clipBehavior: Clip.antiAlias,
            child:  GridTileBar(
      backgroundColor: Colors.black54,
       title: Text(GalleryLocalizations.of(context).myInvestedCropTitle,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white)
      ),),)
            )),

         
          
            
            

//Second tile
  userType == 'Farmer' ||  userType == 'Hobby/DYIFarmer'? 


            GridTile(
      
      child: Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: ()async {
          //route: _GridTitleText(photo.route);
           userType == 'Farmer' ||  userType == 'Hobby/DYIFarmer'?
          
          await Navigator.pushNamed(context,'/fields-overview',
    arguments: {
      'type': 'na',
      
    },) : _showSelectionDialog(context) ;
        },
              child:Image.network(
		"$apiurl/images/folder/lands.jpg",
	fit:BoxFit.cover,),
      ),
    ),
      footer: Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            clipBehavior: Clip.antiAlias,
            child: GridTileBar(
      backgroundColor: Colors.black54,
       title: Text(GalleryLocalizations.of(context).myLands,
       textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white))),)
            ) 
            :
            ( userType == 'Buyer'? GridTile(
      
      child: Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: ()async {
          //route: _GridTitleText(photo.route);
          userType == 'Buyer'?
          
          await Navigator.pushNamed(context,'/crops-for-sale-overview',
    arguments: {
      'type': 'na',
      
    },) : _showSelectionDialog(context) ;
        },
              child:Image.network(
		"$apiurl/images/folder/crops.jpg",
	fit:BoxFit.cover,),
      ),
    ),
      footer: Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            clipBehavior: Clip.antiAlias,
            child: GridTileBar(
      backgroundColor: Colors.black54,
       title: Text(GalleryLocalizations.of(context).allCropsForSale,
       textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white))),)
            ) : GridTile(
      
      child: Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: ()async {
          //route: _GridTitleText(photo.route);
          userType == 'Investor'?
          
          await Navigator.pushNamed(context,'/all-farmers-overview',
    arguments: {
      'type': 'na',
      
    },) : _showSelectionDialog(context) ;
        },
              child:Image.network(
		"$apiurl/images/folder/farmers_all.jpg",
	fit:BoxFit.cover,),
      ),
    ),
      footer: Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            clipBehavior: Clip.antiAlias,
            child: GridTileBar(
      backgroundColor: Colors.black54,
       title: Text(GalleryLocalizations.of(context).allFarmers,
       textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white))),)
            ) ) ,

//Third Tile
            userType == 'Farmer' ||  userType == 'Hobby/DYIFarmer' ?
            GridTile(
      
      child: Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: ()async {
          //route: _GridTitleText(photo.route);
           userType == 'Farmer' ||  userType == 'Hobby/DYIFarmer' ?
          
          await Navigator.pushNamed(context,'/all-farmers-overview',
    arguments: {
      'type': 'na',
      
    },) : _showSelectionDialog(context) ;
        },
              child:Image.network(
		"$apiurl/images/folder/buyer_new.jpg",
	fit:BoxFit.cover,),
      ),
    ),
      footer: Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            clipBehavior: Clip.antiAlias,
            child: GridTileBar(
      backgroundColor: Colors.black54,
       title: Text(GalleryLocalizations.of(context).allBuyers,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white)
      ),),)
            ) : 
            ( userType == 'Investor'?
            GridTile(
      
      child: Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: ()async {
          //route: _GridTitleText(photo.route);
          userType == 'Investor'?
          
          await Navigator.pushNamed(context,'/all-farmers-for-investments-overview',
    arguments: {
      'type': 'na',
      
    },) : _showSelectionDialog(context) ;
        },
              child:Image.network(
		"$apiurl/images/folder/salesandrentals.jpg",
	fit:BoxFit.cover,),
      ),
    ),
      footer: Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            clipBehavior: Clip.antiAlias,
            child: GridTileBar(
      backgroundColor: Colors.black54,
       title: Text(GalleryLocalizations.of(context).cropforInvestments,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white)
      ),),)
            ) :
            SizedBox()), 

            // Fourth Tile
             userType == 'Farmer' ||  userType == 'Hobby/DYIFarmer'?
            GridTile(
      
      child: Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: ()async {
          //route: _GridTitleText(photo.route);
           userType == 'Farmer' ||  userType == 'Hobby/DYIFarmer'?
          
          await Navigator.pushNamed(context,'/my-sales-views',
    arguments: {
      'type': 'na',
      
    },) : _showSelectionDialog(context) ;
        },
              child:Image.network(
		"$apiurl/images/folder/salesandrentals.jpg",
	fit:BoxFit.cover,),
      ),
    ),
      footer: Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            clipBehavior: Clip.antiAlias,
            child: GridTileBar(
      backgroundColor: Colors.black54,
       title: Text(GalleryLocalizations.of(context).mySaleAndRentalAnouncement,
      textAlign: TextAlign.start,
      style: TextStyle(color: Colors.white)
      ),),)
            ) : SizedBox(), 

            // Fifth Tile
            userType == 'Farmer' ||  userType == 'Hobby/DYIFarmer'?
            GridTile(
      
      child: Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: ()async {
          //route: _GridTitleText(photo.route);
           userType == 'Farmer' ||  userType == 'Hobby/DYIFarmer'?
          
          await Navigator.pushNamed(context,'/machinery-for-sale-overview',
    arguments: {
      'type': 'sale',
      'viewer': 'otherFarmer',
      
    },) : _showSelectionDialog(context) ;
        },
              child:Image.network(
		"$apiurl/images/folder/Tractor.jpg",
	fit:BoxFit.contain,),
      ),
    ),
      footer: Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            clipBehavior: Clip.antiAlias,
            child: GridTileBar(
      backgroundColor: Colors.black54,
       title: Text(GalleryLocalizations.of(context).allMachineryForSale,
      textAlign: TextAlign.start,
      style: TextStyle(color: Colors.white)
      ),),)
            ): SizedBox(),

// Sixth Tile
  userType == 'Farmer' ||  userType == 'Hobby/DYIFarmer'?
            GridTile(
      
      child: Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: ()async {
          //route: _GridTitleText(photo.route);
          userType == 'Farmer' ||  userType == 'Hobby/DYIFarmer'?
          
          await Navigator.pushNamed(context,'/machinery-for-sale-overview',
    arguments: {
      'type': 'rental',
      'viewer': 'otherFarmer',
      
    },) : _showSelectionDialog(context) ;
        },
              child:Image.network(
		"$apiurl/images/folder/farm_tools_vector.jpg",
	fit:BoxFit.contain,),
      ),
    ),
      footer:Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            clipBehavior: Clip.antiAlias,
            child:  GridTileBar(
      backgroundColor: Colors.black54,
       title: Text(GalleryLocalizations.of(context).allMachineryForRental,
      textAlign: TextAlign.start,
      style: TextStyle(color: Colors.white)
      ),),)
            ) : SizedBox()

        ]
      ),
         bottomNavigationBar: BottomAppBar(
      
      child: _buildTabsBar(context),
      
     /*  new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,), */
      
      ), 
    ),);

    
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
          onPressed: (){Navigator.of(ctx).pushReplacementNamed('/login');}, 
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
           // Navigator.pushNamed(context, '/guest_home_screen');
          },), 
          Text('Home',
          style: TextStyle(color: Colors.white),)
          ],
          ),),

           SingleChildScrollView(
  child:Column(
  mainAxisSize: MainAxisSize.max,
         children: <Widget>[
         IconButton(icon:FaIcon(MaterialIcons.trending_up, color: Theme.of(context).accentColor,
          
          ),
          onPressed: (){
           Navigator.pushNamed(context, '/market-prices-overview3');
          },), 
          Text('Market Prices',
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
             /*  SingleChildScrollView(
  child:Column(
  mainAxisSize: MainAxisSize.max,
         children: <Widget>[
         IconButton(icon:FaIcon(MaterialIcons.contact_phone, color: Colors.grey[100]
          
          ),
          onPressed: (){
           Navigator.pushNamed(context, '/contact');
          },), 
          Text('Contact Us',
          style: TextStyle(color: Colors.white),)
          ],
          ),), */
          
       ],
      ),
    ),);
  }