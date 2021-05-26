import 'dart:collection';

import 'package:GroceriesApplication/models/product.dart';
import 'package:GroceriesApplication/models/store.dart';
import 'package:GroceriesApplication/models/user.dart';
import 'package:GroceriesApplication/services/app_auth_service.dart';
import 'package:GroceriesApplication/services/cloudFirestore/app_store_service.dart';
import 'package:GroceriesApplication/styles/styles.dart';
import 'package:GroceriesApplication/widgets/app_cached_network_image.dart';
import 'package:GroceriesApplication/widgets/app_slider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreSHop extends StatefulWidget {
  final Store store;
  final User user;
  StoreSHop({
    this.store,
    this.user,
  });
  @override
  _StoreSHopState createState() => _StoreSHopState();
}

class _StoreSHopState extends State<StoreSHop> {
  AppAuthService authService = AppAuthService();
  List<Widget> imageSliders = new List();
  @override
  void initState() {
    _getCarousel();
    super.initState();
  }

  _getCarousel() {
    imageSliders = widget.store.carouselList
        .map(
          (item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    AppCachedNetworkImage(
                      imageURL: item,
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 20.0,
                        ),
                        child: SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  Widget _getBody(BuildContext context) {
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    return Container(
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            stretch: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.25,
            floating: true,
            elevation: 10.0,
            leading: SizedBox.shrink(),
            flexibleSpace: Container(
              color: green,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.30,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 10,
                    bottom: 10,
                  ),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                    ),
                    items: imageSliders,
                  ),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: StreamBuilder(
              stream: cloudStoreService.getAllProduct(widget.store.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                QuerySnapshot qs = snapshot.data;
                if (qs.docs.length > 0) {
                  List<Product> _prodList = qs.docs.map((e) {
                    Product p = Product.fromMap(e.data());
                    p.id = e.id;
                    return p;
                  }).toList();
                  Map<String, List<Product>> catMap =
                      HashMap<String, List<Product>>();
                  for (Product p in _prodList) {
                    if (p.category == null || p.category.isEmpty) {
                      if (catMap.containsKey('Other')) {
                        catMap.update('Other', (value) {
                          value.add(p);
                          return value;
                        });
                      } else {
                        List<Product> pList = List<Product>();
                        pList.add(p);
                        catMap.putIfAbsent('Other', () => pList);
                      }
                    } else {
                      if (catMap.containsKey(p.category)) {
                        catMap.update(p.category, (value) {
                          value.add(p);
                          return value;
                        });
                      } else {
                        List<Product> pList = List<Product>();
                        pList.add(p);
                        catMap.putIfAbsent(p.category, () => pList);
                      }
                    }
                  }

                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        for (MapEntry entry in catMap.entries)
                          AppSlider(
                            leftText: entry.key,
                            rightText: 'See All->',
                            isProduct: false,
                            gotoAddProduct: null,
                            productList: entry.value,
                            store: widget.store,
                            user: widget.user,
                          ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Text('No Product'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getBody(context);
  }
}
