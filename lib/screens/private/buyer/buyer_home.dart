import 'package:GroceriesApplication/models/store.dart';
import 'package:GroceriesApplication/models/user.dart';
import 'package:GroceriesApplication/screens/private/store/store_wrapper.dart';
import 'package:GroceriesApplication/services/cloudFirestore/app_store_service.dart';
import 'package:GroceriesApplication/utility/data/grocery_data.dart';
import 'package:GroceriesApplication/utility/route/app_slide_right_route.dart';
import 'package:GroceriesApplication/widgets/divider_with_text.dart';
import 'package:GroceriesApplication/widgets/grocery_card.dart';
import 'package:GroceriesApplication/widgets/store_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class BuyerHome extends StatefulWidget {
  final User user;
  BuyerHome({
    this.user,
  });
  @override
  _BuyerHomeState createState() => _BuyerHomeState();
}

class _BuyerHomeState extends State<BuyerHome> {
  TextEditingController _searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: new DividerWithText(
            dividerText: 'search results',
          ),
        ),
        Expanded(
          child: StreamBuilder<Object>(
            stream: cloudStoreService.getAllStore(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              QuerySnapshot qs = snapshot.data;
              if (qs.docs.length > 0) {
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: qs.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    Store store =
                        Store.fromMap(qs.docs.elementAt(index).data());
                    store.id = qs.docs.elementAt(index).id;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          AppSlideRightRoute(
                            page: StoreWrapper(
                              store: store,
                              user: widget.user,
                            ),
                          ),
                        );
                      },
                      child: StoreCard(
                        icon: Icons.favorite_border,
                        isLoggedIn: true,
                        store: store,
                        user: widget.user,
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text('No Stores'),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildPlaceCard(BuildContext context, int index) {
    return Hero(
      tag: "a1",
      transitionOnUserGestures: true,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: Card(
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: Text('store.storeName',
                                    maxLines: 3,
                                    style: TextStyle(fontSize: 25.0)),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text('store.storeAddress'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () async {},
            ),
          ),
        ),
      ),
    );
  }
}
