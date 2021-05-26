import 'package:GroceriesApplication/models/order.dart';
import 'package:GroceriesApplication/models/store.dart';
import 'package:GroceriesApplication/models/user.dart';
import 'package:GroceriesApplication/widgets/app_cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StoreCard extends StatefulWidget {
  final Store store;
  final bool isLoggedIn;
  final IconData icon;
  final User user;
  StoreCard({
    this.store,
    this.isLoggedIn,
    this.icon,
    this.user,
  });
  @override
  _StoreCardState createState() => _StoreCardState();
}

class _StoreCardState extends State<StoreCard> {
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
        child: _getStoreList(context),
      ),
    );
  }

  Widget _getStoreList(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 80,
        height: 80,
        child: AppCachedNetworkImage(
          imageURL: widget.store.carouselList.elementAt(0),
        ),
      ),
      title: Text(
        widget.store.storeName,
        style: TextStyle(
          fontSize: 16.0,
          fontFamily: "PoppinsMedium",
          fontStyle: FontStyle.normal,
          color: Colors.black,
          letterSpacing: 0.6,
          fontWeight: FontWeight.w400,
        ),
      ),
      subtitle: Text(
        widget.store.storeAddress.length.toString() + ' Addresses.',
        style: TextStyle(
          fontSize: 14.0,
          fontFamily: "PoppinsMedium",
          fontStyle: FontStyle.normal,
          color: Colors.black,
          letterSpacing: 0.2,
          fontWeight: FontWeight.w300,
        ),
      ),
      trailing: GestureDetector(
        onTap: () {
          print('JJJJ');
        },
        child: Icon(widget.icon),
      ),
    );
  }

  void _handleFavourite() {}
}
