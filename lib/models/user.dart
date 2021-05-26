import 'package:GroceriesApplication/models/card.dart';

class User {
  String uid;
  String firstName;
  String lastName;
  String email;
  String password;
  String type;
  String phone;
  String token;
  List<PaymentCard> cardList;

  User({
    this.uid,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.type,
    this.phone,
    this.token,
    this.cardList,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    print('DATA=>' + data.toString());
    data = data ?? {};
    return User(
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      password: data['password'],
      type: data['type'],
      cardList: data['cardList'] != null
          ? List<PaymentCard>.from(
              data['cardList'].map((e) => PaymentCard.fromMap(e)).toList())
          : null,
      token: data['token'],
      phone: data['phone'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonUser = new Map<String, dynamic>();
    jsonUser['firstName'] = this.firstName.trim();
    jsonUser['lastName'] = this.lastName.trim();
    jsonUser['email'] = this.email.trim();
    jsonUser['password'] = this.password.trim();
    jsonUser['type'] = this.type;
    jsonUser['cardList'] = this.cardList!=null?this.cardList.toList():null;
    jsonUser['phone'] = this.phone;
    jsonUser['token'] = this.token;
    return jsonUser;
  }
}
