import 'package:GroceriesApplication/models/user.dart';
import 'package:GroceriesApplication/services/app_auth_service.dart';
import 'package:GroceriesApplication/styles/styles.dart';
import 'package:GroceriesApplication/widgets/dropdown_widget.dart';
import 'package:GroceriesApplication/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:international_phone_input/international_phone_input.dart';

class AuthenticationScreen extends StatefulWidget {
  final String popupType;
  AuthenticationScreen({Key key, this.popupType}) : super(key: key);
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool register = false;
  bool login = false;
  bool _value = false;
  bool _isLoading = false;
  bool _isResetError = false;
  bool _forwardToResetPassword = false;
  bool _forwardToPhoneLogin = false;
  bool _isSuccessMessage = false;
  String _successMessage = 'Email reset link has been sent to your mail.';

  bool _isLoadingError = false;
  bool _isLoadingRegisterError = false;
  String _errorMessage;
  String _errorRegisterMessage;
  String popupType;
  List<String> menuItems;
  TextEditingController _passwordController,
      _confirmPasswordController,
      _fNameController,
      _lNameController,
      _emailController,
      _phoneController;
  String _fName, _lName, _email, _password, _type, _phone;
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _registerKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _forgetPasswordKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _phoneKey = GlobalKey<FormState>();
  AppAuthService authService = AppAuthService();
  ScrollController _scrollController = new ScrollController();

  _scrollBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        MediaQuery.of(context).size.height * 0.15,
        //_scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  @override
  void initState() {
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _fNameController = TextEditingController();
    _lNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _fName = _lName = _email = _password = _type = _phone = null;
    popupType = widget.popupType;
    _initTypeMenu();
    _scrollBottom();
    super.initState();
  }

  void _initTypeMenu() {
    menuItems = new List();
    menuItems.add('Buying');
    menuItems.add('Selling');
  }

  Widget _getHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
        bottom: MediaQuery.of(context).size.height * 0.03,
      ),
      child: Text(
        'Grocery App, a complete place for the complete shopping',
        style: hintStylesmBlackboldPR(),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _getSwitch(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.01,
        bottom: MediaQuery.of(context).size.height * 0.030,
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
      ),
      alignment: Alignment.center,
      height: 45.0,
      decoration: BoxDecoration(
        color: Color(0xFF645DB3),
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 37.0,
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
                color: popupType == 'login' ? Colors.white : Color(0xFF645DB3),
                borderRadius: BorderRadius.circular(25.0)),
            child: RawMaterialButton(
              onPressed: () {
                setState(
                  () {
                    _forwardToResetPassword = false;
                    _forwardToPhoneLogin = false;
                    popupType = 'login';
                  },
                );
              },
              child: Text('Login',
                  style: popupType == 'login'
                      ? hintStylesmBlackmediumPR()
                      : hintStyleWhitemediumPR()),
            ),
          ),
          Container(
            height: 37.0,
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
                color: popupType == 'signup' ? Colors.white : Color(0xFF645DB3),
                borderRadius: BorderRadius.circular(25.0)),
            child: RawMaterialButton(
              onPressed: () {
                setState(
                  () {
                    _forwardToResetPassword = false;
                    _forwardToPhoneLogin = false;
                    popupType = 'signup';
                  },
                );
              },
              child: Text('Register',
                  style: popupType == 'signup'
                      ? hintStylesmBlackmediumPR()
                      : hintStyleWhitemediumPR()),
            ),
          ),
        ],
      ),
    );
  }

  void _onSaved(String value, String label) {
    if (label.isNotEmpty) {
      if (label == "FirstName") {
        _fName = value;
      } else if (label == "LastName") {
        _lName = value;
      } else if (label == "Email") {
        _email = value;
      } else if (label == "Password") {
        _password = value;
      } else if (label == "I am") {
        _type = value;
      } else if (label == "Phone") {
        _phone = value;
      }
    } else {
      // Should not be here
    }
  }

  @override
  void dispose() {
    _fNameController.dispose();
    _lNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String _fieldValidator(String value, String label) {
    if (value == null || value.isEmpty) {
      if (label == 'FirstName') {
        return "First Name is mandatory.";
      } else if (label == 'LastName') {
        return "Last Name is mandatory.";
      } else if (label == 'Email') {
        return "Email is mandatory.";
      } else if (label == 'Password') {
        return "Password is mandatory.";
      } else if (label == 'Confirm Password') {
        return "Confirm Password is mandatory.";
      } else if (label == 'I am') {
        return "Your role ia mandatory.";
      } else if (label == 'Phone') {
        return "Phonenumber ia mandatory.";
      }
    } else {
      if (label == 'Email') {
        bool emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value);
        if (!emailValid) {
          return 'The Email address is badly formatted';
        }
      } else if (label == 'Confirm Password') {
        if (_passwordController.text != _confirmPasswordController.text) {
          return "Confirm Password must be same as Password.";
        }
      } else if (label == 'Password') {
        if (_passwordController.text.length < 6) {
          return "Password should be at least 6 characters.";
        }
      }
    }
    return null;
  }

  Widget _getRegisterBlock(BuildContext context) {
    return Form(
      key: _registerKey,
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 0.0),
        margin: EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(
          color: Color(0xFFF7F7F7),
          borderRadius: new BorderRadius.only(
            topRight: const Radius.circular(33.0),
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                TextWidget(
                  hintText: 'First Name',
                  suffixIconPath: 'assets/icons/phone.png',
                  obscureText: false,
                  onSaved: (String value) {
                    _onSaved(value, 'FirstName');
                  },
                  validator: (String value) {
                    return _fieldValidator(value, 'FirstName');
                  },
                  controller: _fNameController,
                ),
                TextWidget(
                  hintText: 'Last Name',
                  suffixIconPath: 'assets/icons/phone.png',
                  obscureText: false,
                  onSaved: (String value) {
                    _onSaved(value, 'LastName');
                  },
                  validator: (String value) {
                    return _fieldValidator(value, 'LastName');
                  },
                  controller: _lNameController,
                ),
                TextWidget(
                  hintText: 'Email',
                  suffixIconPath: 'assets/icons/phone.png',
                  obscureText: false,
                  onSaved: (String value) {
                    _onSaved(value, 'Email');
                  },
                  validator: (String value) {
                    return _fieldValidator(value, 'Email');
                  },
                  controller: _emailController,
                ),
                TextWidget(
                  hintText: 'Password',
                  suffixIconPath: 'assets/icons/password.png',
                  obscureText: true,
                  onSaved: (String value) {
                    _onSaved(value, 'Password');
                  },
                  validator: (String value) {
                    return _fieldValidator(value, 'Password');
                  },
                  controller: _passwordController,
                ),
                TextWidget(
                  hintText: 'Confirm Password',
                  suffixIconPath: 'assets/icons/password.png',
                  obscureText: true,
                  onSaved: (String value) {
                    _onSaved(value, 'Confirm Password');
                  },
                  validator: (String value) {
                    return _fieldValidator(value, 'Confirm Password');
                  },
                  controller: _confirmPasswordController,
                ),
                DropdownWidget(
                  menuItem: menuItems,
                  onSaved: (String value) {
                    _onSaved(value, 'I am');
                  },
                  onValidate: (String value) {
                    return _fieldValidator(value, 'I am');
                  },
                  onChanged: (String v) {
                    setState(() {
                      _type = v;
                    });
                  },
                  selectedMenu: _type,
                  hint: 'I am...',
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.15,
                      right: MediaQuery.of(context).size.width * 0.15),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: _isLoadingRegisterError
                            ? Container(
                                margin: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.15,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Text(
                                    _errorRegisterMessage,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30.0, bottom: 20.0),
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 49.0,
                  decoration: BoxDecoration(
                      color: green, borderRadius: BorderRadius.circular(23.0)),
                  child: RawMaterialButton(
                    onPressed: () => _proceed(false),
                    child: Text(
                      'REGISTER ',
                      style: hintStylewhitetextPSB(),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.15,
                    right: MediaQuery.of(context).size.width * 0.15,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Our ',
                                  style: hintStylesmBlackamediumPR()),
                              TextSpan(
                                  text: 'Privacy policy,',
                                  style: hintStylesmallbluePR()),
                              TextSpan(
                                  text: ' and the ',
                                  style: hintStylesmBlackamediumPR()),
                              TextSpan(
                                  text: 'Terms & Conditions.',
                                  style: hintStylesmallbluePR()),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _isLoading
                ? Positioned(
                    top: 150,
                    left: MediaQuery.of(context).size.width * 0.5,
                    child: CircularProgressIndicator(),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _getLoginBlock(BuildContext context) {
    return Form(
      key: _loginKey,
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 20.0),
        margin: EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(
          //color: Color(0xFFF7F7F7),
          //color: Colors.amber,
          borderRadius:
              new BorderRadius.only(topRight: const Radius.circular(33.0)),
        ),
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                TextWidget(
                  hintText: 'Email',
                  suffixIconPath: 'assets/icons/phone.png',
                  obscureText: false,
                  onSaved: (String value) {
                    _onSaved(value, 'Email');
                  },
                  validator: (String value) {
                    return _fieldValidator(value, 'Email');
                  },
                  controller: _emailController,
                ),
                TextWidget(
                  hintText: 'Password',
                  suffixIconPath: 'assets/icons/password.png',
                  obscureText: true,
                  onSaved: (String value) {
                    _onSaved(value, 'Password');
                  },
                  validator: (String value) {
                    return _fieldValidator(value, 'Password');
                  },
                  controller: _passwordController,
                ),
                Padding(
                  // padding: EdgeInsets.all(0),
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.15,
                      right: MediaQuery.of(context).size.width * 0.15),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: _isLoadingError
                            ? Container(
                                margin: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.15,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Text(
                                    _errorMessage,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
                  width: 275.0,
                  height: 49.0,
                  decoration: BoxDecoration(
                      color: green, borderRadius: BorderRadius.circular(23.0)),
                  child: RawMaterialButton(
                    onPressed: () => _proceed(true),
                    child: Text(
                      'LOGIN ',
                      style: hintStylewhitetextPSB(),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
                  width: 275.0,
                  height: 49.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _forwardToResetPassword = true;
                          });
                        },
                        child: Text(
                          'Forgot Password',
                          style: hintStylesmallbluePR(),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _forwardToPhoneLogin = true;
                          });
                        },
                        child: Text(
                          'Login with phone number',
                          style: hintStylesmallbluePR(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _isLoading
                ? Positioned(
                    top: 50,
                    left: MediaQuery.of(context).size.width * 0.5,
                    child: CircularProgressIndicator(),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _getForgotPassword(BuildContext context) {
    return Form(
      key: _forgetPasswordKey,
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 20.0),
        margin: EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(
          color: Color(0xFFF7F7F7),
          borderRadius:
              new BorderRadius.only(topRight: const Radius.circular(33.0)),
        ),
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                TextWidget(
                  hintText: 'Registered Email',
                  suffixIconPath: 'assets/icons/phone.png',
                  obscureText: false,
                  onSaved: (String value) {
                    _onSaved(value, 'Email');
                  },
                  validator: (String value) {
                    return _fieldValidator(value, 'Email');
                  },
                  controller: _emailController,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.15,
                      right: MediaQuery.of(context).size.width * 0.15),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: _isSuccessMessage
                            ? Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  _successMessage,
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.15,
                    right: MediaQuery.of(context).size.width * 0.15,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: _isResetError
                            ? Text(
                                _errorMessage,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              )
                            : SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
                  width: 275.0,
                  height: 49.0,
                  decoration: BoxDecoration(
                      color: green, borderRadius: BorderRadius.circular(23.0)),
                  child: RawMaterialButton(
                    onPressed: () => _proceed(true),
                    child: Text(
                      'Reset Password',
                      style: hintStylewhitetextPSB(),
                    ),
                  ),
                ),
                Text(
                  'OR',
                  style: hintStylesmBlackbPR(),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _forwardToPhoneLogin = true;
                      _forwardToResetPassword = false;
                    });
                  },
                  child: Text(
                    'Login with phone number',
                    style: hintStylesmallbluePR(),
                  ),
                ),
              ],
            ),
            _isLoading
                ? Positioned(
                    top: 50,
                    left: MediaQuery.of(context).size.width * 0.5,
                    child: CircularProgressIndicator(),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  String phoneNumber;
  String phoneIsoCode;

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      _phone = internationalizedPhoneNumber;
      print(_phone);
    });
  }

  Widget _getPhoneSignIn(BuildContext context) {
    return Form(
      key: _phoneKey,
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 20.0),
        margin: EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(
          color: Color(0xFFF7F7F7),
          borderRadius:
              new BorderRadius.only(topRight: const Radius.circular(33.0)),
        ),
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    left: 0,
                    right: 0,
                  ),
                  child: DropdownWidget(
                    menuItem: menuItems,
                    onSaved: (String value) {
                      _onSaved(value, 'I am');
                    },
                    onValidate: (String value) {
                      return _fieldValidator(value, 'I am');
                    },
                    onChanged: (String v) {
                      setState(() {
                        _type = v;
                      });
                    },
                    selectedMenu: _type,
                    hint: 'I am...',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.15,
                    right: MediaQuery.of(context).size.width * 0.15,
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: InternationalPhoneInput(
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            labelStyle: hintStylesmBlackbPR(),
                            alignLabelWithHint: true,
                            fillColor: Colors.grey[200],
                            filled: true,
                            isDense: true,
                            hintStyle: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.w100),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 12.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Color(0xFF707070).withOpacity(0.29),
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                          onPhoneNumberChange: onPhoneNumberChange,
                          initialPhoneNumber: _phone,
                          initialSelection: 'US',
                          //enabledCountries: ['+233', '+1'],
                          showCountryCodes: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.15,
                      right: MediaQuery.of(context).size.width * 0.15),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: _isSuccessMessage
                            ? Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  _successMessage,
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.15,
                    right: MediaQuery.of(context).size.width * 0.15,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: _isResetError
                            ? Text(
                                _errorMessage,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              )
                            : SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
                  width: 275.0,
                  height: 49.0,
                  decoration: BoxDecoration(
                      color: green, borderRadius: BorderRadius.circular(23.0)),
                  child: RawMaterialButton(
                    onPressed: () => _proceed(true),
                    child: Text(
                      'Login with Phone',
                      style: hintStylewhitetextPSB(),
                    ),
                  ),
                ),
              ],
            ),
            _isLoading
                ? Positioned(
                    top: 50,
                    left: MediaQuery.of(context).size.width * 0.5,
                    child: CircularProgressIndicator(),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  void _proceed(bool isLogin) async {
    if (_forwardToResetPassword) {
      setState(() {
        _isResetError = false;
      });
    }

    GlobalKey<FormState> key = isLogin
        ? _forwardToResetPassword
            ? _forgetPasswordKey
            : _forwardToPhoneLogin ? _phoneKey : _loginKey
        : _registerKey;

    if (!key.currentState.validate()) {
      return;
    }

    key.currentState.save();
    setState(() {
      _isLoading = true;
    });

    //try {
    if (isLogin) {
      String email = _emailController.text;
      print('email ' + email);
      if (!_forwardToResetPassword && !_forwardToPhoneLogin) {
        final response = await authService.loginWithEmailAndPassword(
            email: _email, password: _password);
        //print('response ' + response.toString());
        if (response != 'Success') {
          setState(
            () {
              setState(() {
                _isLoading = false;
              });
              _errorMessage = response;
              _isLoadingError = true;
            },
          );
        }
      } else if (_forwardToResetPassword) {
        try {
          await authService.resetPassword(_email);
          setState(() {
            _isSuccessMessage = true;
            _successMessage =
                'A password reset link has been sent to your mail id.';
          });
          setState(() {
            _isLoading = false;
          });
        } catch (e) {
          print('EEEE ' + e.toString());
          setState(() {
            _isResetError = true;
            _isLoading = false;
          });
          if (e.toString().length > 0) {
            setState(() {
              _errorMessage = e
                  .toString()
                  .substring(e.toString().lastIndexOf(']') + 1)
                  .trim();
            });
          } else {
            setState(() {
              _errorMessage = 'Unknown error, Please contact admin';
            });
          }
        }
      } else if (_forwardToPhoneLogin) {
        try {
          await authService.loginWithPhone(_phone, context);

          setState(() {
            _isLoading = false;
          });
        } catch (e) {
          setState(() {
            _isResetError = true;
            _isLoading = false;
          });
          if (e.toString().length > 0) {
            setState(() {
              _errorMessage = e
                  .toString()
                  .substring(e.toString().lastIndexOf(']') + 1)
                  .trim();
            });
          } else {
            setState(() {
              _errorMessage = 'Unknown error, Please contact admin';
            });
          }
        }
      }
    } else {
      print('TYTPE '+_type);
      User user = User(
        firstName: _fName,
        lastName: _lName,
        email: _email,
        password: _password,
        type: _type,
      );
      final registerResponse = await authService.registerUser(
        user: user,
      );
      if (registerResponse != null) {
        setState(
          () {
            setState(() {
              _isLoading = false;
            });
            _errorRegisterMessage = registerResponse.toString() == 'true'
                ? 'User already exists.'
                : registerResponse.toString();
            _isLoadingRegisterError = true;
          },
        );
      }
      //print('registerResponse ' + registerResponse.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          controller: _scrollController,
          child: Container(
            padding: EdgeInsets.only(
              top: screenHeight * 0.17,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      _getHeader(context),
                      _getSwitch(context),
                    ],
                  ),
                ),
                Stack(
                  children: <Widget>[
                    Container(
                        child: popupType == 'signup'
                            ? _getRegisterBlock(context)
                            : _forwardToResetPassword
                                ? _getForgotPassword(context)
                                : _forwardToPhoneLogin
                                    ? _getPhoneSignIn(context)
                                    : _getLoginBlock(context)),
                    Positioned(
                      bottom: 0.0,
                      child: Container(
                        margin: EdgeInsets.only(
                            bottom: 10.0, left: 110.0, right: 110.0),
                        height: 4.0,
                        width: 130.0,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(25.0)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
