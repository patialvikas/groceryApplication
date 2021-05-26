import 'package:GroceriesApplication/models/user.dart';
import 'package:GroceriesApplication/services/app_firestore_service.dart';
import 'package:GroceriesApplication/styles/styles.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class AppAuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future loginWithPhone(String phone, BuildContext context) async {
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (auth.AuthCredential authCredential) {
          _auth.signInWithCredential(authCredential).then((result) {
            print('success');
          }).catchError((err) {
            print('PHONE ERR ' + err.toString());
            return err.toString();
          });
        },
        verificationFailed: (auth.FirebaseAuthException exception) {
          return "error";
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          final _codeController = TextEditingController();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text('Enter Verification Code'),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  children: [
                    TextField(
                      controller: _codeController,
                    ),
                  ],
                ),
              ),
              actions: [
                Container(
                  margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
                  width: 275.0,
                  height: 49.0,
                  decoration: BoxDecoration(
                      color: green, borderRadius: BorderRadius.circular(23.0)),
                  child: RawMaterialButton(
                    onPressed: () async {
                      var _credential = auth.PhoneAuthProvider.credential(
                        verificationId: verificationId,
                        smsCode: _codeController.text.trim(),
                      );
                      _auth.signInWithCredential(_credential).then((result) {
                        //print('success ' + result.user.);
                        if (result.user.uid != null) {
                          AppFirestoreService _fireStoreData =
                              AppFirestoreService(uid: result.user.uid);
                          User user = new User(
                            phone: result.user.phoneNumber,
                          );
                          _fireStoreData
                              .addUser(
                            user: user,
                          )
                              .then((res) {
                            AlertDialog(
                              title: Text('Its ' + res.toString()),
                            );
                          }).catchError((err) {
                            AlertDialog(
                              title: Text('Its err ' + err.toString()),
                            );
                            return err.toString();
                          });
                        }
                      }).catchError((err) {
                        print('PHONE ERR ' + err.toString());
                        return err.toString();
                      });
                    },
                    child: Text(
                      'Submit',
                      style: hintStylewhitetextPSB(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print('VERY ' + verificationId);
        },
        timeout: Duration(seconds: 0));
  }

  

  Stream<auth.User> get user {
    return _auth.authStateChanges().map((event) {
      return event;
    });
  }

  Future registerUser({
    @required User user,
  }) async {
    try {
      AppFirestoreService _fireStoreData = AppFirestoreService(uid: null);
      final _isuserExits =
          await _fireStoreData.doesUserExists(email: user.email);
      if (_isuserExits == null) {
        print('USER DOES NOT EXIST');
        auth.User _user = (await _auth.createUserWithEmailAndPassword(
          email: user.email.trim(),
          password: user.password.trim(),
        ))
            .user;
        if (_user.uid != null) {
          _fireStoreData = AppFirestoreService(uid: _user.uid);
          await _fireStoreData.addUser(
            user: user,
          );
          await _user.sendEmailVerification();
        }
        return null;
      } else {
        return _isuserExits;
      }
    } catch (e) {
      String err = e.toString().substring(e.toString().lastIndexOf(']') + 1);
      return err;
    }
  }

  Future<String> loginWithEmailAndPassword({
    String email,
    String password,
  }) async {
    try {
      auth.User _user = (await _auth.signInWithEmailAndPassword(
              email: email.trim(), password: password.trim()))
          .user;

      if (_user.uid != null) {
        final AppFirestoreService _fireStoreData =
            AppFirestoreService(uid: _user.uid);
        //await _fireStoreData.currentUser(_user.uid, password.trim());
        return 'Success';
      }
      return "Unable to Sign-In";
    } on PlatformException catch (err) {
      return err.message;
    } catch (e) {
      String err = e.toString().substring(e.toString().lastIndexOf(']') + 1);
      return err.trim();
    }
  }

  Future<bool> forgotPassword({
    String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
