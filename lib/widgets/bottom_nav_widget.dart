import 'package:GroceriesApplication/styles/colors.dart';
import 'package:GroceriesApplication/utility/data/grocery_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BottomNavWidget extends StatefulWidget {
  final Function setViewForIndex;
  final int rootSelectedIndex;
  List<Map> bottomNavbarData;
  BottomNavWidget({
    this.setViewForIndex,
    this.rootSelectedIndex,
    this.bottomNavbarData,
  });
  @override
  _BottomNavWidgetState createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> {
  int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.rootSelectedIndex;
  }

  void _bottomItemTapped(int tappedIndex) {
    setState(() {
      _selectedIndex = tappedIndex;
    });
    widget.setViewForIndex(_selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).bottomAppBarColor,
      unselectedItemColor: Colors.grey,
      selectedItemColor: AppColor.LIGHT_ON_CARD_COLOR_SHADOW,
      currentIndex: widget.rootSelectedIndex,
      iconSize: 23.0,
      elevation: 10.0,
      onTap: (int index) {
        _bottomItemTapped(index);
      },
      type: BottomNavigationBarType.fixed,
      items: [
        for (var item in widget.bottomNavbarData)
          _buildBottomNavigationBarItem(item['icon'], item['text']),
      ],
    );
  }

  Widget _getIcon(IconData icon, bool isActive) {
    return Icon(icon);
    /*return Image.asset(
      path,
      cacheHeight: 25,
      cacheWidth: 30,
      color: isActive ? Theme.of(context).primaryColor : Colors.black54,
    );*/
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData iconData, String text) {
    return BottomNavigationBarItem(
      icon: _getIcon(iconData, false),
      activeIcon: _getIcon(iconData, true),
      title: Text(
        text,
        style: TextStyle(
          fontFamily: 'PoppinsSemiBold',
          fontSize: 12,
        ),
      ),
    );
  }
}
