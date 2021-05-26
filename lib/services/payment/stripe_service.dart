import 'dart:convert';

import 'package:GroceriesApplication/widgets/show_dialog_to_dismiss.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;

class StripeServices {
  static const PUBLISHABLE_KEY =
      "pk_test_51HcYgYFrPnjXtcaV9FhjPakPhLxi24RH5dgox8EPyeSJsAopZMn0D3024cpHB8rNI4SAJyc7mIDcG7GaaH6u7U2e00bLfdVJbi";
  static const SECRET_KEY =
      "sk_test_51HcYgYFrPnjXtcaVs2KvpjOjIFu5ANmhfmjqVqOdnMVZ2uGMUaZSTHBe6qZpSvtLueMeqjqLTMiIEDXDRC1PA5AP00Sfl1eW4d";
  static const PAYMENT_METHOD_URL = "https://api.stripe.com/v1/payment_methods";
  static const CUSTOMERS_URL = "https://api.stripe.com/v1/customers";
  static const CHARGE_URL = "https://api.stripe.com/v1/charges";
  Map<String, String> headers = {
    'Authorization': "Bearer  $SECRET_KEY",
    "Content-Type": "application/x-www-form-urlencoded"
  };

  static void initialize() {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: PUBLISHABLE_KEY,
        merchantId: 'Test',
        androidPayMode: 'test',
      ),
    );
  }

  static void checkIfNativePayReady(BuildContext context) async {
    print('started to check if native pay ready');
    bool deviceSupportNativePay = await StripePayment.deviceSupportsNativePay();
    bool isNativeReady = await StripePayment.canMakeNativePayPayments(
        ['american_express', 'visa', 'maestro', 'master_card']);
    print('deviceSupportNativePay '+deviceSupportNativePay.toString());
    print('isNativeReady '+isNativeReady.toString());
    deviceSupportNativePay && isNativeReady
        ? createPaymentMethodNative(context)
        : createPaymentMethod(context);
  }
static double tip = 0.01;
static double taxPercent = 0.02;
static double tax = 0.5;
static double totalCost = 5000.0;
static int amount=0;
  static Future<void> createPaymentMethodNative(BuildContext context) async {
  print('started NATIVE payment...');
  StripePayment.setStripeAccount(null);
  List<ApplePayItem> items = [];
  items.add(ApplePayItem(
    label: 'Demo Order',
    amount: (5000.0).toString(),
  ));
  
  if (tip != 0.0)
    items.add(ApplePayItem(
      label: 'Tip',
      amount: tip.toString(),
    ));
    
  if (taxPercent != 0.0) {
    //tax = ((totalCost * taxPercent) * 100).ceil() / 100;
    
    items.add(ApplePayItem(
      label: 'Tax',
      amount: tax.toString(),
    ));
  }
  items.add(ApplePayItem(
    label: 'Vendor A',
    amount: (totalCost + tip + tax).toString(),
  ));
  amount = ((totalCost + tip + tax) * 100).toInt();
  print('amount in pence/cent which will be charged = $amount');
  //step 1: add card
  PaymentMethod paymentMethod = PaymentMethod();
  Token token = await StripePayment.paymentRequestWithNativePay(
    androidPayOptions: AndroidPayPaymentRequest(
      totalPrice: (totalCost + tax + tip).toStringAsFixed(2),
      currencyCode: 'USD',

    ),
    applePayOptions: ApplePayPaymentOptions(
      countryCode: 'US',
      currencyCode: 'USD',
      items: items,
    ),
  );
  print('token.tokenId=>'+token.tokenId);
  paymentMethod = await StripePayment.createPaymentMethod(
    PaymentMethodRequest(
      card: CreditCard(
        token: token.tokenId,
      ),
    ),
  );
  paymentMethod != null
      ? processPaymentAsDirectCharge(paymentMethod,context)
      : showDialog(
          context: context,
          builder: (BuildContext context) => ShowDialogToDismiss(
              title: 'Error',
              content:
                  'It is not possible to pay with this card. Please try again with a different card',
              buttonText: 'CLOSE'));
}

static Future<void> createPaymentMethod(BuildContext context) async {
  StripePayment.setStripeAccount(null);
  tax = ((totalCost * taxPercent) * 100).ceil() / 100;
  amount = ((totalCost + tip + tax) * 100).toInt();
  print('amount in pence/cent which will be charged = $amount');
  //step 1: add card
  PaymentMethod paymentMethod = PaymentMethod();
  paymentMethod = await StripePayment.paymentRequestWithCardForm(
    CardFormPaymentRequest(),
  ).then((PaymentMethod paymentMethod) {
    print('paymentMethod=>'+paymentMethod.customerId);
    return paymentMethod;
  }).catchError((e) {
    print('Errore Card: ${e.toString()}');
  });
  print('PAYMENT METHOD');
  paymentMethod != null
      ? processPaymentAsDirectCharge(paymentMethod,context)
      : showDialog(
          context: context,
          builder: (BuildContext context) => ShowDialogToDismiss(
              title: 'Error',
              content:
                  'It is not possible to pay with this card. Please try again with a different card',
              buttonText: 'CLOSE'));
}
static String url ='https://us-central1-groceryapp-dev-cf506.cloudfunctions.net/stripePI';

static Future<void> processPaymentAsDirectCharge(PaymentMethod paymentMethod, BuildContext context) async {
    /*setState(() {
      showSpinner = true;
    });*/
    //step 2: request to create PaymentIntent, attempt to confirm the payment & return PaymentIntent
    final http.Response response = await http
        .post('$url?amount=$amount&currency=USD&paym=${paymentMethod.id}');
    print('Now i decode');
    if (response.body != null && response.body != 'error') {
      final paymentIntentX = jsonDecode(response.body);
      final status = paymentIntentX['paymentIntent']['status'];
      final strAccount = paymentIntentX['stripeAccount'];
      //step 3: check if payment was succesfully confirmed
      if (status == 'succeeded') {
        //payment was confirmed by the server without need for futher authentification
        StripePayment.completeNativePayRequest();
       // setState(() {
       //   text =
       //       'Payment completed. ${paymentIntentX['paymentIntent']['amount'].toString()}p succesfully charged';
         // showSpinner = false;
       // });
      } else {
        //step 4: there is a need to authenticate
        StripePayment.setStripeAccount(strAccount); 
        await StripePayment.confirmPaymentIntent(PaymentIntent(
                paymentMethodId: paymentIntentX['paymentIntent']
                    ['payment_method'],
                clientSecret: paymentIntentX['paymentIntent']['client_secret']))
            .then(
          (PaymentIntentResult paymentIntentResult) async {
            //This code will be executed if the authentication is successful
            //step 5: request the server to confirm the payment with
            final statusFinal = paymentIntentResult.status;
            if (statusFinal == 'succeeded') {
              StripePayment.completeNativePayRequest();
              //setState(() {
              //  showSpinner = false;
              //});
            } else if (statusFinal == 'processing') {
              StripePayment.cancelNativePayRequest();
             // setState(() {
             //   showSpinner = false;
             // });
              showDialog(
                  context: context,
                  builder: (BuildContext context) => ShowDialogToDismiss(
                      title: 'Warning',
                      content:
                          'The payment is still in \'processing\' state. This is unusual. Please contact us',
                      buttonText: 'CLOSE'));
            } else {
              StripePayment.cancelNativePayRequest();
              //setState(() {
               // showSpinner = false;
              //});
              showDialog(
                  context: context,
                  builder: (BuildContext context) => ShowDialogToDismiss(
                      title: 'Error',
                      content:
                          'There was an error to confirm the payment. Details: $statusFinal',
                      buttonText: 'CLOSE'));
            }
          },
          //If Authentication fails, a PlatformException will be raised which can be handled here
        ).catchError((e) {
          //case B1
          StripePayment.cancelNativePayRequest();
          //setState(() {
          //  showSpinner = false;
         // });
          showDialog(
              context: context,
              builder: (BuildContext context) => ShowDialogToDismiss(
                  title: 'Error',
                  content:
                      'There was an error to confirm the payment. Please try again with another card',
                  buttonText: 'CLOSE'));
        });
      }
    } else {
      //case A
     StripePayment.cancelNativePayRequest();
     // setState(() {
     //   showSpinner = false;
    //  });
      showDialog(
          context: context,
          builder: (BuildContext context) => ShowDialogToDismiss(
              title: 'Error',
              content:
                  'There was an error in creating the payment. Please try again with another card',
              buttonText: 'CLOSE'));
    }
  }



}
