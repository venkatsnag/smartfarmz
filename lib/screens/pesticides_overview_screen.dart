import 'package:flutter/material.dart';

import '../widgets/crop_item.dart';

import 'package:provider/provider.dart';
import '../widgets/crop_expense_item.dart';
import '../widgets/app_drawer.dart';
import 'add_expense_screen.dart';
import '../providers/fertilizers.dart';
import '../providers/crops.dart';
import '../widgets/fertilizer_item.dart';
import '../screens/add_fertilizer_pesticide.dart';
import '../providers/cropExpenses.dart' show CropExpenses;
import '../providers/auth.dart';

class PesticidesOverviewScreen extends StatefulWidget {
  

  static const routeName = '/pesticides-overview';
  @override

  _PesticidesOverviewScreenState createState() => _PesticidesOverviewScreenState();
}

class _PesticidesOverviewScreenState extends State<PesticidesOverviewScreen> {
  
Future<void> _refreshPesticides(BuildContext context) async {
   final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
  final dynamic cropId = routes['id'];
  final dynamic type = routes['type'];
  await Provider.of<FertiPestis>(context, listen: false).fetchAndSetCropFertilizers(cropId, type);

}


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
      await Provider.of<FertiPestis>(context, listen: false).fetchAndSetCropFertilizers(cropId, type);
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  } 
 @override
Widget build(BuildContext context) {

  WidgetsBinding.instance.addPostFrameCallback((_) => _refreshPesticides(context));
final authData = Provider.of<Auth>(context, listen: false);
final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
  final dynamic cropId = routes['id'];
  final dynamic type = routes['type'];
  Map<String, String> args = {'id': '$cropId', 'type':'$type'};
final pestiData = Provider.of<FertiPestis>(context, listen: false);
//final dynamic loadedCrops = Provider.of<Crops>(context).findById(cropId);
  return new Scaffold(
    appBar: 
	AppBar(title: const Text('Schedule of Pesticides/Feritilizers'),
  ),
  
	//drawer: AppDrwaer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshPesticides(context),
        child: Padding(
          padding: EdgeInsets.all(10),
        child: ListView.builder(itemCount: pestiData.items.length, itemBuilder: 
        (ctx, i) => FertiPestiItem(pestiData.items[i]), ),
        
    ),),
    floatingActionButtonLocation: 
      FloatingActionButtonLocation.centerDocked,
    floatingActionButton: 
    authData.userType == 'Farmer' || authData.userType == 'Hobby/DYIFarmer'?
    FloatingActionButton(
      child: const Icon(Icons.add), onPressed: () {
 Navigator.of(context).pushNamed(AddFertiPestiScreen.routeName, arguments: args);
         // print(loadedCrops.id);

      },): null,
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
}