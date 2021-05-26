import 'package:GroceriesApplication/models/user.dart';
import 'package:GroceriesApplication/services/app_auth_service.dart';
import 'package:GroceriesApplication/utility/data/grocery_data.dart';
import 'package:GroceriesApplication/widgets/account_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class OwnerSetting extends StatefulWidget {
  final User user;
  OwnerSetting({this.user});
  @override
  _OwnerSettingState createState() => _OwnerSettingState();
}

class _OwnerSettingState extends State<OwnerSetting> {
  AppAuthService _authService = AppAuthService();
  void _logout() {
    _authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.grey[200],
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            for (int i = 0; i < GroceryData.ownerSettingData.length; i++)
              _getListTile(GroceryData.ownerSettingData[i]['text'],
                  GroceryData.ownerSettingData[i]['images'], i, context),
            SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.white,
              child: GestureDetector(
                onTap: _logout,
                child: ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Colors.red,
                  ),
                  title: Text(
                    'Logout',
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getListTile(String label, IconData img, int i, BuildContext context) {
    return Container(
      color: Colors.white,
      child: GestureDetector(
        onTap: () {
          if (i == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => new AccountSetting(
                  user: widget.user,
                ),
              ),
            );
          } else if (i == 3) {
            /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => new FeedBackAndSuggession(uid:widget.uid),
              ),
            );*/
          }
        },
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(img),
              title: Text(
                label,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: "PoppinsMedium",
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                  letterSpacing: 0.6,
                  fontWeight: FontWeight.w400,
                ),
              ),
              trailing: _getTrailer(i),
            ),
            Divider(
              thickness: 3,
            )
          ],
        ),
      ),
    );
  }

  Widget _getTrailer(int i) {
    return Icon(Icons.arrow_right);
  }

  void _switchOnchange(bool val, String uid, int i) {}
}
