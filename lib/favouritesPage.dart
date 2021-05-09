import 'package:flutter/material.dart';
import 'dart:core';

//  This class defines FavouritesPage as being stateful
class FavouritesPage extends StatefulWidget {
  //  This override will use the state produced by FavouritesPageState()
  @override
  FavouritesPageState createState() => FavouritesPageState();
}

//  This class defines the states of the MainPage class
class FavouritesPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {
    return Text('Favourites');
  }
}