import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import "package:http/http.dart" as http;
import 'package:page_transition/page_transition.dart';
import 'package:imgur/imgur.dart' as imgur;
import 'dart:io';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:simple_search_bar/simple_search_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:epicture/AccountPage.dart';
import 'package:epicture/HomePage.dart';
import 'package:epicture/CommentPage.dart';


class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);
  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  String name = "Search " + searchName;
  @override
  void initState() {
    super.initState();
    client.gallery.list().then((value) => gal = value);
    print(search.length);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(name),
          backgroundColor: Color(0xFF9CCC65),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: List.generate(search.length, (index) {
                return Card (
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                        children: [
                          search[index].images != null ? Image.network(search[index].images[0].link)  : Image.network("https://1080motion.com/wp-content/uploads/2018/06/NoImageFound.jpg.png"),
                          search[index].title != null ? Text(search[index].title, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF9CCC65), fontSize: 24),) : Text("Fail to load", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF9CCC65), fontSize: 24)),
                          search[index].description != null ? Text(search[index].description, style: TextStyle(color: Color(0xFF9CCC65), fontSize: 18),) : Text(""),
                          ButtonBar(
                              buttonMinWidth: 16,
                              alignment: MainAxisAlignment.start,
                              children: [
                                FlatButton(
                                  textColor: const Color(0xFF9CCC65),
                                  onPressed: () async {
                                    if (search[index].vote != imgur.VoteType.up) {
                                      client.image.vote(search[index].id, imgur.VoteType.up);
                                      setState(() {
                                        search[index].vote = imgur.VoteType.up;
                                      });
                                    } else {
                                      client.image.vote(search[index].id, imgur.VoteType.veto);
                                      setState(() {
                                        search[index].vote = imgur.VoteType.veto;
                                      });
                                    }
                                  },
                                  child: search[index].vote == imgur.VoteType.up ? Icon(Icons.thumb_up) : Icon(Icons.thumb_up_alt_outlined),
                                ),
                                FlatButton(
                                  textColor: const Color(0xFF9CCC65),
                                  onPressed: () async {
                                    if (search[index].vote != imgur.VoteType.down) {
                                      client.image.vote(search[index].id, imgur.VoteType.down);
                                      setState(() {
                                        search[index].vote = imgur.VoteType.down;
                                      });
                                    } else {
                                      client.image.vote(search[index].id, imgur.VoteType.veto);
                                      setState(() {
                                        search[index].vote = imgur.VoteType.veto;
                                      });
                                    }
                                  },
                                  child: search[index].vote == imgur.VoteType.down ? Icon(Icons.thumb_down) : Icon(Icons.thumb_down_alt_outlined),
                                ),
                                FlatButton(
                                  textColor: const Color(0xFF9CCC65),
                                  onPressed: () async {
                                    if (search[index].favorite != true) {
                                      client.image.favorite(search[index].id);
                                      setState(() {
                                        search[index].favorite = true;
                                      });
                                    } else {
                                      client.image.favorite(search[index].id);
                                      setState(() {
                                        search[index].favorite = false;
                                      });
                                    }
                                  },
                                  child: search[index].favorite == true ? Icon(Icons.star) : Icon(Icons.star_border_outlined),
                                ),
                                FlatButton(
                                  textColor: const Color(0xFF9CCC65),
                                  onPressed: () async {
                                    final cli = imgur.Imgur(imgur.Authentication.fromToken(accessToken));
                                    print(search[index].id);
                                    String id = search[index].id;
                                    com = await client.image.getComments(id, sort: imgur.BestSort.best);
                                    print(com);
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => CommentPage()
                                    ));
                                  },
                                  child: Icon(Icons.comment),
                                ),
                                Icon(
                                  Icons.remove_red_eye,
                                  color: const Color(0xFF9CCC65),
                                ),
                                search.isNotEmpty ? Text(search[index].views.toString(), style: TextStyle(color: Color(0xFF9CCC65), fontSize: 16),) : Text(""),
                              ]
                          )
                        ]));
              },
              ),)
        ));
  }
}