import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_profiles.dart';
import '../providers/crops.dart';
import './crop_item.dart';
import 'package:provider/provider.dart';
import '../l10n/gallery_localizations.dart';
import '../providers/machinery.dart';
import './machinery_forSaleRental_item.dart';
import './machinery_forRental_item.dart';
import '../providers/auth.dart';

import 'dart:ui';

/* enum BannerAction {
  reset,
  showMultipleActions,
  showLeading,
} */

class MachineryForSaleRentalGrid extends StatefulWidget {
  

  static const routeName = '/machinery-for-saleRental';
  @override
  

  _MachineryForSaleRentalGridState createState() => _MachineryForSaleRentalGridState();
}

class _MachineryForSaleRentalGridState extends State<MachineryForSaleRentalGrid> {
  




  var _isLoading = false;
  var transType;
var viewerType;

  @override
  
  void initState() {
  Future<dynamic>.delayed(Duration.zero).then((dynamic _) async {
      setState(() {
       
    
       _isLoading = true;
      });
        
          final dynamic userData = await Provider.of<Auth>(context, listen: false);
      String userId = '${userData.userId}';
    String userType = '${userData.userType}';
     

final routes =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      
      final dynamic type = routes['type'];
       final dynamic viewer = routes['viewer'];
      transType = type;
      viewerType = viewer;
       if(type == 'sale'){
       
         if(viewerType == 'user'){
        await Provider.of<Machinery>(context, listen: false).fetchUserMachineryForSaleRental();
      } else {
await Provider.of<Machinery>(context, listen: false).fetchMachineryForSale();
      } 
       }
      else if(viewerType == 'user') {
         await Provider.of<Machinery>(context, listen: false).fetchUserMachineryForSaleRental();
      } else {
        await Provider.of<Machinery>(context, listen: false).fetchMachineryForRental();
      }
       
      
      
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
 
    final machineryData = Provider.of<Machinery>(context, listen: false);
 final machinery =  machineryData.items;
    //final farmers = farmersData.items;
  if (machineryData.items.length > 0 ) {
    if(transType == 'sale'){
  return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: machinery.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: machinery[i],
          child:  MachineryForSaleRentalItem(
            machinery[i].id,
            machinery[i].type,
            machinery[i].imageUrl,
            machinery[i].year,
            machinery[i].salePrice.toString(),
            machinery[i].rentPrice.toString(),
          ),
        ),
       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
      );
    }
    else{
       return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: machinery.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: machinery[i],
          child: MachineryForRentalItem(
            machinery[i].id,
            machinery[i].type,
            machinery[i].imageUrl,
            machinery[i].year,
            machinery[i].salePrice.toString(),
            machinery[i].rentPrice.toString(),
          ),
        ),
       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
      );

    }
    

        
     
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
      content:  Text(GalleryLocalizations.of(context).nomachineryForSale),
      leading: _showLeading
          ? CircleAvatar(
              child: Icon(Icons.bookmark),
             
            )
          : null,
      actions: [
        FlatButton(
          child: Text(" "),
          onPressed: () {
            setState(() {
              _displayBanner = false;
             
              Navigator.pushNamed(context, '/machinery-sale-anouncement');
             
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
