import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import 'package:provider/provider.dart';
import '../widgets/fields_grid.dart';
import '../l10n/gallery_localizations.dart';
import './edit_field_screen.dart';
import '../providers/fields.dart';
import '../providers/auth.dart';
import 'package:flutter/scheduler.dart';
import '../screens/login_page.dart';
import '../screens/splash_screen.dart';
import '../providers/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



enum FilterOptions{

  Favorites,
  All,

}
class FieldsOverviewScreen extends StatefulWidget {
  static const routeName = '/fields-overview';
  @override
  _FieldsOverviewScreenState createState() => _FieldsOverviewScreenState();
}

class _FieldsOverviewScreenState extends State<FieldsOverviewScreen> {

  var _showOnlyFavorites = false;
var _isInit = true;
  @override
  void initState() {
     _refreshCrops(context);
    super.initState();
  }

  @override
  void didChangeDependencies() {
 /*  if(_isInit){
Provider.of<Crops>(context).fetchCrops();
  }
  _isInit = false;
    super.didChangeDependencies(); */
  }

   Future<void> _refreshCrops(BuildContext context) async {
     //final userId = ModalRoute.of(context).settings.arguments;
     //if(userId != null){
await Provider.of<Fields>(context,listen: false).fetchfields(true);
     //}
  }

  @override
  Widget build(BuildContext context) {
    //Call refresh crops after loggin in.
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshCrops(context));
    
  
    // These delegates make sure that the localization data for the proper language is loaded
      
    //return Scaffold(
     return  Consumer<Auth>
      (builder: (ctx, auth, _) => Scaffold(
      appBar: AppBar(
        title: auth.isAuth ? Text(GalleryLocalizations.of(context).myLandTitle,) 
        : Text(GalleryLocalizations.of(context).login_Signup,) ,
        //title: auth.isAuth ? Text(AppLocalizations.of(context).translate('crop_title'),) : 
       // Text(AppLocalizations.of(context).translate('login_Signup'),),
        /* actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue){

              setState(() {
                if(selectedValue == FilterOptions.Favorites){

              _showOnlyFavorites = true;

             }
             else{
               
              _showOnlyFavorites = false;
             } 
              });
            
            },
            //icon: Icon(Icons.more_vert,), 
            itemBuilder: (_) => [
            PopupMenuItem(child: Text('Only Favories'), value: FilterOptions.Favorites,),
            PopupMenuItem(
              child: Text('Show All'), 
              value: FilterOptions.All),
          ],
          ),
        /*  Consumer<Cart>(builder: (_, cart, ch) => Badge(child: ch,
         
         value: cart.itemCount.toString(),
         ),
         child: IconButton(icon: 
         Icon(Icons.shopping_cart,),
         onPressed: (){
           Navigator.of(context).pushNamed(CartScreen.routeName);
         },
         ),
         ) */
         
        ], */
      ),
     //drawer: AppDrwaer(),
      body: Container( child: 
          auth.isAuth ? FieldsGrid(_showOnlyFavorites) : 
      
       Banner()
       
      ,
      
        //CropsOverviewScreen() : 
       /*  FutureBuilder(
          future: auth.tryAutoLogin(), 
          builder: (ctx, authResultSnapshot) => 
          authResultSnapshot.connectionState == 
          ConnectionState.waiting ? 
          SplashScreen() : 
          AuthCard(),
          //AuthCard(),
          //FacebookLogin(),
          ), */ 
       
      
      ),
      
    floatingActionButtonLocation: 
      FloatingActionButtonLocation.centerDocked,
    floatingActionButton: new Visibility( 
        visible: true,
       child: auth.isAuth ?
       FloatingActionButton(
      child: const Icon(Icons.add), onPressed: () {
 Navigator.of(context).pushNamed(EditFieldScreen.routeName, arguments: {'id': null, 'type':'lands'});
         // print(loadedCrops.id);

      },) : FloatingActionButton(onPressed: (){},),
      ),
     bottomNavigationBar: BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: _buildTabsBar(context),
      
     /*  new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,), */
      
      ), 
      
      ),
      
      );

  }

  Widget _buildTabsBar(dynamic context) {
   return Container(
      height: 70,
      color: Color.fromRGBO(21, 32, 43, 1.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SingleChildScrollView(
  child:Column(
  mainAxisSize: MainAxisSize.max,
         children: <Widget>[
           IconButton(icon:Icon(MaterialIcons.home, color: Theme.of(context).accentColor,
          
          ),
          onPressed: (){
            Navigator.pushNamed(context, '/farmer_home_screen');
          },),
          Text('Home',
          style: TextStyle(color: Colors.white),)
          ],
          ),),
           SingleChildScrollView(
  child:Column(
  mainAxisSize: MainAxisSize.min,
         children: <Widget>[
          IconButton(icon:Icon(MaterialIcons.edit, color: Colors.grey[100]),
          onPressed: (){
             Navigator.pushNamed(context, '/user-lands');
          },),
          
        Text('Edit Lands',
          style: TextStyle(color: Colors.white),),],),),
          
       ],
      ),
    );
  }
}
     
class Banner extends StatefulWidget {
  const Banner();

  @override
  _BannerState createState() => _BannerState();
}

class _BannerState extends State<Banner> {
  
  var _showMultipleActions = true;
  var _displayBanner = true;
  var _showLeading = true;

/*   void handleDemoAction(BannerAction action) {
    setState(() {
      switch (action) {
        case BannerAction.reset:
          _displayBanner = true;
          
          _showLeading = true;
          break;
       
        case BannerAction.showLeading:
          _showLeading = !_showLeading;
          break;
      }
    });
  } */

  @override
  Widget build(BuildContext context) {
    
    return MaterialBanner(
      content: Text(GalleryLocalizations.of(context).bannerSignIn),
      leading: _showLeading
          ? CircleAvatar(
              child: Icon(Icons.account_circle),
             
            )
          : null,
      actions: [
        FlatButton(
          child: Text(GalleryLocalizations.of(context).signIn),
          onPressed: () {
            setState(() {
              _displayBanner = false;
              SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamed(context, '/login');
              });
            });
            
          },
        ),
         FlatButton(
            child: Text(GalleryLocalizations.of(context).dismiss),
            onPressed: () {
               setState(() {
                _displayBanner = false;
              });
              Navigator.pushReplacementNamed(context, '/guest_home_screen');
            },
          ),
      ],
      
    );

    
  }

  
}


