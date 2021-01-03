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
//final String url = 'http://192.168.39.190:3000/upload';
  PickedFile _imageFile;
  File _storedImage;
  String _storedImagePath;

  Future<String> uploadImage(dynamic filename) async {
    String picName = _forSaleCrop.userId + _forSaleCrop.title + 'forsale';
    String userId = _forSaleCrop.userId;
    final String url = '$apiurl/upload/$userId';
    // Map<String,String> newMap = {'id':'$picName.jpg', 'userId' :'$userId'};
    Map<String, String> id = {'id': '$picName.jpg'};
    Map<String, String> folderId = {'folderId': '$userId'};
    //Map<String,String> usId = {'usId' : '$userId'};
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.files.add(await http.MultipartFile.fromPath('picture', filename));
    request.fields['id'] = json.encode(id);
    request.fields['folderId'] = json.encode(folderId);
    //request.fields['usId'] = json.encode(usId);
    var res = await request.send();
    request.url;
    print(res);
    return res.reasonPhrase;
  }

  Future<String> updateImage(dynamic filename) async {
    String picName = _forSaleCrop.userId + _forSaleCrop.title + 'forsale';
    String userId = _forSaleCrop.userId;
    final String url = '$apiurl/upload/$userId';
    // Map<String,String> newMap = {'id':'$picName.jpg', 'userId' :'$userId'};
    Map<String, String> id = {'id': '$picName.jpg'};
    Map<String, String> folderId = {'folderId': '$userId'};
    //Map<String,String> usId = {'usId' : '$userId'};
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.files.add(await http.MultipartFile.fromPath('picture', filename));
    request.fields['id'] = json.encode(id);
    request.fields['folderId'] = json.encode(folderId);
    //request.fields['usId'] = json.encode(usId);
    var res = await request.send();
    request.url;
    print(res);
    return res.reasonPhrase;
  }

// Take picture
  String state = "";

  // Images camera selection
  void _openGallery(BuildContext context) async {
    final picker = ImagePicker();
    var picture = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 600,
    );
    _imageFile = picture;

    setState(() {
      _storedImage = File(_imageFile.path);
      _storedImagePath = _imageFile.path;
    });
    Navigator.of(context).pop();
  }

/*  Widget _setImageView() {
    if (_imageFile != null) {
      return Image.file(_imageFile, width: 500, height: 500);
    } else {
      return Text("Please select an image");
    }
  }  */

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
    final imageFile = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 600,
    );
    setState(() {
      _storedImage = File(imageFile.path);
      _storedImagePath = imageFile.path;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await _storedImage.copy('${appDir.path}/$fileName');
    //widget.onSelectImage();
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final routes =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      final dynamic cropId = routes['id'];
      final dynamic action = routes['action'];

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
          'location': _forSaleCrop.location,
          'quantityForSale': _forSaleCrop.quantityForSale.toString(),
          'quantityUnits': _forSaleCrop.quantityUnits,
        };
        _imageUrlController.text = _forSaleCrop.imageUrl;
        _action = action;
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
      await Provider.of<Crops>(context, listen: false)
          .updateCropForSale(_forSaleCrop.id, _forSaleCrop);
      if (_storedImage != null) {
        await updateImage(_storedImagePath);
      }
    } else {
      try {
        await Provider.of<Crops>(context, listen: false)
            .anounseCropSale(_forSaleCrop);
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
                                isFavorite: _forSaleCrop.isFavorite);
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
                                    hint: _forSaleCrop.salesUnits != null
                                        ? Text('${_forSaleCrop.salesUnits}')
                                        : Text(
                                            'Choose Units for Price'), // Not necessary for Option 1
                                    value: _forSaleCrop.salesUnits,
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
                                    validator: (dynamic value) => value == null
                                        ? 'Please fill in your salesUnits'
                                        : null,
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
                                      isFavorite: _forSaleCrop.isFavorite);
                                },
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  DropdownButtonFormField(
                                    hint: _forSaleCrop.units != null
                                        ? Text('${_forSaleCrop.units}')
                                        : Text(
                                            'Choose Units'), // Not necessary for Option 1
                                    value: _forSaleCrop.units,
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
                                      isFavorite: _forSaleCrop.isFavorite);
                                },
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  DropdownButtonFormField(
                                    hint: _forSaleCrop.quantityUnits != null
                                        ? Text('${_forSaleCrop.quantityUnits}')
                                        : Text(
                                            'Choose Units'), // Not necessary for Option 1
                                    value: _forSaleCrop.quantityUnits,
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
                                    validator: (dynamic value) => value == null
                                        ? 'Please fill in your Units'
                                        : null,
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
                              hint: _forSaleCrop.cropMethod != null
                                  ? Text('${_forSaleCrop.cropMethod}')
                                  : Text(
                                      'Crop Method'), // Not necessary for Option 1
                              value: _forSaleCrop.cropMethod,
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
                              validator: (dynamic value) =>
                                  value == null ? 'Please choose method' : null,
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

                      /* TextFormField(
              
              initialValue: _initValues['seedingDating'],
            decoration: InputDecoration(labelText: 'Seeding Date'),
            textInputAction: TextInputAction.next,
            
            focusNode: _seedingDateFocusNode,
            
            onFieldSubmitted: (_){ 
              
              FocusScope.of(context).requestFocus(_descriptionFocusNode);},
                 onSaved: (value){
                _editCrop = Crop( 
                  title: _editCrop.title,
                  price: _editCrop.price,
                  area: _editCrop.area,
                  farmer: _editCrop.farmer,
                  investor: _editCrop.investor,
                  cropMethod: _editCrop.cropMethod,
                  //seedingDate: DateTime.parse(value),
                  description: _editCrop.description, 
                  
                  imageUrl: _editCrop.imageUrl,
                  id: _editCrop.id,
                  isFavorite: _editCrop.isFavorite );
              },
              
            ), */
                      /* IconButton(icon: Icon(Icons.alarm),
          onPressed: (){
            selectedDate(context);} */

                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            /*  Container(
              width: 100,
              height: 100,
              margin: EdgeInsets.only(top: 8, right: 10,),
              
              decoration: BoxDecoration(border: Border.all(width: 1,
               color: Colors.grey, ),
               ),
               child: _imageUrlController.text.isEmpty ? Text('Enter Image Url') : FittedBox(child: Image.network(_imageUrlController.text),
               fit: BoxFit.cover,),
            ),
            Expanded(
                          child: TextFormField(
                           
                decoration: InputDecoration(labelText: 'Image Url'),
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                controller: _imageUrlController,
                focusNode: _imageUrlFocusNode,
                onFieldSubmitted: (_){_saveForm();},
                 onSaved: (value){
              _editCrop = Crop( 
                title: _editCrop.title,
                seedVariety: _editCrop.seedVariety,
                price: _editCrop.price,
                description: _editCrop.description, 
                area: _editCrop.area,
                units: _editCrop.units,
                imageUrl: value,
                farmer: _editCrop.farmer,
                investor: _editCrop.investor,
                cropMethod: _editCrop.cropMethod,
               seedingDate: _editCrop.seedingDate,
                id: _editCrop.id,
                userId: _editCrop.userId,
                isFavorite: _editCrop.isFavorite );
            },
                ),
                
            ), */

                            Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
                                ),
                                child: _storedImage != null
                                    ? Image.file(
                                        _storedImage,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      )
                                    : _forSaleCrop.id != null
                                        ? Image.network(
                                            _imageUrlController.text)
                                        : Text('No Image Taken'),
                                alignment: Alignment.center),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: FlatButton.icon(
                                icon: Icon(Icons.camera),
                                label: Text('Take Pickture'),
                                textColor: Color(0xFFFF9000),
                                onPressed: () {
                                  _showSelectionDialog(context);
                                  setState(() {
                                    _forSaleCrop.imageUrl == null;
                                  });
                                },
                              ),
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
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
