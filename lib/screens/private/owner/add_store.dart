import 'dart:io';
import 'package:GroceriesApplication/models/store.dart';
import 'package:GroceriesApplication/models/user.dart';
import 'package:GroceriesApplication/services/cloudFirestore/app_store_service.dart';
import 'package:GroceriesApplication/services/storage/app_storage.dart';
import 'package:GroceriesApplication/styles/styles.dart';
import 'package:GroceriesApplication/widgets/app_button.dart';
import 'package:GroceriesApplication/widgets/dropdown_widget.dart';
import 'package:GroceriesApplication/widgets/input_field_title.dart';
import 'package:GroceriesApplication/widgets/text_widget.dart';
import 'package:GroceriesApplication/widgets/upload_image_unit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddStore extends StatefulWidget {
  final User user;
  AddStore({this.user});
  @override
  _AddStoreState createState() => _AddStoreState();
}

class _AddStoreState extends State<AddStore> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PickedFile _image;
  String imageURL;
  bool _isLoading = false;
  bool _isImageError = false;
  List<String> menuItems;
  List<PickedFile> _imageList = new List();
  List<String> _uploadedImageUrl = [];
  String _storeName, _type, _storeDescription, imageFileURLList, _email, _phone;
  List<String> _streetAddressList;

  TextEditingController _storeNameController,
      _storeDescriptionController,
      _storePhoneController,
      _storetEmailController;
  List<TextEditingController> _streetAddressControllerList;
  Store store;

  List<int> _skipList = [];

  void _onDelete(int index) {
    setState(() {
      if (store.carouselList.length > index) {
        _skipList.add(index);
      } else {
        _imageList.removeAt(index);
        _imageList.insert(index, null);
      }
    });
  }

  void _onImageSelect(PickedFile pickFile, int index) {
    setState(() {
      _imageList.removeAt(index);
      _imageList.insert(index, pickFile);
    });
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    for (TextEditingController contr in _streetAddressControllerList) {
      contr.dispose();
    }
    _storeDescriptionController.dispose();
    _storePhoneController.dispose();
    _storetEmailController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _initTypeMenu();
    _imageList.add(null);
    _imageList.add(null);
    _imageList.add(null);
    _imageList.add(null);
    _imageList.add(null);
    _imageList.add(null);
    _storeNameController = TextEditingController();
    _streetAddressControllerList = new List<TextEditingController>();
    _streetAddressControllerList.add(TextEditingController());
    _storeDescriptionController = TextEditingController();
    _storePhoneController = TextEditingController();
    _storetEmailController = TextEditingController();
    super.initState();
  }

  void _initTypeMenu() {
    menuItems = new List();
    //_type = 'Pick-Up';
    menuItems.add('Pick Up');
    //menuItems.add('Home Delivery');
    //menuItems.add('Both');
  }

  _setImage(final PickedFile file) {
    print('DDDDD');
    setState(() {
      _image = file;
    });
    Navigator.pop(context);
  }

  void _onSaved(String value, String label) {
    if (label.isNotEmpty) {
      switch (label) {
        case 'Store name':
          _storeName = value;
          break;
        case 'Mode':
          _type = value;
          break;
        case 'Street Address':
          if (_streetAddressList == null) {
            _streetAddressList = new List<String>();
          }
          _streetAddressList.add(value);
          break;
        case 'Phone':
          _phone = value;
          break;
        case 'Email':
          _email = value;
          break;
        case 'Description':
          _storeDescription = value;
          break;
        case 'Phone':
          _phone = value;
          break;
        case 'Email':
          _email = value;
          break;
        default:
      }
    }
  }

  String _onValidate(String value, String label) {
    if (value == null || value.isEmpty) {
      if (label == 'Mode') {
        return "Mode of service is mandatory";
      } else if (label == 'Street Address') {
        return "Street Address is mandatory.";
      } else if (label == 'Description') {
        return "Description is mandatory.";
      } else if (label == 'Store name') {
        return "Store name is mandatory.";
      } else if (label == 'Phone') {
        return "Store Phone number is mandatory.";
      } else if (label == 'Email') {
        return "Store email ID is mandatory.";
      }
    } else {
      if (label == 'Description') {
        if (value.length > 500) {
          return "Description must be less than 500 character.";
        }
      }
    }
    return null;
  }

  Future<void> _saveImagesList() async {
    final storage = Provider.of<AppStorage>(context, listen: false);
    for (int p = 0; p < _imageList.length; p++) {
      if (_imageList.elementAt(p) == null) {
        continue;
      }
      final downloadUrl = await storage.uploadStoreImages(
          file: File(_imageList.elementAt(p).path), fileName: '$p.png');
      setState(() {
        _uploadedImageUrl.add(downloadUrl);
      });
    }
  }

  Future<void> _saveImagesIfAny() async {
    final storage = Provider.of<AppStorage>(context, listen: false);
    final downloadUrl =
        await storage.uploadStoreImages(file: File(_image.path));
    setState(() {
      imageURL = downloadUrl;
    });
  }

  bool _checkIfImageListIsEmpty() {
    for (PickedFile p in _imageList) {
      if (p != null) {
        return false;
      }
    }
    return true;
  }

  void deleteStoreImage(String url) {
    print('Goping to dele');
    FirebaseStorage.instance.getReferenceFromUrl(url).then((res) {
      res.delete().then((res) {
        print("Deleted!");
      });
    });
  }

  void _proceed() async {
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    bool _flag = false;
    setState(() {
      _isLoading = true;
      _isImageError = false;
    });
    if (_isUpdate) {
      setState(() {
        _isLoading = true;
      });
      print('LEN=>' + _checkIfImageListIsEmpty().toString());
      if (_checkIfImageListIsEmpty()) {
        /*setState(() {
          _uploadedImageUrl = [];
        });*/
        for (int index = 0; index < store.carouselList.length; index++) {
          if (_doesIndexExist(index)) {
            continue;
          } else {
            setState(() {
              _uploadedImageUrl.add(store.carouselList.elementAt(index));
            });
          }
        }
        if (_uploadedImageUrl.length < 3) {
          setState(() {
            _isLoading = false;
            _isImageError = true;
          });
          return;
        }
        print('_skipList ' + _skipList.length.toString());
        for (int i in _skipList) {
          deleteStoreImage(store.carouselList.elementAt(i));
        }
      } else {
        setState(() {
          _uploadedImageUrl = [];
        });
        for (int index = 0; index < store.carouselList.length; index++) {
          if (!_doesIndexExist(index)) {
            setState(() {
              _uploadedImageUrl.add(store.carouselList.elementAt(index));
            });
          }
        }

        await _saveImagesList();
        if (_uploadedImageUrl.length >= 3) {
        } else {
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }
    } else {
      if (_imageList.length >= 3) {
        await _saveImagesList();
      } else {
        setState(() {
          _isImageError = true;
          _isLoading = false;
        });
        _flag = true;
      }
    }
    if (!_formKey.currentState.validate()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    print('brb');
    if (_flag) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    _formKey.currentState.save();
    Store _store;
    if (_isUpdate) {
      _store = new Store(
        id: _documentID,
        ownerUid: widget.user.uid,
        imageURL: imageURL ?? store.imageURL,
        storeName: _storeName,
        storeAddress: _streetAddressList,
        serviceMode: _type,
        storeDescription: _storeDescription,
        email: _email,
        carouselList: _uploadedImageUrl,
        phone: _phone,
        creationDate: store.creationDate,
      );
      try {
        await cloudStoreService.updateStore(_store);
        setState(() {
          _imageList = new List();
          _skipList = [];
          _extraAddress = 0;
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text('Store has been updated successfully'),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      } catch (error) {
        print('Some Error');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      try {
        _store = new Store(
          ownerUid: widget.user.uid,
          imageURL: imageURL,
          storeName: _storeName,
          storeAddress: _streetAddressList,
          storeDescription: _storeDescription,
          email: _email,
          serviceMode: _type,
          carouselList: _uploadedImageUrl,
          phone: _phone,
          creationDate: DateTime.now(),
        );
        await cloudStoreService.addStore(_store);
        setState(() {
          _extraAddress = 0;
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text('Store has been added successfully'),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      } catch (error) {
        print('Some Error : ' + error.toString());
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Color _baseColor = Color(0xFF707070).withOpacity(0.51);

  Color _normalColor = Color(0xFF707070).withOpacity(0.51);
  bool _isUpdate = false;
  String _documentID;

  bool _doesIndexExist(int index) {
    for (int sl in _skipList) {
      if (sl == index) {
        return true;
      }
    }
    return false;
  }

  int _extraAddress = 0;

  @override
  Widget build(BuildContext context) {
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    return StreamBuilder(
      stream: cloudStoreService.getStore(widget.user.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          final QuerySnapshot qs = snapshot.data;
          if (qs.docs.length > 0) {
            store = Store.fromMap(qs.docs.first.data());
            _isUpdate = qs.docs.length == 0 ? false : true;
            _documentID = qs.docs.length == 0 ? '' : qs.docs.first.id;
            _storeNameController.text = store.storeName;

            print('JJJJKKKKLLLL');
            _streetAddressControllerList = new List<TextEditingController>();
            for (int i = 0; i < store.storeAddress.length; i++) {
              _streetAddressControllerList.add(TextEditingController());
            }
            for (int k = 0; k < _extraAddress; k++) {
              _streetAddressControllerList.add(TextEditingController());
            }
            for (int i = 0; i < store.storeAddress.length; i++) {
              _streetAddressControllerList[i].text = store.storeAddress[i];
            }
            _storeDescriptionController.text = store.storeDescription;
            _storePhoneController.text = store.phone;
            _storetEmailController.text = store.email;
            _type = store.serviceMode;
          } else {
            //_streetAddressControllerList = new List<TextEditingController>();
            
            //_streetAddressControllerList.add(TextEditingController());
            //for (int k = 0; k < _extraAddress; k++) {
             // _streetAddressControllerList.add(TextEditingController());
            //}
          }
        } else {
          print('JJJJJgggggJ');
          _streetAddressControllerList = new List<TextEditingController>();
          _streetAddressControllerList.add(TextEditingController());
        }

        return Container(
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  margin: EdgeInsets.only(top: 15.0),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            InputFieldTitle(
                              text: 'Register store',
                            ),
                            TextWidget(
                              controller: _storeNameController,
                              obscureText: false,
                              hintText: 'Store name',
                              onSaved: (String value) {
                                _onSaved(value, 'Store name');
                              },
                              validator: (String value) {
                                return _onValidate(value, 'Store name');
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InputFieldTitle(
                              text: 'Upload Store Images(Min 3 and max 6)',
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            _isImageError
                                ? Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'You must upload atleast 3 images',
                                      style: hintStyleSmPRRED(),
                                    ),
                                  )
                                : SizedBox.shrink(),
                            SizedBox(
                              height: 5,
                            ),
                            GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 3,
                              childAspectRatio: 1,
                              physics: BouncingScrollPhysics(),
                              children: List.generate(
                                6,
                                (index) {
                                  if (store != null &&
                                      store.carouselList != null &&
                                      index < store.carouselList.length &&
                                      !_doesIndexExist(index)) {
                                    return UploadImageUnit(
                                      imageFile:
                                          store.carouselList.elementAt(index),
                                      onImageSelect: _onImageSelect,
                                      pickedFile: (_imageList.length != 0 &&
                                              _imageList.length > index)
                                          ? _imageList.elementAt(index)
                                          : null,
                                      index: index,
                                      onDelete: _onDelete,
                                    );
                                  } else {
                                    return UploadImageUnit(
                                      imageFile: null,
                                      onImageSelect: _onImageSelect,
                                      pickedFile: (_imageList.length != 0 &&
                                              _imageList.length > index)
                                          ? _imageList.elementAt(index)
                                          : null,
                                      index: index,
                                      onDelete: _onDelete,
                                    );
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                '(These images will be shown in header when buyers visit your store.)',
                                style: hintStyleSmPR(),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Address',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.add_box,
                                    color: green,
                                    //size: 10,
                                  ),
                                  onPressed: () {
                                    print('jjjj' +
                                        _streetAddressControllerList.length
                                            .toString());
                                    setState(() {
                                      _extraAddress++;
                                      _streetAddressControllerList.add(TextEditingController());
                                     // _streetAddressControllerList
                                         // .add(TextEditingController());
                                    });
                                    print('jjjj3' +
                                        _extraAddress
                                            .toString());
                                  },
                                ),
                              ],
                            ),
                            for (int index = 0;
                                index < _streetAddressControllerList.length;
                                index++)
                              _getAddressField(context, index),
                            SizedBox(
                              height: 10,
                            ),
                            InputFieldTitle(
                              text: 'Description',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              autofocus: false,
                              controller: _storeDescriptionController,
                              validator: (String value) {
                                return _onValidate(value, 'Description');
                              },
                              onSaved: (String value) {
                                _onSaved(value, 'Description');
                              },
                              obscureText: false,
                              maxLines: 5,
                              cursorColor: Theme.of(context).primaryColor,
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Description of Store',
                                isDense: true,
                                fillColor: Colors.grey[200],
                                filled: true,
                                alignLabelWithHint: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                  vertical: 12.0,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                '(Limit 500 Charecter)',
                                style: hintStyleSmPR(),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InputFieldTitle(
                              text: 'Mode of Service',
                            ),
                            DropdownWidget(
                              menuItem: menuItems,
                              onSaved: (String value) {
                                _onSaved(value, 'Mode');
                              },
                              onValidate: (String value) {
                                return _onValidate(value, 'Mode');
                              },
                              onChanged: (String v) {
                                setState(() {
                                  _type = v;
                                });
                              },
                              selectedMenu: _type,
                              hint: 'Mode',
                            ),
                            InputFieldTitle(
                              text: 'Contact',
                            ),
                            TextWidget(
                              controller: _storePhoneController,
                              obscureText: false,
                              hintText: 'Store Phone number',
                              onSaved: (String value) {
                                _onSaved(value, 'Phone');
                              },
                              validator: (String value) {
                                return _onValidate(value, 'Phone');
                              },
                            ),
                            TextWidget(
                              controller: _storetEmailController,
                              obscureText: false,
                              hintText: 'Store Email ID',
                              onSaved: (String value) {
                                _onSaved(value, 'Email');
                              },
                              validator: (String value) {
                                return _onValidate(value, 'Email');
                              },
                            ),
                            AppButton(
                              label: store != null ? 'Edit Store' : 'Add Store',
                              onPressed: _proceed,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  _showLocationPicker(int index) async {
    LocationResult result = await showLocationPicker(
      context,
      'AIzaSyBIAAC2DJx3v44z-ZJQBDhz-Jrg-UBvc8A',
      initialCenter: LatLng(31.1975844, 29.9598339),
      myLocationButtonEnabled: true,
      layersButtonEnabled: true,
    );
    _streetAddressControllerList[index].text = result.address;
  }

  Widget _getAddressField(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        onTap: () async {
          await _showLocationPicker(index);
        },
        autofocus: false,
        controller: _streetAddressControllerList[index],
        onSaved: (String value) {
          _onSaved(value, 'Street Address');
        },
        validator: (String value) {
          return _onValidate(value, 'Street Address');
        },
        obscureText: false,
        cursorColor: Theme.of(context).primaryColor,
        style: TextStyle(
          color: Colors.black38,
        ),
        decoration: InputDecoration(
          labelText: 'Street Address',
          isDense: true,
          fillColor: Colors.grey[200],
          filled: true,
          suffixIcon: Padding(
            padding: const EdgeInsets.all(3.0),
            child: GestureDetector(
              onTap: () async {
                await _showLocationPicker(index);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                width: MediaQuery.of(context).size.width * 0.01,
                height: MediaQuery.of(context).size.width * 0.01,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: green,
                ),
                child: Center(
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 12.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
    /*return TextWidget(
      controller: _streetAddressControllerList.elementAt(index),
      obscureText: false,
      hintText: 'Street Address',
      onSaved: (String value) {
        _onSaved(value, 'Street Address');
      },
      validator: (String value) {
        return _onValidate(value, 'Street Address');
      },
    );*/
  }
}
