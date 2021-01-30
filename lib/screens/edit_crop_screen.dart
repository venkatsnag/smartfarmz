import 'dart:async';
import 'package:flutter/material.dart';
import '../providers/crop.dart';
import 'package:provider/provider.dart';
import '../providers/crops.dart';
import '../providers/fields.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'dart:convert';
import '../providers/auth.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import '../providers/apiClass.dart';


class EditCropScreen extends StatefulWidget {
  static const routeName = '/edit-crops-multi';
  @override
  _EditCropScreenState createState() => _EditCropScreenState();
}

class _EditCropScreenState extends State<EditCropScreen> {
  final apiurl = AppApi.api;

  final _priceFocusNode = FocusNode();
  final _otherTitleFocusNode = FocusNode();
  final _areaFocusNode = FocusNode();
  final _seedVarietyFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _farmerFocusNode = FocusNode();
  final _investorFocusNode = FocusNode();
  final _cropMethodFocusNode = FocusNode();
  final _seedingDateFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editCrop = Crop(
    id: null,
    title: '',
    otherTitle: '',
    price: 0,
    description: '',
    farmer: '',
    investor: '',
    seedingDate: DateTime.now(),
    cropMethod: '',
    totalPlants: '',
    area: 0,
    units: '',
    userId: '',
    seedVariety: '',
    landId: 0,
    imageUrl: '',
  );

  Map<String, String> _initValues = {
    'title': '',
    'otherTitle': '',
    'description': '',
    'farmer': '',
    'investor': '',
    'cropMethod': '',
    'seedingDate': '',
    'totalPlants': '0',
    'area': '',
    'units': '',
    'seedVariety': '',
    'userId': '',
    'landId': '',
    'price': '0',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;


// Titles List
  // Option 2
  String _selectedTitle;
  List cropTitleList;
  String authToken;

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

  Future<String> _getCropTitleList() async {
    final String url = '$apiurl/V1/croptitles';
    Map<String, String> headers = {
      "Content-type": "application/json",
      'Authorization': 'Bearer $authToken'
    };

    await http.get(url, headers: headers).then((response) {
      List<dynamic> data = json.decode(response.body);

//      print(data);
      setState(() {
        cropTitleList = data;
      });
    });
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    Future<dynamic>.delayed(Duration.zero).then((dynamic _) async {
/*     setState(() {
        //_storedImage = File(_imageFile.path);

        _isLoading = true;
      }); */

      final token = await Provider.of<Auth>(context, listen: false).token;
      authToken = token;
      _getCropTitleList();
      /*   setState(() {
        _isLoading = false;
      }); */
    });
    super.initState();
  }

  DateTime selectedDate = new DateTime.now();
  Future _selectDate(BuildContext context) async {
    //final DateTime _date = DateTime.now();
    final _date = new DateTime.now();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2999),
    );

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        print(selectedDate);
        return _editCrop.seedingDate = picked;
      });

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
                                _editCrop.imageUrl = appendedImages;
                                
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
      String cropId = _editCrop.cropId;
      String userId = _editCrop.userId;
      String picName = 'crop' + '_' + image.split('/').last;
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
     
      _editCrop.imageUrl = cropImageUrlString;
      
     
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
      String cropId = _editCrop.cropId;
      String userId = _editCrop.userId;
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
     
      _editCrop.imageUrl = cropImageUrlString;
      
     
    }

//return;
  }


 var apiImages;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      dynamic landId = _editCrop.landId;
      final routes =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      final dynamic cropId = routes['id'];
      final dynamic type = routes['type'];

      if (cropId != null && type == 'crops') {
        _editCrop = Provider.of<Crops>(context, listen: false).findById(cropId);

        _initValues = {
          'title': _editCrop.title,
          'otherTitle': _editCrop.otherTitle,
          'description': _editCrop.description,
          'farmer': _editCrop.farmer,
          'investor': _editCrop.investor,
          'cropMethod': _editCrop.cropMethod,
          'seedVariety': _editCrop.seedVariety,
          'seedingDate': _editCrop.seedingDate.toIso8601String(),
          'price': _editCrop.price.toString(),
          'area': _editCrop.area.toString(),
          'totalPlants': _editCrop.totalPlants.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editCrop.imageUrl;
        _imageUrlController.text.isNotEmpty ?
        apiImages = _imageUrlController.text.split(",") : apiImages = null;
        apiImages != null ? 
        imagesFromAPI = apiImages 
        : imagesFromAPI = [];
        
      } else if (type == 'lands') {
        _editCrop.landId = int.parse(cropId);
      } else if (cropId == null && type == 'crops') {
        _editCrop.landId = null;
      }
    }

    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _otherTitleFocusNode.dispose();
    _farmerFocusNode.dispose();
    _investorFocusNode.dispose();
    _cropMethodFocusNode.dispose();
    _seedingDateFocusNode.dispose();
    _areaFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
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
    });
    if (_editCrop.id != null) {
      if (_storedImagePath != null) {
        await updateImage(imagesFromPhone);
//await Provider.of<Images>(context, listen: false).updateImages(_editCrop.id, cropImageUrlString);
      }

      await Provider.of<Crops>(context, listen: false)
          .updateCrop(_editCrop.id, _editCrop);
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Sucessful"),
          content: Text("You have sucessfully edited crop details."),
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
        //await Provider.of<Images>(context, listen: false).addImages(_newImages);
        await Provider.of<Crops>(context, listen: false).addCrop(_editCrop);
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Sucessful"),
            content: Text("You have sucessfully added Crop details."),
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
      } catch (error) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An Error Occured"),
            content: Text(
                "Something went wrong. Either Image is not added or failed to upload image to server!"),
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

    //Lands
    final loadedLands = Provider.of<Fields>(context);
    //final landId = loadedLands.id;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add/ Edit Crop'),
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
                                title: _editCrop.title,
                                otherTitle: _editCrop.otherTitle,
                                seedVariety: _editCrop.seedVariety,
                                totalPlants: _editCrop.totalPlants,
                                price: _editCrop.price,
                                description: _editCrop.description,
                                farmer: _editCrop.farmer,
                                investor: _editCrop.investor,
                                cropMethod: _editCrop.cropMethod,
                                area: _editCrop.area,
                                units: _editCrop.units,
                                imageUrl: _editCrop.imageUrl,
                                seedingDate: _editCrop.seedingDate,
                                id: _editCrop.id,
                                landId: _editCrop.landId,
                                userId: value,
                                isFavorite: _editCrop.isFavorite);
                            _editCrop = crop;
                          },
                        ),
                      ),

                     

                      Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(left: 10.0),
                        child: Text('Crop Title'),
                      ),
                      Container(
                        width: 500,
                        child: Column(
                          children: [
                            Column(
                              children: <Widget>[
                                SearchableDropdown<String>.single(
                                  //items: items,
                                  value: _selectedTitle,
                                  hint: _editCrop.title == null
                                      ? Text("Select crop title")
                                      : Text("${_editCrop.title}"),
                                  searchHint: "type name to search",
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _selectedTitle = newValue;
                                      return _editCrop.title = _selectedTitle;
                                    });
                                  },
                                  items: cropTitleList != null
                                      ? cropTitleList.map((dynamic title) {
                                          return DropdownMenuItem<String>(
                                            child: new Text(title['title_en']),
                                            value: title['title_en'].toString(),
                                          );
                                        }).toList()
                                      : [],

                                  isExpanded: true,
                                ),
                              ],
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            )),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5, horizontal: 1.0),
                        margin: EdgeInsets.all(10.0),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(left: 10.0),
                        child: Text('Crop Variety / Other Title'),
                      ),
                      Visibility(
                        maintainState: true,
                        visible: true,
                        child: Container(
                          child: TextFormField(
                            initialValue: _initValues['otherTitle'],
                            decoration: InputDecoration(
                              labelText:
                                  'eg: Type/variety or names not available in crop title',
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
                              if (_selectedTitle == 'Others' && value.isEmpty) {
                                return 'Please provide crop Name';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              final crop = Crop(
                                  title: _editCrop.title,
                                  otherTitle: value,
                                  seedVariety: _editCrop.seedVariety,
                                  price: _editCrop.price,
                                  description: _editCrop.description,
                                  farmer: _editCrop.farmer,
                                  investor: _editCrop.investor,
                                  cropMethod: _editCrop.cropMethod,
                                  area: _editCrop.area,
                                  units: _editCrop.units,
                                  imageUrl: _editCrop.imageUrl,
                                  seedingDate: _editCrop.seedingDate,
                                  totalPlants: _editCrop.totalPlants,
                                  id: _editCrop.id,
                                  userId: _editCrop.userId,
                                  landId: _editCrop.landId,
                                  isFavorite: _editCrop.isFavorite);
                              _editCrop = crop;
                            },
                          ),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              )),
                          padding: EdgeInsets.symmetric(
                              vertical: 0.5, horizontal: 1.0),
                          margin: EdgeInsets.all(10.0),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(left: 10.0),
                        child: Text('Seed Name/ Variety'),
                      ),
                      Container(
                        child: TextFormField(
                          initialValue: _initValues['seedVariety'],
                          decoration: InputDecoration(
                            labelText: 'seedVariety',
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
                                title: _editCrop.title,
                                otherTitle: _editCrop.otherTitle,
                                seedVariety: value,
                                price: _editCrop.price,
                                description: _editCrop.description,
                                farmer: _editCrop.farmer,
                                investor: _editCrop.investor,
                                cropMethod: _editCrop.cropMethod,
                                totalPlants: _editCrop.totalPlants,
                                area: _editCrop.area,
                                units: _editCrop.units,
                                imageUrl: _editCrop.imageUrl,
                                seedingDate: _editCrop.seedingDate,
                                id: _editCrop.id,
                                userId: _editCrop.userId,
                                landId: _editCrop.landId,
                                isFavorite: _editCrop.isFavorite);
                            _editCrop = crop;
                          },
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            )),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5, horizontal: 1.0),
                        margin: EdgeInsets.all(10.0),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(left: 10.0),
                        child: Text('Crop Total Area'),
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
                                  _editCrop = Crop(
                                      title: _editCrop.title,
                                      otherTitle: _editCrop.otherTitle,
                                      totalPlants: _editCrop.totalPlants,
                                      seedVariety: _editCrop.seedVariety,
                                      price: _editCrop.price,
                                      area: double.parse(value),
                                      units: _editCrop.units,
                                      farmer: _editCrop.farmer,
                                      investor: _editCrop.investor,
                                      cropMethod: _editCrop.cropMethod,
                                      seedingDate: _editCrop.seedingDate,
                                      description: _editCrop.description,
                                      imageUrl: _editCrop.imageUrl,
                                      id: _editCrop.id,
                                      userId: _editCrop.userId,
                                      landId: _editCrop.landId,
                                      isFavorite: _editCrop.isFavorite);
                                },
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  DropdownButton(
                                    hint: _editCrop.units.isNotEmpty
                                        ? Text('${_editCrop.units}')
                                        : Text(
                                            'Choose Units'), // Not necessary for Option 1
                                    value: _selectedUom,
                                    onChanged: (dynamic newValue) {
                                      setState(() {
                                        _selectedUom = newValue;
                                        return _editCrop.units = _selectedUom;
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
                              color: Colors.black,
                              width: 1,
                            )),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5, horizontal: 1.0),
                        margin: EdgeInsets.all(10.0),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(left: 10.0),
                        child: Text('Name of Farmer'),
                      ),
                      Container(
                        child: TextFormField(
                          initialValue: _initValues['farmer'],
                          decoration: InputDecoration(
                            labelText: 'farmer',
/*           fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ), */
                          ),
                          textInputAction: TextInputAction.next,
                          focusNode: _farmerFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_investorFocusNode);
                          },
                          onSaved: (value) {
                            _editCrop = Crop(
                                title: _editCrop.title,
                                otherTitle: _editCrop.otherTitle,
                                seedVariety: _editCrop.seedVariety,
                                price: _editCrop.price,
                                area: _editCrop.area,
                                units: _editCrop.units,
                                farmer: value,
                                investor: _editCrop.investor,
                                totalPlants: _editCrop.totalPlants,
                                cropMethod: _editCrop.cropMethod,
                                description: _editCrop.description,
                                seedingDate: _editCrop.seedingDate,
                                imageUrl: _editCrop.imageUrl,
                                id: _editCrop.id,
                                landId: _editCrop.landId,
                                userId: _editCrop.userId,
                                isFavorite: _editCrop.isFavorite);
                          },
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            )),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5, horizontal: 1.0),
                        margin: EdgeInsets.all(10.0),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(left: 10.0),
                        child: Text('Number of Plants/Trees in orchard'),
                      ),
                      Container(
                        child: TextFormField(
                          initialValue: _initValues['totalPlants'],
                          decoration: InputDecoration(
                            labelText: 'Total Numer of plants in an Orchid',
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
                              return 'Please enter 0 or number of plants';
                            } else {
                              return null;
                            }
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_areaFocusNode);
                          },
                          onSaved: (value) {
                            final crop = Crop(
                                title: _editCrop.title,
                                otherTitle: _editCrop.otherTitle,
                                seedVariety: _editCrop.seedVariety,
                                totalPlants: value,
                                farmer: _editCrop.farmer,
                                investor: _editCrop.investor,
                                cropMethod: _editCrop.cropMethod,
                                description: _editCrop.description,
                                seedingDate: _editCrop.seedingDate,
                                area: _editCrop.area,
                                units: _editCrop.units,
                                imageUrl: _editCrop.imageUrl,
                                id: _editCrop.id,
                                userId: _editCrop.userId,
                                landId: _editCrop.landId,
                                isFavorite: _editCrop.isFavorite);
                            _editCrop = crop;
                          },
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            )),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5, horizontal: 1.0),
                        margin: EdgeInsets.all(10.0),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(left: 10.0),
                        child: Text('Farming Method'),
                      ),
                      Container(
                        width: 500,
                        child: Column(
                          children: <Widget>[
                            DropdownButton(
                              hint: _editCrop.cropMethod.isNotEmpty
                                  ? Text('${_editCrop.cropMethod}')
                                  : Text(
                                      'Crop Method'), // Not necessary for Option 1
                              value: _selectedCropMethod,
                              onChanged: (dynamic newValue) {
                                setState(() {
                                  _selectedCropMethod = newValue;
                                  return _editCrop.cropMethod =
                                      _selectedCropMethod;
                                });
                              },
                              items: _cropMethod.map((cropMethod) {
                                return DropdownMenuItem(
                                  child: new Text(cropMethod),
                                  value: cropMethod,
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            )),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5, horizontal: 1.0),
                        margin: EdgeInsets.all(10.0),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(left: 10.0),
                        child: Text('Seeding Date'),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Seeding Date :' +
                                "${_editCrop.seedingDate.toLocal()}"
                                    .split(' ')[0]),
                            SizedBox(
                              height: 20.0,
                            ),
                            RaisedButton(
                              onPressed: () => _selectDate(context),
                              child: Text('Select date'),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            )),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5, horizontal: 1.0),
                        margin: EdgeInsets.all(10.0),
                      ),

                     
                      Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(left: 10.0),
                        child: Text('Description about crop'),
                      ),
                      Container(
                        child: TextFormField(
                          initialValue: _initValues['description'],
                          decoration: InputDecoration(labelText: 'Description'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          onSaved: (value) {
                            _editCrop = Crop(
                                title: _editCrop.title,
                                otherTitle: _editCrop.otherTitle,
                                seedVariety: _editCrop.seedVariety,
                                price: _editCrop.price,
                                description: value,
                                farmer: _editCrop.farmer,
                                investor: _editCrop.investor,
                                cropMethod: _editCrop.cropMethod,
                                seedingDate: _editCrop.seedingDate,
                                area: _editCrop.area,
                                units: _editCrop.units,
                                imageUrl: _editCrop.imageUrl,
                                id: _editCrop.id,
                                userId: _editCrop.userId,
                                landId: _editCrop.landId,
                                totalPlants: _editCrop.totalPlants,
                                isFavorite: _editCrop.isFavorite);
                          },
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.black,
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
