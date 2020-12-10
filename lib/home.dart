import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:aplikasi_news/detail.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  static String tag = 'home-page';
  @override
  _HomeState createState() => _HomeState();
}

// ignore: non_constant_identifier_names
class _HomeState extends State<Home> {
  List _posts = [];

  int _currentIndex = 0;

  final tabs = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kampus News')),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Search'),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
              backgroundColor: Colors.blue),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              color: Colors.grey[200],
              height: 100,
              width: 100,
              child: _posts[index]['urlToImage'] != null
                  ? Image.network(
                      _posts[index]['urlToImage'],
                      width: 100,
                      fit: BoxFit.cover,
                    )
                  : Center(),
            ),
            title: Text(
              '${_posts[index]['title']}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${_posts[index]['description']}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => Detail(
                    url: _posts[index]['url'],
                    title: _posts[index]['title'],
                    content: _posts[index]['content'],
                    publishedAt: _posts[index]['publishedAt'],
                    author: _posts[index]['author'],
                    urlToImage: _posts[index]['urlToImage'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future _getData() async {
    try {
      final response = await http.get(
          'https://newsapi.org/v2/top-headlines?country=id&apiKey=85cc59e48fe24e62bf19e707dde8a7cd');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _posts = data['articles'];
        });
      }
    } catch (e) {
      print(e);
    }
  }
}

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('About'),
      ),
      body: new Center(
        child: new Text('Copyright '),
      ),
    );
  }
}
