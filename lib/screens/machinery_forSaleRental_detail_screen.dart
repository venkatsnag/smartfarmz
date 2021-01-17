import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/machinery.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../providers/apiClass.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:flutter/gestures.dart';


class MachineryForSaleRentalDetailScreen extends StatefulWidget {

  static const routeName = '/machinery-for-sale-detail';

  @override
  _MachineryForSaleRentalDetailScreenState createState() => _MachineryForSaleRentalDetailScreenState();
}

class _MachineryForSaleRentalDetailScreenState extends State<MachineryForSaleRentalDetailScreen> {

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
    final id = ModalRoute.of(context).settings.arguments as String;
    final loadedMachinery = Provider.of<Machinery>(context).findById(id);
    loadedMachinery?.imageUrl?.isEmpty ?? true ? loadedMachinery.imageUrl : imageUrls = loadedMachinery.imageUrl.split(",") ;
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
            title: Text(loadedMachinery.type),
            
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
            loadedMachinery?.imageUrl?.isEmpty ?? true ?
            Image.network('https://cdn.pixabay.com/photo/2015/01/21/13/21/sale-606687_960_720.png', fit:BoxFit.contain) :
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
                   child: Text('${loadedMachinery.type}'),
                   
                   
                 ),
                 
                 
               ),
               Stack(children: <Widget>[
                 Column(children: <Widget>[
                    RichText(
                     text: TextSpan(
                      text: 'Brand : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedMachinery.brand}'),
                  ],
                  ),
                  ),
                   RichText(
                     text: TextSpan(
                      text: 'Model : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedMachinery.model}')
                  ],
                  ),
                  ),
                  
                  RichText(
                     text: TextSpan(
                      text: 'Year : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedMachinery.year}'),
                  ],
                  ),
                  ),

                    loadedMachinery.forSale == 1 ? 
                          RichText(
                     text: TextSpan(
                      text: 'salePrice : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                    TextSpan(text: '₹ '),
                  TextSpan(text: ' ${loadedMachinery.salePrice}'),
                    TextSpan(
      text: 'Per ',
      style: TextStyle(
        fontSize: 15,
        color: Colors.black.withOpacity(0.6),
      ),
    ), 
     TextSpan(
      text: ' ${loadedMachinery.units}',
      style: TextStyle(
        fontSize: 15,
        color: Colors.black.withOpacity(0.6),
      ),
    ),
                  ],
                  ),
                  ) :

                  RichText(
                     text: TextSpan(
                      text: 'Rental Price : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                    TextSpan(text: '₹ '),
                  TextSpan(text: ' ${loadedMachinery.rentPrice}'),
                    TextSpan(
      text: 'Per ',
      style: TextStyle(
        fontSize: 15,
        color: Colors.black.withOpacity(0.6),
      ),
    ), 
     TextSpan(
      text: ' ${loadedMachinery.units}',
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
      
                  TextSpan(text: ' ${loadedMachinery.description}'),
                  ],
                  ),
                  ),
 RichText(
                     text: TextSpan(
                      text: 'Condition of Machinery : ',
                      
                    style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
      
                  TextSpan(text: ' ${loadedMachinery.machCondition}'),
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
         launchWhatsApp(phone: "${loadedMachinery.sellerContact}", message: "Hello");
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
            ],
               
               ),),
                
               
    );
    
  }

}

