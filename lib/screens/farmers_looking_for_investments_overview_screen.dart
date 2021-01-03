import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import 'package:provider/provider.dart';
import '../widgets/farmers_grid.dart';
import '../l10n/gallery_localizations.dart';
import './edit_crop_screen.dart';
import '../providers/crops.dart';
import '../providers/crop.dart';
import '../providers/auth.dart';
import 'package:flutter/scheduler.dart';
import '../widgets/farmers_item.dart';
import '../screens/farmer_detail_screen.dart';
import '../screens/crops_for_investment_details_screen.dart';

class FarmersForInvestmentOverviewScreen extends StatefulWidget {

  static const routeName = '/all-farmers-for-investments-overview';
  @override
  _FarmersForInvestmentOverviewScreenState createState() => _FarmersForInvestmentOverviewScreenState();
}




  

class _FarmersForInvestmentOverviewScreenState extends State<FarmersForInvestmentOverviewScreen> {

  List<Crop> _crops = [];
   String crop;
  TextEditingController _searchController = TextEditingController();
String userT;
var _showOnlyFavorites = false;
var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
  Future<dynamic>.delayed(Duration.zero).then((dynamic _) async {
      setState(() {
       _isLoading = true;
      });
       

      List<Crop> cropsList = await Provider.of<Crops>(context, listen: false).fetchCropsForInvestments(crop);
      
      setState(() {
        _crops.addAll(cropsList);
        
        _isLoading = false;
      });
    });


    super.initState();
    _searchController.addListener(_onSearchChanged);
  } 

dynamic _onSearchChanged(){
  searchResults();
  print(_searchController.text);
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
    var location = _crops[userSnapshot].location.toLowerCase();
    var cropMethod = _crops[userSnapshot].cropMethod.toLowerCase();
    var cropName = _crops[userSnapshot].title.toLowerCase();
    var description = _crops[userSnapshot].description.toLowerCase();
    if(location.contains(_searchController.text.toLowerCase()) 
    || cropMethod.contains(_searchController.text.toLowerCase())
    || description.contains(_searchController.text.toLowerCase())
    || cropName.contains(_searchController.text.toLowerCase())
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
print(_resultList);

}
  Future resultsLoaded;
  @override
  void didChangeDependencies() {
resultsLoaded = getusersStreamSnapShot(context);

    super.didChangeDependencies();
  }

   Future<void> _refreshCrops(BuildContext context) async {
     //final userId = ModalRoute.of(context).settings.arguments;
     //if(userId != null){
      
await Provider.of<Crops>(context,listen: false).fetchCropsForInvestments(crop);

     //}
  }

List _allResults = <dynamic> [];
List _resultList = <dynamic> [];

  dynamic getusersStreamSnapShot(BuildContext context)async {
final dynamic userData = Provider.of<Auth>(context, listen: false);

 String userType = '${userData.userType}';
   userT = userType;
dynamic farmersData ;
if(userT == 'Investor') {
  farmersData = await Provider.of<Crops>(context,listen: false).fetchCropsForInvestments(crop);
}
   else {
     //farmersData = await Provider.of<Users>(context,listen: false).getUsersByType('Farmer');
   }
   
    
    setState(() {
    return  _allResults = farmersData;
    });
    searchResults();
    
  }
 

@override
Widget build(BuildContext context) {

  WidgetsBinding.instance.addPostFrameCallback((_) => _refreshCrops(context));
  
   final dynamic userData = Provider.of<Auth>(context, listen: false);

   // _users = farmers;
   
   
   String userType = '${userData.userType}';
   userT = userType;

  return  Consumer<Auth>
      (builder: (ctx, auth, _) => Scaffold(
      appBar: AppBar(
        title:  userType == 'Buyer' || userType == 'Investor'?? 
        auth.isAuth ? 
        Text(GalleryLocalizations.of(context).cropforInvestments,) :
        Text(GalleryLocalizations.of(context).allBuyers,),
        actions:<Widget> [
         
            
        ],
      ),
     //drawer: AppDrwaer(),
      body: Container( child: Column(
        children: [

          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: "Search with crop names, location, crop method",
              hintText: "Search with crop names, location, crop method",
              prefixIcon: Icon(Icons.search)),),
        Expanded(child: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: _resultList.length,

        itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(left: 15.0, top: 8.0, bottom: 16.0),
                  child: InkWell(
                    
                    child: Container(
                      
                    width: 100,
                      height:150,
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            //borderRadius: widget.iconImageBorderRadius,
                            child:  Card(
      margin: EdgeInsets.all(5),
     color: Colors.white,
    elevation: 5,
    shape: Border(right: BorderSide(color: Colors.lightGreen, width: 10)),
    shadowColor: Colors.grey,
    child: InkWell(
  onTap: () {
          Navigator.of(context).pushNamed(CropForInvestmentDetailScreen.routeName, 
          arguments: _resultList[index].id,
        
          );
        },
 child: 
         Row(
          children: [
           
    
  
          new       
          Container(
            width: 150,
            height: 250,
                padding: const EdgeInsets.all(8.0),
                child: _resultList[index]?.imageUrl?.isEmpty ?? true ?
        Image.asset('assets/img/Indian_farmer.png') :
    Image.network(_resultList[index].imageUrl, fit:BoxFit.cover,
    ),), 
            Flexible(
              child: Container(
              width: 165,
              height: 5000,
             
              padding: const EdgeInsets.all(10.0),
              child: 
              
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                    RichText(
                     text: TextSpan(
                      text: 'Farmer: ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: _resultList[index].farmer),
                  ],
                  ),
                  ),
                  _resultList[index].title != null ?
            RichText(
                     text: TextSpan(
                      text: 'Crop name: ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: _resultList[index].title),
                  ],
                  ),
                  ) :  Text('NA',
          style: TextStyle(color: Colors.black),                 
          ),
                   _resultList[index].cropMethod != null ?
                     RichText(
                     text: TextSpan(
                      text: 'Farming Method: ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: _resultList[index].cropMethod),
                  ],
                  ),
                  ) :  Text('NA',
          style: TextStyle(color: Colors.black),                 
          ),

            _resultList[index].location != null ?
                     RichText(
                     text: TextSpan(
                      text: 'Crop Location: ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: _resultList[index].location),
                  ],
                  ),
                  ) :  Text('NA',
          style: TextStyle(color: Colors.black),                 
          ),

            /*  _resultList[index].expectedTotalCropCost != null ?
                     RichText(
                     text: TextSpan(
                      text: 'Expected crop cost: ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: _resultList[index].expectedTotalCropCost.toString()),
                  ],
                  ),
                  ) :  Text('NA',
          style: TextStyle(color: Colors.black),                 
          ),

             _resultList[index].investmentNeeded != null ?
                     RichText(
                     text: TextSpan(
                      text: 'Investment requested: ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: _resultList[index].investmentNeeded.toString()),
                  ],
                  ),
                  ) :  Text('NA',
          style: TextStyle(color: Colors.black),                 
          ), */

      /*       _resultList[index].seedingDate != null ?
                     RichText(
                     text: TextSpan(
                      text: 'Expected Start date: ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: _resultList[index].seedingDate.toString()),
                  ],
                  ),
                  ) :  Text('NA',
          style: TextStyle(color: Colors.black),                 
          ), */

          
          
          
                  
                 
                 /* farmer.userLastname != null ?  Text(farmer.userLastname,
                      style: TextStyle(color: Colors.black.withOpacity(0.8))) : 'NA' , */
                      /* new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Farmer\'s Average Rating'),
         
                     ] ),  */
                    /*    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        
          RatingBar.readOnly(
    initialRating: 3.5,
    isHalfAllowed: true,
    halfFilledIcon: Icons.star_half,
    filledIcon: Icons.star,
    emptyIcon: Icons.star_border,
    filledColor: Colors.amberAccent,
    halfFilledColor: Colors.amberAccent, 
    size: 25,
  ),
  
                     ] ),   */
                  //Text(farmer.userLastname),
                ],
              ),),)
              
           
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        )
        ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
      )) 
      ],)
         
     
                    
      
      ),
      ),
       );
}


}
