import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;

//  This line will call MyApp() as the application to run
void main() => runApp(MyApp());

//  Class defining MyApp
class MyApp extends StatelessWidget {
  //  This override will build a MaterialApp widget and return it using custom data
  @override
  Widget build(BuildContext context) {
    //  Returns a MaterialApp widget
    return MaterialApp(
      title: 'Crypto Spy',
      //  Declare a theme to be used by the app
      theme: new ThemeData(primaryColor: Colors.amber[400]),
      //  Define the home page that the app will launch to
      home: HomePage(),
    );
  }
}

//  This class defines HomePage as being stateful
class HomePage extends StatefulWidget {
  //  This override will use the state produced by HomePageState()
  @override
  HomePageState createState() => HomePageState();
}

//  This class defines the states of the HomePage class
class HomePageState extends State<HomePage> {
  List _fetchedCrypto;

  //  Declare a map to store favourited currencies
  final _favourites = Set<Map>();

  //  Override the build function to return the layout defined below
  @override
  Widget build(BuildContext context) {
    //  Return a Scaffold widget that defines the layout of HomePage
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Spy'),
        //  Declare the actions (menu items) to be contained on the AppBar
        actions: <Widget>[
          new IconButton(
              icon: const Icon(Icons.list_rounded), onPressed: _viewFavourites),
        ],
      ),
      //  Here, a function is called that returns a widget to build the body
      body: _cryptoListBuilder(),
    );
  }

  //  Override the initState activity to add additional actions on page load
  @override
  void initState() {
    //  Carry out the standard init process
    super.initState();
    //  Call the fetchCrypto() function on load
    fetchCrypto();
  }

  //  Declare a function to call the API and store the response as JSON objects
  //  Using async allows this to be carried out as other actions occur
  //  Future means that a correct response or error can return once the function finishes
  Future<void> fetchCrypto() async {
    //  API URL that returns data on different cryptos
    String _apiUrl = 'https://api.coincap.io/v2/assets';
    //  Make a fetch request to the API using the URL
    http.Response response = await http.get(Uri.parse(_apiUrl));
    //  Update the state of the List when a response is received
    setState(() {
      //  Decode the JSON object returned, using the JSON array that falls
      //  under the "data" heading
      _fetchedCrypto = jsonDecode(response.body)['data'];
    });
  }

  //  Function will build the ListView that displays the crypto values
  Widget _cryptoListBuilder() {
    //  Return a ListView using a separated list builder to create items within the ListView
    return ListView.separated(
        itemCount: _fetchedCrypto.length,
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
          return _rowBuilder(_fetchedCrypto[index]);
        });
  }

  //  Function will build each row within the ListView
  Widget _rowBuilder(Map crypto) {
    //  Check if the favourites list contains the passed in crypto and
    //  store the result in a boolean variable
    final bool isFavourite = _favourites.contains(crypto);

    //  This function will be used to add and remove items from the favourited list
    //  This is called when the heart icon is tapped
    void _setFavourite() {
      //  Update the state of the icon when tapped
      setState(() {
        if (isFavourite) {
          _favourites.remove(crypto);
        } else {
          _favourites.add(crypto);
        }
      });
    }

    //  Parse the value of "priceUsd" from the crypto JSON to a double value
    double price = double.parse(crypto['priceUsd']);
    //  Round to 2dp and cast into a string
    String priceStr = "\$" + (price).toStringAsFixed(2);

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
      //  Define what will be at the trailing edge of the List Item (in this case an IconButton)
      trailing: IconButton(
        //  Icon is set by a conditional statement based on if the item is in
        //  the favourites list or not
        icon: Icon(isFavourite ? Icons.favorite : Icons.favorite_border),
        //  Set the colour of the icon based on the same conditional (null if not fave)
        color: isFavourite ? Colors.redAccent : null,
        //  Define the action to be carried out if pressed (_setFavourite())
        onPressed: _setFavourite,
      ),
    );
  }

  //  Define the action that will occur when the list icon is tapped
  void _viewFavourites() {}
}
