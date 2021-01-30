import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import 'package:provider/provider.dart';
import '../widgets/crop_for_sale_grid_user.dart';
import '../l10n/gallery_localizations.dart';
import './crop_sale_anounce_screen.dart';
import '../providers/crops.dart';
import '../providers/auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:share/share.dart';



enum FilterOptions{

  Favorites,
  All,

}

class CropsForSaleOverviewScreenUser extends StatefulWidget {

  static const routeName = '/crops-for-sale-overview-user';
  @override
  _CropsForSaleOverviewScreenUserState createState() => _CropsForSaleOverviewScreenUserState();
}

class _CropsForSaleOverviewScreenUserState extends State<CropsForSaleOverviewScreenUser> {

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
await Provider.of<Crops>(context,listen: false).fetchUserCropsForSale();
     //}
  }


@override
Widget build(BuildContext context) {

  WidgetsBinding.instance.addPostFrameCallback((_) => _refreshCrops(context));
  return  Consumer<Auth>
      (builder: (ctx, auth, _) => Scaffold(
      appBar: AppBar(
        
        title: auth.isAuth ? Text(GalleryLocalizations.of(context).allCropsForSale,) 
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
      
         
        ], */
      ),
     //drawer: AppDrwaer(),
      body: Container( child: 
          auth.isAuth ? CropsForSaleGridUser() : 
      
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
 Navigator.of(context).pushNamed(CropSaleAnouncementScreen.routeName, arguments:{'id': null, 'action': 'create'});
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
             Navigator.pushNamed(context, '/user-crops-sale');
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
              Navigator.pushReplacementNamed(context, '/main_home_screen');
            },
          ),
      ],
      
    );

    
  }

  

  
}
