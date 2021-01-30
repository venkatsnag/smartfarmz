import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/machinery.dart';
import '../widgets/user_machinery_forSaleRental.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_crop_screen.dart';
import '../l10n/gallery_localizations.dart';
import 'package:flutter/scheduler.dart';
import '../providers/auth.dart';

class UserMachinerySaleRentalScreen extends StatelessWidget {
  static const String routeName = '/user-machinery-ForsaleRental';

  Future<void> _refreshMachinerySalesRental(BuildContext context) async {
await Provider.of<Machinery>(context, listen: false).fetchUserMachineryForSaleRental();
  }
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshMachinerySalesRental(context));
    //final cropsData = Provider.of<Crops>(context);
    return  Consumer<Auth>
      (builder: (ctx, auth, _) => Scaffold(appBar: AppBar(
      title: const Text('Your Machinery sale/Rental anouncements'),
/*       actions: <Widget>[
        IconButton(icon: Icon(Icons.add), onPressed: (){
          Navigator.of(context).pushNamed(EditCropScreen.routeName);
        },)
      ] */
    ),
    //drawer: AppDrwaer(),
    body: auth.isAuth ?  FutureBuilder(
        future: _refreshMachinerySalesRental(context),
          builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting ? Center(
            child: CircularProgressIndicator(),) : 
            RefreshIndicator(
        onRefresh: () => _refreshMachinerySalesRental(context),
            child: Consumer<Machinery>(
                          builder: (ctx,machinerySalesRentalData, _ ) => Padding(padding: const EdgeInsets.all(8.0),
        child: ListView.builder(itemCount: machinerySalesRentalData.items.length , itemBuilder: (_, i) => Column(
          children: <Widget>[
              UserMachineryForSaleRentalItem(
                machinerySalesRentalData.items[i].id,
                machinerySalesRentalData.items[i].type, 
                machinerySalesRentalData.items[i].forSale.toString(), 
                machinerySalesRentalData.items[i].forRental.toString(), 
                machinerySalesRentalData.items[i].imageUrl),
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
