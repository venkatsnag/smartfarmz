import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../widgets/user_crop_item.dart';
import '../providers/crop.dart';
import './edit_expense_screen.dart';
import 'package:provider/provider.dart';
import 'add_expense_screen.dart';
import '../providers/crops.dart';
import './expenses_overview_screen.dart';

import './pesticides_overview_screen.dart';
import './sales_overview_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../providers/apiClass.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:flutter/gestures.dart';


class CropForSaleDetailScreen extends StatefulWidget {

  static const routeName = '/crop-for-sale-detail';

  @override
  _CropForSaleDetailScreenState createState() => _CropForSaleDetailScreenState();
}

class _CropForSaleDetailScreenState extends State<CropForSaleDetailScreen> {

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
    List<String> networkImages;
    var imageUrls;
    final cropid = ModalRoute.of(context).settings.arguments as String;
    final loadedCrops = Provider.of<Crops>(context).findById(cropid);
    loadedCrops?.imageUrl?.isEmpty ?? true ? loadedCrops.imageUrl : imageUrls = loadedCrops.imageUrl.split(",") ;
    networkImages = imageUrls;
    /* var imageUrl = loadedCrops.imageUrl;
     dynamic img;
    if(  imageUrl.isEmpty) {
      img = imageUrl;
    }else {
      img = 0;
    } */


        return Scaffold(
          appBar: AppBar(
            title: Text(loadedCrops.title),
            
            ),
            
            
            body: 
             new SingleChildScrollView(
           child: new  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
             Container(
              width:  500,
              height: 350,
    child:  
            loadedCrops?.imageUrl?.isEmpty ?? true ?
            Image.network('https://cdn.pixabay.com/photo/2015/01/21/13/21/sale-606687_960_720.png', fit:BoxFit.cover) :
                 new Swiper(
        itemBuilder: (BuildContext context,int index){
          return new Image.network(networkImages[index],fit: BoxFit.fill,);
        },
        itemCount:networkImages.length,
        pagination: new SwiperPagination(),
        control: new SwiperControl(),
      ),),
      
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Container(
                   margin: EdgeInsets.all(10),
                   child: Text('${loadedCrops.title}'),
                   
                   
                 ),
                 
                 
               ),
               Stack(children: <Widget>[
                 Column(children: <Widget>[
                    RichText(
                     text: TextSpan(
                      text: 'Seed Variety : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedCrops.seedVariety}'),
                  ],
                  ),
                  ),
                   RichText(
                     text: TextSpan(
                      text: 'Farmer : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedCrops.farmer}')
                  ],
                  ),
                  ),
                  
                  RichText(
                     text: TextSpan(
                      text: 'Crop Method : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedCrops.cropMethod}'),
                  ],
                  ),
                  ),


                          RichText(
                     text: TextSpan(
                      text: 'Price : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                    TextSpan(text: '₹ '),
                  TextSpan(text: ' ${loadedCrops.price}'),
                    TextSpan(
      text: 'Per ',
      style: TextStyle(
        fontSize: 15,
        color: Colors.black.withOpacity(0.6),
      ),
    ), 
     TextSpan(
      text: ' ${loadedCrops.salesUnits}',
      style: TextStyle(
        fontSize: 15,
        color: Colors.black.withOpacity(0.6),
      ),
    ),
                  ],
                  ),
                  ),

                  RichText(
                     text: TextSpan(
                      text: 'Available Qty: ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                    
                  TextSpan(text: ' ${loadedCrops.quantityForSale}'),
                   
     TextSpan(
      text: ' ${loadedCrops.quantityUnits}',
      style: TextStyle(
        fontSize: 15,
        color: Colors.black.withOpacity(0.6),
      ),
    ),
                  ],
                  ),
                  ),

                    RichText(
                     text: TextSpan(
                      text: 'Description : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedCrops.description}'),
                  ],
                  ),
                  ),
 RichText(
                     text: TextSpan(
                      text: 'Crop Location : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedCrops.location}'),
                  ],
                  ),
                  ),
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
         launchWhatsApp(phone: "${loadedCrops.sellerContact}", message: "Hello");
      },
      child: Text(
        "WhatsApp Seller",
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
    ),
    ],
    )
                  
                   ]
                   ),
                 
               ]
               )
              /*  Container(
                 child: Banner(child: Container
                 (child: Center(child: Text('Todays Market Price at Guimalkapur Market is Rs.12'),)
                 ),
                 message: "message",
                 textDirection: TextDirection.ltr,
                 location: BannerLocation.bottomEnd,
                 ),
                 ), */],
               
               ),
               ),
                
               
    );
    
  }
 void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      final cropid = ModalRoute.of(context).settings.arguments as String;
    final loadedCrops = Provider.of<Crops>(context, listen: false).findById(cropid);
      if(selectedIndex == 0){
Navigator.of(context).pushNamed(ExpensesOverviewScreen.routeName, arguments: {'id':loadedCrops.id, 'type':'crops'});
      }
      if(selectedIndex == 1){
Navigator.of(context).pushNamed(PesticidesOverviewScreen.routeName, arguments: {'id':loadedCrops.id, 'type':'crops'});
      }
      if(selectedIndex == 2){
        Navigator.of(context).pushNamed(SalesOverviewScreen.routeName, arguments: {'id':loadedCrops.id, 'type':'crops'});
      }
      
      else(dynamic error){

      };
    });
  }
}

