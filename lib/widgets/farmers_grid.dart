import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/users.dart';
import '../providers/crop.dart';
import './crop_item.dart';
import 'package:provider/provider.dart';
import '../l10n/gallery_localizations.dart';
import '../providers/crops.dart';
import './farmers_item.dart';
import '../providers/auth.dart';

import 'dart:ui';

/* enum BannerAction {
  reset,
  showMultipleActions,
  showLeading,
} */

class   FarmersGrid extends StatefulWidget {
  

  //static const routeName = '/expense-overview';
  @override

  _FarmersGridState createState() => _FarmersGridState();
}

class _FarmersGridState extends State<FarmersGrid> {
  




  var _isLoading = false;
  @override
  
  void initState() {
  Future<dynamic>.delayed(Duration.zero).then((dynamic _) async {
      setState(() {
       _isLoading = true;
      });
        final dynamic userData = Provider.of<Auth>(context, listen: false);
        String users = '${userData.userType}';
        String userType;
        users == 'Farmer' ? 
        userType = 'Buyer' : 
        userType = 'Farmer';


      await Provider.of<Users>(context, listen: false).getUsersByType(userType);
      
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  } 

  //FarmersGrid(this.showFavs);

  final noCropText = Text('No Crops Registered! Register crop');

  @override
  Widget build(BuildContext context) {
    
    
    final farmersData = Provider.of<Users>(context, listen: false);
 final farmers =  farmersData.items;
    //final farmers = farmersData.items;
  if (farmersData.userId != null) {
      return ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: farmers.length,

        itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(left: 15.0, top: 8.0, bottom: 16.0),
                  child: InkWell(
                    
                    child: Container(
                      
                    width: 100,
                      height:150,
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            //borderRadius: widget.iconImageBorderRadius,
                            child:  ChangeNotifierProvider.value(
                              
           value: farmers[index],
                    child: FarmerItem(
              farmers[index].id, 
              farmers[index].userFirstname, 
              farmers[index].userFirstname,
              farmers[index].userType,
           ),
         ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
      );
              /* 
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: farmers[i],
          child: FarmerItem(
            farmers[i].id,
            farmers[i].userFirstname,
            farmers[i].userFirstname,
            farmers[i].userType,
          ),
        ),
       
      ); */
     
    
/*      if (farmersData.userId != null) {
      return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: farmers.length,
        itemBuilder: (ctx, i) {
    return new Card(
      child: new GridTile(
        footer: new Text(farmers[i].id),
        child: new Text(farmers[i].userFirstname), //just for testing, will fill with image later
      ),
    );
  }, */
       /*  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10, */
        
     
    }
    else {
      return Banner();
    }

    
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
    final colorScheme = Theme.of(context).colorScheme;
    return MaterialBanner(
      content: Text(GalleryLocalizations.of(context).bannerDemoText),
      leading: _showLeading
          ? CircleAvatar(
              child: Icon(Icons.account_circle, color: colorScheme.onPrimary),
              backgroundColor: colorScheme.primary,
            )
          : null,
      actions: [
        FlatButton(
          child: Text(GalleryLocalizations.of(context).signIn),
          onPressed: () {
            setState(() {
              _displayBanner = false;
            });
            Navigator.pushNamed(context, '/login');
          },
        ),
         FlatButton(
            child: Text(GalleryLocalizations.of(context).dismiss),
            onPressed: () {
               setState(() {
                _displayBanner = false;
              });
              Navigator.pushNamed(context, '/main_home_screen');
            },
          ),
      ],
      backgroundColor: colorScheme.background,
    );

    
  }
}