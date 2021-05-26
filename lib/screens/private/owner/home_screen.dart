import 'package:GroceriesApplication/models/product.dart';
import 'package:GroceriesApplication/models/store.dart';
import 'package:GroceriesApplication/models/user.dart';
import 'package:GroceriesApplication/services/cloudFirestore/app_store_service.dart';
import 'package:GroceriesApplication/styles/colors.dart';
import 'package:GroceriesApplication/styles/styles.dart';
import 'package:GroceriesApplication/utility/data/grocery_data.dart';
import 'package:GroceriesApplication/utility/route/app_slide_right_route.dart';
import 'package:GroceriesApplication/widgets/app_button.dart';
import 'package:GroceriesApplication/widgets/app_cached_network_image.dart';
import 'package:GroceriesApplication/widgets/app_slider.dart';
import 'package:GroceriesApplication/widgets/dashboard_widget.dart';
import 'package:GroceriesApplication/widgets/grocery_card.dart';
import 'package:GroceriesApplication/widgets/grocery_webview.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:GroceriesApplication/services/app_auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  final Function gotoAddStore;
  final Function gotoAddProduct;
  HomeScreen({
    this.user,
    this.gotoAddStore,
    this.gotoAddProduct,
  });
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppAuthService authService = AppAuthService();
  List<Widget> imageSliders = new List();
  @override
  void initState() {
    _getCarousel();
    super.initState();
  }

  _getCarousel() {
    imageSliders = GroceryData.imgList
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

  @override
  Widget build(BuildContext context) {
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    return Container(
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            stretch: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.3,
            floating: true,
            elevation: 10.0,
            leading: SizedBox.shrink(),
            flexibleSpace: DashboardWidget(
              uid: widget.user.uid,
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: StreamBuilder(
                stream: cloudStoreService.getStore(widget.user.uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final QuerySnapshot qs = snapshot.data;
                  Store store;
                  if (qs.docs.length > 0) {
                    store = Store.fromMap(qs.docs.first.data());
                    store.id = qs.docs.first.id;
                  } else {
                    store = null;
                  }

                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        store != null
                            ? Padding(
                                padding: EdgeInsets.only(left: 15, right: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'My Store',
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
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Text(
                                          '',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox.shrink(),
                        store != null
                            ? Container(
                                height: 275.0,
                                width: MediaQuery.of(context).size.width,
                                child: GroceryCard(
                                  data: store,
                                  editMode: widget.gotoAddStore,
                                ),
                              )
                            : AppButton(
                                label: 'Add Store',
                                onPressed: _gotoAddStore,
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        store != null
                            ? StreamBuilder(
                                stream:
                                    cloudStoreService.getAllProduct(store.id),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  final QuerySnapshot qs = snapshot.data;
                                  if (qs.docs.length > 0) {
                                    List<Product> _prodList = qs.docs.map((e) {
                                      Product p = Product.fromMap(e.data());
                                      p.id = e.id;
                                      return p;
                                    }).toList();
                                    return AppSlider(
                                      leftText: 'Active Products',
                                      rightText: 'See All->',
                                      isProduct: true,
                                      gotoAddProduct: widget.gotoAddProduct,
                                      store: store,
                                      productList: _prodList,
                                      user: widget.user,
                                    );
                                  } else {
                                    return SizedBox.shrink();
                                  }
                                },
                              )
                            : SizedBox.shrink(),
                        SizedBox(
                          height: 10,
                        ),
                        /* StreamBuilder(
                          stream: cloudStoreService.getAccountLink(),
                          builder: (context, docSnapshot) {
                            if (!docSnapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            DocumentSnapshot ds = docSnapshot.data;
                            if (ds.data() != null) {
                              if (ds.data()['account_link_url'] != null) {
                                print('fdhbbjh');
                                /*Navigator.push(
                                  context,
                                  AppSlideRightRoute(
                                    page: GroceryWebview(
                                      url: ds
                                          .data()['account_link_url']
                                          .toString(),
                                    ),
                                  ),
                                );*/
                                return SizedBox.shrink();
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),*/
                        store != null
                            ? StreamBuilder(
                                stream: cloudStoreService
                                    .getBlockedProduct(store.id),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  final QuerySnapshot qs = snapshot.data;
                                  if (qs.docs.length > 0) {
                                    List<Product> _prodList = qs.docs.map((e) {
                                      Product p = Product.fromMap(e.data());
                                      p.id = e.id;
                                      return p;
                                    }).toList();
                                    return AppSlider(
                                      leftText: 'Blocked Products',
                                      rightText: 'See All->',
                                      isProduct: true,
                                      gotoAddProduct: widget.gotoAddProduct,
                                      store: store,
                                      productList: _prodList,
                                      user: widget.user,
                                    );
                                  } else {
                                    return SizedBox.shrink();
                                  }
                                },
                              )
                            : SizedBox.shrink(),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  void _gotoAddStore() {
    widget.gotoAddStore();
  }
}
