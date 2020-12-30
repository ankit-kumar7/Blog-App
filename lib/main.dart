import 'package:blog_app/Screens/authentication_screen.dart';
import 'package:blog_app/screens/all_blogs_screen.dart';
import 'package:blog_app/screens/bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main()async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  bool userStatus()
  {
    if(FirebaseAuth.instance.currentUser == null)
      return false;
    else
      return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Blog App",
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
       initialRoute: userStatus () ? '/bottomNavigation':'/authenticationScreen',
      routes: {
        '/mainScreen':(context)=>MyApp(),
        '/authenticationScreen':(context)=>AuthenticationScreen(),
        '/allBlogScreen':(context)=>AllBlogScreen(),
        '/bottomNavigation':(context)=>MyBottomNavigationBar(),
      },
    );
  }
}
