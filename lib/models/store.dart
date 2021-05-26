class Store {
  String id;
  String ownerUid;
  String imageURL;
  String storeName;
  List<String> storeAddress;
  String storeDescription;
  List<String> carouselList;
  String email;
  String serviceMode;
  DateTime creationDate;
  String phone;
  List<String> likedUID;

  Store({
    this.id,
    this.ownerUid,
    this.imageURL,
    this.storeDescription,
    this.email,
    this.storeName,
    this.storeAddress,
    this.serviceMode,
    this.creationDate,
    this.phone,
    this.carouselList,
    this.likedUID,
  });

  factory Store.fromMap(Map<dynamic, dynamic> data) {
    data = data ?? {};
    return Store(
      ownerUid: data['ownerUid'],
      imageURL: data['imageURL'],
      storeDescription: data['storeDescription'],
      email: data['email'],
      carouselList: List<String>.from(data['carouselList']),
      serviceMode: data['serviceMode'],
      storeName: data['storeName'],
      likedUID: data['likedUID']!=null?List<String>.from(data['likedUID']):new List(),
      creationDate: data['creationDate'].toDate(),
      storeAddress: List<String>.from(data['storeAddress']),
      phone: data['phone'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonUser = new Map<String, dynamic>();
    jsonUser['ownerUid'] = this.ownerUid;
    jsonUser['imageURL'] = this.imageURL;
    jsonUser['email'] = this.email;
    jsonUser['storeDescription'] = this.storeDescription;
    jsonUser['storeName'] = this.storeName;
    jsonUser['carouselList'] = this.carouselList;
    jsonUser['storeAddress'] = this.storeAddress;
    jsonUser['creationDate'] = this.creationDate;
    jsonUser['likedUID'] = this.likedUID;
    jsonUser['serviceMode'] = this.serviceMode;
    jsonUser['phone'] = this.phone;
    return jsonUser;
  }
}
