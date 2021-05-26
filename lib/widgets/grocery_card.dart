import 'package:GroceriesApplication/models/store.dart';
import 'package:GroceriesApplication/widgets/app_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class GroceryCard extends StatefulWidget {
  final Store data;
  final Function editMode;
  GroceryCard({this.data, this.editMode});
  @override
  _GroceryCardState createState() => _GroceryCardState();
}

class _GroceryCardState extends State<GroceryCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.all(10.0),
      child: _getCardChild(context),
    );
  }

  int getTotatViews() {
    int totalInteraction = 0;
    /*if (widget.data['deals'] != null) {
      for (dynamic deal in widget.data['deals']) {
        totalInteraction = totalInteraction +
            (deal['interaction'] == null ? 0 : deal['interaction']);
      }
    }*/

    return totalInteraction;
  }

  Widget _getCardChild(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Nothing as of now
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: 5,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                    child: AppCachedNetworkImage(
                      imageURL: widget.data.carouselList.elementAt(0) ?? null,
                      fit: BoxFit.contain,
                      color: Colors.black,
                    ),
                  ),
                ),
                Positioned(
                  top: 15.0,
                  right: 15.0,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          widget.editMode();
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 5,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: _getDescription(),
                ),
                Divider(
                  thickness: 2,
                ),
                Flexible(
                  child: _getFooter(),
                  fit: FlexFit.loose,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _getFooter() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: <Widget>[
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        'Views',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        getTotatViews().toString(),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                VerticalDivider(
                  thickness: 2,
                  indent: 2,
                  endIndent: 2,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        'Uploaded Date',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        DateFormat('dd MMM, yyyy')
                            .format(widget.data.creationDate),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                VerticalDivider(
                  thickness: 2,
                  indent: 2,
                  endIndent: 2,
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          'Saved',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          '19',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  int _getActiveCount() {
    int count = 0;
    /*for (int i = 0; i < widget.data['deals'].length; i++) {
      if (widget.data['deals'][i]['endTime'].toDate().isAfter(DateTime.now()) &&
          widget.data['deals'][i]['startTime']
              .toDate()
              .isBefore(DateTime.now())) {
        count++;
      }
    }*/
    return count;
  }

  Widget _getDescription() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < 3; i++) _getRows(i),
      ],
    );
  }

  Widget _getRows(int index) {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              index == 0
                  ? Icon(Icons.store)
                  : index == 1
                      ? Icon(Icons.description)
                      : Icon(Icons.location_on),
              SizedBox(
                width: 5.0,
              ),
              Flexible(
                child: Text(
                  index == 0
                      ? widget.data.storeName
                      : index == 1
                          ? widget.data.storeDescription
                          : widget.data.storeAddress.length.toString(),
                  style: (index == 0 || index == 2)
                      ? TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.normal,
                        )
                      : TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                  textAlign: TextAlign.left,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
