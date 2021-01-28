import 'package:flutter/material.dart';

import '../widgets/crop_item.dart';
import 'package:provider/provider.dart';
import '../widgets/crop_expense_item.dart';
import '../widgets/app_drawer.dart';
import 'add_expense_screen.dart';
import '../providers/fertilizers.dart';
import '../providers/crops.dart';
import '../widgets/sale_item.dart';
import '../screens/add_sale_screen.dart';
import '../providers/crop_sales.dart';
import '../l10n/gallery_localizations.dart';
import '../providers/auth.dart';

class SalesOverviewScreen extends StatefulWidget {
  

  static const routeName = '/sales-overview';
  @override

  _SalesOverviewScreenState createState() => _SalesOverviewScreenState();
}

class _SalesOverviewScreenState extends State<SalesOverviewScreen> {
  
Future<void> _refreshSales(BuildContext context) async {
   final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
  final dynamic cropId = routes['id'];
  final dynamic type = routes['type'];
  await Provider.of<Sales>(context, listen: false).fetchAndFetchSales(cropId, type);

}


  var _isLoading = false;
  @override
  
  void initState() {
    Future<dynamic>.delayed(Duration.zero).then((dynamic _) async {
      setState(() {
       _isLoading = true;
      });
       final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
  final  dynamic cropId = routes['id'];
  final dynamic type = routes['type'];
      await Provider.of<Sales>(context, listen: false).fetchAndFetchSales(cropId, type);
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  } 

  
 @override
Widget build(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_) => _refreshSales(context));
  final authData = Provider.of<Auth>(context, listen: false);
 final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
  final dynamic cropId = routes['id'];
  final dynamic type = routes['type'];

  Map<String, String> args = {'id': '$cropId', 'type':'$type'};
final salesData = Provider.of<Sales>(context, listen: false);
//final dynamic loadedCrops = Provider.of<Crops>(context).findById(cropId);
  return new Scaffold(
    appBar: 
	AppBar(title: new Text(GalleryLocalizations.of(context).cropSalesTitle, textAlign: TextAlign.center,),
  actions: <Widget>[
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text ('Total Sales :'),
        Text('\₹${salesData.totalAmount}'),
      ],
    ),
  ],
  ),
  
	//drawer: AppDrwaer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshSales(context),
        child: Padding(
          padding: EdgeInsets.all(10),
        child: ListView.builder(itemCount: salesData.items.length, itemBuilder: 
        (ctx, i) => SaleItem(salesData.items[i]), ),
        
    ),),
    floatingActionButtonLocation: 
   
      FloatingActionButtonLocation.centerDocked,
    floatingActionButton: 
      authData.userType == 'Farmer' || authData.userType == 'Hobby/DYIFarmer'?
    FloatingActionButton(
      child: const Icon(Icons.add), onPressed: () {
 Navigator.of(context).pushNamed(AddSaleScreen.routeName, arguments: args );
          //print(loadedCrops.id);

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
}