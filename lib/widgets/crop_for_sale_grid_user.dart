import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_profiles.dart';
import '../providers/crops.dart';
import './crop_item.dart';
import 'package:provider/provider.dart';
import '../l10n/gallery_localizations.dart';
import '../providers/crops.dart';
import './crop_for_sale_item_user.dart';

import 'dart:ui';

/* enum BannerAction {
  reset,
  showMultipleActions,
  showLeading,
} */

class CropsForSaleGridUser extends StatefulWidget {
  

  static const routeName = '/crops-for-sale-user';
  @override

  _CropsForSaleGridUserState createState() => _CropsForSaleGridUserState();
}

class _CropsForSaleGridUserState extends State<CropsForSaleGridUser> {
  




  var _isLoading = false;
  @override
  
  void initState() {
  Future<dynamic>.delayed(Duration.zero).then((dynamic _) async {
      setState(() {
       //_isLoading = true;
      });
      const type = 'sale';



      await Provider.of<Crops>(context, listen: false).fetchUserCropsForSale();
      
      setState(() {
        //_isLoading = false;
      });
    });
    super.initState();
  } 

  //FarmersGrid(this.showFavs);

  final noCropText = Text('No Crops Registered! Register crop');

  @override
  Widget build(BuildContext context) {
    
    final cropsData = Provider.of<Crops>(context, listen: false);
 final crops =  cropsData.items;
    //final farmers = farmersData.items;
  if (cropsData.items.length > 0 ) {
      return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: crops.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: crops[i],
          child: CropsForSaleItemUser(
            crops[i].id,
            crops[i].title,
            crops[i].imageUrl,
            crops[i].price.toString(),
          ),
        ),
       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
      );
     
    
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
    
    return MaterialBanner(
      content: Text(GalleryLocalizations.of(context).noCropForSale),
      leading: _showLeading
          ? CircleAvatar(
              child: Icon(Icons.bookmark),
             
            )
          : null,
      actions: [
        FlatButton(
          child: Text("Go to crops page"),
          onPressed: () {
            setState(() {
              _displayBanner = false;
             
              Navigator.pushNamed(context, '/crops-overview');
             
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
