import 'package:GroceriesApplication/models/price.dart';
import 'package:GroceriesApplication/models/product.dart';
import 'package:GroceriesApplication/services/cloudFirestore/app_store_service.dart';
import 'package:GroceriesApplication/styles/styles.dart';
import 'package:GroceriesApplication/widgets/app_cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final bool isLoggedIn;
  final Function gotoAddProduct;

  ProductCard({
    this.product,
    this.isLoggedIn,
    this.gotoAddProduct,
  });
  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  //List<bool> _flag = [true, false, false];
  List<Price> _priceList = [];
  int _clickedIndex = 0;

  @override
  void initState() {
    _setPriceList();
    super.initState();
  }

  _setPriceList() {
    List<Price> pList = [];
    Price p;
    for (MapEntry mapEntry in widget.product.unitPriceComb.entries) {
      p = Price(unit: mapEntry.key, price: mapEntry.value);
      pList.add(p);
    }
    setState(() {
      _priceList = pList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10,
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        shadowColor: Color.fromRGBO(105, 105, 105, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: GestureDetector(
          onTap: () {
            //Nothing as of now
          },
          child: _getProductCard(context),
        ),
      ),
    );
  }

  Widget _getProductCard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.33,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: AppCachedNetworkImage(
                imageURL: widget.product.productImageUrl.elementAt(0),
              ),
            ),
          ),
          _getFooter(context),
        ],
      ),
    );
  }

  Widget _getFooter(BuildContext context) {
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.product.productName,
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: "PoppinsMedium",
                fontStyle: FontStyle.normal,
                color: Colors.black,
                letterSpacing: 0.6,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (int i = 0; i < _priceList.length; i++)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _clickedIndex = i;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              i == _clickedIndex ? green : Colors.transparent,
                          border: Border.all(
                            color: green,
                            style: BorderStyle.solid,
                            width: 1,
                          ),
                        ),
                        padding: EdgeInsets.all(2),
                        margin: EdgeInsets.only(right: 4),
                        child: Text(
                          _priceList.elementAt(i).unit,
                          style: TextStyle(
                            color: i == _clickedIndex
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Text(
                  '\$ ' + _priceList.elementAt(_clickedIndex).price.toStringAsFixed(2)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  widget.product.quantity == null
                      ? Text('')
                      : Text('${widget.product.quantity}',),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    child: Icon(Icons.edit),
                    onTap: () {
                      widget.gotoAddProduct(widget.product);
                    },
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.block,
                      color:
                          widget.product.isActive ? Colors.black : Colors.red,
                    ),
                    onTap: () async {
                      Product p = widget.product;
                      p.isActive = !p.isActive;
                      await cloudStoreService.updateProduct(p);
                    },
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onTap: () async {
                      await cloudStoreService.deleteProduct(widget.product.id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
