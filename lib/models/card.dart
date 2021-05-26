class PaymentCard {
  String id;
  String type;
  String last4;
  String expMonthYear;
  //String ownerName;
  String brand;

  PaymentCard({
    this.id,
    this.type,
    this.last4,
    this.expMonthYear,
    //this.ownerName,
    this.brand,
  });

  factory PaymentCard.fromMap(Map<String, dynamic> data) {
    data = data ?? {};
    return PaymentCard(
      type: data['card']['funding'],
      last4: data['card']['last4'],
      expMonthYear: data['card']['exp_month'].toString()+'/'+data['card']['exp_year'].toString(),
      //ownerName: data['ownerName'],
      brand: data['card']['brand'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonUser = new Map<String, dynamic>();
    jsonUser['type'] = this.type;
    jsonUser['last4'] = this.last4;
    jsonUser['expMonthYear'] = this.expMonthYear;
    //jsonUser['ownerName'] = this.ownerName;
    jsonUser['brand'] = this.brand;
    return jsonUser;
  }

  bool operator ==(dynamic other) =>
      other != null &&
      other is PaymentCard &&
      this.expMonthYear == other.expMonthYear;

  @override
  int get hashCode => super.hashCode;
}
