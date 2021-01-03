

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/machinery.dart';
import '../widgets/user_machinery_item.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_crop_screen.dart';
import '../l10n/gallery_localizations.dart';
import 'package:flutter/scheduler.dart';
import '../providers/auth.dart';
import '../providers/cropNotes.dart';

class UserMachineryScreen extends StatelessWidget {
  static const String routeName = '/user-machinery-screen';

  Future<void> _refreshNotes(BuildContext context) async {
await Provider.of<Machinery>(context, listen: false);
  }
  @override
  Widget build(BuildContext context) {
    //final cropsData = Provider.of<Crops>(context);
    return  Consumer<Auth>
      (builder: (ctx, auth, _) => Scaffold(appBar: AppBar(
      title: const Text('Your Machinery'),
/*       actions: <Widget>[
        IconButton(icon: Icon(Icons.add), onPressed: (){
          Navigator.of(context).pushNamed(EditCropScreen.routeName);
        },)
      ] */
    ),
    //drawer: AppDrwaer(),
    body: auth.isAuth ?  FutureBuilder(
        future: _refreshNotes(context),
          builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting ? Center(
            child: CircularProgressIndicator(),) : 
            RefreshIndicator(
        onRefresh: () => _refreshNotes(context),
            child: Consumer<Machinery>(
                          builder: (ctx,cropsData, _ ) => Padding(padding: const EdgeInsets.all(8.0),
        child: ListView.builder(itemCount: cropsData.items.length , itemBuilder: (_, i) => Column(
          children: <Widget>[
              UserMachineryItem(
                cropsData.items[i].id,
                cropsData.items[i].type, 
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
              Navigator.pushReplacementNamed(context, '/guest_home_screen');
            },
          ),
      ],
      
    );

    
  }

  
}
