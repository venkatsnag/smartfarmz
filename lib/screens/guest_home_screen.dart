import 'package:flutter/material.dart';
import '../l10n/gallery_localizations.dart';
import '../screens/crops_overview_screen.dart';
import '../providers/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../providers/auth.dart';
import '../providers/user_profiles.dart';
import 'package:provider/provider.dart';

class GuestHomeScreen extends StatelessWidget {
static const routeName = '/guest_home_screen';
  
  const GuestHomeScreen({Key key, this.type}) : super(key: key);
  

  final GuestHomeScreen type;
  
  List<_Photo> _photos(BuildContext context) {
    return [
      _Photo(
        
        assetName: 'assets/img/Indian_farmer.png',
        navi: '/main_home_screen',
        //title: Text(AppLocalizations.of(context).translate('crop_title'),),
        //navi: Navigator.pushNamed(context, CropsOverviewScreen.routeName ),
        title: GalleryLocalizations.of(context).farmers,
       // subtitle: GalleryLocalizations.of(context).placeFlowerMarket, 
      ),
      _Photo(
        assetName: 'assets/img/farmer_market.png',
        navi: '/market-prices-overview3',
        
        title: GalleryLocalizations.of(context).marketPrices,
        /* subtitle: GalleryLocalizations.of(context).placeBronzeWorks, */
      ), 
     _Photo(
        assetName: 'assets/img/buyer.png',
        navi: '/buyer_home_screen',
        title: GalleryLocalizations.of(context).buyer,
        //subtitle: GalleryLocalizations.of(context).placeMarket,
      ), 

      _Photo(
        assetName: 'assets/img/investor.png',
        navi: '/investor_home_screen',
        title: GalleryLocalizations.of(context).investor,
        //subtitle: GalleryLocalizations.of(context).placeMarket,
      ), 
       
    ];
  }
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
      body: GridView.count(
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
    );
  }
}

class _Photo {
  _Photo({
    this.assetName,
    this.title,
    this.subtitle,
    this.navi,
    this.args,
  });

  final String assetName;
  final  String title;
  final String subtitle;
 final  String navi;
 String args;
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
  

  @override

  Widget build(BuildContext context) {
    final Widget image = Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: (){
          //route: _GridTitleText(photo.route);
          //Navigator.pushNamed(context, photo.navi, arguments:{'id':'Tomato','type':'Boinpally'});
          Navigator.pushNamed(context, photo.navi,);
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
   final dynamic loadedUser = Provider.of<UserProfiles>(context, listen: false);
  
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
          style: TextStyle(color: Colors.white),),
          
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
          style: TextStyle(color: Colors.white),),

          
          ],
          ),),
                
 SingleChildScrollView(
  child:Column(
  mainAxisSize: MainAxisSize.max,
         children: <Widget>[
         IconButton(icon:FaIcon(MaterialIcons.call, color: Theme.of(context).accentColor,
          
          ),
          onPressed: (){
            Navigator.pushReplacementNamed(context, '/contact-us');
          },), 
          Text('Contact Us',
          style: TextStyle(color: Colors.white),)
          ],
          ),),
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
          ),) : SizedBox(
            width: 1,
          ),
  
           
          
       ],
      ),
    ),
    );
  }
