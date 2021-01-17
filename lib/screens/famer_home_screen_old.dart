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


class FarmerHomeScreen extends StatelessWidget {
  
static const routeName = '/farmer_home_screen';
  
  const FarmerHomeScreen({Key key, this.type}) : super(key: key);

  final FarmerHomeScreen type;

  
  
  List<_Photo> _photos(BuildContext context) {
    return [
      _Photo(
        
        assetName: 'assets/img/watermelon.jpg',
        navi: '/crops-overview',
        //title: Text(AppLocalizations.of(context).translate('crop_title'),),
        //navi: Navigator.pushNamed(context, CropsOverviewScreen.routeName ),
        title: GalleryLocalizations.of(context).myCropTitle,
        type:'na',
       // subtitle: GalleryLocalizations.of(context).placeFlowerMarket, 
      ),
       _Photo(
        assetName: 'assets/img/land.jpg',
        navi: '/fields-overview',
        title: GalleryLocalizations.of(context).myLands,
        subtitle: GalleryLocalizations.of(context).myLands,
        type:'ns',
      ),
     _Photo(
        assetName: 'assets/img/orchads.jpg',
        navi: '/crops-for-sale-overview-user',
        title: GalleryLocalizations.of(context).myCropforSale,
        type:'ns',
        /* subtitle: GalleryLocalizations.of(context).placeBronzeWorks, */
      ),  
      _Photo(
        assetName: 'assets/img/orchads.jpg',
        navi: '/machinery-for-sale-overview',
        title: GalleryLocalizations.of(context).mymachineryForSale,
        type:'sale',
        viewer:'otherFarmer',
        /* subtitle: GalleryLocalizations.of(context).placeBronzeWorks, */
      ),  
      _Photo(
        assetName: 'assets/img/orchads.jpg',
        navi: '/machinery-for-sale-overview',
        title: GalleryLocalizations.of(context).mymachineryForRental,
        type:'rental',
        viewer:'otherFarmer',
        /* subtitle: GalleryLocalizations.of(context).placeBronzeWorks, */
      ),  
    

      _Photo(
        assetName: 'assets/img/buyer.png',
        navi: '/all-farmers-overview',
        title: GalleryLocalizations.of(context).allBuyers,
        subtitle: GalleryLocalizations.of(context).allBuyers,
        type:'na',
      ), 

       _Photo(
        assetName: 'assets/img/buyer.png',
        navi: '/my-sales-views',
        title: GalleryLocalizations.of(context).allBuyers,
        subtitle: GalleryLocalizations.of(context).allBuyers,
        type:'na',
      ), 
       
    ];
  }
  @override
  Widget build(BuildContext context) {
    //WidgetsBinding.instance.addPostFrameCallback((_) => _photos(context));
    final dynamic userData = Provider.of<Auth>(context);
    String userId = '${userData.userId}';
    String userLetter = '${userId[0]}';
   String userType = '${userData.userType}';
    
    return  Consumer<Auth>
      (builder: (ctx, auth, _) => Scaffold(
      appBar: new AppBar(
        
            title: 
            Row(
              children: <Widget>[
                Container(
                  child: CircleAvatar(
                    child: new Text(userLetter),
                    radius: 15.0,
                  ),
                  margin: EdgeInsets.only(right: 30.0),
                ),
                new Text(GalleryLocalizations.of(context).mainTitle, textAlign: TextAlign.center,),
              ],
            ),
            elevation: 4.0,
          ),
          drawer:  userType == 'Farmer'? AppDrwaer() : SizedBox(),
      body:
       
       GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        childAspectRatio: 1,
        children: _photos(context).map<Widget>((photo) {
          return _GridDemoPhotoItem(
            photo: photo,
            
          );
        }).toList(),
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

class _Photo {
  _Photo({
    this.assetName,
    this.title,
    this.subtitle,
    this.navi,
    this.type,
    this.viewer,
  });

  final String assetName;
  final  String title;
  final String subtitle;
 final  String navi;
 final  String type;
 final  String viewer;
}

const tit = 'Text';
/// Allow the text size to shrink to fit in the space
class _GridTitleText extends StatelessWidget {
  const _GridTitleText(this.text);

  final  dynamic text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: AlignmentDirectional.centerStart,
      child: Text(text),
    );
  }
}

class _GridDemoPhotoItem extends StatelessWidget {
  _GridDemoPhotoItem({
    Key key,
    @required this.photo,
    
   
  }) : super(key: key);

  final _Photo photo;
  
  Future<void> _showSelectionDialog(BuildContext context) {

     // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pushNamed(context, '/guest_home_screen');
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
  @override

  Widget build(BuildContext context) {
    final dynamic userData = Provider.of<Auth>(context);
    String userId = '${userData.userId}';
    String userLetter = '${userId[0]}';
   String userType = '${userData.userType}';
    final Widget image = Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: ()async {
          //route: _GridTitleText(photo.route);
          userType == 'Farmer'?
          
          await Navigator.pushNamed(context, photo.navi,
    arguments: {
      'type': photo.type,
      
    },) : _showSelectionDialog(context) ;
        },
              child:Image.asset(
          photo.assetName,
          //package: 'flutter_gallery_assets',
          //package: 'HAPPY_FARMING_V4.1',
          fit: BoxFit.cover,
        ),
      ),
    );

    return GridTile(
          footer: Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            clipBehavior: Clip.antiAlias,
            child: GridTileBar(
              backgroundColor: Colors.black45,
              title: _GridTitleText(photo.title),
              //subtitle: _GridTitleText(photo.subtitle),
            ),
         ),
          child: image,
        );

    
     //return image;
     
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





