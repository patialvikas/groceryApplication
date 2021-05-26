import 'package:GroceriesApplication/models/product.dart';
import 'package:flutter/material.dart';

class GroceryData {
  static const List<Map> bottomAppBarItem = [
    {
      "text": "Home",
      "icon": Icons.home,
    },
    {
      "text": "Add Store",
      "icon": Icons.add_circle_outline,
    },
    {
      "text": "Add Product",
      "icon": Icons.add_shopping_cart,
    },
    {
      "text": "Orders",
      "icon": Icons.attach_money,
    },
    {
      "text": "Settings",
      "icon": Icons.settings,
    },
  ];

  static const List<Map> bottomAppBarStoreItem = [
    {
      "text": "Shop",
      "icon": Icons.shopping_basket,
    },
    {
      "text": "Cart",
      "icon": Icons.shopping_cart,
    },
    {
      "text": "History",
      "icon": Icons.history,
    },
    {
      "text": "Help",
      "icon": Icons.help,
    }
  ];

  static const List<Map> bottomAppBarItemForUser = [
    {
      "text": "Stores",
      "icon": Icons.store,
    },
    {
      "text": "Carts",
      "icon": Icons.shopping_cart,
    },
    {
      "text": "Orders",
      "icon": Icons.local_offer,
    },
    {
      "text": "Settings",
      "icon": Icons.settings,
    },
  ];

  static const List<String> imgList = [
    'https://images.unsplash.com/photo-1542838132-92c53300491e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
    'https://techcrunch.com/wp-content/uploads/2015/03/groceries-e1554037962210.jpg',
    'https://api.time.com/wp-content/uploads/2020/03/grocery-store-safety-coronavirus.jpg?quality=85&w=1024&h=628&crop=1',
    'https://intermountainhealthcare.org/-/media/images/modules/blog/posts/2018/04/grocery-aisle.jpg?la=en&h=463&w=896&mw=896&hash=1EF7FADBA82984D0BF978FD397BA09CE9D62E3C0',
    'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/grocery-shop-safely-1585329663.jpg',
    'https://www.morrisons-corporate.com/contentassets/0674f7464642488eb656a814b6757eee/morrisons-deliveroo-partnership.jpg'
  ];

  static const List<Map> ownerSettingData = [
    {
      "text": "Profile",
      "images": Icons.account_circle,
    },
    {
      "text": "Account",
      "images": Icons.account_balance,
    },
    {
      "text": "Terms and Conditions",
      "images": Icons.work,
    },
    {
      "text": "Feedback",
      "images": Icons.feedback,
    }
  ];

  static const List<Map> productList = [
    {
      "productName": "Onion",
      "productDescription": '',
      "productImageUrl":
          'https://rukminim1.flixcart.com/image/352/352/plant-seed/6/m/x/real-seed-650-onion-nasik-red-hybrid-original-imaedwbtxgf59ff2.jpeg?q=70',
    },
    {
      "productName": "Potato",
      "productDescription": '',
      "productImageUrl":
          'https://rukminim1.flixcart.com/image/352/352/jtsz3bk0/vegetable/b/8/4/2-potato-un-branded-no-whole-original-imafdsymh2aepaph.jpeg?q=70',
    },
    {
      "productName": "Mustard Oil",
      "productDescription": '',
      "productImageUrl":
          'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSJdzj_moeGGWftC627vXiOEb7xF_WU4WYiRg&usqp=CAU',
    },
    {
      "productName": "Sanitizer",
      "productDescription": '',
      "productImageUrl":
          'https://post.healthline.com/wp-content/uploads/2020/05/Babyganics-Alcohol-Free-Foaming-Hand-Sanitizer_Thumbnail-732x549.jpg',
    },
    {
      "productName": "Onion",
      "productDescription": '',
      "productImageUrl":
          'https://rukminim1.flixcart.com/image/352/352/plant-seed/6/m/x/real-seed-650-onion-nasik-red-hybrid-original-imaedwbtxgf59ff2.jpeg?q=70',
    },
    {
      "productName": "Potato",
      "productDescription": '',
      "productImageUrl":
          'https://rukminim1.flixcart.com/image/352/352/jtsz3bk0/vegetable/b/8/4/2-potato-un-branded-no-whole-original-imafdsymh2aepaph.jpeg?q=70',
    },
    {
      "productName": "Mustard Oil",
      "productDescription": '',
      "productImageUrl":
          'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSJdzj_moeGGWftC627vXiOEb7xF_WU4WYiRg&usqp=CAU',
    },
    {
      "productName": "Sanitizer",
      "productDescription": '',
      "productImageUrl":
          'https://post.healthline.com/wp-content/uploads/2020/05/Babyganics-Alcohol-Free-Foaming-Hand-Sanitizer_Thumbnail-732x549.jpg',
    }
  ];

  static Map<Product, double> _itemList = _getItems();

  static Map<Product, double> _getItems(){
    _itemList = new Map();
    _itemList.putIfAbsent(new Product(
      productName: 'Onion',
      productDescription: 'ffff',
      productImageUrl: ['https://rukminim1.flixcart.com/image/352/352/plant-seed/6/m/x/real-seed-650-onion-nasik-red-hybrid-original-imaedwbtxgf59ff2.jpeg?q=70'],
  
    ), () => 3.5);
    _itemList.putIfAbsent(new Product(
      productName: 'Potato',
      productDescription: 'ffff',
      productImageUrl: ['https://rukminim1.flixcart.com/image/352/352/jtsz3bk0/vegetable/b/8/4/2-potato-un-branded-no-whole-original-imafdsymh2aepaph.jpeg?q=70'],
  
    ), () => 5.5);

  }

  static const List<Map> homeDashboardData = [
    {
      "count": "18",
      "label": 'Store(s)',
      "backgroundColor": Color.fromRGBO(255, 230, 215, 1),
      "textColor": Colors.deepOrange,
    },
    {
      "count": "15",
      "label": 'Active\nProduct(s)',
      "backgroundColor": Color.fromRGBO(203, 238, 238, 1),
      "textColor": Colors.blue,
    },
    {
      "count": "03",
      "label": 'Blocked\nProduct(s)',
      "backgroundColor": Color.fromRGBO(246, 206, 206, 1),
      "textColor": Colors.red,
    },
  ];

  static List<Map> activeCart = [
    {
      "orderOriginatorName": 'Gupta\'s store',
      "orderOriginatorAddress": '89\$ for 16 item(s)',
      "totalPrice":'89.15',
      "status":'In-progress',
      "expectedDeliveryDate":DateTime.now(),
      "orderList":_itemList,
    },
    {
      "orderOriginatorName": 'Morrison Market',
      "orderOriginatorAddress": '30\$ for 3 item(s)',
      "totalPrice":'89.15',
      "status":'In-progress',
      "expectedDeliveryDate":DateTime.now(),
      "orderList":_itemList,
    },
  ];

   String id;
  String ownerUid;
  String imageURL;
  String storeName;
  String storeAddress;
  String email;
  String phone;

  static List<Map> storeParentList = [
    {
      "ownerUid": 'Vyxjhbjhbdbfcehbhebhber',
      "imageURL": 'https://image.shutterstock.com/image-photo/charleston-south-carolina-usa-february-260nw-1667464183.jpg',
      "storeName":'Publix',
      "storeAddress":'37 Hilltop Dr, Dallas, Pennsylvania(PA), 18612',
      "email":'publix@yopmail.com',
      "phone":'(610) 681-2734',
    },
    {
      "ownerUid": 'Vyxjhbjhbdbfcehbhebhber',
      "imageURL": 'https://image.shutterstock.com/image-photo/fort-lauderdale-flausa-april-13-260nw-627010022.jpg',
      "storeName":'Winni Dixie',
      "storeAddress":'Rr 2 Dallas, Pennsylvania(PA), 18612',
      "email":'dixie@yopmail.com',
      "phone":'(610) 681-2734',
    },
    {
      "ownerUid": 'Vyxjhbjhbdbfcehbhebhber',
      "imageURL": 'https://image.shutterstock.com/image-photo/madrid-spain-october-25-2015-260nw-385477516.jpg',
      "storeName":'Morrison',
      "storeAddress":'37 Hilltop Dr, Dallas, Pennsylvania(PA), 18612',
      "email":'publix@yopmail.com',
      "phone":'(610) 681-2734',
    },
    {
      "ownerUid": 'Vyxjhbjhbdbfcehbhebhber',
      "imageURL": 'https://image.shutterstock.com/image-photo/charleston-south-carolina-usa-february-260nw-1667464183.jpg',
      "storeName":'Holy Mart',
      "storeAddress":'37 Hilltop Dr, Dallas, Pennsylvania(PA), 18612',
      "email":'publix@yopmail.com',
      "phone":'(610) 681-2734',
    },
    {
      "ownerUid": 'Vyxjhbjhbdbfcehbhebhber',
      "imageURL": 'https://image.shutterstock.com/image-photo/charleston-south-carolina-usa-february-260nw-1667464183.jpg',
      "storeName":'Gupta\'s Store',
      "storeAddress":'37 Hilltop Dr, Dallas, Pennsylvania(PA), 18612',
      "email":'publix@yopmail.com',
      "phone":'(610) 681-2734',
    },
  ];

  
  static List<Map> customerOrderList = [
    {
      "orderOriginatorName": 'Publix',
      "orderOriginatorAddress": '88\$   In-progress',
      "totalPrice":'89.15',
      "status":'In-progress',
      "expectedDeliveryDate":DateTime.now(),
      "orderList":_itemList,
    },
    {
      "orderOriginatorName": 'Gupta\'s Store',
      "orderOriginatorAddress": '18\$  Completed',
      "totalPrice":'89.15',
      "status":'In-progress',
      "expectedDeliveryDate":DateTime.now(),
      "orderList":_itemList,
    },
    {
      "orderOriginatorName": 'Winne Store',
      "orderOriginatorAddress": '1\$ Rejected',
      "totalPrice":'89.15',
      "status":'In-progress',
      "expectedDeliveryDate":DateTime.now(),
      "orderList":_itemList,
    },
  ];
  

  static List<Map> orderList = [
    {
      "orderOriginatorName": 'Mr. Worrison',
      "orderOriginatorAddress": '32 Rue avenue, Dallas-40007',
      "totalPrice":'89.15',
      "status":'In-progress',
      "expectedDeliveryDate":DateTime.now(),
      "orderList":_itemList,
    },
    {
      "orderOriginatorName": 'Mrs. Boris',
      "orderOriginatorAddress": '32 Rue avenue, Dallas-40007',
      "totalPrice":'89.15',
      "status":'In-progress',
      "expectedDeliveryDate":DateTime.now(),
      "orderList":_itemList,
    },
    {
      "orderOriginatorName": 'Ms. Karla',
      "orderOriginatorAddress": '32 Rue avenue, Dallas-40007',
      "totalPrice":'89.15',
      "status":'In-progress',
      "expectedDeliveryDate":DateTime.now(),
      "orderList":_itemList,
    },
    {
      "orderOriginatorName": 'Mr. Sunder',
      "orderOriginatorAddress": '32 Rue avenue, Dallas-40007',
      "totalPrice":'89.15',
      "status":'In-progress',
      "expectedDeliveryDate":DateTime.now(),
      "orderList":_itemList,
    },
    {
      "orderOriginatorName": 'Mr. Ronald',
      "orderOriginatorAddress": '32 Rue avenue, Dallas-40007',
      "totalPrice":'89.15',
      "status":'In-progress',
      "expectedDeliveryDate":DateTime.now(),
      "orderList":_itemList,
    },
    {
      "orderOriginatorName": 'Mrs. Parker',
      "orderOriginatorAddress": '32 Rue avenue, Dallas-40007',
      "totalPrice":'89.15',
      "status":'In-progress',
      "expectedDeliveryDate":DateTime.now(),
      "orderList":_itemList,
    },
    {
      "orderOriginatorName": 'Ms. Suzzy',
      "orderOriginatorAddress": '32 Rue avenue, Dallas-40007',
      "totalPrice":'89.15',
      "status":'In-progress',
      "expectedDeliveryDate":DateTime.now(),
      "orderList":_itemList,
    },
    {
      "orderOriginatorName": 'Mr. Mukherjee',
      "orderOriginatorAddress": '32 Rue avenue, Dallas-40007',
      "totalPrice":'89.15',
      "status":'In-progress',
      "expectedDeliveryDate":DateTime.now(),
      "orderList":_itemList,
    },
    {
      "orderOriginatorName": 'Mr. Rosemerry',
      "orderOriginatorAddress": '32 Rue avenue, Dallas-40007',
      "totalPrice":'89.15',
      "status":'In-progress',
      "expectedDeliveryDate":DateTime.now(),
      "orderList":_itemList,
    },
  ];




  static List<Map> historyList = [
    {
      "orderOriginatorName": 'Order ID : 1717171717171717171XXXX',
      "orderOriginatorAddress": 'USD 51.34   3rd Aug 2020',
      "totalPrice":'89.15',
      "status":'In-progress',
      "expectedDeliveryDate":DateTime.now(),
      "orderList":_itemList,
    },
    {
      "orderOriginatorName": 'Order ID : 171ERT1717171717171XXXX',
      "orderOriginatorAddress": 'USD 51.34   3rd Aug 2020',
      "totalPrice":'89.15',
      "status":'In-progress',
      "expectedDeliveryDate":DateTime.now(),
      "orderList":_itemList,
    },
  ];
}
