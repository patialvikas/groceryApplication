import 'package:GroceriesApplication/models/user.dart';
import 'package:GroceriesApplication/services/cloudFirestore/app_store_service.dart';
import 'package:GroceriesApplication/utility/route/app_slide_right_route.dart';
import 'package:GroceriesApplication/widgets/app_button.dart';
import 'package:GroceriesApplication/widgets/grocery_webview.dart';
import 'package:GroceriesApplication/widgets/input_field_title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';

class AccountSetting extends StatefulWidget {
  AccountSetting({this.user});

  final User user;

  @override
  _AccountSettingState createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _flag = false;

  @override
  Widget build(BuildContext context) {
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Setting'),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        child: StreamBuilder(
          stream: cloudStoreService.getAccountLink(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            DocumentSnapshot ds = snapshot.data;
            Map<String, dynamic> documentMap = ds.data();
            if (_flag) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (documentMap != null) {
              return _getAccountSettingBody(context, documentMap);
            } else {
              return Center(
                child: AppButton(
                  label: 'Create Stripe Account',
                  onPressed: () async {
                    setState(() {
                      _flag = true;
                    });

                    await cloudStoreService.updateSellerAccount();
                    setState(() {
                      _flag = false;
                    });
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _openAccountLink(String url) {
    AppSlideRightRoute(
      page: GroceryWebview(
        url: url,
      ),
    );
  }

  Widget _getAccountSettingBody(
      BuildContext context, Map<String, dynamic> documentMap) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stripe Acc Id : ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                documentMap['id'].toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                  fontFamily: 'PoppinsMedium',
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Business Name : ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                documentMap['business_profile']['name'].toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                  fontFamily: 'PoppinsMedium',
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Business Type : ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                documentMap['business_type'].toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                  fontFamily: 'PoppinsMedium',
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          InputFieldTitle(
            text: 'Business Address',
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Address: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              documentMap != null
                  ? documentMap['business_profile'] != null
                      ? documentMap['business_profile']['support_address'] !=
                              null
                          ? Text(
                              documentMap['business_profile']['support_address']
                                          ['line1']
                                      .toString() +
                                  '\n' +
                                  documentMap['business_profile']
                                          ['support_address']['city']
                                      .toString() +
                                  ', ' +
                                  documentMap['business_profile']
                                          ['support_address']['state']
                                      .toString() +
                                  ', ' +
                                  documentMap['business_profile']
                                          ['support_address']['country']
                                      .toString() +
                                  '\n' +
                                  'Pincode : ' +
                                  documentMap['business_profile']
                                          ['support_address']['postal_code']
                                      .toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                                fontFamily: 'PoppinsMedium',
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              'N/A',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                                fontFamily: 'PoppinsMedium',
                                color: Colors.black,
                              ),
                            )
                      : Text(
                          'N/A',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                            fontFamily: 'PoppinsMedium',
                            color: Colors.black,
                          ),
                        )
                  : Text(
                      'N/A',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                        fontFamily: 'PoppinsMedium',
                        color: Colors.black,
                      ),
                    ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Account Type : ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                documentMap['type'].toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                  fontFamily: 'PoppinsMedium',
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          InputFieldTitle(
            text: 'Capabilities',
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'bancontact_payments : ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                documentMap['capabilities']['bancontact_payments'] != null
                    ? documentMap['capabilities']['bancontact_payments']
                        .toString()
                    : 'False',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                  fontFamily: 'PoppinsMedium',
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'card_payments : ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                documentMap['capabilities']['card_payments'] != null
                    ? documentMap['capabilities']['card_payments'].toString()
                    : 'False',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                  fontFamily: 'PoppinsMedium',
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'eps_payments : ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                documentMap['capabilities']['eps_payments'] != null
                    ? documentMap['capabilities']['eps_payments'].toString()
                    : 'False',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                  fontFamily: 'PoppinsMedium',
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'giropay_payments : ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                documentMap['capabilities']['giropay_payments'] != null
                    ? documentMap['capabilities']['giropay_payments'].toString()
                    : 'False',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                  fontFamily: 'PoppinsMedium',
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ideal_payments : ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                documentMap['capabilities']['ideal_payments'] != null
                    ? documentMap['capabilities']['ideal_payments'].toString()
                    : 'False',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                  fontFamily: 'PoppinsMedium',
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'p24_payments : ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                documentMap['capabilities']['p24_payments'] != null
                    ? documentMap['capabilities']['p24_payments'].toString()
                    : 'False',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                  fontFamily: 'PoppinsMedium',
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          InputFieldTitle(
            text: 'Validity',
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enabled ? ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                documentMap['requirements']['disabled_reason'] != null
                    ? 'No'
                    : 'Yes',
                style: TextStyle(
                  color:
                      (documentMap['requirements']['disabled_reason'] != null)
                          ? Colors.red
                          : Colors.green,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                  fontFamily: 'PoppinsMedium',
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Acc linking : ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: documentMap['account_link_url'] == null
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : documentMap['requirements']['disabled_reason'] != null
                            ? GestureDetector(
                                onTap: () {
                                  print('dfjgvdf');
                                  Navigator.push(
                                    context,
                                    AppSlideRightRoute(
                                      page: GroceryWebview(
                                        url: documentMap['account_link_url']
                                            .toString(),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Click herle to Link it',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                    fontFamily: 'PoppinsMedium',
                                  ),
                                ),
                              )
                            : Text(
                                'Account is Linked',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.0,
                                  fontFamily: 'PoppinsMedium',
                                ),
                              ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
