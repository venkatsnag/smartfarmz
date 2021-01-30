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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_icons/flutter_icons.dart';

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

  void launchWhatsApp({
    @required String phone,
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

    double c_width = MediaQuery.of(context).size.width*0.8;
    /* final ratingData = Provider.of<UserRating>(context, listen: false);
    
   
    var averageRating = double.parse('${ratingData.totalRating}'); */

    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            text: '${loadedFarmers.userFirstname}',
            style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(text: '${loadedFarmers.userLastname}'),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 1.0),
        child: new SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(direction: Axis.horizontal, children: <Widget>[
                loadedFarmers.userType == 'Buyer'
                    ? loadedFarmers?.userImageUrl?.isEmpty ?? true
                        ?
                        //Image.asset('assets/img/Indian_farmer.png')
                        Image.network(
                            "$apiurl/images/folder/buyer.jpg",
                            width: 500,
                            height: 240,
                            fit: BoxFit.contain,
                          )
                        : Image.network(
                            loadedFarmers.userImageUrl,
                            width: 600,
                            height: 340,
                            fit: BoxFit.cover,
                          )
                    : (loadedFarmers.userType == 'Farmer' || loadedFarmers.userType == 'Hobby/DYIFarmer'
                        ? loadedFarmers?.userImageUrl?.isEmpty ?? true
                            ? Image.network(
                                "$apiurl/images/folder/Indian_farmer.jpg",
                                width: 500,
                                height: 240,
                                fit: BoxFit.contain,
                              )
                            : Image.network(
                                loadedFarmers.userImageUrl,
                                width: 600,
                                height: 340,
                                fit: BoxFit.cover,
                              )
                        : (loadedFarmers.userType == 'Investor'
                            ? loadedFarmers?.userImageUrl?.isEmpty ?? true
                                ? Image.network(
                                    "$apiurl/images/folder/buyer.jpg",
                                    width: 500,
                                    height: 200,
                                    fit: BoxFit.contain,
                                  )
                                : Image.network(
                                    loadedFarmers.userImageUrl,
                                    width: 600,
                                    height: 340,
                                    fit: BoxFit.cover,
                                  )
                            : Image.network(
                                "$apiurl/images/folder/Indian_farmer.jpg",
                                width: 500,
                                height: 240,
                                fit: BoxFit.contain,
                              ))),
              ]),

              //First line
              new Container(
               
                margin: const EdgeInsets.all(6.0),
                padding: const EdgeInsets.all(6.0),
                decoration:
                    BoxDecoration(
                    boxShadow: [
                     BoxShadow(color: Colors.grey[100], spreadRadius: 1),
                                 ],
                    ),
                child: 
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Chip(
                                    label: new Icon(
                                      MaterialIcons.face,
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Name',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ]),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                width: 120,
                                margin: EdgeInsets.all(2),
                                padding: const EdgeInsets.all(3.0),
                                /*            decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)
                              ), */

                               child: new Column (
                                    children: <Widget>[ 
          
                                    RichText(
                                  text: TextSpan(
                                    text: '${loadedFarmers.userFirstname}',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontWeight: FontWeight.bold),
                                   
                                  ),
                                ),
                                
                                RichText(
                                  text: TextSpan(
                                    text: '${loadedFarmers.userLastname}',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontWeight: FontWeight.bold),
                                   
                                  ),
                                ),
                                
                                
                                
                                ]),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(2.0),),



                              loadedFarmers.userType == 'Buyer'
                                   ?
                               Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  
                            new Chip(
                              label: new FaIcon(FontAwesomeIcons.carrot)
                            ),
                            
                              RichText(
                                    text: TextSpan(
                                      text: 'Buys',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ), 
                            ]) :
                             Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  
                            new Chip(
                              label: new FaIcon(FontAwesomeIcons.seedling)
                            ),
                            
                            
                                  RichText(
                                    text: TextSpan(
                                      text: 'Grows',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                            ]),

                            Flexible(
                             
                                 child:Padding(
                              padding: const EdgeInsets.all(6.0),
                              
                                
                               
                                child: new Column (
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 
                               children: <Widget>[ 
                                        RichText(
                                  text: TextSpan(
                                    text: '${loadedFarmers.userCrops}',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                ]
                                ),
                             
                            ),
                                    ),
                          
                                         ]
                                 ),
                                          ),

                                        // Next Line

                                new Container(
               
                               margin: const EdgeInsets.all(6.0),
                padding: const EdgeInsets.all(6.0),
                decoration:
                    BoxDecoration(
                    boxShadow: [
                     BoxShadow(color: Colors.grey[100], spreadRadius: 3),
                                 ],
                    ),
                child: 
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Chip(
                                    label: new Icon(
                                      MaterialIcons.person_pin_circle,
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Location',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ]),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                               // width: c_width,
                                margin: EdgeInsets.all(2),
                                padding: const EdgeInsets.all(3.0),
                                /*            decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)
                              ), */

                               child: Container(
                                 width: 120,
                                 child : new Column (
                                    children: <Widget>[ 
                                       '${loadedFarmers.userVillage}' != null ?
                                    RichText(
                                  text: TextSpan(
                                    text: '${loadedFarmers.userVillage}',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontWeight: FontWeight.bold),
                                   
                                  ),
                                ) : 
                                 RichText(
                                  text: TextSpan(
                                    text: '${loadedFarmers.city}',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontWeight: FontWeight.bold),
                                   
                                  ),
                                ),
                                
                                RichText(
                                  text: TextSpan(
                                    text: '${loadedFarmers.state}',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontWeight: FontWeight.bold),
                                   
                                  ),
                                ),
                                
                                  '${loadedFarmers.country}' != null ?
                                 RichText(
                                  text: TextSpan(
                                    text: '${loadedFarmers.country}',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontWeight: FontWeight.bold),
                                   
                                  ),
                                ) : Container(),
                                
                                ]),),
                              ),
                            ),

                            /* Padding(
                              padding: const EdgeInsets.all(2.0),),



                              loadedFarmers.userType == 'Buyer'
                                   ?
                               Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  
                            new Chip(
                              label: new FaIcon(FontAwesomeIcons.carrot)
                            ),
                            
                              RichText(
                                    text: TextSpan(
                                      text: 'Buys',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ), 
                            ]) :
                             Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  
                            new Chip(
                              label: new FaIcon(FontAwesomeIcons.seedling)
                            ),
                            
                            
                                  RichText(
                                    text: TextSpan(
                                      text: 'Grows',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                            ]),

                            Flexible(
                             
                                 child:Padding(
                              padding: const EdgeInsets.all(6.0),
                              
                                
                               
                                child: new Column (
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 
                               children: <Widget>[ 
                                        RichText(
                                  text: TextSpan(
                                    text: '${loadedFarmers.userCrops}',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                ]
                                ),
                             
                            ),
                                    ), */
                          
                                         ]
                                 ),
                                          ),


              Stack(children: <Widget>[
                Column(
                  children: <Widget>[
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.green)),
                          color: Colors.white,
                          textColor: Colors.green,
                          padding: EdgeInsets.all(8.0),
                          onPressed: () {
                            launchWhatsApp(
                                phone: "${loadedFarmers.userMobile}",
                                message: "Hello");
                          },
                          child: loadedFarmers.userType == 'Buyer'  ? Text(
                            "WhatsApp Buyer",
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ) :
                          Text(
                            "WhatsApp Seller",
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ]),
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
        ),
      ),
    );
  }
}
