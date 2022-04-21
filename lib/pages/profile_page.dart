import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/navigation.dart';
import 'auth_page.dart';
import 'favourites_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String currentDateFormatted =
      DateFormat("EEEEE dd MMMM").format(DateTime.now());

  CollectionReference news = FirebaseFirestore.instance.collection('news');

  final _imageLinkTextController = TextEditingController();
  final _categoryTextController = TextEditingController();
  final _topicTextController = TextEditingController();
  final _messageTextController = TextEditingController();

  void clearControllers() {
    _imageLinkTextController.clear();
    _categoryTextController.clear();
    _topicTextController.clear();
    _messageTextController.clear();
  }

  Future<void> addNews() {
    return news
        .add({
          'imageLink': _imageLinkTextController.text,
          'category': _categoryTextController.text,
          'topic': _topicTextController.text,
          'likes': 0,
          'postDate': currentDateFormatted,
          'message': _messageTextController.text,
        })
        .then((value) => print("Новина добавлена"))
        .catchError((error) => print("Сталася помилка: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: TextFormField(
                      controller: _imageLinkTextController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Силка на картинку',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: TextFormField(
                      controller: _categoryTextController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Категорія',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: TextFormField(
                      controller: _topicTextController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Тема',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: TextFormField(
                      controller: _messageTextController,
                      decoration: const InputDecoration(
                        helperMaxLines: 4,
                        border: UnderlineInputBorder(),
                        labelText: 'Новина',
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ))),
                    child: const Text(
                      'Добавити новину',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    onPressed: addNews,
                  ),
                  const SizedBox(height: 70),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const AuthPage(),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 20,
                      child: const Text(
                        'Вийти з акаунту',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const MyNavigation(index: 2),
          ],
        ),
      ),
    );
  }
}
