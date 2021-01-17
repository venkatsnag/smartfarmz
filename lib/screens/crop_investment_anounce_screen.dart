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
import '../providers/apiClass.dart';

class CropInvestmentSeekAnouncementScreen extends StatefulWidget {
  static const routeName = '/crops-investment-anounce';
  @override

  //final String url = 'http://api.happyfarming.net:5000/upload';
  //final String url = 'http://192.168.39.190:5000/upload';
  _CropInvestmentSeekAnouncementScreenState createState() =>
      _CropInvestmentSeekAnouncementScreenState();
}

class _CropInvestmentSeekAnouncementScreenState extends State<CropInvestmentSeekAnouncementScreen> {
final apiurl = AppApi.api;

  
  final _areaFocusNode = FocusNode();
  final _seedVarietyFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _farmerFocusNode = FocusNode();
  final _cropMethodFocusNode = FocusNode();
  final _expectedHarvestDateFocusNode = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
   final _investmentNeededFocusNode = FocusNode();
  final _locationFocusNode = FocusNode();
  final _expectedTotalCropCostFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();

  bool _validate = false;
  String _action;

  var _forInvestmentCrop = Crop(
    id: null,
    cropId: '',
    title: '',
    otherTitle: '',
    description: '',
    farmer: '',
    seedingDate: DateTime.now(),
    expectedHarvestDate: DateTime.now(),
    cropMethod: '',
    area: 0,
    units: '',
    investmentNeeded: 0,
    expectedTotalCropCost:0,
    userId: '',
    seedVariety: '',
    imageUrl: '',
    location: '',
    seekInvestment: 0,
  );

  Map<String, String> _initValues = {
    'title': '',
    'cropId':'',
    'otherTitle': '',
    'description': '',
    'farmer': '',
    'cropMethod': '',
    'seedingDate': '',
    'expectedHarvestDate': '',
    'area': '',
    'units': '',
    'seedVariety': '',
    'userId': '',
    'imageUrl': '',
    'location': '',
    'seekInvestment': '',
    'investmentNeeded': '',
    'expectedTotalCropCost':'',
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
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  DateTime harvestSelectedDate = new DateTime.now();
  Future _expectedHarvestSelectDate(BuildContext context) async {
    //final DateTime _date = DateTime.now();
    final _date = new DateTime.now();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: harvestSelectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2999),
    );

    if (picked != null && picked != harvestSelectedDate) {
      setState(() => harvestSelectedDate = picked);
      print(harvestSelectedDate);
      return _forInvestmentCrop.expectedHarvestDate = picked;
    } else {
      _forInvestmentCrop.expectedHarvestDate = harvestSelectedDate;
    }

    //if(picked != null) setState(() => val = picked.toString());
  }

DateTime seedingSelectedDate = new DateTime.now();
    Future _expectedSeedingSelectDate(BuildContext context) async {
    //final DateTime _date = DateTime.now();
    final _date = new DateTime.now();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: seedingSelectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2999),
    );

    if (picked != null && picked != seedingSelectedDate) {
      setState(() => seedingSelectedDate = picked);
      print(seedingSelectedDate);
      return _forInvestmentCrop.seedingDate = picked;
    } else {
      _forInvestmentCrop.seedingDate = seedingSelectedDate;
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
                                _forInvestmentCrop.imageUrl = appendedImages;
                                
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
      String cropId = _forInvestmentCrop.cropId;
      String userId = _forInvestmentCrop.userId;
      String picName = 'cropInvestment' + '_' + image.split('/').last;
      var imageUrl = '$apiurl/images/folder/$picName.jpg';
       cropImageUrl.insert(0,imageUrl);
       
      final String url = '$apiurl/upload/folder';

      Map<String, String> id = {'id': '$picName.jpg'};
      Map<String, String> folderId = {'folderId': 'folder'};
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.files.add(await http.MultipartFile.fromPath('picture',imagePath));
      request.fields['id'] = json.encode(id);
      request.fields['folderId'] = json.encode(folderId);
      var res = await request.send();
      request.url;
      print(res);
       
       cropImageUrlString = cropImageUrl.join(",");
     
      _forInvestmentCrop.imageUrl = cropImageUrlString;
      
     
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
      String cropId = _forInvestmentCrop.cropId;
      String userId = _forInvestmentCrop.userId;
      String picName = 'cropInvestment' + '_' + image.split('/').last;
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
     
      _forInvestmentCrop.imageUrl = cropImageUrlString;
      
     
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

      if (cropId != null) {
        _forInvestmentCrop =
            Provider.of<Crops>(context, listen: false).findById(cropId);

        _initValues = {
          'title': _forInvestmentCrop.title,
           'cropId': _forInvestmentCrop.id,
          'description': _forInvestmentCrop.description,
          'farmer': _forInvestmentCrop.farmer,
          'investor': _forInvestmentCrop.investor,
          'cropMethod': _forInvestmentCrop.cropMethod,
          'seedVariety': _forInvestmentCrop.seedVariety,
          'expectedHarvestDate': _forInvestmentCrop.expectedHarvestDate != null
              ? _forInvestmentCrop.expectedHarvestDate.toIso8601String()
              : harvestSelectedDate.toIso8601String(),
          
          'seedingDate': _forInvestmentCrop.seedingDate != null
              ? _forInvestmentCrop.seedingDate.toIso8601String()
              : seedingSelectedDate.toIso8601String(),
         
          'area': _forInvestmentCrop.area.toString(),
          'imageUrl': '',
          'units': _forInvestmentCrop.units,
          'salesUnits': _forInvestmentCrop.salesUnits,
          'location': _forInvestmentCrop.location,
          'investmentNeeded': _forInvestmentCrop.investmentNeeded.toString(),
          'expectedTotalCropCost': _forInvestmentCrop.expectedTotalCropCost.toString(),
        };
        _imageUrlController.text = _forInvestmentCrop.imageUrl;
        _action = action;
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
   
    _farmerFocusNode.dispose();
   
    _cropMethodFocusNode.dispose();
    _expectedHarvestDateFocusNode.dispose();
    _areaFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    _locationFocusNode.dispose();
    _investmentNeededFocusNode.dispose();
    _expectedTotalCropCostFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    /*  setState((){ 
                _expectedHarvestDateFocusNode.text.isEmpty ? _validate = true : _validate = false;
            
             }); */

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
      if (_storedImage != null) {
        await updateImage(imagesFromPhone);}
      await Provider.of<Crops>(context, listen: false)
          .updateCropforInvestment(_forInvestmentCrop.id, _forInvestmentCrop);
              await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Sucessfuly updated"),
            content: Text(
                "Your request for crop inestment is updated!. Just wait for Investors to come back to you!"),
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
    
    } else {
      try {
         await uploadImage(imagesFromPhone);
        await Provider.of<Crops>(context, listen: false)
            .anounseCropforInvestment(_forInvestmentCrop);
            await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Sucessful"),
            content: Text(
                "Your request for crop inestment is registered!. Just wait for Investors to come back to you!"),
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
        if (_storedImage != null) {
          await uploadImage(_storedImagePath);
        }
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
        title: Text('Add/ Edit ask Investment for Crop'),
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
                              validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide value';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            final crop = Crop(
                                title: _forInvestmentCrop.title,
                                cropId: _forInvestmentCrop.id,
                                seedVariety: _forInvestmentCrop.seedVariety,
                                description: _forInvestmentCrop.description,
                                farmer: _forInvestmentCrop.farmer,
                                cropMethod: _forInvestmentCrop.cropMethod,
                                area: _forInvestmentCrop.area,
                                units: _forInvestmentCrop.units,
                                imageUrl: _forInvestmentCrop.imageUrl,
                                location: _forInvestmentCrop.location,
                                seedingDate: _forInvestmentCrop.seedingDate,
                                expectedHarvestDate:
                                _forInvestmentCrop.expectedHarvestDate,
                                id: _forInvestmentCrop.id,
                                investmentNeeded: _forInvestmentCrop.investmentNeeded,
                                expectedTotalCropCost:_forInvestmentCrop.expectedTotalCropCost,
                                userId: value,
                                isFavorite: _forInvestmentCrop.isFavorite);
                            _forInvestmentCrop = crop;
                          },
                        ),
                      ),
                      Container(
                        child: TextFormField(
                          initialValue: _initValues['title'],
                          decoration: InputDecoration(
                            labelText: 'Title',
                          
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
                                cropId: _forInvestmentCrop.id,
                                seedVariety: _forInvestmentCrop.seedVariety,
                                description: _forInvestmentCrop.description,
                                farmer: _forInvestmentCrop.farmer,
                                cropMethod: _forInvestmentCrop.cropMethod,
                                area: _forInvestmentCrop.area,
                                units: _forInvestmentCrop.units,
                                imageUrl: _forInvestmentCrop.imageUrl,
                                location: _forInvestmentCrop.location,
                                seedingDate: _forInvestmentCrop.seedingDate,
                                expectedHarvestDate:
                                _forInvestmentCrop.expectedHarvestDate,
                                id: _forInvestmentCrop.id,
                                investmentNeeded: _forInvestmentCrop.investmentNeeded,
                                expectedTotalCropCost:_forInvestmentCrop.expectedTotalCropCost,
                                userId: userId,
                                isFavorite: _forInvestmentCrop.isFavorite);
                            _forInvestmentCrop = crop;
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
                            
                          ),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
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
                                title: _forInvestmentCrop.title,
                                cropId: _forInvestmentCrop.id,
                                seedVariety: value,
                                description: _forInvestmentCrop.description,
                                farmer: _forInvestmentCrop.farmer,
                                cropMethod: _forInvestmentCrop.cropMethod,
                                area: _forInvestmentCrop.area,
                                units: _forInvestmentCrop.units,
                                imageUrl: _forInvestmentCrop.imageUrl,
                                location: _forInvestmentCrop.location,
                                seedingDate: _forInvestmentCrop.seedingDate,
                                expectedHarvestDate:
                                _forInvestmentCrop.expectedHarvestDate,
                                id: _forInvestmentCrop.id,
                                investmentNeeded: _forInvestmentCrop.investmentNeeded,
                                expectedTotalCropCost:_forInvestmentCrop.expectedTotalCropCost,
                                userId: userId,
                                isFavorite: _forInvestmentCrop.isFavorite);
                            _forInvestmentCrop = crop;
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
                                final crop = Crop(
                                title: _forInvestmentCrop.title,
                               cropId: _forInvestmentCrop.id,
                                seedVariety: _forInvestmentCrop.seedVariety,
                                description: value,
                                farmer: _forInvestmentCrop.farmer,
                                cropMethod: _forInvestmentCrop.cropMethod,
                                area: _forInvestmentCrop.area,
                                units: _forInvestmentCrop.units,
                                imageUrl: _forInvestmentCrop.imageUrl,
                                location: _forInvestmentCrop.location,
                                seedingDate: _forInvestmentCrop.seedingDate,
                                expectedHarvestDate:
                                _forInvestmentCrop.expectedHarvestDate,
                                id: _forInvestmentCrop.id,
                                investmentNeeded: _forInvestmentCrop.investmentNeeded,
                                expectedTotalCropCost:_forInvestmentCrop.expectedTotalCropCost,
                                userId: userId,
                                isFavorite: _forInvestmentCrop.isFavorite);
                            _forInvestmentCrop = crop;
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
                          initialValue: _initValues['expectedTotalCropCost'],
                          decoration:
                              InputDecoration(labelText: 'Expected Total cost of Crop'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _expectedTotalCropCostFocusNode,
                          validator: (value) {
                            if (value == 'null') {
                              return 'Please provide expected total cost pf crop';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            final crop = Crop(
                                title: _forInvestmentCrop.title,
                                cropId: _forInvestmentCrop.id,
                                seedVariety: _forInvestmentCrop.seedVariety,
                                description: _forInvestmentCrop.description,
                                farmer: _forInvestmentCrop.farmer,
                                cropMethod: _forInvestmentCrop.cropMethod,
                                area: _forInvestmentCrop.area,
                                units: _forInvestmentCrop.units,
                                imageUrl: _forInvestmentCrop.imageUrl,
                                location: _forInvestmentCrop.location,
                                seedingDate: _forInvestmentCrop.seedingDate,
                                expectedHarvestDate:
                                _forInvestmentCrop.expectedHarvestDate,
                                id: _forInvestmentCrop.id,
                                investmentNeeded: _forInvestmentCrop.investmentNeeded,
                                expectedTotalCropCost:double.parse(value),
                                userId: userId,
                                isFavorite: _forInvestmentCrop.isFavorite);
                            _forInvestmentCrop = crop;
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
                          initialValue: _initValues['investmentNeeded'],
                          decoration:
                              InputDecoration(labelText: 'Amount of Investment needed'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _investmentNeededFocusNode,
                          validator: (value) {
                            var numValue = int.tryParse(value);
                            if (numValue.toString() == 'null') {
                              return 'Please provide expected investment amount required';
                            } else if (numValue > 5000) {
                              return 'You can raise maximum of 5000 Rupees please choose less';
                            }
                            else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            final crop = Crop(
                                title: _forInvestmentCrop.title,
                                cropId: _forInvestmentCrop.id,
                                seedVariety: _forInvestmentCrop.seedVariety,
                                description: _forInvestmentCrop.description,
                                farmer: _forInvestmentCrop.farmer,
                                cropMethod: _forInvestmentCrop.cropMethod,
                                area: _forInvestmentCrop.area,
                                units: _forInvestmentCrop.units,
                                imageUrl: _forInvestmentCrop.imageUrl,
                                location: value,
                                seedingDate: _forInvestmentCrop.seedingDate,
                                expectedHarvestDate:
                                _forInvestmentCrop.expectedHarvestDate,
                                id: _forInvestmentCrop.id,
                                investmentNeeded: double.parse(value),
                                expectedTotalCropCost:_forInvestmentCrop.expectedTotalCropCost,
                                userId: userId,
                                isFavorite: _forInvestmentCrop.isFavorite);
                            _forInvestmentCrop = crop;
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
                            final crop = Crop(
                                title: _forInvestmentCrop.title,
                                cropId: _forInvestmentCrop.id,
                                seedVariety: _forInvestmentCrop.seedVariety,
                                description: _forInvestmentCrop.description,
                                farmer: _forInvestmentCrop.farmer,
                                cropMethod: _forInvestmentCrop.cropMethod,
                                area: _forInvestmentCrop.area,
                                units: _forInvestmentCrop.units,
                                imageUrl: _forInvestmentCrop.imageUrl,
                                location: value,
                                seedingDate: _forInvestmentCrop.seedingDate,
                                expectedHarvestDate:
                                _forInvestmentCrop.expectedHarvestDate,
                                id: _forInvestmentCrop.id,
                                investmentNeeded: _forInvestmentCrop.investmentNeeded,
                                expectedTotalCropCost:_forInvestmentCrop.expectedTotalCropCost,
                                userId: userId,
                                isFavorite: _forInvestmentCrop.isFavorite);
                            _forInvestmentCrop = crop;
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
                                initialValue: _initValues['area'],
                                decoration: InputDecoration(
                                  labelText: 'Crop area',

                                ),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: _areaFocusNode,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_descriptionFocusNode);
                                },
                                onSaved: (value) {
                                  final crop = Crop(
                                title: _forInvestmentCrop.title,
                                cropId: _forInvestmentCrop.id,
                                seedVariety: _forInvestmentCrop.seedVariety,
                                description: _forInvestmentCrop.description,
                                farmer: _forInvestmentCrop.farmer,
                                cropMethod: _forInvestmentCrop.cropMethod,
                                area: double.parse(value),
                                units: _forInvestmentCrop.units,
                                imageUrl: _forInvestmentCrop.imageUrl,
                                location: _forInvestmentCrop.location,
                                seedingDate: _forInvestmentCrop.seedingDate,
                                expectedHarvestDate:
                                _forInvestmentCrop.expectedHarvestDate,
                                id: _forInvestmentCrop.id,
                                investmentNeeded: _forInvestmentCrop.investmentNeeded,
                                expectedTotalCropCost:_forInvestmentCrop.expectedTotalCropCost,
                                userId: userId,
                                isFavorite: _forInvestmentCrop.isFavorite);
                            _forInvestmentCrop = crop;
                          },
                                
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  DropdownButtonFormField(
                                    hint: _forInvestmentCrop?.units?.isNotEmpty
                                        ?? true ? Text('${_forInvestmentCrop.units}')
                                        : Text(
                                            'Choose Units'), // Not necessary for Option 1
                                    value: _forInvestmentCrop.units,
                                    onChanged: (dynamic newValue) {
                                      setState(() {
                                        _selectedUom = newValue;
                                        return _forInvestmentCrop.units =
                                            _selectedUom;
                                      });
                                    },
                                    items: _uom.map((units) {
                                      return DropdownMenuItem(
                                        child: new Text(units),
                                        value: units,
                                      );
                                    }).toList(),
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
                              hint: _forInvestmentCrop?.cropMethod?.isNotEmpty
                                        ?? true ? Text('${_forInvestmentCrop.cropMethod}')
                                  : Text(
                                      'Crop Method'), // Not necessary for Option 1
                              value: _selectedCropMethod,
                              onChanged: (dynamic newValue) {
                                setState(() {
                                  _selectedCropMethod = newValue;
                                  return _forInvestmentCrop.cropMethod =
                                      _selectedCropMethod;
                                });
                              },
                              items: _cropMethod.map((cropMethod) {
                                return DropdownMenuItem(
                                  child: new Text(cropMethod),
                                  value: cropMethod,
                                );
                              }).toList(),
                              validator: (dynamic value) =>
                                  value == null ? 'Please choose method' : _initValues['cropMethod'],
                            ),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              initialValue: _initValues['seedingDate'],
                              decoration: InputDecoration(
                                  labelText: 'Expected start Date'),

                              //focusNode: _expectedHarvestDateFocusNode,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please provide Expected crop start Date';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                               final crop = Crop(
                                title: _forInvestmentCrop.title,
                                cropId: _forInvestmentCrop.id,
                                seedVariety: _forInvestmentCrop.seedVariety,
                                description: _forInvestmentCrop.description,
                                farmer: _forInvestmentCrop.farmer,
                                cropMethod: _forInvestmentCrop.cropMethod,
                                area:  _forInvestmentCrop.area,
                                units: _forInvestmentCrop.units,
                                imageUrl: _forInvestmentCrop.imageUrl,
                                location: _forInvestmentCrop.location,
                                seedingDate: seedingSelectedDate,
                                expectedHarvestDate:
                                _forInvestmentCrop.expectedHarvestDate,
                                id: _forInvestmentCrop.id,
                                investmentNeeded: _forInvestmentCrop.investmentNeeded,
                                expectedTotalCropCost:_forInvestmentCrop.expectedTotalCropCost,
                                userId: userId,
                                isFavorite: _forInvestmentCrop.isFavorite);
                            _forInvestmentCrop = crop;
                          },
                           
                            ),
                           
                            SizedBox(
                              height: 20.0,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RaisedButton(
                                  onPressed: () => _expectedSeedingSelectDate(context),

                                
                                  child: Text('Select date'),
                                ),
                              ],
                            ),
                            
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
                               final crop = Crop(
                                title: _forInvestmentCrop.title,
                                cropId: _forInvestmentCrop.id,
                                seedVariety: _forInvestmentCrop.seedVariety,
                                description: _forInvestmentCrop.description,
                                farmer: _forInvestmentCrop.farmer,
                                cropMethod: _forInvestmentCrop.cropMethod,
                                area:  _forInvestmentCrop.area,
                                units: _forInvestmentCrop.units,
                                imageUrl: _forInvestmentCrop.imageUrl,
                                location: _forInvestmentCrop.location,
                                seedingDate: _forInvestmentCrop.seedingDate,
                                expectedHarvestDate:
                                harvestSelectedDate,
                                id: _forInvestmentCrop.id,
                                investmentNeeded: _forInvestmentCrop.investmentNeeded,
                                expectedTotalCropCost:_forInvestmentCrop.expectedTotalCropCost,
                                userId: userId,
                                isFavorite: _forInvestmentCrop.isFavorite);
                            _forInvestmentCrop = crop;
                          },
                           
                            ),
                           
                            SizedBox(
                              height: 20.0,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RaisedButton(
                                  onPressed: () => _expectedHarvestSelectDate(context),

                                
                                  child: Text('Select date'),
                                ),
                              ],
                            ),
                            
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
                              color: Colors.black,
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
                              color: Colors.black,
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
