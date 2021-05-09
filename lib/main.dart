import 'package:flutter/material.dart';
import 'dart:core';
import 'favouritesPage.dart';
import 'homePage.dart';

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
      home: MainPage(),
    );
  }
}

//  This class defines HomePage as being stateful
class MainPage extends StatefulWidget {
  //  This override will use the state produced by HomePageState()
  @override
  MainPageState createState() => MainPageState();
}

//  This class defines the states of the MainPage class
class MainPageState extends State<MainPage> {
  int _selectedPageIndex = 0;

  //  List of widgets that will be swapped to form the body for each page
  static List<Widget> _pageContent = <Widget>[
    HomePage(),
    FavouritesPage(),
  ];

  //  Override the build function to return the layout defined below
  @override
  Widget build(BuildContext context) {
    //  Return a Scaffold widget that defines the layout of HomePage
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Spy'),
      ),
      //  Set the page content to be chosen using the bottomNavigationBar
      body: Center(
        child: _pageContent[_selectedPageIndex],
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
    );
  }

  //  Function to handle tap event on navBar
  void _onNavBarItemTapped(int index) {
    //  Update selectedPageIndex to match that of navBar item
    setState(() {
      _selectedPageIndex = index;
    });
  }

  //  Define the action that will occur when the list icon is tapped
  void _viewFavourites() {}
}
