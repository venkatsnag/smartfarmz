import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../widgets/user_crop_item.dart';
import 'package:provider/provider.dart';
import '../providers/users.dart';
import '../providers/user_rating.dart';
import 'package:rating_bar/rating_bar.dart';
import '../providers/user_rating.dart' as userRating;
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/apiClass.dart';

class FarmerDetailScreen extends StatefulWidget {

  static const routeName = '/farmer-detail';

  @override
  _FarmerDetailScreenState createState() => _FarmerDetailScreenState();
}

class _FarmerDetailScreenState extends State<FarmerDetailScreen> {

final apiurl = AppApi.api;
  var _isLoading = false;
  @override
  
/*   void initState() {
  Future<dynamic>.delayed(Duration.zero).then((dynamic _) async {
      setState(() {
       _isLoading = true;
      });
    final userId = ModalRoute.of(context).settings.arguments as String;



      await Provider.of<UserRating>(context, listen: false).getRating(userId);
      
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  } */ 
int selectedIndex = 0;

void launchWhatsApp(
    {@required String phone,
    @required String message,
    }) async {
  String url() {
    if (Platform.isIOS) {
      return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
    } else {
      return "whatsapp://send?phone=91$phone&text=${Uri.parse(message)}";
    }
  }

  if (await canLaunch(url())) {
    await launch(url());
  } else {
    throw 'Could not launch ${url()}';
  }
}

  @override
  Widget build(BuildContext context) {
    //final crop = Provider.of<Crops>(context);
    final userId = ModalRoute.of(context).settings.arguments as String;
    final loadedFarmers = Provider.of<Users>(context).findById(userId);
    /* final ratingData = Provider.of<UserRating>(context, listen: false);
    
   
    var averageRating = double.parse('${ratingData.totalRating}'); */
    


        return Scaffold(
          appBar: AppBar(
            title: 
            
            RichText(
                     text: TextSpan(
                      
                      text: '${loadedFarmers.userFirstname}',
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: '${loadedFarmers.userLastname}'),
                  ],
                  ),
            
                      
            ),
            
            ),
            
            
            body: Padding(
             padding:
             EdgeInsets.only(top: 10.0),
              child:new SingleChildScrollView(
              
              physics: ScrollPhysics(),
              child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
               loadedFarmers.userType == 'Buyer' ?
            loadedFarmers?.userImageUrl?.isEmpty ?? true ?
            //Image.asset('assets/img/Indian_farmer.png')
            Image.network("$apiurl/images/folder/buyer.jpg",
                width: 600,            
                height: 340,
              fit: BoxFit.cover,
              ):
                Image.network(loadedFarmers.userImageUrl,
                width: 600,            
                height: 340,
              fit: BoxFit.cover,
              ) : 
              
                (loadedFarmers.userType == 'Farmer' ?
            loadedFarmers?.userImageUrl?.isEmpty ?? true ?
                Image.network("$apiurl/images/folder/Indian_farmer.jpg",
                width: 600,            
                height: 340,
              fit: BoxFit.cover,
              ) :
                Image.network(loadedFarmers.userImageUrl,
                width: 600,            
                height: 340,
              fit: BoxFit.cover,
              )
               :
               (loadedFarmers.userType == 'Investor' ?
            loadedFarmers?.userImageUrl?.isEmpty ?? true ?
                Image.network("$apiurl/images/folder/buyer.jpg",
                width: 600,            
                height: 340,
              fit: BoxFit.cover,
              ) :
                Image.network(loadedFarmers.userImageUrl,
                width: 600,            
                height: 340,
              fit: BoxFit.cover,
              ) : Image.network("$apiurl/images/folder/Indian_farmer.jpg",
                width: 600,            
                height: 340,
              fit: BoxFit.cover,
              ) 
              ) ),
   
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Container(
                   margin: EdgeInsets.all(10),
                   child:  RichText(
                     text: TextSpan(
                      
                      text: '${loadedFarmers.userFirstname}',
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedFarmers.userLastname}'),
                  ],
                  ),
            
                      
            ),
                   
                   
                 ),
                 
                 
               ),
/* new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Farmer\'s Average Rating'),
         
                     ] ),  
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                       
          RatingBar.readOnly(
    initialRating: averageRating,
    isHalfAllowed: true,
    halfFilledIcon: Icons.star_half,
    filledIcon: Icons.star,
    emptyIcon: Icons.star_border,
    filledColor: Colors.amberAccent,
    halfFilledColor: Colors.amberAccent, 
  ),
                     ] ),  */ 
               Stack(children: <Widget>[
                 Column(children: <Widget>[
                    RichText(
                     text: TextSpan(
                      text: 'First Name : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedFarmers.userFirstname}'),
                  ],
                  ),
                  ),
                   RichText(
                     text: TextSpan(
                      text: 'Lastname : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                        '${loadedFarmers.userLastname}' != null ?
                  TextSpan(text: ' ${loadedFarmers.userLastname}') : TextSpan(text: "NA"),
                  ],
                  ),
                  ),
                  
                  
                  RichText(
                     text: TextSpan(
                      
                      text: 'State : ',
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      '${loadedFarmers.state}' != null ?
                  TextSpan(text: " ${loadedFarmers.state}") : TextSpan(text: "NA"),
                  ],
                  ),
                  
                  ),
              
                  RichText(
                     text: TextSpan(
                      
                      text: 'City : ',
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
         '${loadedFarmers.city}' != null ?
                  TextSpan(text: " ${loadedFarmers.city}") : TextSpan(text: "NA"),
                  ],
                  ),
                  
                  ),
                    RichText(
                     text: TextSpan(
                      
                      text: 'Village : ',
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      '${loadedFarmers.userVillage}' != null ?
                  TextSpan(text: " ${loadedFarmers.userVillage}")  : TextSpan(text: "NA"),
                  
                  ],
                  ),
                  
                  ),
                  
                     RichText(
                     text: TextSpan(
                      
                      text: 'Mobile : ',
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: [
       '${loadedFarmers.userMobile}' != null ?
                  TextSpan(text: "${loadedFarmers.userMobile}", 
                  recognizer: TapGestureRecognizer()..onTap = (){
                      launchWhatsApp(phone: "${loadedFarmers.userMobile}", message: "Hello");
                }) : TextSpan(text: "NA"),
                  
                   WidgetSpan(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: IconButton(
            icon: FaIcon(FontAwesomeIcons.whatsapp),
            onPressed: () {
               launchWhatsApp(phone: "${loadedFarmers.userMobile}", message: "Hello");
            },)
        ),
      ),
      
                  ],
                  
                  ),
                  
                  ),

                 

                   '${loadedFarmers.userType}' == 'Buyer' ?
              RichText(
                     text: TextSpan(
                      text: 'Will buy : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
       '${loadedFarmers.userCrops}' != null ?
                  TextSpan(text: '${loadedFarmers.userCrops}') : TextSpan(text: 'NA') 
                  ],
                  ),
                  ) : 
                  RichText(
                     text: TextSpan(
                      text: 'Grows : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
     '${loadedFarmers.userCrops}' != null ?
                  TextSpan(text: '${loadedFarmers.userCrops}') : TextSpan(text: 'NA') 
                  ],
                  ),
                  )
           
                  ],
                  ),

                  
                  
                   ]
                   ),
                   /* SizedBox(
                     height: 150,
                   ),
                         new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                      
         
    Text('Total Review\'s'),
                     ] ),
                     ListView.builder(
                       physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
  itemCount: ratingData.items.length,
  itemBuilder: (context, i) {
    return ListTile(
          title:  RatingBar.readOnly(
    initialRating:double.parse('${ratingData.items[i].rating}'),
    isHalfAllowed: true,
    halfFilledIcon: Icons.star_half,
    filledIcon: Icons.star,
    emptyIcon: Icons.star_border,
    filledColor: Colors.amberAccent,
    halfFilledColor: Colors.amberAccent, 
  ),
          subtitle: 
          RichText(
                     text: TextSpan(
                      
                      text: '${ratingData.items[i].comments}' != 'null' ?
                      '${ratingData.items[i].comments}' : '',
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                   
                  ),
                  
                  ),
          trailing: 
                  RichText(
                     text: TextSpan(
                      
                      text: 'Reviewer : ',
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: '${ratingData.items[i].reviewerId}'),
                  ],
                  ),
                  
                  ),
        );
      
   },
), */
                     
               ],
               
               ),
               
        ),),);
                    
    
  }

}

