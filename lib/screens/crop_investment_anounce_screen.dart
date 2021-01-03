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
//final String url = 'http://192.168.39.190:3000/upload';
  PickedFile _imageFile;
  File _storedImage;
  String _storedImagePath;

  Future<String> uploadImage(dynamic filename) async {
    String picName = _forInvestmentCrop.userId + _forInvestmentCrop.title + 'forsale';
    String userId = _forInvestmentCrop.userId;
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
    String picName = _forInvestmentCrop.userId + _forInvestmentCrop.title + 'forsale';
    String userId = _forInvestmentCrop.userId;
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
      if (_storedImage != null) {
        await updateImage(_storedImagePath);
      }
    } else {
      try {
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
                                    hint: _forInvestmentCrop.units != null
                                        ? Text('${_forInvestmentCrop.units}')
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
                              hint: _forInvestmentCrop.cropMethod != null
                                  ? Text('${_forInvestmentCrop.cropMethod}')
                                  : Text(
                                      'Crop Method'), // Not necessary for Option 1
                              value: _forInvestmentCrop.cropMethod,
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                          

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
                                    : _forInvestmentCrop.id != null
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
                                    _forInvestmentCrop.imageUrl == null;
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
                   
              )
                    
            ),
    
    
    
     );
  }
}
