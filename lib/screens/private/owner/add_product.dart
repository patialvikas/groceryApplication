import 'dart:io';

import 'package:GroceriesApplication/models/product.dart';
import 'package:GroceriesApplication/models/store.dart';
import 'package:GroceriesApplication/models/user.dart';
import 'package:GroceriesApplication/services/cloudFirestore/app_store_service.dart';
import 'package:GroceriesApplication/services/storage/app_storage.dart';
import 'package:GroceriesApplication/styles/styles.dart';
import 'package:GroceriesApplication/utility/image/image_utility.dart';
import 'package:GroceriesApplication/widgets/app_button.dart';
import 'package:GroceriesApplication/widgets/app_cached_network_image.dart';
import 'package:GroceriesApplication/widgets/dropdown_widget.dart';
import 'package:GroceriesApplication/widgets/image_upload_card.dart';
import 'package:GroceriesApplication/widgets/input_field_title.dart';
import 'package:GroceriesApplication/widgets/small_text_widget.dart';
import 'package:GroceriesApplication/widgets/text_widget.dart';
import 'package:GroceriesApplication/widgets/upload_image_unit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatefulWidget {
  final User user;
  final Store store;
  final Product editProduct;
  AddProduct({
    this.user,
    this.store,
    this.editProduct,
  });
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isImageError = false;
  //Product product;
  String imageURL;
  //bool _priceValidated = false;
  PickedFile _image;
  String _cat;
  bool _isLoading = false;
  String _productName, _productDescription, _quantity;
  double _piecePrice, _lbPrice, _ozPrice;
  bool _isPriceSelected = false;

  List<String> _uploadedImageUrl = [];
  Color _baseColor = Color(0xFF707070).withOpacity(0.51);
  Color _normalColor = Color(0xFF707070).withOpacity(0.51);
  bool _isEdit = false;
  List<bool> _priceFlagList = [false, false, false];

  TextEditingController _productNameController,
      _quantityController,
      _productDescriptionController,
      _piecePriceController,
      _ozPriceController,
      _lbPriceController;

  List<PickedFile> _imageList = new List();
  //List<String> menuItems = [];

  bool _doesIndexExist(int index) {
    for (int sl in _skipList) {
      if (sl == index) {
        return true;
      }
    }
    return false;
  }

  List<int> _skipList = [];

  void _onDelete(int index) {
    setState(() {
      if (widget.editProduct.productImageUrl.length > index) {
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

  Future<void> _saveImagesList(String name) async {
    final storage = Provider.of<AppStorage>(context, listen: false);
    bool ool = false;
    for (int p = 0; p < _imageList.length; p++) {
      if (_imageList.elementAt(p) == null) {
        continue;
      }
      ool = true;
      final downloadUrl = await storage.uploadProductImages(
          file: File(_imageList.elementAt(p).path), name: '$name/$p.png');
      setState(() {
        _uploadedImageUrl.add(downloadUrl);
      });
    }
    if (!ool) {
      setState(() {
        _isImageError = true;
      });
    }
  }

  @override
  void initState() {
    _productNameController = new TextEditingController();
    _quantityController = new TextEditingController();
    _productDescriptionController = new TextEditingController();
    _piecePriceController = new TextEditingController();
    _ozPriceController = new TextEditingController();
    _lbPriceController = new TextEditingController();

    _imageList.add(null);
    _imageList.add(null);
    _imageList.add(null);
    _imageList.add(null);
    _imageList.add(null);
    _imageList.add(null);

    if (widget.editProduct != null) {
      _isEdit = true;
      _mapEditProduct();
    } else {}
    super.initState();
  }

  _mapEditProduct() {
    _productNameController.text = widget.editProduct.productName;
    _productDescriptionController.text = widget.editProduct.productDescription;
    _quantityController.text = widget.editProduct.quantity;
    //imageURL = widget.editProduct.productImageUrl;
    _cat = widget.editProduct.category;
    _setEditProduct();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productDescriptionController.dispose();
    _piecePriceController.dispose();
    _ozPriceController.dispose();
    _lbPriceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _setEditProduct() {
    for (MapEntry mapEntry in widget.editProduct.unitPriceComb.entries) {
      switch (mapEntry.key) {
        case 'Item':
          setState(() {
            _priceFlagList[0] = true;
            _piecePriceController.text = mapEntry.value.toString();
          });

          break;
        case 'Lb':
          setState(() {
            _priceFlagList[1] = true;
            _lbPriceController.text = mapEntry.value.toString();
          });

          break;
        case 'Oz':
          setState(() {
            _priceFlagList[2] = true;
            _ozPriceController.text = mapEntry.value.toString();
          });

          break;
        default:
      }
    }
  }

  Map<String, double> _getPriceList() {
    Map<String, double> map = new Map();
    if (_priceFlagList[0]) {
      map.putIfAbsent('Item', () => _piecePrice);
    }
    if (_priceFlagList[1]) {
      map.putIfAbsent('Lb', () => _lbPrice);
    }
    if (_priceFlagList[2]) {
      map.putIfAbsent('Oz', () => _ozPrice);
    }
    return map;
  }

  void _onSaved(String value, String label) {
    if (label.isNotEmpty) {
      switch (label) {
        case 'Product Name':
          _productName = value;
          break;
        case 'Quantity':
          _quantity = value;
          break;
        case 'Item':
          if (_priceFlagList[0]) {
            _piecePrice = double.parse(value);
          }

          break;
        case 'Lb':
          if (_priceFlagList[1]) {
            _lbPrice = double.parse(value);
          }

          break;
        case 'Oz':
          if (_priceFlagList[2]) {
            _ozPrice = double.parse(value);
          }

          break;
        case 'Description of Product':
          _productDescription = value;
          break;
        case 'Category':
          _cat = value;
          break;
        default:
      }
    }
  }

  Future<void> _saveImagesIfAny(String name) async {
    final storage = Provider.of<AppStorage>(context, listen: false);
    final downloadUrl =
        await storage.uploadProductImages(file: File(_image.path), name: name);
    setState(() {
      imageURL = downloadUrl;
    });
  }

  bool _flag = false;

  bool ifAnyElementIsTrue(List<bool> flagList) {
    bool flag = false;
    for (bool b in flagList) {
      if (b) {
        flag = true;
        break;
      }
    }

    return flag;
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
    setState(() {
      _flag = false;
      _isLoading = true;
      _isImageError = false;
    });
    if (!ifAnyElementIsTrue(_priceFlagList)) {
      setState(() {
        _isPriceSelected = true;
      });
    }

    if (_isEdit) {
      setState(() {
        _isLoading = true;
      });
      print('LEN=>' + _checkIfImageListIsEmpty().toString());
      if (_checkIfImageListIsEmpty()) {
        for (int index = 0;
            index < widget.editProduct.productImageUrl.length;
            index++) {
          if (_doesIndexExist(index)) {
            continue;
          } else {
            setState(() {
              _uploadedImageUrl
                  .add(widget.editProduct.productImageUrl.elementAt(index));
            });
          }
        }
        if (_uploadedImageUrl.length < 1) {
          setState(() {
            _isLoading = false;
            _isImageError = true;
          });
          return;
        }
        print('_skipList ' + _skipList.length.toString());
        for (int i in _skipList) {
          deleteStoreImage(widget.editProduct.productImageUrl.elementAt(i));
        }
      } else {
        setState(() {
          _uploadedImageUrl = [];
        });
        for (int index = 0;
            index < widget.editProduct.productImageUrl.length;
            index++) {
          if (!_doesIndexExist(index)) {
            setState(() {
              _uploadedImageUrl
                  .add(widget.editProduct.productImageUrl.elementAt(index));
            });
          }
        }
        print(
            '_uploadedImageUrl.length ' + _uploadedImageUrl.length.toString());

        await _saveImagesList(_productNameController.text ?? 'prod');
        print(
            '_uploadedImageUrl.length2 ' + _uploadedImageUrl.length.toString());
        if (_uploadedImageUrl.length >= 1) {
        } else {
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }
    } else {
      if (_imageList.length >= 1) {
        await _saveImagesList(_productNameController.text ?? 'prod');
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
    setState(() {
      _isLoading = true;
    });
    Product _product;
    if (_isEdit) {
      _product = new Product(
        id: widget.editProduct.id,
        productDescription: _productDescriptionController.text,
        productImageUrl: _uploadedImageUrl,
        productName: _productNameController.text,
        isActive: true,
        quantity: _quantityController.text,
        category: _cat,
        ownerStoreId: widget.store.id,
        unitPriceComb: _getPriceList(),
      );
      try {
        await cloudStoreService.updateProduct(_product);
        setState(() {
          _imageList = new List();
          _skipList = [];
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text('Product has been updated successfully'),
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
        print('Some Error' + error.toString());
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      try {
        _product = new Product(
          productDescription: _productDescription,
          productImageUrl: _uploadedImageUrl,
          productName: _productName,
          quantity: _quantityController.text,
          unitPriceComb: _getPriceList(),
          isActive: true,
          category: _cat,
          ownerStoreId: widget.store.id,
        );
        await cloudStoreService.addProduct(_product);
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text('Product has been added successfully'),
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

  String _onValidate(String value, String label) {
    if (value == null || value.isEmpty) {
      if (label == 'Product Name') {
        return "Product name can not be empty.";
      } else if (label == 'Category') {
        print('JJJJKKKKLLLL');
        return "Product category can not be empty.";
      } else if (label == 'Description of Product') {
        return "Description of product can not be empty.";
      } else if (label == 'Quantity') {
        return "Quantity of product can not be empty.";
      } else if (label == 'Item' && _priceFlagList[0]) {
        return "Item price can not be empty.";
      } else if (label == 'Lb' && _priceFlagList[1]) {
        return "Lb price can not be empty.";
      } else if (label == 'Oz' && _priceFlagList[2]) {
        return "Oz price can not be empty.";
      }
    } else {
      if (label == 'Description of Product') {
        if (value.length > 500) {
          return "Description must be less than 500 character.";
        }
      } else if (label == 'Quantity') {
        if (value.length > 10) {
          return "Quantity must be within 10 character.";
        }
      }
    }
    return null;
  }

  _setImage(final file) {
    setState(() {
      _image = file;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
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
                          text: 'Add product',
                        ),
                        TextWidget(
                          controller: _productNameController,
                          obscureText: false,
                          hintText: 'Product name',
                          onSaved: (String value) {
                            _onSaved(value, 'Product Name');
                          },
                          validator: (String value) {
                            return _onValidate(value, 'Product Name');
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InputFieldTitle(
                          text: 'Upload Product Images(Min 1 and max 6)',
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        _isImageError
                            ? Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'You must upload atleast 1 images',
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
                              if (widget.editProduct != null &&
                                  widget.editProduct.productImageUrl != null &&
                                  index <
                                      widget
                                          .editProduct.productImageUrl.length &&
                                  !_doesIndexExist(index)) {
                                return UploadImageUnit(
                                  imageFile: widget.editProduct.productImageUrl
                                      .elementAt(index),
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
                        InputFieldTitle(
                          text: 'Product Category:',
                        ),
                        StreamBuilder(
                          stream: cloudStoreService.getAllCategory(),
                          builder: (context, snap) {
                            if (!snap.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            DocumentSnapshot ds = snap.data;

                            return DropdownWidget(
                              menuItem:
                                  List<String>.from(ds.data()['category']),
                              onSaved: (String value) {
                                _onSaved(value, 'Category');
                              },
                              onValidate: (String value) {
                                return _onValidate(value, 'Category');
                              },
                              onChanged: (String v) {
                                setState(() {
                                  _cat = v;
                                });
                              },
                              selectedMenu: _cat,
                              hint: 'Category',
                            );
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InputFieldTitle(
                          text: 'Add Price Details:',
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        _isPriceSelected
                            ? Text(
                                'A product must have atleast one price details.',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              )
                            : SizedBox.shrink(),
                        SizedBox(
                          height: 10,
                        ),
                        _getUnit(context, 'Item', 0),
                        SizedBox(
                          height: 5,
                        ),
                        _getUnit(context, 'Lb', 1),
                        SizedBox(
                          height: 10,
                        ),
                        TextWidget(
                          controller: _quantityController,
                          obscureText: false,
                          hintText: 'Quantity',
                          onSaved: (String value) {
                            _onSaved(value, 'Quantity');
                          },
                          validator: (String value) {
                            return _onValidate(value, 'Quantity');
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '(Limit 10 character)',
                            style: hintStyleSmPR(),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //_getUnit(context, 'Oz', 2),
                        /*SizedBox(
                          height: 10,
                        ),*/
                        TextFormField(
                          autofocus: false,
                          controller: _productDescriptionController,
                          validator: (String value) {
                            return _onValidate(value, 'Description of Product');
                          },
                          onSaved: (String value) {
                            _onSaved(value, 'Description of Product');
                          },
                          obscureText: false,
                          maxLines: 5,
                          cursorColor: Theme.of(context).primaryColor,
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Description of Product',
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
                            '(Limit 500 character)',
                            style: hintStyleSmPR(),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        AppButton(
                          label: _isEdit ? 'Edit Product' : 'Add Product',
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
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _getUnit(BuildContext context, String label, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  _priceFlagList[index] = !_priceFlagList[index];
                });
              },
              child: Container(
                  margin: EdgeInsets.only(right: 10.0, left: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFBBC2C3), width: 1.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: _priceFlagList[index]
                        ? Icon(
                            Icons.check,
                            size: 15.0,
                            color: blacktext,
                          )
                        : Icon(
                            Icons.check,
                            size: 15.0,
                            color: Colors.black.withOpacity(0.0),
                          ),
                  )),
            ),
            Text(
              label,
              style: hintStyleSmPR(),
            ),
          ],
        ),
        SmallTextWidget(
          controller: index == 0
              ? _piecePriceController
              : index == 1
                  ? _lbPriceController
                  : _ozPriceController,
          hintText: '\$',
          obscureText: false,
          onSaved: (String value) {
            _onSaved(value, label);
          },
          suffixIconPath: null,
          validator: (String value) {
            return _onValidate(value, label);
          },
          flag: _priceFlagList[index],
        ),
      ],
    );
  }
}
