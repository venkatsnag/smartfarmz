import 'package:flutter/material.dart';
import '../widgets/crop_item.dart';
import 'package:provider/provider.dart';
import '../widgets/crop_harvest_item.dart';
import '../widgets/app_drawer.dart';
import '../l10n/gallery_localizations.dart';
import 'add_harvest_screen.dart';
import '../providers/crops.dart';
import '../providers/cropHarvest.dart' show CropHarvest;
import '../providers/auth.dart';

class HarvestOverviewScreen extends StatefulWidget {
  

  static const routeName = '/harvest-overview';
  @override

  _HarvestOverviewScreenState createState() => _HarvestOverviewScreenState();
}

class _HarvestOverviewScreenState extends State<HarvestOverviewScreen> {
  




  var _isLoading = false;
  @override
  
  void initState() {
  Future<dynamic>.delayed(Duration.zero).then((dynamic _) async {
      setState(() {
       _isLoading = true;
      });
      final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
  final dynamic cropId = routes['id'];
  final dynamic type = routes['type'];



      await Provider.of<CropHarvest>(context, listen: false).fetchAndSetCropHarvest(cropId, type);
      
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  } 

  

  Future<void> _refreshHarvest(BuildContext context) async {
  
  final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
   final dynamic cropId = routes['id'];
  final dynamic type = routes['type'];
  
  await Provider.of<CropHarvest>(context, listen: false).fetchAndSetCropHarvest(cropId, type);

  
}

var _isInit = true;

   
 @override

Widget build(BuildContext context) {

  WidgetsBinding.instance.addPostFrameCallback((_) => _refreshHarvest(context));
final authData = Provider.of<Auth>(context, listen: false);
  final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
  final dynamic cropId = routes['id'];
  final dynamic type = routes['type'];

  Map<String, String> args = {'id': '$cropId', 'type':'$type'};

final harvestData = Provider.of<CropHarvest>(context, listen: false);
 

return Scaffold(
    appBar: 
	AppBar(title: new Text(GalleryLocalizations.of(context).cropHarvestTitle, textAlign: TextAlign.center,),

  ),
	//drawer: AppDrwaer(),
  
      body: RefreshIndicator(
        onRefresh: () => _refreshHarvest(context),
        
        child: Padding(
          padding: EdgeInsets.all(10),
          
        child: ListView.builder(itemCount: harvestData.items.length, itemBuilder: 
        (ctx, i) => CropHarvestItem(harvestData.items[i]), ),
        
    ),
    ),
    floatingActionButtonLocation: 
      FloatingActionButtonLocation.centerDocked,
    floatingActionButton: 
    authData.userType == 'Farmer' || authData.userType == 'Hobby/DYIFarmer'?
    FloatingActionButton(
      child: const Icon(Icons.add), onPressed: () {
 Navigator.of(context).pushNamed(AddHarvestScreen.routeName, arguments: args);
  _refreshHarvest(context);
         // print(loadedCrops.id);

      },) : null,
    bottomNavigationBar: BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        
      ),
    ),
    
  );
}



Widget get text{

  Text('No Harvests');
}


}