import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import 'package:provider/provider.dart';
import '../widgets/crops_grid.dart';
import '../l10n/gallery_localizations.dart';
import './edit_crop_screen.dart';
import '../providers/crops.dart';
import '../providers/auth.dart';
import 'package:flutter/scheduler.dart';
import '../screens/login_page.dart';
import '../screens/splash_screen.dart';
import '../providers/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/fields.dart';



enum FilterOptions{

  Favorites,
  All,

}
class CropsOnLandOverviewScreen extends StatefulWidget {
  static const routeName = '/crops-on-land-overview';
  @override
  _CropsOnLandOverviewScreenState createState() => _CropsOnLandOverviewScreenState();
}

class _CropsOnLandOverviewScreenState extends State<CropsOnLandOverviewScreen> {

  var _showOnlyFavorites = false;
var _isInit = true;
var _isLoading = false;
  @override
 void initState() {
     Future<dynamic>.delayed(Duration.zero).then((dynamic _) async {
      setState(() {
       _isLoading = true;
      });
       final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
  final dynamic landId = routes['id'];
  final dynamic type = routes['type'];
  await Provider.of<Crops>(context, listen: false).fetchAndFetchCropWithLand(landId, type);
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  } 



  @override
  void didChangeDependencies() async {

    
 
    super.didChangeDependencies();
  }

   

  @override
  Widget build(BuildContext context) {
    //Call refresh crops after loggin in.
    final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
     final dynamic fieldid = routes['id'];
    final loadedFields = Provider.of<Fields>(context, listen: false).findById(fieldid);
    

    // These delegates make sure that the localization data for the proper language is loaded
      
    //return Scaffold(
     return  Consumer<Auth>
      (builder: (ctx, auth, _) => Scaffold(
      appBar: AppBar(
        title: auth.isAuth ? Text(GalleryLocalizations.of(context).cropOnLandTitle,) 
        : Text(GalleryLocalizations.of(context).login_Signup,) ,
        
      ),
     //drawer: AppDrwaer(),
      body: Container( child: 
          auth.isAuth ? CropsGrid(_showOnlyFavorites) : 
      
       Banner()
       
      ,
      
        
       
      
      ),
      
    floatingActionButtonLocation: 
      FloatingActionButtonLocation.centerDocked,
    floatingActionButton: new Visibility( 
        visible: true,
       child: auth.isAuth ?
       FloatingActionButton(
      child: const Icon(Icons.add), onPressed: () {
 Navigator.of(context).pushNamed(EditCropScreen.routeName,  arguments: {'id': loadedFields.id, 'type':'lands'});
         // print(loadedCrops.id);

      },) : FloatingActionButton(onPressed: (){},),
      ),
     bottomNavigationBar: BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: _buildTabsBar(context),
      
     
      
      ), 
      
      ),
      
      );

  }

  Widget _buildTabsBar(dynamic context) {
    return Container(
      height: 60,
      color: Color.fromRGBO(21, 32, 43, 1.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
          IconButton(icon:Icon(MaterialIcons.home, color: Theme.of(context).accentColor,
          
          ),
          onPressed: (){
            Navigator.pushNamed(context, '/farmer_home_screen');
          },),
          IconButton(icon:Icon(MaterialIcons.edit, color: Colors.grey[100]),
          onPressed: (){
             Navigator.pushNamed(context, '/user-crops');
          },),
          
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


