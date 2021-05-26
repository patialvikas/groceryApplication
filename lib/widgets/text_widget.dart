import 'package:GroceriesApplication/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TextWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function validator;
  final Function onSaved;
  final String hintText;
  final String suffixIconPath;
  final bool obscureText;
  TextWidget({
    this.controller,
    this.validator,
    this.onSaved,
    this.hintText,
    this.suffixIconPath,
    this.obscureText,
  });
  @override
  _TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  bool _isVisible;
  @override
  void initState() {
    _isVisible = widget.obscureText;
    super.initState();
  }

  IconData _getIconData() {
    String label = widget.hintText;
    switch (label) {
      case 'First Name':
        return Icons.person;
        break;
      case 'Last Name':
        return Icons.person;
        break;
      case 'Email':
        return Icons.email;
        break;
      case 'Store Email ID':
        return Icons.email;
        break;
      case 'Registered Email':
        return Icons.email;
        break;
      case 'Password':
        if (_isVisible) {
          return FontAwesomeIcons.eyeSlash;
        } else if (!_isVisible) {
          return Icons.remove_red_eye;
        }

        break;
      case 'Confirm Password':
        if (_isVisible) {
          return FontAwesomeIcons.eyeSlash;
        } else if (!_isVisible) {
          return Icons.remove_red_eye;
        }
        break;
      case 'I am':
        return Icons.remove_red_eye;
        break;
      case 'Phone':
        return Icons.phone;
        break;
      case 'Store Phone number':
        return Icons.phone;
        break;
      case 'Store name':
        return Icons.store;
        break;
      case 'Street Address':
        return FontAwesomeIcons.addressCard;
        break;
      default:
        return Icons.local_grocery_store;
    }
  }

  _getObscurePassword() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      margin: EdgeInsets.only(top: 15.0),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        onSaved: widget.onSaved,
        decoration: InputDecoration(
          labelText: widget.hintText,
          labelStyle: hintStylesmBlackbPR(),
          alignLabelWithHint: true,
          fillColor: Colors.grey[200],
          filled: true,
          isDense: true,
          //suffixIcon: Image.asset(widget.suffixIconPath),
          suffixIcon: GestureDetector(
            child: Icon(
              _getIconData(),
              color: Colors.grey[500],
            ),
            onTap: () {
              if (widget.hintText.toLowerCase().contains('password')) {
                _getObscurePassword();
              }
            },
          ),

          hintStyle:
              TextStyle(color: Colors.black45, fontWeight: FontWeight.w100),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 12.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Color(0xFF707070).withOpacity(0.29),
              style: BorderStyle.none,
            ),
          ),
        ),
        style: hintStylesmBlackbPR(),
        obscureText: _isVisible,
      ),
    );
  }
}
