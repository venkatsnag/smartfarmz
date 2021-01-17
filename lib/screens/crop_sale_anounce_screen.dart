import 'dart:async';
import 'package:flutter/material.dart';
import '../providers/crop.dart';
import 'package:provider/provider.dart';
import '../providers/crops.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'dart:convert';


import '../providers/user_profiles.dart';
import '../providers/apiClass.dart';
import '../providers/auth.dart';


class CropSaleAnouncementScreen extends StatefulWidget {
  static const routeName = '/crops-sale-anounce';
  @override

  //final String url = 'http://api.happyfarming.net:5000/upload';
  //final String url = 'http://192.168.39.190:5000/upload';
  _CropSaleAnouncementScreenState createState() =>
      _CropSaleAnouncementScreenState();
}

class _CropSaleAnouncementScreenState extends State<CropSaleAnouncementScreen> {
final apiurl = AppApi.api;

  final _priceFocusNode = FocusNode();
  final _areaFocusNode = FocusNode();
  final _seedVarietyFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _farmerFocusNode = FocusNode();
  final _investorFocusNode = FocusNode();
  final _cropMethodFocusNode = FocusNode();
  final _expectedHarvestDateFocusNode = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _locationFocusNode = FocusNode();
  final _contactFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();

  bool _validate = false;
  String _action;

  var _forSaleCrop = Crop(
    id: null,
    title: '',
    otherTitle: '',
    price: 0,
    description: '',
    farmer: '',
    investor: '',
    seedingDate: DateTime.now(),
    expectedHarvestDate: DateTime.now(),
    cropMethod: '',
    area: 0,
    units: '',
    salesUnits: '',
    userId: '',
    seedVariety: '',
    imageUrl: '',
    location: '',
    sellerName: '',
    sellerContact: '',
    quantityForSale: '',
    quantityUnits: '',
    forSale: 0,
  );

  Map<String, String> _initValues = {
    'title': '',
    'otherTitle': '',
    'description': '',
    'farmer': '',
    'investor': '',
    'cropMethod': '',
    'seedingDate': '',
    'expectedHarvestDate': '',
    'area': '',
    'units': '',
    'salesUnits': '',
    'seedVariety': '',
    'userId': '',
    'price': '',
    'imageUrl': '',
    'location': '',
    'quantityForSale': '',
    'quantityUnits': '',
    'sellerName':'',
    'sellerContact':'',
    'forSale': '',
  };
  var _isInit = true;
  var _isLoading = false;


// Titles List
  List<String> _title = [
    'Tomato',
    'Brinjal',
    'Lady Finger',
    'Red Chilli'
  ]; // Option 2
  String _selectedTitle;

// Sales Unit of measurements

  List<String> _salesUom = ['Kgs', 'Tons', 'Quintals', 'Box']; // Option 2
  String _selectedSalesUom;

// Sales Unit of measurements

  List<String> _quantityUnits = ['Kgs', 'Tons', 'Quintals', 'Box']; // Option 2
  String _selectedquantityUnits;

// Unit of measurements
  List<String> _uom = ['Yard', 'Acer', 'Hectar', 'Gunta']; // Option 2
  String _selectedUom;

// Crop method
  List<String> _cropMethod = [
    'Natural Farming',
    'Organic Farming',
    'Conventional/Chemical Farming'
  ]; // Option 2
  String _selectedCropMethod;
  @override
  void initState() {
    Future<dynamic>.delayed(Duration.zero).then((dynamic _) async {
      setState(() {
        //_storedImage = File(_imageFile.path);
     
    
       _isLoading = true;
      });
       final dynamic user = Provider.of<Auth>(context, listen: false);
    String userId = '${user.userId}';
  
    final dynamic userData =  await Provider.of<UserProfiles>(context, listen: false).getusers(userId);
     
     
    dynamic userFirstName = userData[0].userFirstname;
    dynamic userMobile = userData[0].userMobile;
    userId = userData[0].userId;

        _forSaleCrop.userId = userId;
    _forSaleCrop.sellerName = userFirstName;
    _forSaleCrop.sellerContact = userMobile;
      
      setState(() {
        _isLoading = false;
      });
    });
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  DateTime selectedDate = new DateTime.now();
  Future _selectDate(BuildContext context) async {
    //final DateTime _date = DateTime.now();
    final _date = new DateTime.now();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2999),
    );

    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
      print(selectedDate);
      return _forSaleCrop.expectedHarvestDate = picked;
    } else {
      _forSaleCrop.expectedHarvestDate = selectedDate;
    }

    //if(picked != null) setState(() => val = picked.toString());
  }

// Uppload Picture

  List<String> imagesFromAPI;
  List<String> tempImages;
  
  String patchImage;
  String _error;
  String appendedImages;
  List<dynamic> imagesFromPhone = List<dynamic>();
  /* Future<File> _imageFromPhone; */
  Widget buildGridView(BuildContext context) {
    
    return GridView.count(
      crossAxisCount: 2,
      children: 
      (_imageUrlController.text.isEmpty) ?
      List.generate(imagesFromPhone.length, (index) {
             
              return Card(
                clipBehavior: Clip.antiAlias,
                
                child:  Stack(
                  children: <Widget>[
                    Image.file(
                      imagesFromPhone[index],
        fit: BoxFit.cover,
        width: double.infinity,
        ),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: InkWell(
                        child: Icon(
                          Icons.remove_circle,
                          size: 25,
                          color: Colors.red,
                        ),
                        onTap: () {
                          setState(() {
                             
                              imagesFromPhone.replaceRange(index, index + 1, []);
                          });
                        },
                      ),
                    ),
                  ],
                ) 
              );  
            }) :
      List.generate(imagesFromAPI.length, (index) {
                  //var image = _editCrop.imageUrl[index];
                  patchImage = imagesFromAPI[index];
                 
                  return Card(
                    clipBehavior: Clip.antiAlias,

                    child: 
                   
                    
                    Stack(
                      children: <Widget>[
                        new Image.network(
                          imagesFromAPI[index],
                          width: 300,
                          height: 300,
                          fit: BoxFit.fill,
                        ),
                        Positioned(
                          right: 5,
                          top: 5,
                          child: InkWell(
                            child: Icon(
                              Icons.remove_circle,
                              size: 25,
                              color: Colors.red,
                            ),
                            onTap: () {
                              setState(() {
                                imagesFromAPI.remove(patchImage);
                                String newImageUrls = jsonEncode(imagesFromAPI);
                                imagesFromAPI.isNotEmpty
                                    ? newImageUrls
                                    : imagesFromAPI;

                               
                                appendedImages = imagesFromAPI.join(",");
                                _forSaleCrop.imageUrl = appendedImages;
                                
                              });
                            },
                          ),
                        ),
                      ],
                    ) 
                  );
                   
                }),
          
           
    );
  }

  Widget newGridView(BuildContext context) {
     
      return GridView.count(
      crossAxisCount: 2,
      children: List.generate(imagesFromPhone.length, (index) {
             
              return Card(
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: <Widget>[
                  Image.file(
                     imagesFromPhone[index],
        fit: BoxFit.cover,
        width: double.infinity,
        ),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: InkWell(
                        child: Icon(
                          Icons.remove_circle,
                          size: 25,
                          color: Colors.red,
                        ),
                        onTap: () {
                          setState(() {
                            imagesFromPhone.replaceRange(index, index + 1, []);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            })
         
    );
  }
    

  Future _onAddImageClick(BuildContext context) async {
setState(() {
  _showSelectionDialog(context);
});
  }

    Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        _takePicture(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

     Future<void> _takePicture(BuildContext context) async {
    final picker = ImagePicker();
    final picture = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 600,
    );
    _imageFile = picture;
    setState(() {
      _storedImage = File(_imageFile.path);
      imagesFromPhone.insert(0, _storedImage);
      _storedImagePath = _imageFile.path;
    });
    Navigator.of(context).pop();
  }

  Future<void> _openGallery(BuildContext context) async {
    final picker = ImagePicker();
    var picture = await picker.getImage(source: ImageSource.gallery,
          imageQuality: 85,
      maxWidth: 600,);
     _imageFile = picture;
    
        setState(() {
      _storedImage = File(_imageFile.path);
      imagesFromPhone.insert(0, _storedImage);
      _storedImagePath = _imageFile.path;
      
    });
    Navigator.of(context).pop();
  }

  

  PickedFile _imageFile;
  List<dynamic> storedImage;
  File _storedImage;
  String _storedImagePath;
  var cropImageUrlString;
String tempImage;
  Future<String> uploadImage(dynamic storedImage) async {
    List<dynamic> cropImageUrl = [];
 
   
    for (int i = 0; i < storedImage.length; i++) {
     
     
     

      var image = storedImage[i].toString();
      var imagePath = storedImage[i].path;
      String cropId = _forSaleCrop.cropId;
      String userId = _forSaleCrop.userId;
      String picName = 'crop' + '_' + image.split('/').last;
       var imageUrl = '$apiurl/images/folder/$picName.jpg';
       cropImageUrl.insert(0,imageUrl);
       
      final String url = '$apiurl/upload/folder';

      Map<String, String> id = {'id': '$picName.jpg'};
      Map<String, String> folderId = {'folderId': 'folder'};
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.files.add(await http.MultipartFile.fromPath('picture', imagePath));
      request.fields['id'] = json.encode(id);
      request.fields['folderId'] = json.encode(folderId);
      var res = await request.send();
      request.url;
      print(res);
       
       cropImageUrlString = cropImageUrl.join(",");
     
      _forSaleCrop.imageUrl = cropImageUrlString;
      
     
    }


  }

  Future<String> updateImage(dynamic storedImage) async {
    
    List<dynamic> cropImageUrl = [];
 
   
    if (imagesFromAPI.isNotEmpty) {
 tempImage = imagesFromAPI.reduce((value, element) {
  return value + "," +element;
  
        
});
_imageUrlController.text.isNotEmpty && appendedImages != null ?
       cropImageUrl.add(appendedImages) :  
       cropImageUrl.add(tempImage);
   } else{
     imagesFromAPI;
   }
        
       
    
    for (int i = 0; i < storedImage.length; i++) {
     
     
     

     var image = storedImage[i].toString();
var imagePath = storedImage[i].path;
      String cropId = _forSaleCrop.cropId;
      String userId = _forSaleCrop.userId;
      String picName = 'crop' + '_' + image.split('/').last;
      var imageUrl = '$apiurl/images/folder/$picName.jpg';
       cropImageUrl.insert(0,imageUrl);
       
      final String url = '$apiurl/upload/folder';

      Map<String, String> id = {'id': '$picName.jpg'};
      Map<String, String> folderId = {'folderId': 'folder'};
      var request = http.MultipartRequest('PUT', Uri.parse(url));

      request.files.add(await http.MultipartFile.fromPath('picture', imagePath));
      request.fields['id'] = json.encode(id);
      request.fields['folderId'] = json.encode(folderId);
      var res = await request.send();
      request.url;
      print(res);
       
       cropImageUrlString = cropImageUrl.join(",");
     
      _forSaleCrop.imageUrl = cropImageUrlString;
      
    
    }

//return;
  }
var apiImages;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final routes =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      final dynamic cropId = routes['id'];
      final dynamic action = routes['action'];
      _action = action;

      if (cropId != null) {
        _forSaleCrop =
            Provider.of<Crops>(context, listen: false).findById(cropId);

        _initValues = {
          'title': _forSaleCrop.title,
          'description': _forSaleCrop.description,
          'farmer': _forSaleCrop.farmer,
          'investor': _forSaleCrop.investor,
          'cropMethod': _forSaleCrop.cropMethod,
          'seedVariety': _forSaleCrop.seedVariety,
          'expectedHarvestDate': _forSaleCrop.expectedHarvestDate != null
              ? _forSaleCrop.expectedHarvestDate.toIso8601String()
              : selectedDate.toIso8601String(),
          'price': _forSaleCrop.price.toString(),
          'area': _forSaleCrop.area.toString(),
          'imageUrl': '',
          'units': _forSaleCrop.units,
          'salesUnits': _forSaleCrop.salesUnits,
          'sellerName' : _forSaleCrop.sellerName,
      'sellerContact' : _forSaleCrop.sellerContact,
          'location': _forSaleCrop.location,
          'quantityForSale': _forSaleCrop.quantityForSale.toString(),
          'quantityUnits': _forSaleCrop.quantityUnits,
        };
       _imageUrlController.text = _forSaleCrop.imageUrl;
         _imageUrlController.text.isNotEmpty ?
        apiImages = _imageUrlController.text.split(",") : apiImages = null;
        apiImages != null ? 
        imagesFromAPI = apiImages 
        : imagesFromAPI = [];
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _farmerFocusNode.dispose();
    _investorFocusNode.dispose();
    _cropMethodFocusNode.dispose();
    _expectedHarvestDateFocusNode.dispose();
    _areaFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    _locationFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {


    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    _form.currentState.save();
    setState(() {
      _isLoading = true;
      //_expectedHarvestDateFocusNode.text.isEmpty ? _validate = true : _validate = false;
    });
    if (_action == 'update') {
      if (_storedImagePath != null) {
        await updateImage(imagesFromPhone);
      }
      await Provider.of<Crops>(context, listen: false)
          .updateCropForSale(_forSaleCrop.id, _forSaleCrop);
      
    } else {
      try {
         if (_storedImagePath != null) {
          await uploadImage(imagesFromPhone);
        }
        await Provider.of<Crops>(context, listen: false)
            .anounseCropSale(_forSaleCrop);
       
      } catch (error) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An Error Occured"),
            content: Text(
                "Something went wrong . Image not uploaded to server or not provided!"),
            actions: <Widget>[
              FlatButton(
                child: Text("Okay"),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      }
      /* finally{
            setState(() {
  _isLoading = false;
});
Navigator.of(context).pop();

          } */
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final loadedCrops = Provider.of<Crops>(context);
    final userId = loadedCrops.userId;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add/ Edit Crop for sale'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      /* Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Title : ',
              style: TextStyle(fontSize: 20)
              
              , ),
              DropdownButton(
                                     
                  hint: Text('Please choose crop Title'), // Not necessary for Option 1
                  value: _selectedTitle,
                  onChanged: (dynamic newValue) {
                    setState(() {
                      _selectedTitle = newValue;
                      return _editCrop.title = _selectedTitle;
                    });
                  },
                  items: _title.map((title) {
                    return DropdownMenuItem(
                      child: new Text(title),
                      value: title,
                    );
                  }).toList(),
                ),
            ],
          ), */

                      Visibility(
                        maintainState: true,
                        visible: false,
                        child: TextFormField(
                          initialValue: userId,
                          decoration: InputDecoration(
                              labelText: 'useId',
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                gapPadding: 10.0,
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(
                                  color: Colors.blueAccent,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(20)),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide value';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            final crop = Crop(
                                title: _forSaleCrop.title,
                                seedVariety: _forSaleCrop.seedVariety,
                                price: _forSaleCrop.price,
                                description: _forSaleCrop.description,
                                farmer: _forSaleCrop.farmer,
                                investor: _forSaleCrop.investor,
                                cropMethod: _forSaleCrop.cropMethod,
                                area: _forSaleCrop.area,
                                units: _forSaleCrop.units,
                                salesUnits: _forSaleCrop.salesUnits,
                                quantityForSale: _forSaleCrop.quantityForSale,
                                quantityUnits: _forSaleCrop.quantityUnits,
                                imageUrl: _forSaleCrop.imageUrl,
                                location: _forSaleCrop.location,
                                seedingDate: _forSaleCrop.seedingDate,
                                expectedHarvestDate:
                                    _forSaleCrop.expectedHarvestDate,
                                id: _forSaleCrop.id,
                                userId: value,
                                isFavorite: _forSaleCrop.isFavorite,
                                 sellerContact: _forSaleCrop.sellerContact,
                                  sellerName: _forSaleCrop.sellerName,
                                
                                );
                            _forSaleCrop = crop;
                          },
                        ),
                      ),
                      Container(
                        child: TextFormField(
                          initialValue: _initValues['title'],
                          decoration: InputDecoration(
                            labelText: 'Title',
                            /*   fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          gapPadding: 10.0,
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(20) */
                          ),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_seedVarietyFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide value';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            final crop = Crop(
                                title: value,
                                seedVariety: _forSaleCrop.seedVariety,
                                price: _forSaleCrop.price,
                                description: _forSaleCrop.description,
                                farmer: _forSaleCrop.farmer,
                                investor: _forSaleCrop.investor,
                                cropMethod: _forSaleCrop.cropMethod,
                                area: _forSaleCrop.area,
                                units: _forSaleCrop.units,
                                quantityForSale: _forSaleCrop.quantityForSale,
                                quantityUnits: _forSaleCrop.quantityUnits,
                                imageUrl: _forSaleCrop.imageUrl,
                                seedingDate: _forSaleCrop.seedingDate,
                                expectedHarvestDate:
                                    _forSaleCrop.expectedHarvestDate,
                                id: _forSaleCrop.id,
                                userId: _forSaleCrop.userId,
                                salesUnits: _forSaleCrop.salesUnits,
                                location: _forSaleCrop.location,
                                 sellerContact: _forSaleCrop.sellerContact,
                                  sellerName: _forSaleCrop.sellerName,
                                isFavorite: _forSaleCrop.isFavorite);
                            _forSaleCrop = crop;
                          },
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.blue,
                              width: 1,
                            )),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5, horizontal: 1.0),
                        margin: EdgeInsets.all(10.0),
                      ),
                      Container(
                        child: TextFormField(
                          initialValue: _initValues['seedVariety'],
                          decoration: InputDecoration(
                            labelText: 'Variety',
                            /*     fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          gapPadding: 10.0,
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(20) */
                          ),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide value';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            final crop = Crop(
                                title: _forSaleCrop.title,
                                seedVariety: value,
                                price: _forSaleCrop.price,
                                description: _forSaleCrop.description,
                                farmer: _forSaleCrop.farmer,
                                investor: _forSaleCrop.investor,
                                cropMethod: _forSaleCrop.cropMethod,
                                area: _forSaleCrop.area,
                                units: _forSaleCrop.units,
                                salesUnits: _forSaleCrop.salesUnits,
                                quantityForSale: _forSaleCrop.quantityForSale,
                                quantityUnits: _forSaleCrop.quantityUnits,
                                imageUrl: _forSaleCrop.imageUrl,
                                seedingDate: _forSaleCrop.seedingDate,
                                expectedHarvestDate:
                                    _forSaleCrop.expectedHarvestDate,
                                id: _forSaleCrop.id,
                                userId: _forSaleCrop.userId,
                                location: _forSaleCrop.location,
                                 sellerContact: _forSaleCrop.sellerContact,
                                  sellerName: _forSaleCrop.sellerName,
                                isFavorite: _forSaleCrop.isFavorite);
                            _forSaleCrop = crop;
                          },
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.blue,
                              width: 1,
                            )),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5, horizontal: 1.0),
                        margin: EdgeInsets.all(10.0),
                      ),
                      Container(
                        child: TextFormField(
                          initialValue: _initValues['description'],
                          decoration: InputDecoration(labelText: 'Description'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide description';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            _forSaleCrop = Crop(
                                title: _forSaleCrop.title,
                                seedVariety: _forSaleCrop.seedVariety,
                                price: _forSaleCrop.price,
                                description: value,
                                farmer: _forSaleCrop.farmer,
                                investor: _forSaleCrop.investor,
                                cropMethod: _forSaleCrop.cropMethod,
                                seedingDate: _forSaleCrop.seedingDate,
                                expectedHarvestDate:
                                    _forSaleCrop.expectedHarvestDate,
                                area: _forSaleCrop.area,
                                units: _forSaleCrop.units,
                                salesUnits: _forSaleCrop.salesUnits,
                                quantityForSale: _forSaleCrop.quantityForSale,
                                quantityUnits: _forSaleCrop.quantityUnits,
                                imageUrl: _forSaleCrop.imageUrl,
                                id: _forSaleCrop.id,
                                userId: _forSaleCrop.userId,
                                location: _forSaleCrop.location,
                                 sellerContact: _forSaleCrop.sellerContact,
                                  sellerName: _forSaleCrop.sellerName,
                                isFavorite: _forSaleCrop.isFavorite);
                          },
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.blue,
                              width: 1,
                            )),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5, horizontal: 1.0),
                        margin: EdgeInsets.all(10.0),
                      ),
                      Container(
                        child: TextFormField(
                          initialValue: _initValues['location'],
                          decoration:
                              InputDecoration(labelText: 'Crop Location'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _locationFocusNode,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide Location of crop';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            _forSaleCrop = Crop(
                                title: _forSaleCrop.title,
                                seedVariety: _forSaleCrop.seedVariety,
                                price: _forSaleCrop.price,
                                description: _forSaleCrop.description,
                                farmer: _forSaleCrop.farmer,
                                investor: _forSaleCrop.investor,
                                cropMethod: _forSaleCrop.cropMethod,
                                seedingDate: _forSaleCrop.seedingDate,
                                expectedHarvestDate:
                                    _forSaleCrop.expectedHarvestDate,
                                area: _forSaleCrop.area,
                                units: _forSaleCrop.units,
                                salesUnits: _forSaleCrop.salesUnits,
                                quantityForSale: _forSaleCrop.quantityForSale,
                                quantityUnits: _forSaleCrop.quantityUnits,
                                imageUrl: _forSaleCrop.imageUrl,
                                id: _forSaleCrop.id,
                                userId: _forSaleCrop.userId,
                                location: value,
                                 sellerContact: _forSaleCrop.sellerContact,
                                  sellerName: _forSaleCrop.sellerName,
                                isFavorite: _forSaleCrop.isFavorite);
                          },
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.blue,
                              width: 1,
                            )),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5, horizontal: 1.0),
                        margin: EdgeInsets.all(10.0),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                initialValue: _initValues['price'],
                                decoration: InputDecoration(
                                  labelText: 'Price',

                                  /*       fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          gapPadding: 10.0,
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ), */
                                ),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: _priceFocusNode,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please provide Price/Value';
                                  } else {
                                    return null;
                                  }
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_areaFocusNode);
                                },
                                onSaved: (value) {
                                  final crop = Crop(
                                      title: _forSaleCrop.title,
                                      seedVariety: _forSaleCrop.seedVariety,
                                      price: double.parse(value),
                                      farmer: _forSaleCrop.farmer,
                                      investor: _forSaleCrop.investor,
                                      cropMethod: _forSaleCrop.cropMethod,
                                      description: _forSaleCrop.description,
                                      seedingDate: _forSaleCrop.seedingDate,
                                      expectedHarvestDate:
                                          _forSaleCrop.expectedHarvestDate,
                                      area: _forSaleCrop.area,
                                      units: _forSaleCrop.units,
                                      salesUnits: _forSaleCrop.salesUnits,
                                      imageUrl: _forSaleCrop.imageUrl,
                                      quantityForSale:
                                          _forSaleCrop.quantityForSale,
                                      quantityUnits: _forSaleCrop.quantityUnits,
                                      id: _forSaleCrop.id,
                                      userId: _forSaleCrop.userId,
                                      location: _forSaleCrop.location,
                                       sellerContact: _forSaleCrop.sellerContact,
                                  sellerName: _forSaleCrop.sellerName,
                                      isFavorite: _forSaleCrop.isFavorite);
                                  _forSaleCrop = crop;
                                },
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Column(
                                children: <Widget>[
                                  DropdownButtonFormField(
                                    hint: _forSaleCrop?.salesUnits?.isNotEmpty
                                        ?? true ? Text('${_forSaleCrop.salesUnits}')
                                        : Text(
                                            'Choose Units for Price'), // Not necessary for Option 1
                                    value: _selectedSalesUom,
                                    onChanged: (dynamic newValue) {
                                      setState(() {
                                        _selectedSalesUom = newValue;
                                        return _forSaleCrop.salesUnits =
                                            _selectedSalesUom;
                                      });
                                    },
                                    items: _salesUom.map((salesUnits) {
                                      return DropdownMenuItem(
                                        child: new Text(salesUnits),
                                        value: salesUnits,
                                      );
                                    }).toList(),
                                   /*  validator: (dynamic value) => value == null
                                        ? 'Please fill in your salesUnits'
                                        : null, */
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.blue,
                              width: 1,
                            )),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5, horizontal: 1.0),
                        margin: EdgeInsets.all(10.0),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                initialValue: _initValues['area'],
                                decoration: InputDecoration(
                                  labelText: 'area',
/*           fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          gapPadding: 10.0,
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ), */
                                ),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: _areaFocusNode,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_descriptionFocusNode);
                                },
                                onSaved: (value) {
                                  _forSaleCrop = Crop(
                                      title: _forSaleCrop.title,
                                      seedVariety: _forSaleCrop.seedVariety,
                                      price: _forSaleCrop.price,
                                      area: double.parse(value),
                                      units: _forSaleCrop.units,
                                      salesUnits: _forSaleCrop.salesUnits,
                                      farmer: _forSaleCrop.farmer,
                                      investor: _forSaleCrop.investor,
                                      cropMethod: _forSaleCrop.cropMethod,
                                      quantityForSale:
                                          _forSaleCrop.quantityForSale,
                                      quantityUnits: _forSaleCrop.quantityUnits,
                                      expectedHarvestDate:
                                          _forSaleCrop.expectedHarvestDate,
                                      description: _forSaleCrop.description,
                                      imageUrl: _forSaleCrop.imageUrl,
                                      id: _forSaleCrop.id,
                                      userId: _forSaleCrop.userId,
                                      location: _forSaleCrop.location,
                                       sellerContact: _forSaleCrop.sellerContact,
                                  sellerName: _forSaleCrop.sellerName,
                                      isFavorite: _forSaleCrop.isFavorite);
                                },
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  DropdownButtonFormField(
                                    hint: _forSaleCrop?.units?.isNotEmpty ?? true
                                        ? Text('${_forSaleCrop.units}')
                                        : Text(
                                            'Choose Units'), // Not necessary for Option 1
                                    value: _selectedUom,
                                    onChanged: (dynamic newValue) {
                                      setState(() {
                                        _selectedUom = newValue;
                                        return _forSaleCrop.units =
                                            _selectedUom;
                                      });
                                    },
                                    items: _uom.map((units) {
                                      return DropdownMenuItem(
                                        child: new Text(units),
                                        value: units,
                                      );
                                    }).toList(),
                                   /*  validator: (dynamic value) => value == null
                                        ? 'Please fill in your Units'
                                        : null, */
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.blue,
                              width: 1,
                            )),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5, horizontal: 1.0),
                        margin: EdgeInsets.all(10.0),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                initialValue: _initValues['quantityForSale'],
                                decoration: InputDecoration(
                                  labelText: 'Available Quantity for sale',
/*           fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          gapPadding: 10.0,
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ), */
                                ),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please provide available quantity';
                                  } else {
                                    return null;
                                  }
                                },
                                //focusNode: _areaFocusNode,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_descriptionFocusNode);
                                },
                                onSaved: (value) {
                                  _forSaleCrop = Crop(
                                      title: _forSaleCrop.title,
                                      seedVariety: _forSaleCrop.seedVariety,
                                      price: _forSaleCrop.price,
                                      area: _forSaleCrop.area,
                                      units: _forSaleCrop.units,
                                      salesUnits: _forSaleCrop.salesUnits,
                                      farmer: _forSaleCrop.farmer,
                                      investor: _forSaleCrop.investor,
                                      cropMethod: _forSaleCrop.cropMethod,
                                      quantityForSale: value,
                                      quantityUnits: _forSaleCrop.quantityUnits,
                                      expectedHarvestDate:
                                          _forSaleCrop.expectedHarvestDate,
                                      description: _forSaleCrop.description,
                                      imageUrl: _forSaleCrop.imageUrl,
                                      id: _forSaleCrop.id,
                                      userId: _forSaleCrop.userId,
                                      location: _forSaleCrop.location,
                                       sellerContact: _forSaleCrop.sellerContact,
                                  sellerName: _forSaleCrop.sellerName,
                                      isFavorite: _forSaleCrop.isFavorite);
                                },
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  DropdownButtonFormField(
                                    hint: _forSaleCrop?.quantityUnits?.isNotEmpty ?? true
                                        ? Text('${_forSaleCrop.quantityUnits}')
                                        : Text(
                                            'Choose Units'), // Not necessary for Option 1
                                    value: _selectedquantityUnits,
                                    onChanged: (dynamic newValue) {
                                      setState(() {
                                        _selectedquantityUnits = newValue;
                                        return _forSaleCrop.quantityUnits =
                                            _selectedquantityUnits;
                                      });
                                    },
                                    items: _quantityUnits.map((quantityUnits) {
                                      return DropdownMenuItem(
                                        child: new Text(quantityUnits),
                                        value: quantityUnits,
                                      );
                                    }).toList(),
                                   /*  validator: (dynamic value) => value == null
                                        ? 'Please fill in your Units'
                                        : null, */
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.blue,
                              width: 1,
                            )),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5, horizontal: 1.0),
                        margin: EdgeInsets.all(10.0),
                      ),
                      Container(
                        width: 500,
                        child: Column(
                          children: <Widget>[
                            DropdownButtonFormField(
                              hint: _forSaleCrop?.cropMethod?.isNotEmpty ?? true
                                  ? Text('${_forSaleCrop.cropMethod}')
                                  : Text(
                                      'Crop Method'), // Not necessary for Option 1
                              value: _selectedCropMethod,
                              onChanged: (dynamic newValue) {
                                setState(() {
                                  _selectedCropMethod = newValue;
                                  return _forSaleCrop.cropMethod =
                                      _selectedCropMethod;
                                });
                              },
                              items: _cropMethod.map((cropMethod) {
                                return DropdownMenuItem(
                                  child: new Text(cropMethod),
                                  value: cropMethod,
                                );
                              }).toList(),
                              /* validator: (dynamic value) =>
                                  value == null ? 'Please choose method' : null,
                            */ ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.blue,
                              width: 1,
                            )),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5, horizontal: 1.0),
                        margin: EdgeInsets.all(10.0),
                      ),

                      Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(left: 10.0),
            child: Text('Contact Number'),
            ),   
Container(
          child:
          TextFormField(
            initialValue: _forSaleCrop.sellerContact,
          decoration: InputDecoration(labelText: 'Contact number',
        /*   fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ), */
                        ),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          focusNode: _contactFocusNode,
         /*  onFieldSubmitted: (_){ 
            FocusScope.of(context).requestFocus(_rentPriceFocusNode);}, */
              validator: (value){
              if(value.isEmpty){
                  return 'Please provide value';
              }
              else {
                return null;
              }
            },
                onSaved: (value) {
                                  _forSaleCrop = Crop(
                                      title: _forSaleCrop.title,
                                      seedVariety: _forSaleCrop.seedVariety,
                                      price: _forSaleCrop.price,
                                      area: _forSaleCrop.area,
                                      units: _forSaleCrop.units,
                                      salesUnits: _forSaleCrop.salesUnits,
                                      farmer: _forSaleCrop.farmer,
                                      investor: _forSaleCrop.investor,
                                      cropMethod: _forSaleCrop.cropMethod,
                                      quantityForSale: _forSaleCrop.quantityForSale,
                                    quantityUnits: _forSaleCrop.quantityUnits,
                                      expectedHarvestDate:
                                          _forSaleCrop.expectedHarvestDate,
                                      description: _forSaleCrop.description,
                                      imageUrl: _forSaleCrop.imageUrl,
                                      id: _forSaleCrop.id,
                                      userId: _forSaleCrop.userId,
                                      location: _forSaleCrop.location,
                                      isFavorite: _forSaleCrop.isFavorite,

                                      sellerContact: value,
                  sellerName: _forSaleCrop.sellerName,
                 );
                                },
            ),
           decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                              color: Colors.blue,
                              width: 1,
                            )),
                     padding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 1.0),
                      margin: EdgeInsets.all(10.0),
),


                      Container(
                        width: 500,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              initialValue: _initValues['expectedHarvestDate'],
                              decoration: InputDecoration(
                                  labelText: 'Expected Harvest Date'),

                              //focusNode: _expectedHarvestDateFocusNode,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please provide Expected Harvest Date';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                _forSaleCrop = Crop(
                                    title: _forSaleCrop.title,
                                    seedVariety: _forSaleCrop.seedVariety,
                                    price: _forSaleCrop.price,
                                    description: _forSaleCrop.description,
                                    farmer: _forSaleCrop.farmer,
                                    investor: _forSaleCrop.investor,
                                    cropMethod: _forSaleCrop.cropMethod,
                                    seedingDate: _forSaleCrop.seedingDate,
                                    expectedHarvestDate: selectedDate,
                                    area: _forSaleCrop.area,
                                    units: _forSaleCrop.units,
                                    salesUnits: _forSaleCrop.salesUnits,
                                    quantityForSale:
                                        _forSaleCrop.quantityForSale,
                                    quantityUnits: _forSaleCrop.quantityUnits,
                                    imageUrl: _forSaleCrop.imageUrl,
                                    id: _forSaleCrop.id,
                                    userId: _forSaleCrop.userId,
                                    location: _forSaleCrop.location,
                                     sellerContact: _forSaleCrop.sellerContact,
                                  sellerName: _forSaleCrop.sellerName,
                                    isFavorite: _forSaleCrop.isFavorite);
                              },
                            ),
                            //Text('Expected Harvest Date :' + "${_forSaleCrop.seedingDate.toLocal()}".split(' ')[0]),

                            /*  _forSaleCrop.expectedHarvestDate != null ? 
              
              Text('Expected Harvest Date :' + "${_forSaleCrop.expectedHarvestDate.toLocal()}".split(' ')[0]) :  
             
              Text('Expected Harvest Date :' + "${selectedDate.toLocal()}".split(' ')[0]),
              
               */
                            SizedBox(
                              height: 20.0,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RaisedButton(
                                  onPressed: () => _selectDate(context),

                                  /*  setState(() {
                  _text.text.isEmpty ? _validate = true : _validate = false;
                }); */
                                  child: Text('Select date'),
                                ),
                              ],
                            ),
                            /* TextField(
                 
              controller: _expectedHarvestDateFocusNode,
              decoration: InputDecoration(
                labelText: 'Choose Date',
                errorText: _validate ? 'Value Can\'t Be Empty' : null,
              ),),  */
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.blue,
                              width: 1,
                            )),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5, horizontal: 1.0),
                        margin: EdgeInsets.all(10.0),
                      ),

                    

                      Container(
                        
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(left: 10.0),
                        child: Text('Images'),
                      ),

                       _imageUrlController.text.isNotEmpty && _storedImagePath != null ? 
                      Container(
                        height: 700,
                        width: 500,
                        child: Column(
                          children: <Widget>[
                           /*  Center(child: Text('Error: $_error')), */
                                               
                            Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
    imagesFromAPI.length == 3? 
    new FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.red)),
      color: Colors.white,
      textColor: Colors.red,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
          //
      },
      child: Text(
        "Max 3 images can be added",
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
    ) :
   getUpdatePicker(),
    ],
    ) ,
                           Expanded(
                              child: 
                              
                              buildGridView(context),
                            ),

                             Expanded(
                              child: 
                              
                              newGridView(context),
                            ) 

                           
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            )),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5, horizontal: 1.0),
                        margin: EdgeInsets.all(10.0),
                      ) :

                      imagesFromAPI  == null ? 
                      Container(
                        height: 500,
                        width: 500,
                        child: Column(
                          children: <Widget>[
                           getCreatePicker(),
    Expanded(
                              child: 
                              
                              buildGridView(context),
                            ),
  ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.blue,
                              width: 1,
                            )),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5, horizontal: 1.0),
                        margin: EdgeInsets.all(10.0),
                      ) :
                    imagesFromAPI.length == 3? 
                      Container(
                        height: 500,
                        width: 500,
                        child: Column(
                          children: <Widget>[
    new FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.red)),
      color: Colors.white,
      textColor: Colors.red,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
          //
      },
      child: Text(
        "Max 3 images can be added",
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
    ),
    
    Expanded(
                              child: 
                              
                              buildGridView(context),
                            ),
    ])) :
                      Container(
                        height: 500,
                        width: 500,
                        child: Column(
                          children: <Widget>[
                         getCreatePicker(),
                          Expanded(
                              child: 
                              
                              buildGridView(context),
                            ),
                             ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.blue,
                              width: 1,
                            )),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5, horizontal: 1.0),
                        margin: EdgeInsets.all(10.0),
                      ) ,
                    ],
                  ),
                ),
              ),
            ),
    );
  }
  
  Widget getUpdatePicker(){
      if(imagesFromAPI.length == 3){
return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.red)),
      color: Colors.white,
      textColor: Colors.red,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
          //
      },
      child: Text(
        "Max 3 images can be added",
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
    );
      }
else
    if(imagesFromAPI == null){
      return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.green)),
      color: Colors.white,
      textColor: Colors.green,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
          _onAddImageClick(context);
      },
      child: Text(
        "Pick Images",
        style: TextStyle(
          fontSize: 14.0,
        ),
      ));
  }
  else if (imagesFromAPI.length < 3){
    if(imagesFromPhone.length < 3 && imagesFromAPI.length <= 1 ){
       return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.green)),
      color: Colors.white,
      textColor: Colors.green,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
          _onAddImageClick(context);
      },
      child: Text(
        "Pick Images",
        style: TextStyle(
          fontSize: 14.0,
        ),
      ));

    } else {
      return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.red)),
      color: Colors.white,
      textColor: Colors.red,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
          //
      },
      child: Text(
        "Max 3 images can be added",
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
    );

    }

  }
  else {
     return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.red)),
      color: Colors.white,
      textColor: Colors.red,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
          //
      },
      child: Text(
        "Max 3 images can be added",
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
    );
    
  }
  }






  Widget getCreatePicker() {
if(imagesFromPhone?.isEmpty ?? true){
      return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.green)),
      color: Colors.white,
      textColor: Colors.green,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
          _onAddImageClick(context);
      },
      child: Text(
        "Pick Images",
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
    );
    }
    else if (imagesFromPhone.length < 3) {
 return  FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.green)),
      color: Colors.white,
      textColor: Colors.green,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
          _onAddImageClick(context);
      },
      child: Text(
        "Pick Images",
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
    );
}
    else {
 return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.red)),
      color: Colors.white,
      textColor: Colors.red,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
          //
      },
      child: Text(
        "Max 3 images can be added",
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
    );
    
}
  }
  
}
