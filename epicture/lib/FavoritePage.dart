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


class FavoritePage extends StatefulWidget {
  FavoritePage({Key key}) : super(key: key);
  @override
  FavoritePageState createState() => FavoritePageState();
}

class FavoritePageState extends State<FavoritePage> {

  @override
  void initState() {
    super.initState();
    client.gallery.list().then((value) => gal = value);
    client.account.getFavoriteGalleries().then((value) => listFavorite = value);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Post'),
          backgroundColor: Color(0xFF9CCC65),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: List.generate(listFavorite.length, (index) {
                return Card (
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                        children: [
                          listFavorite[index].images[0].link != null ? Image.network(listFavorite[index].images[0].link)  : Image.network("https://1080motion.com/wp-content/uploads/2018/06/NoImageFound.jpg.png"),
                          listFavorite[index].title != null ? Text(listFavorite[index].title, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF9CCC65), fontSize: 24),) : Text("Fail to load", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF9CCC65), fontSize: 24)),
                          listFavorite[index].description != null ? Text(listFavorite[index].description, style: TextStyle(color: Color(0xFF9CCC65), fontSize: 18),) : Text(""),
                          ButtonBar(
                              alignment: MainAxisAlignment.start,
                              children: [
                                FlatButton(
                                  textColor: const Color(0xFF9CCC65),
                                  onPressed: () async {
                                    if (listFavorite[index].vote != imgur.VoteType.up) {
                                      client.image.vote(listFavorite[index].id, imgur.VoteType.up);
                                      setState(() {
                                        listFavorite[index].vote = imgur.VoteType.up;
                                      });
                                    } else {
                                      client.image.vote(listFavorite[index].id, imgur.VoteType.veto);
                                      setState(() {
                                        listFavorite[index].vote = imgur.VoteType.veto;
                                      });
                                    }
                                  },
                                  child: listFavorite[index].vote == imgur.VoteType.up ? Icon(Icons.thumb_up) : Icon(Icons.thumb_up_alt_outlined),
                                ),
                                FlatButton(
                                  textColor: const Color(0xFF9CCC65),
                                  onPressed: () async {
                                    if (listFavorite[index].vote != imgur.VoteType.down) {
                                      client.image.vote(listFavorite[index].id, imgur.VoteType.down);
                                      setState(() {
                                        listFavorite[index].vote = imgur.VoteType.down;
                                      });
                                    } else {
                                      client.image.vote(listFavorite[index].id, imgur.VoteType.veto);
                                      setState(() {
                                        listFavorite[index].vote = imgur.VoteType.veto;
                                      });
                                    }
                                  },
                                  child: listFavorite[index].vote == imgur.VoteType.down ? Icon(Icons.thumb_down) : Icon(Icons.thumb_down_alt_outlined),
                                ),
                                FlatButton(
                                  textColor: const Color(0xFF9CCC65),
                                  onPressed: () async {
                                    final cli = imgur.Imgur(imgur.Authentication.fromToken(accessToken));
                                    print(listFavorite[index].id);
                                    String id = listFavorite[index].id;
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
                                listFavorite.isNotEmpty ? Text(listFavorite[index].views.toString(), style: TextStyle(color: Color(0xFF9CCC65), fontSize: 16),) : Text(""),
                              ]
                          )
                        ]));
              },
              ),)
        ));
  }
}