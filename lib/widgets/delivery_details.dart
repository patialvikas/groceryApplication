import 'package:GroceriesApplication/models/card.dart';
import 'package:GroceriesApplication/models/cart.dart';
import 'package:GroceriesApplication/models/release_order.dart';
import 'package:GroceriesApplication/models/store.dart';
import 'package:GroceriesApplication/models/user.dart';
import 'package:GroceriesApplication/services/cloudFirestore/app_store_service.dart';
import 'package:GroceriesApplication/services/extension/string_extension.dart';
import 'package:GroceriesApplication/services/payment/stripe_service.dart';
import 'package:GroceriesApplication/styles/styles.dart';
import 'package:GroceriesApplication/widgets/app_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';

class DeliveryDetails extends StatefulWidget {
  final String storeId;
  final Cart cart;
  final User user;
  DeliveryDetails({
    this.storeId,
    this.cart,
    this.user,
  });
  @override
  _DeliveryDetailsState createState() => _DeliveryDetailsState();
}

class _DeliveryDetailsState extends State<DeliveryDetails> {
  String groupValue;
  String paymentGroupValue;
  String selectedCard;
  PaymentCard card;
  String paymentId;
  ReleaseOrder _relOrder;

  @override
  void initState() {
    super.initState();
    StripeServices.initialize();
  }

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  bool _isLoading = false;
  bool _isCardError = false;
  @override
  Widget build(BuildContext context) {
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    return StreamBuilder(
      stream: cloudStoreService.getStoreById(widget.storeId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        DocumentSnapshot ds = snapshot.data;
        Store _store = Store.fromMap(ds.data());
        _store.id = ds.id;
        List<String> _options = [];
        List<String> _paymentOptions = [
          'Cash on Pickup',
          'Credit Card/Debit Card'
        ];
        if (_store.serviceMode == 'Both') {
          _options.add('Home Delivery');
          _options.add('Pick Up');
        } else {
          _options.add(_store.serviceMode);
        }
        return Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        RaisedButton(
                          child: Text("Add Card"),
                          onPressed: () {
                            StripePayment.paymentRequestWithCardForm(
                                    CardFormPaymentRequest())
                                .then((paymentMethod) async {
                              final cloudStoreService =
                                  Provider.of<AppStoreService>(context,
                                      listen: false);

                              await cloudStoreService.addCard(paymentMethod);
                              print('Received ${paymentMethod.id}');
                            }).catchError((e) {
                              print('Error : ' + e.toString());
                            });
                            //StripeServices.checkIfNativePayReady(context);
                            /*StripePayment.paymentRequestWithCardForm(
                                  CardFormPaymentRequest())
                              .then((paymentMethod) async {
                            final cloudStoreService =
                                Provider.of<AppStoreService>(context,
                                    listen: false);
                            await cloudStoreService.addCard(paymentMethod.id);
                            print('Received ${paymentMethod.id}');
                            
                          }).catchError((e) {
                            print('Error : ');
                          });*/
                          },
                        ),
                        Text(
                          'Select Cards',
                          style: hintStyleblackatextPSB(),
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('stripe_customers')
                              .doc(widget.user.uid)
                              .collection('payment_methods')
                              .snapshots(),
                          builder: (context, snap) {
                            if (!snap.hasData) {
                              return SizedBox.shrink();
                            }
                            QuerySnapshot qs = snap.data;
                            if (qs.docs.length > 0) {
                              List<PaymentCard> cardList = qs.docs.map((e) {
                                PaymentCard m = PaymentCard.fromMap(e.data());
                                m.id = e.id;
                                return m;
                              }).toList();
                              return Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                margin: EdgeInsets.only(top: 15.0),
                                child: new DropdownButtonFormField<PaymentCard>(
                                  decoration: InputDecoration(
                                    labelText: 'Saved Card',
                                    labelStyle: hintStylesmBlackbPR(),
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                    isDense: true,
                                    hintStyle: TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w100,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                      vertical: 12.0,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                        color:
                                            Color(0xFF707070).withOpacity(0.29),
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                  ),
                                  style: hintStylesmBlackbPR(),
                                  onSaved: null,
                                  dropdownColor: Colors.white,
                                  validator: null,
                                  value: card != null ? card : null,
                                  onChanged: (PaymentCard v) {
                                    setState(() {
                                      card = v;
                                      _isCardError = false;
                                    });
                                  },
                                  items: cardList.map(
                                    (PaymentCard map) {
                                      return new DropdownMenuItem<PaymentCard>(
                                        value: map,
                                        child: new Text(
                                          map.last4,
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                              );
                            } else {
                              return Text('No Card has been added');
                            }
                          },
                        ),
                        _isCardError
                            ? SizedBox(
                                height: 5,
                              )
                            : SizedBox.shrink(),
                        _isCardError
                            ? Container(
                                margin: EdgeInsets.only(left: 35),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'You must select a card',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              )
                            : SizedBox.shrink(),
                        SizedBox(
                          height: 20,
                        ),
                        card != null
                            ? Text(
                                'Card Details',
                                style: hintStyleblackatextPSB(),
                              )
                            : SizedBox.shrink(),
                        card != null
                            ? Column(
                                children: [
                                  TextFormField(
                                    obscureText: false,
                                    style: style,
                                    enabled: false,
                                    validator: null,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(20.0, 0, 0, 10.0),
                                      labelText: 'XXXX XXXX XXXX ' + card.last4,
                                      //hintText: "XXXX",
                                    ),
                                  ),
                                  TextFormField(
                                    obscureText: false,
                                    style: style,
                                    enabled: false,
                                    validator: null,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(20.0, 0, 0, 10.0),
                                      labelText: card.expMonthYear,
                                      //hintText: "XXXX",
                                    ),
                                  ),
                                  TextFormField(
                                    obscureText: false,
                                    style: style,
                                    enabled: false,
                                    validator: null,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(20.0, 0, 0, 10.0),
                                      labelText: card.brand.capitalize(),
                                      //hintText: "XXXX",
                                    ),
                                  )
                                ],
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Total",
                                style: Theme.of(context).textTheme.subtitle),
                            Text(
                                "\$ " +
                                    widget.cart.totalCost.toStringAsFixed(2),
                                style: Theme.of(context).textTheme.headline),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 50,
                          child: RaisedButton(
                            child: Text("Pay", style: hintStylewhitetextPSB()),
                            onPressed: () async {
                              setState(() {
                                _isCardError = false;
                              });
                              // if (groupValue == 'Pick Up' &&
                              //   paymentGroupValue == 'Cash on Pickup') {
                              if (card == null) {
                                setState(() {
                                  _isCardError = true;
                                });
                                return;
                              }
                              setState(() {
                                _isLoading = true;
                              });
                              final cloudStoreService =
                                  Provider.of<AppStoreService>(context,
                                      listen: false);
                              List<ReleaseOrderItem> itemList = new List();
                              ReleaseOrderItem roi;
                              for (CartItem cI in widget.cart.cartItemList) {
                                roi = new ReleaseOrderItem(
                                  price: cI.itemCost,
                                  productReference: cI.productDoc,
                                  quantity: cI.quantity,
                                  selectedUnit: cI.selectedUnit,
                                );
                                itemList.add(roi);
                              }
                              ReleaseOrder relOrder = new ReleaseOrder(
                                storeId: widget.cart.storeId,
                                userId: widget.cart.userId,
                                //status: 'In Progress',
                                status: 'Created',
                                creationTime: DateTime.now(),
                                totalCost: widget.cart.totalCost,
                                orderItemList: itemList,
                              );
                              setState(() {
                                // _relOrder = relOrder;
                              });
                              final DocumentReference ref =
                                  await cloudStoreService.createOrder(relOrder);
                              //await cloudStoreService.deleteCart(widget.cart);
                              final DocumentSnapshot ds =
                                  await cloudStoreService
                                      .getStoreByIdFuture(widget.cart.storeId);
                              //ref.get('ownerUid');
                              String owner = ds.data()['ownerUid'];
                              final DocumentSnapshot vds =
                                  await cloudStoreService
                                      .getVendorAccount(owner);

                              String cust = vds.data()['id'];
                              print('widget.cart.totalCost=>' +
                                  (widget.cart.totalCost * 100)
                                      .toStringAsFixed(2));
                              final DocumentReference paymentRef =
                                  await cloudStoreService.doPayment(
                                double.parse((widget.cart.totalCost * 100)
                                    .toStringAsFixed(2)),
                                card.id,
                                cust,
                                ref.id,
                                widget.cart.id,
                              );
                              if (paymentRef != null) {
                                setState(() {
                                  paymentId = paymentRef.id;
                                  _isLoading = false;
                                });
                              }

                              /////////////final DocumentReference ref = await cloudStoreService.createOrder(relOrder);
                              //////////////await cloudStoreService.deleteCart(widget.cart);
                            },
                            color: green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox.shrink(),
              paymentId != null
                  ? StreamBuilder<Object>(
                      stream: cloudStoreService.getPaymentDetails(paymentId),
                      builder: (context, snapPayment) {
                        if (!snapPayment.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        DocumentSnapshot ds = snapPayment.data;
                        if (ds.data()['error'] != null) {
                          return Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 0.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.orangeAccent,
                              ),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error,
                                    size: 30,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    'Payment is Failed',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      fontFamily: 'PoppinsMedium',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  AppButton(
                                      label: 'Okay!!',
                                      onPressed: () {
                                        setState(() {
                                          paymentId = null;
                                        });
                                      }),
                                ],
                              ),
                            ),
                          );
                        }

                        if (ds.data()['error'] == null) {
                          if (ds.data()['status'] != null) {
                            if (ds.data()['status'] == 'succeeded') {
                              return Center(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.orangeAccent,
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.payments,
                                        size: 30,
                                        color: Colors.green,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'Payment Success',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0,
                                          fontFamily: 'PoppinsMedium',
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      AppButton(
                                        label: 'Okay',
                                        onPressed: () async {
                                          setState(() {
                                            paymentId = null;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                          } else {
                            return Center(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width * 0.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.orangeAccent,
                                ),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Payment is Going On....',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.0,
                                        fontFamily: 'PoppinsMedium',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        }
                      })
                  : SizedBox.shrink()
            ],
          ),
        );
      },
    );
  }
}
