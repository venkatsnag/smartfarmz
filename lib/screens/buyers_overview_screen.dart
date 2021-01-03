import 'package:flutter/material.dart';

class BuyersOverviewScreen extends StatefulWidget {

  static const routeName = '/buyer-overview';
  @override

  _BuyersOverviewScreenState createState() => _BuyersOverviewScreenState();
}

class _BuyersOverviewScreenState extends State<BuyersOverviewScreen> {
  @override
Widget build(BuildContext context) {
  return new Scaffold(
    appBar: AppBar(title: const Text('List of Buyers')),
    floatingActionButtonLocation: 
      FloatingActionButtonLocation.centerDocked,
    floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.add), onPressed: () {},),
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