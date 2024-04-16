import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minimal_weather_app/bookmark.dart';
import 'package:minimal_weather_app/home.dart';
import 'package:minimal_weather_app/search.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatefulWidget{
  const MyApp({Key? key}): super(key:key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  late List<Widget> screens;

  int index = 0;


   @override
  void initState() {
    super.initState();
    screens = [
      home(),
      search_page(),
      bookmark()
    ];
  }


  @override
  Widget build(BuildContext context){
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent)
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: IndexedStack(
          index: index,
        children:screens
      ),
         bottomNavigationBar: NavigationBarTheme(
          data:NavigationBarThemeData(
            indicatorColor: Colors.blue.shade100,
            labelTextStyle: MaterialStateProperty.all(
              TextStyle(fontSize: 14, fontWeight: FontWeight.w500)
            )
          ),
          child: NavigationBar(
            //  height: 60,
            selectedIndex: index,
            onDestinationSelected: (index) =>
            setState(() => this.index = index),

            destinations: [
             NavigationDestination(
              icon: Icon(Icons.home_outlined), label: 'Home'),
         
             NavigationDestination(
              icon: Icon(Icons.search_outlined), label: 'Search'),

             NavigationDestination(
              icon: Icon(Icons.bookmark_outline), label: 'Bookmark')
         
          ]),
       ),
      ),
    );
  }
}