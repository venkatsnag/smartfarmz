import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import 'package:provider/provider.dart';
import '../widgets/farmers_grid.dart';
import '../l10n/gallery_localizations.dart';
import './edit_crop_screen.dart';
import '../providers/users.dart';
import '../providers/auth.dart';
import 'package:flutter/scheduler.dart';
import '../widgets/farmers_item.dart';
import '../screens/farmer_detail_screen.dart';

class FarmersOverviewScreen extends StatefulWidget {

  static const routeName = '/all-farmers-overview';
  @override
  _FarmersOverviewScreenState createState() => _FarmersOverviewScreenState();
}




  

class _FarmersOverviewScreenState extends State<FarmersOverviewScreen> {

  List<UsersItem> _users = [];
   
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
        final dynamic userData = Provider.of<Auth>(context, listen: false);
        String users = '${userData.userType}';
        String userType;
        users == 'Farmer' ? 
        userType = 'Buyer' : 
        userType = 'Farmer';


      List<UsersItem> userList = await Provider.of<Users>(context, listen: false).getUsersByType(userType);
      
      setState(() {
        _users.addAll(userList);
        
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
    var buyItem = _users[userSnapshot].userCrops.toLowerCase();
    var village = _users[userSnapshot].userVillage.toLowerCase();
    var state = _users[userSnapshot].state.toLowerCase();
    if(buyItem.contains(_searchController.text.toLowerCase()) 
    || village.contains(_searchController.text.toLowerCase())
    || state.contains(_searchController.text.toLowerCase())
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
print(showResults);
}
  Future resultsLoaded;
  @override
  void didChangeDependencies() {
resultsLoaded = getusersStreamSnapShot(context);

    super.didChangeDependencies();
  }

   Future<void> _refreshUsers(BuildContext context) async {
     //final userId = ModalRoute.of(context).settings.arguments;
     //if(userId != null){
      userT == 'Farmer' ?
await Provider.of<Users>(context,listen: false).getUsersByType('Buyer'):
await Provider.of<Users>(context,listen: false).getUsersByType('Farmer');
     //}
  }

List _allResults = <dynamic> [];
List _resultList = <dynamic> [];

  dynamic getusersStreamSnapShot(BuildContext context)async {
final dynamic userData = Provider.of<Auth>(context, listen: false);

 String userType = '${userData.userType}';
   userT = userType;
dynamic farmersData ;
if(userT == 'Farmer') {
  farmersData = await Provider.of<Users>(context,listen: false).getUsersByType('Buyer');
}
   else {
     farmersData = await Provider.of<Users>(context,listen: false).getUsersByType('Farmer');
   }
   
    
    setState(() {
    return  _allResults = farmersData;
    });
    searchResults();
    
  }
 

@override
Widget build(BuildContext context) {

  WidgetsBinding.instance.addPostFrameCallback((_) => _refreshUsers(context));
  
   final dynamic userData = Provider.of<Auth>(context, listen: false);

   // _users = farmers;
   
   
   String userType = '${userData.userType}';
   userT = userType;

  return  Consumer<Auth>
      (builder: (ctx, auth, _) => Scaffold(
      appBar: AppBar(
        title:  userType == 'Buyer' || userType == 'Investor'?? 
        auth.isAuth ? 
        Text(GalleryLocalizations.of(context).allFarmers,) :
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
              labelText: "Search by crop, city, village, state",
              hintText: "Search with crop names,city, village, state",
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
          Navigator.of(context).pushNamed(FarmerDetailScreen.routeName, 
          arguments: _resultList[index].id,
        
          );
        },
 child: 
         Row(
          children: [
           
    
  
          new Container(
            width: 150,
            height: 150,
                padding: const EdgeInsets.all(8.0),
                child: _resultList[index]?.userImageUrl?.isEmpty ?? true ?
        Image.asset('assets/img/Indian_farmer.png') :
    Image.network(_resultList[index].userImageUrl, fit:BoxFit.cover,
    ),), 
    
    Flexible(child: 
    Padding(
  padding: const EdgeInsets.all(8.0),
  child:
     Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                    RichText(
                     text: TextSpan(
                      text: 'Name : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: _resultList[index].userFirstname),
                  ],
                  ),
                  ),
                  _resultList[index].state != null ?
            RichText(
                     text: TextSpan(
                      text: 'State : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: _resultList[index].state),
                  ],
                  ),
                  ) :  Text('NA',
          style: TextStyle(color: Colors.black),                 
          ),
                  _resultList[index].city != null ?
            RichText(
                     text: TextSpan(
                      text: 'City : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: _resultList[index].city),
                  ],
                  ),
                  ) :  Text('NA',
          style: TextStyle(color: Colors.black),                 
          ),
                   _resultList[index].userVillage != null ?
                     RichText(
                     text: TextSpan(
                      text: 'Village : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: _resultList[index].userVillage),
                  ],
                  ),
                  ) :  Text('NA',
          style: TextStyle(color: Colors.black),                 
          ),

          
          
           _resultList[index].userType == 'Buyer' ?
              RichText(
                     text: TextSpan(
                      text: 'Will buy : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      _resultList[index].userCrops != null ?
                  TextSpan(text: _resultList[index].userCrops) : TextSpan(text: 'NA') 
                  ],
                  ),
                  ) : 
                  Expanded(child: RichText(
                     text: TextSpan(
                      text: 'Grows : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      _resultList[index].userCrops != null ?
                  TextSpan(text: _resultList[index].userCrops) : TextSpan(text: 'NA') 
                  ],
                  ),
                  ))
                  
                  
                 
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
              ),),
            )
            
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
