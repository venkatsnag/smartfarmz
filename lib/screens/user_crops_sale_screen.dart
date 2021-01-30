

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/crops.dart';
import '../widgets/user_crop_sale_item.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_crop_screen.dart';
import '../l10n/gallery_localizations.dart';
import 'package:flutter/scheduler.dart';
import '../providers/auth.dart';

class UserCropsSaleScreen extends StatelessWidget {
  static const String routeName = '/user-crops-sale';

  Future<void> _refreshCrops(BuildContext context) async {
await Provider.of<Crops>(context, listen: false).fetchUserCropsForSale();
  }
  @override
  Widget build(BuildContext context) {
    //final cropsData = Provider.of<Crops>(context);
    return  Consumer<Auth>
      (builder: (ctx, auth, _) => Scaffold(appBar: AppBar(
      title: const Text('Your Crops sale anouncements'),
/*       actions: <Widget>[
        IconButton(icon: Icon(Icons.add), onPressed: (){
          Navigator.of(context).pushNamed(EditCropScreen.routeName);
        },)
      ] */
    ),
    //drawer: AppDrwaer(),
    body: auth.isAuth ?  FutureBuilder(
        future: _refreshCrops(context),
          builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting ? Center(
            child: CircularProgressIndicator(),) : 
            RefreshIndicator(
        onRefresh: () => _refreshCrops(context),
            child: Consumer<Crops>(
                          builder: (ctx,cropsData, _ ) => Padding(padding: const EdgeInsets.all(8.0),
        child: ListView.builder(itemCount: cropsData.items.length , itemBuilder: (_, i) => Column(
          children: <Widget>[
              UserCropSaleItem(
                cropsData.items[i].id,
                cropsData.items[i].title, 
                cropsData.items[i].imageUrl),
              Divider(),
          ],
        ),),
        ),
            ),
      ),
    ) : Banner(),
      
    ),);
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
              Navigator.pushReplacementNamed(context, '/main_home_screen');
            },
          ),
      ],
      
    );

    
  }

  
}
