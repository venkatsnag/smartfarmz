
import 'package:flutter/material.dart';
import '../providers/crop.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:json_table/json_table.dart';
import '../screens/add_market_prices.dart';
import '../l10n/gallery_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/apiClass.dart';

class  MarketPriceItemNew {
final String id;
String marketName;
String cropTitle;
final double price;
DateTime priceDate;
final double quantity;
String units;
String state;
String city;



  MarketPriceItemNew({
  this.id,  
  @required this.marketName,
  @required this.cropTitle, 
  @required this.price,
  this.priceDate,
  @required this.quantity,  
  @required this.units,  
  this.state,
  this.city,
  
   });
 
}

class MarketPricesScreen extends StatefulWidget {


static const routeName = '/market-prices-overview3';
   MarketPricesScreen({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  
  @override
  _MarketPricesScreenState createState() => _MarketPricesScreenState();
}

class _MarketPricesScreenState extends State<MarketPricesScreen> {
  final apiurl = AppApi.api;
  int _counter = 0;

  String dropdownValue1;
  String dropdownValue2;
  String dropdownValue3;
  bool _selected = true;
  
List<MarketPriceItemNew> _pricelList = [];

List<MarketPriceItemNew> get pricelList{

return [..._pricelList];
}

TextEditingController _searchController = TextEditingController();

Future<List<MarketPriceItemNew>> fetchMarketprices()async {
  var url = '$apiurl/marketPrices';

  final response = await http.get(url);
    
  final List<dynamic> marketPricesMap = jsonDecode(response.body);
  List<MarketPriceItemNew> loadedMarketPrices = [];
  if(marketPricesMap != null){
     setState(() {
       _isLoading = true;
      });
marketPricesMap.forEach((dynamic marketPriceData){
  loadedMarketPrices.add(MarketPriceItemNew(
    id: marketPriceData['id'].toString(),
    marketName: marketPriceData['marketName'],
    cropTitle: marketPriceData['cropTitle'],
    city: marketPriceData['city'],
    price: double.parse(marketPriceData['price'].toString()),
    quantity: double.parse(marketPriceData['quantity'].toString()),
    units: marketPriceData['units'],
    //priceDate: DateTime.parse(marketPriceData['priceDate']),
   
    ),
     
    );
_pricelList = loadedMarketPrices.toList();


});
return loadedMarketPrices.toList();
}

}



var _isLoading = false;
 @override
  void initState() {
    //_pricelList = List<MarketPriceItemNew>();
     setState(() {
       _isLoading = true;
      });
    fetchMarketprices();
    setState(() {
        //_users.addAll(userList);
        
        _isLoading = false;
      });
      super.initState();
       _searchController.addListener(_onSearchChanged);
  }

  dynamic _onSearchChanged(){
  searchResults();
  //print(_searchController.text);
}

@override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

dynamic searchResults(){
   
var showResults = <dynamic> [];

if(_searchController.text != ''){
  // we have search parameter
 // for (var userSnapshot in _allResults){
   for (var userSnapshot = 0; userSnapshot < _allResults.length; ++userSnapshot){

    //String buyItem = _users[0].userCrops.toLowerCase();
    var cropTitle = _pricelList[userSnapshot].cropTitle.toLowerCase();
    var marketName = _pricelList[userSnapshot].marketName.toLowerCase();
    var city = _pricelList[userSnapshot].city.toLowerCase();
    if(cropTitle.contains(_searchController.text.toLowerCase()) 
    || marketName.contains(_searchController.text.toLowerCase())
    || city.contains(_searchController.text.toLowerCase())
    ){
      showResults.add( _allResults[userSnapshot]);
   
  }
   
  }
} else {
 showResults =  List<dynamic>.from(_allResults);
}
setState(() {
        //_users.addAll(userList);
        
        _resultList = showResults;
      });

}
  Future resultsLoaded;
  @override
  void didChangeDependencies() {
resultsLoaded = getMarketPricesStreamSnapShot(context);

    super.didChangeDependencies();
  }

List _allResults = <dynamic> [];
List _resultList = <dynamic> [];

  dynamic getMarketPricesStreamSnapShot(BuildContext context)async {

dynamic pricesData ;
 pricesData = await fetchMarketprices();

   
    
    setState(() {
    return  _allResults = pricesData;
    });
    searchResults();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(GalleryLocalizations.of(context).market_prices, textAlign: TextAlign.center,),
        actions: <Widget>[
      /*   IconButton(icon: Icon(Icons.add), onPressed: (){
          Navigator.of(context).pushNamed(AddMarketPricesScreen.routeName);
        },) */
      ]
      ),
      resizeToAvoidBottomInset: false,
      body:   Container(
        width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
               scrollDirection: Axis.vertical,
                  child: 
                  Wrap(
                    direction: Axis.vertical,
                    children: <Widget>[
Row(children: [
SizedBox(
      width: 400, // hard coding child width
      child:    
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: "Search prices by crop, city, market etc",
              hintText: "Search prices by crop, city, market etc",
              prefixIcon: Icon(Icons.search)),),),
],),


                      Row(
                        
                        children: <Widget>[
                          // table header items
                         SizedBox(
      width: 90, // hard coding child width
      child: const DecoratedBox(
    decoration: const BoxDecoration(
      color: Colors.white10
      
    ),
    child:  Padding(
  padding: const EdgeInsets.all(3.0),
                  child: Text("Commodity",
                  style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0
                  ),
                  ),),
    ),
                   ), 
                  SizedBox(
      width: 90, // hard coding child width
      child:  const DecoratedBox(
    decoration: const BoxDecoration(
      color: Colors.white10
      
    ),
    child:  
                    
                  Padding(
  padding: const EdgeInsets.all(3.0),
                  child: Text("Market Name",
                  style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0
                  ),
                  ),),),),
                   
                   SizedBox(
      width: 90, // hard coding child width
      child:
                    const DecoratedBox(
    decoration: const BoxDecoration(
      color: Colors.white10
      
    ),
    child:  Padding(
  padding: const EdgeInsets.all(1.0),
                  child: Text("City",
                  style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0
                  ),
                  ),),)),

                     SizedBox(
      width: 50, // hard coding child width
      child:
                   const DecoratedBox(
    decoration: const BoxDecoration(
      color: Colors.white10
      
    ),
    child:   Padding(
  padding: const EdgeInsets.all(3.0),
                  child: Text("Price",
                  style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0
                  ),
                  ),),)),

                   SizedBox(
      width: 50, // hard coding child width
      child:
                   const DecoratedBox(
    decoration: const BoxDecoration(
      color: Colors.white10
      
    ),
    child:   Padding(
  padding: const EdgeInsets.all(3.0),
                  child: Text("Qty",
                  style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0
                  ),
                  ),),)),
                   SizedBox(
      width: 50, // hard coding child width
      child:
                  const DecoratedBox(
    decoration: const BoxDecoration(
      color: Colors.white10
      
    ),
    child:   Padding(
  padding: const EdgeInsets.all(3.0),
                  child: Text("Unit",
                  style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0
                  ),
                  ),),)),


                        ],
                      ),

  Container(
       height: MediaQuery.of(context).size.height,
       width: MediaQuery.of(context).size.width,
  child:
          ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: _resultList.length,
              itemBuilder: (BuildContext context, int index) =>
  ListView(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true, 
      padding: EdgeInsets.all(1.0),
      children: <Widget>[
        
        Table(
          defaultColumnWidth: const FlexColumnWidth(1.0),
          children: <TableRow>[
            TableRow(
              decoration: BoxDecoration(
                  color: Colors.greenAccent// Background color for the row
                      .withOpacity(index % 2 == 0 ? 1.0 : 0.5), // To alternate between dark and light shades of the row's background color.
                ),
              children: <Widget>[


                      Row(
                        children: <Widget>[
                          // data cells
                            Expanded(
      flex: 6, // hard coding child width
      child:  Padding(
  padding: const EdgeInsets.all(10.0),
                  child:
                   Text(_resultList[index].cropTitle,
                  style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0
                  ),
                  ),),),
                 Expanded(
      flex: 7, // hard coding child width
      child:  Padding(
  padding: const EdgeInsets.all(7.0),
                  child:
                   Text(_resultList[index].marketName,
                  style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0
                  ),
                  ),),),
                   Expanded(
      flex: 8, // hard coding child width
      child:
                    Padding(
  padding: const EdgeInsets.all(4.0),
                  child:
                   Text(_resultList[index].city,
                  style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0
                  ),
                  ),),),

                    Wrap(
            
            children: <Widget>[
                    Padding(
  padding: const EdgeInsets.all(6.0),
                  child:
                   Text(_resultList[index].price.toString(),
                  style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0
                  ),
                  ),),]),

                   Wrap(
            
            children: <Widget>[
                    Padding(
  padding: const EdgeInsets.all(6.0),
                  child:
                   Text(_resultList[index].quantity.toString(),
                  style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0
                  ),
                  ),),]),

                  Wrap(
            
            children: <Widget>[
                   Padding(
  padding: const EdgeInsets.all(6.0),
                  child:
                   Text(_resultList[index].units,
                  style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0
                  ),
                  ),),]),










                        ],
                      ),
              ],
                      ),
                    ],
                  ),
                  ],
                ),
                
        ),
      
    ),

 
                
    ],
    ),
    )
    ),
                 
              
            
        
    );
   
  }

  BoxDecoration myBottomBorder() {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.black,
          width: 1.5,
        ),
      ),
    );
  }
}