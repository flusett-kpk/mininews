import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mininews/components/navigation.dart';
import 'package:intl/intl.dart';
import 'package:mininews/widgets/large_news.dart';

import '../widgets/small_news.dart';
import 'news_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String currentDateFormatted =
      DateFormat("EEEEE dd MMMM").format(DateTime.now());

  // CollectionReference bigNews = FirebaseFirestore.instance.collection('big');
  //CollectionReference smallNews =
  //   FirebaseFirestore.instance.collection('small');

  final Stream<QuerySnapshot> _newsStream =
      FirebaseFirestore.instance.collection('news').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40, right: 30, left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentDateFormatted.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'MiniNews',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/logo.png'),
                    backgroundColor: Colors.transparent,
                  )
                ],
              ),
            ),
            const SizedBox(height: 35),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 30),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _newsStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }

                    return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => NewsPage(
                                  category: data['category'],
                                  topic: data['topic'],
                                  postDate: data['postDate'].toString(),
                                  likes: data['likes'].toString(),
                                  message: data['message'],
                                ),
                              ),
                            );
                          },
                          child: SmallNews(
                              imageLink: data['imageLink'],
                              category: data['category'],
                              topic: data['topic'],
                              likes: data['likes'].toString(),
                              postDate: data['postDate']),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            const MyNavigation(index: 0),
          ],
        ),
      ),
    );
  }
}
