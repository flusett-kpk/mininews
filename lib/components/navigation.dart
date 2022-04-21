import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mininews/pages/home_page.dart';

import '../pages/auth_page.dart';
import '../pages/favourites_page.dart';
import '../pages/profile_page.dart';

class MyNavigation extends StatefulWidget {
  const MyNavigation({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  MyNavigationState createState() => MyNavigationState();
}

class MyNavigationState extends State<MyNavigation> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.home_outlined,
              color: widget.index == 0 ? Colors.black : Colors.grey,
              size: 24,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const HomePage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.person_outline,
              color: widget.index == 2 ? Colors.black : Colors.grey,
              size: 24,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      user == null ? const AuthPage() : const ProfilePage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
