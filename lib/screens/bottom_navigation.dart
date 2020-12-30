import 'package:blog_app/screens/account_screen.dart';
import 'package:blog_app/screens/all_blogs_screen.dart';
import 'package:blog_app/widget/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/screens/addBlog_screen.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {

  int _selectedIndex = 0;

  final List _bodyPages = [
    AllBlogScreen(),
    AddBlogScreen(),
    AccountScreen(),
  ];

  void _onTapIndex(int index)
  {
    setState(() {
      _selectedIndex  = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? "Home" :
                    (_selectedIndex == 1) ? "Add Blog" : "Account"),
      ),
      drawer: MyDrawer(),
      body: _bodyPages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home_outlined),
          ),
          BottomNavigationBarItem(
            label: "Add Blog",
            icon: Icon(Icons.camera_alt_outlined),
          ),
          BottomNavigationBarItem(
            label: "Account",
            icon: Icon(Icons.account_circle_outlined),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onTapIndex,
      ),
    );
  }
}
