import 'package:GroceriesApplication/models/product.dart';
import 'package:GroceriesApplication/models/store.dart';
import 'package:GroceriesApplication/models/user.dart';
import 'package:GroceriesApplication/screens/private/owner/add_product.dart';
import 'package:GroceriesApplication/services/cloudFirestore/app_store_service.dart';
import 'package:GroceriesApplication/widgets/product_card.dart';
import 'package:GroceriesApplication/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  final String leftText;
  final List<Product> productList;
  final User user;
  ProductDetails({
    this.leftText,
    this.productList,
    this.user,
  });
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int denomitar = 410;
  bool _shouldFilterSectionShown = false;
  bool _isEdit = false;
  Product p;
  TextEditingController _controll;

  @override
  void initState() {
    _controll = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery App'),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            if (_isEdit == true) {
              setState(() {
                _isEdit = false;
              });
            } else {
              Navigator.pop(context);
            }
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: _isEdit
          ? StreamBuilder(
              stream: cloudStoreService.getStore(widget.user.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final QuerySnapshot qs = snapshot.data;
                  Store store;
                  if (qs.docs.length > 0) {
                    store = Store.fromMap(qs.docs.first.data());
                    store.id = qs.docs.first.id;
                    return AddProduct(
                      user: widget.user,
                      store: store,
                      editProduct: p,
                    );
                  }
                  return Center(
                    child:
                        Text('Before adding product, you need to add a store.'),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              })
          : _getProductDetails(context),
    );
  }

  Widget _getProductDetails(BuildContext context) {
    
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.leftText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  // onTap: _listView,
                  child: Row(
                    children: <Widget>[
                      FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            if (denomitar == 205) {
                              setState(() {
                                denomitar = 410;
                              });
                            } else {
                              setState(() {
                                denomitar = 205;
                              });
                            }
                          });
                        },
                        mini: true,
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          'assets/images/orion-icon.png',
                          cacheHeight: 16,
                          cacheWidth: 20,
                        ),
                        elevation: 10.0,
                        isExtended: false,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        heroTag: null,
                        hoverColor: Theme.of(context).primaryColor,
                        splashColor: Theme.of(context).primaryColor,
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            _shouldFilterSectionShown =
                                !_shouldFilterSectionShown;
                          });
                        },
                        mini: true,
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          'assets/images/orion-right.png',
                          cacheHeight: 16,
                          cacheWidth: 20,
                        ),
                        elevation: 10.0,
                        isExtended: false,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        heroTag: null,
                        hoverColor: Theme.of(context).primaryColor,
                        splashColor: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          _shouldFilterSectionShown
              ? TextWidget(
                  controller: _controll,
                  hintText: 'Search',
                  obscureText: false,
                  onSaved: null,
                  suffixIconPath: null,
                  validator: null,
                )
              : SizedBox.shrink(),
          SizedBox(
            height: 10.0,
          ),
          Flexible(
            child: widget.productList != null
                ? GridView.builder(
                    itemCount: widget.productList
                        .map((e) {
                          if (e.productName
                              .toLowerCase()
                              .contains(_controll.text.toLowerCase())) {
                            return e;
                          } else {
                            return null;
                          }
                        })
                        .toList()
                        .length,
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    addRepaintBoundaries: true,
                    itemBuilder: (BuildContext context, int index) {
                      if (_controll.text != '') {
                        if (widget.productList
                            .elementAt(index)
                            .productName
                            .toLowerCase()
                            .contains(_controll.text.toLowerCase())) {
                          return ProductCard(
                            gotoAddProduct: _switchToEdit,
                            isLoggedIn: true,
                            product: widget.productList.elementAt(index),
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return ProductCard(
                          gotoAddProduct: _switchToEdit,
                          isLoggedIn: true,
                          product: widget.productList.elementAt(index),
                        );
                      }
                      if (widget.productList
                          .elementAt(index)
                          .productName
                          .toLowerCase()
                          .contains(_controll.text.toLowerCase())) {
                        return ProductCard(
                          gotoAddProduct: _switchToEdit,
                          isLoggedIn: true,
                          product: widget.productList.elementAt(index),
                        );
                      }

                      return Container();
                    },
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          (MediaQuery.of(context).size.width / denomitar)
                              .round(),
                    ),
                  )
                : Center(
                    child: Text('No Deal'),
                  ),
          ),
        ],
      ),
    );
  }

  void _switchToEdit(Product prod) {
    setState(() {
      _isEdit = true;
      p = prod;
    });
  }

  Widget _getFilterSection(BuildContext context) {}
}
