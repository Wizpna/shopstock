import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shopstock/theme.dart';
import '../Item.dart';

class StoreInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StoreInfoState();
}

class _StoreInfoState extends State<StoreInfo> {
  final items = <Item>[
    Item("Bread", -1),
    Item("Bread", -0.8),
    Item("Bread", -0.6),
    Item("Eggs", -0.4),
    Item("Eggs", -0.2),
    Item("Eggs", 0),
    Item("Cheese", 0.2),
    Item("Cheese", 0.4),
    Item("Cheese", 0.6),
    Item("Cheese", 0.8),
    Item("Cheese", 1),
  ];
  String search = "";

  ListView _buildList() {

    return ListView.builder(itemBuilder: (context, item) {
      if (item < items.length && items[item].name.toLowerCase().contains(search.toLowerCase())){
        return ListTile(
          title: Text(
              items[item].name,
              style: Theme.of(context).textTheme.bodyText1
          ),
          trailing: Container(
            child: Padding(
                child: Text(
                        (confidence) {
                      const outs = <String>[
                        "Out of Stock",
                        "Likely Out of Stock",
                        "Unknown",
                        "Likely In Stock",
                        "In Stock"
                      ];
                      return outs[min((((confidence + 1) / 2) * outs.length).floor(), outs.length - 1)];
                    }(items[item].confidence),
                    style: TextStyle(
                      color: AppColors.background,
                    )
                ),
                padding: EdgeInsets.fromLTRB(8, 4, 8, 4)
            ),
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
                color: (confidence) {
                  const double SAT = 0.6;
                  double hue = ((confidence + 1) / 2);
                  double red = sqrt(1 - (hue * SAT));
                  double green = sqrt((1 - SAT) + hue * SAT);
                  double blue = (1 - SAT);
                  return Color.fromARGB(0xFF, (red * 0xff).round(), (green * 0xff).round(), (blue * 0xff).round());
                } (items[item].confidence)
            ),
          ),
        );
      }
      return null;
    });
  }

  void _onTextChange(String str) {
    setState(() {
      search = str;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Store Info"),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            child: AppSearchBar(
              onTextChange: _onTextChange
            ),
            padding: EdgeInsets.all(PADDING),
          ),
          Expanded(
            child: _buildList(),
          ),
          Center(
              child: AppButton(
                text: "Report",
                onPressed: () {
                  Navigator.pushNamed(context, "/map_explore/store_info/report");
                },
              )
          )
        ],
      ),
    );
  }
}