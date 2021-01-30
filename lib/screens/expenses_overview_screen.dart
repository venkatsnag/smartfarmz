import 'package:flutter/material.dart';

import '../widgets/crop_item.dart';
import 'package:provider/provider.dart';
import '../widgets/crop_expense_item.dart';
import '../widgets/app_drawer.dart';
import '../l10n/gallery_localizations.dart';
import 'add_expense_screen.dart';
import '../providers/crops.dart';
import '../providers/cropExpenses.dart' show CropExpenses;
import '../providers/auth.dart';

class ExpensesOverviewScreen extends StatefulWidget {
  

  static const routeName = '/expense-overview';
  @override

  _ExpensesOverviewScreenState createState() => _ExpensesOverviewScreenState();
}

class _ExpensesOverviewScreenState extends State<ExpensesOverviewScreen> {
  




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



      await Provider.of<CropExpenses>(context, listen: false).fetchAndSetCropExpenses(cropId, type);
      
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  } 

  

  Future<void> _refreshExpenes(BuildContext context) async {
     
  
  final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
   final dynamic cropId = routes['id'];
  final dynamic type = routes['type'];
  
  await Provider.of<CropExpenses>(context, listen: false).fetchAndSetCropExpenses(cropId, type);

  
}

var _isInit = true;

   
 @override

Widget build(BuildContext context) {

  WidgetsBinding.instance.addPostFrameCallback((_) => _refreshExpenes(context));
 final authData = Provider.of<Auth>(context, listen: false);
  final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
  final dynamic cropId = routes['id'];
  final dynamic type = routes['type'];

  Map<String, String> args = {'id': '$cropId', 'type':'$type'};

final expenseData = Provider.of<CropExpenses>(context, listen: false);
 

return Scaffold(
    appBar: 
	AppBar(title: type == 'lands' ? new Text(GalleryLocalizations.of(context).landExpensesTitle, textAlign: TextAlign.center,) :  
  new Text(GalleryLocalizations.of(context).cropExpensesTitle, textAlign: TextAlign.center,),
  actions: <Widget>[
    Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text ('Total Expenses'),
        Text('\₹${expenseData.totalAmount}'),
      ],
    ),
  ],
  ),
  
	//drawer: AppDrwaer(),
  
      body: RefreshIndicator(
        onRefresh: () => _refreshExpenes(context),
        
        child: Padding(
          padding: EdgeInsets.all(10),
          
        child: ListView.builder(itemCount: expenseData.items.length, itemBuilder: 
        (ctx, i) => CropExpenseItem(expenseData.items[i]), ),
        
    ),
    ),
    floatingActionButtonLocation: 
      FloatingActionButtonLocation.centerDocked,
    floatingActionButton: 
    authData.userType == 'Farmer' ||  authData.userType == 'Hobby/DYIFarmer'?
    FloatingActionButton(
      child: const Icon(Icons.add), onPressed: () {
 Navigator.of(context).pushNamed(AddExpenseScreen.routeName, arguments: args);
  _refreshExpenes(context);
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

  Text('No Expenses');
}


}