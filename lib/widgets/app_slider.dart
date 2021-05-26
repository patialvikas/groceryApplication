import 'package:GroceriesApplication/models/product.dart';
import 'package:GroceriesApplication/models/store.dart';
import 'package:GroceriesApplication/models/user.dart';
import 'package:GroceriesApplication/screens/private/owner/product_details.dart';
import 'package:GroceriesApplication/styles/styles.dart';
import 'package:GroceriesApplication/widgets/product_card.dart';
import 'package:GroceriesApplication/widgets/user_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppSlider extends StatefulWidget {
  final String leftText;
  final String rightText;
  final Store store;
  final bool isProduct;
  final Function gotoAddProduct;
  final List<Product> productList;
  final User user;
  AppSlider({
    this.leftText,
    this.rightText,
    this.store,
    this.isProduct,
    this.gotoAddProduct,
    this.productList,
    this.user,
  });
  @override
  _AppSliderState createState() => _AppSliderState();
}

class _AppSliderState extends State<AppSlider> {
  @override
  Widget build(BuildContext context) {
    return _getColumn(context, null);
  }

  Widget _getColumn(BuildContext context, List dealList) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.leftText,
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
              widget.productList.length > 2
                  ? Align(
                      alignment: Alignment.topRight,
                      child: widget.rightText != ''
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => new ProductDetails(
                                      leftText: widget.leftText,
                                      productList: widget.productList,
                                      user: widget.user,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                widget.rightText,
                                style: TextStyle(
                                  color: green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : Text(''),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          height: 250.0,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: widget.productList.length,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                height: 10.0,
                child: widget.isProduct
                    ? ProductCard(
                        isLoggedIn: true,
                        product: widget.productList[index],
                        gotoAddProduct: widget.gotoAddProduct,
                      )
                    : UserProductCard(
                        isLoggedIn: true,
                        product: widget.productList[index],
                        store: widget.store,
                        user: widget.user,
                      ),
              );
            },
          ),
          //}),
        ),
      ],
    );
  }
}
