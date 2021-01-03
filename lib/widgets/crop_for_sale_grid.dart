import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_profiles.dart';
import '../providers/crops.dart';
import './crop_item.dart';
import 'package:provider/provider.dart';
import '../l10n/gallery_localizations.dart';
import '../providers/crops.dart';
import './crop_for_sale_item.dart';
import '../providers/auth.dart';

import 'dart:ui';

/* enum BannerAction {
  reset,
  showMultipleActions,
  showLeading,
} */

class CropsForSaleGrid extends StatefulWidget {
  

  static const routeName = '/crops-for-sale';
  @override

  _CropsForSaleGridState createState() => _CropsForSaleGridState();
}

class _CropsForSaleGridState extends State<CropsForSaleGrid> {
  




  var _isLoading = false;
  @override
  
  void initState() {
  Future<dynamic>.delayed(Duration.zero).then((dynamic _) async {
      setState(() {
       _isLoading = true;
      });
      const type = 'sale';



      await Provider.of<Crops>(context, listen: false).fetchCropsForSale();
      
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
    
    final cropsData = Provider.of<Crops>(context, listen: false);
 final crops =  cropsData.items;
    //final farmers = farmersData.items;
  if (cropsData.items.length != null) {
      return  GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: crops.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: crops[i],
          child: CropsForSaleItem(
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
      ) ;
     
    
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

   Future<void> _showDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Section only for Buyers"),
                content: Text("This section is only for buyers! Please edit your"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Okay"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
        });
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
              Navigator.pushNamed(context, '/guest_home_screen');
            },
          ),
      ],
      backgroundColor: colorScheme.background,
    );

    
  }
}