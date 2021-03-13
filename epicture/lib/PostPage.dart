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


class PostPage extends StatefulWidget {
  PostPage({Key key}) : super(key: key);
  @override
  PostPageState createState() => PostPageState();
}

class PostPageState extends State<PostPage> {

  @override
  void initState() {
    super.initState();
    client.gallery.list().then((value) => gal = value);
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
              children: List.generate(listimageaccount.length, (index) {
                return Card (
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                        children: [
                          listimageaccount[index].link != null ? Image.network(listimageaccount[index].link)  : Image.network("https://1080motion.com/wp-content/uploads/2018/06/NoImageFound.jpg.png"),
                          listimageaccount[index].title != null ? Text(listimageaccount[index].title, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF9CCC65), fontSize: 24),) : Text("Fail to load", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF9CCC65), fontSize: 24)),
                          listimageaccount[index].description != null ? Text(listimageaccount[index].description, style: TextStyle(color: Color(0xFF9CCC65), fontSize: 18),) : Text(""),
                          ButtonBar(
                              alignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.thumb_up_alt_outlined, color: Color(0xFF9CCC65),),
                                listimageaccount.isNotEmpty ? Text(listimageaccount[index].ups == null ? "0": listimageaccount[index].ups.toString(),
                                  style: TextStyle(color: Color(0xFF9CCC65), fontSize: 16),) : Text(""),
                                Icon(Icons.thumb_down_alt_outlined, color: Color(0xFF9CCC65)),
                                listimageaccount.isNotEmpty ? Text(listimageaccount[index].downs == null ? "0": listimageaccount[index].downs.toString(),
                                  style: TextStyle(color: Color(0xFF9CCC65), fontSize: 16),) : Text(""),
                                FlatButton(
                                  textColor: const Color(0xFF9CCC65),
                                  onPressed: () async {
                                    final cli = imgur.Imgur(imgur.Authentication.fromToken(accessToken));
                                    com = await cli.image.getComments(listimageaccount[index].id, sort: imgur.BestSort.best);
                                    print(com[0].comment);
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
                                listimageaccount.isNotEmpty ? Text(listimageaccount[index].views.toString(), style: TextStyle(color: Color(0xFF9CCC65), fontSize: 16),) : Text(""),
                              ]
                          )
                        ]));
              },
              ),)
        ));
  }
}