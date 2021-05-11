import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'favouritesPage.dart';

//  This line will call MainPage() as the application to run
void main() => runApp(MainPage());

//  This class defines MainPage as being stateful
class MainPage extends StatefulWidget {
  //  This override will use the state produced by HomePageState()
  @override
  MainPageState createState() => MainPageState();
}

//  This class defines the states of the MainPage class
class MainPageState extends State<MainPage> {
  int _selectedPageIndex = 0;

  List _fetchedCrypto;

  //  Declare a set to store favourited currencies
  final List _favourites = [];

  //  Boolean flag to show if data is loaded or not
  bool isLoaded;

  //  Override the initState to add additional actions on page load
  @override
  void initState() {
    //  Carry out the standard init process
    super.initState();
    //  Call the fetchCrypto() function on load
    fetchCrypto();
  }

  //  Override the build function to return the layout defined below
  @override
  Widget build(BuildContext context) {
    //  This override will build a MaterialApp widget and return it using custom data
    return MaterialApp(
      title: 'Crypto Spy',
      //  Declare a theme to be used by the app
      theme: new ThemeData(primaryColor: Colors.amber[400]),
      //  Define the home page that the app will launch to
      home: Scaffold(
        appBar: AppBar(
          title: Text('Crypto Spy'),
        ),
        //  Set the page content to be chosen using the bottomNavigationBar
        body: Center(
          child: _pageContent(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.amber[400],
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black45,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favourites',
            ),
          ],
          currentIndex: _selectedPageIndex,
          onTap: _onNavBarItemTapped,
        ),
      ),
    );
  }

  //  Declare a function to call the API and store the response as JSON objects
  //  Using async allows this to be carried out as other actions occur
  //  Future means that a correct response or error can return once the function finishes
  Future<void> fetchCrypto() async {
    setState(() {
      isLoaded = false;
    });
    //  API URL that returns data on different cryptos
    String _apiUrl = 'https://api.coincap.io/v2/assets';
    //  Make a fetch request to the API using the URL
    http.Response response = await http.get(Uri.parse(_apiUrl));
    //  Update the state of the List when a response is received
    setState(() {
      //  Decode the JSON object returned, using the JSON array that falls
      //  under the "data" heading
      _fetchedCrypto = jsonDecode(response.body)['data'];
      isLoaded = true;
    });
  }

  //  Function to handle which page is being shown as the body
  //  Case default will show the main crypto list page as a refreshable
  //  Case 1 will swap the body to show the favourites page
  _pageContent() {
    switch (_selectedPageIndex) {
      case 1:
        return FavouritesPage(
          favourites: _favourites,
        );
        break;
      default:
        //  If data has been loaded
        if (isLoaded) {
          //  This will allow pull down to refresh which will update the page content
          return RefreshIndicator(
            child: _cryptoListBuilder(),
            onRefresh: fetchCrypto,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        break;
    }
  }

  //  Function to handle tap event on navBar
  void _onNavBarItemTapped(int index) {
    //  Update selectedPageIndex to match that of navBar item
    setState(() {
      _selectedPageIndex = index;
    });
  }

  //  Home page list creation

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
}
