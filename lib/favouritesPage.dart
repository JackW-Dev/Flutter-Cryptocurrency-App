import 'dart:core';

import 'package:flutter/material.dart';

//  This class defines FavouritesPage as being stateful
class FavouritesPage extends StatefulWidget {
  final List favourites;

  //  Custom constructor to accept favourites list and use as a param in this class
  const FavouritesPage({Key key, this.favourites}) : super(key: key);

  //  This override will use the state produced by FavouritesPageState()
  @override
  FavouritesPageState createState() => FavouritesPageState();
}

//  This class defines the states of the MainPage class
class FavouritesPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {
    return _favouritesListBuilder();
  }

  //  Function will build the ListView that displays the crypto values
  Widget _favouritesListBuilder() {
    if (widget.favourites.isEmpty) {
      return Text("Favourites list is empty.");
    } else {
      //  Return a ListView using a separated list builder to create items within the ListView
      return ListView.separated(
          itemCount: widget.favourites.length,
          //  Set padding for each side of the list
          padding: const EdgeInsets.all(16.0),
          //  Add dividers between each item
          separatorBuilder: (context, index) {
            return Divider(color: Colors.black);
          },
          //  Define how each item in the ListView is created
          itemBuilder: (context, i) {
            final index = i;
            //  Call the _rowBuilder() function to produce a row using the data passed to it
            return _rowBuilder(widget.favourites[index]);
          });
    }
  }

  //  Function will build each row within the ListView
  Widget _rowBuilder(Map crypto) {
    //  Parse the value of "priceUsd" from the crypto JSON to a double value
    double price = double.parse(crypto['priceUsd']);
    //  Round to 6dp and cast into a string
    String priceStr = "\$" + (price).toStringAsFixed(6);

    //  Return a ListTile item (this will be each item in the list)
    return ListTile(
      //  Start with a CircleAvatar widget
      leading: CircleAvatar(
        backgroundColor: Colors.blue[200],
        child: Text(
          //  This will use the 1st letter of the name
          crypto['name'][0],
          style: TextStyle(color: Colors.black),
        ),
      ),
      title: Text('${crypto['name']} (${crypto['symbol']})'),
      //  Set the subtitle for the ListTile
      subtitle: Text(
        priceStr,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
