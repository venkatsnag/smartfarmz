import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import 'package:provider/provider.dart';
import '../widgets/machinery_forSaleRental_grid.dart';
import '../l10n/gallery_localizations.dart';
import './machinery_rental_anounce_screen.dart';
import '../providers/machinery.dart';
import '../providers/auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:share/share.dart';



enum FilterOptions{

  Favorites,
  All,

}

class MachineryForSaleRentalOverviewScreen extends StatefulWidget {

  static const routeName = '/machinery-for-sale-overview';
  @override
  _MachineryForSaleRentalOverviewScreenState createState() => _MachineryForSaleRentalOverviewScreenState();
}

class _MachineryForSaleRentalOverviewScreenState extends State<MachineryForSaleRentalOverviewScreen> {

var _showOnlyFavorites = false;
var _isInit = true;
var transType;
var viewerType;
  @override
  void initState() {

    super.initState();
  }

  @override
  void didChangeDependencies() {
 if(_isInit){
 final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
 final dynamic type = routes['type'];
 final dynamic viewer = routes['viewer'];
 transType = type;
 viewerType = viewer;
  }
  _isInit = false;
    super.didChangeDependencies(); 
  }

/*  Future<void> _refreshMachinery(BuildContext context) async {
     final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
     final dynamic type = routes['type'];
     //if(userId != null){
       type == 'sale' ?
await Provider.of<Machinery>(context,listen: false).fetchMachineryForSale()
: await Provider.of<Machinery>(context,listen: false).fetchMachineryForRental();;
     //}
  }  */


@override
Widget build(BuildContext context) {
  //final authData = Provider.of<Auth>(context, listen: false);
  //String type;
  
  //WidgetsBinding.instance.addPostFrameCallback((_) => _refreshMachinery(context));
  return  Consumer<Auth>
      (builder: (ctx, auth, _) => Scaffold(
      appBar: AppBar(
        
        title: transType == 'sale' ? ( viewerType == 'user' ? Text(GalleryLocalizations.of(context).mymachineryForSale,) : Text(GalleryLocalizations.of(context).allMachineryForSale,) )
        : ( viewerType == 'user' ? Text(GalleryLocalizations.of(context).mymachineryForRental,)  : Text(GalleryLocalizations.of(context).allMachineryForRental,) ) ,
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
          auth.isAuth ? 
          MachineryForSaleRentalGrid()
          //MachineryForSaleRentalGrid() 
          : 
      
       Banner()     
      ,
      
       
       
      
      ),
      
     floatingActionButtonLocation: 
      FloatingActionButtonLocation.centerDocked,
    floatingActionButton: new Visibility( 
        visible: viewerType == 'user' ? true : false,
       child: 
       FloatingActionButton(
      child: const Icon(Icons.add), onPressed: () {
 Navigator.of(context).pushNamed(MachinerySaleAnouncementScreen.routeName, arguments: {'id': null, 'action': 'create', 'type':transType});
         // print(loadedCrops.id);

      },),
      ),
     bottomNavigationBar:  viewerType == 'user' ? BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: _buildTabsBar(context),
      
     /*  new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,), */
      
      ) : SizedBox(),  
     
      
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
             Navigator.pushNamed(context, '/user-machinery-ForsaleRental');
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
