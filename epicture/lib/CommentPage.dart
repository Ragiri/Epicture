import 'package:flutter/cupertino.dart';
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


class CommentPage extends StatefulWidget {
  CommentPage({Key key}) : super(key: key);
  @override
  CommentPageState createState() => CommentPageState();
}

class CommentPageState extends State<CommentPage> {

  @override
  void initState() {
    super.initState();
    client.gallery.list().then((value) => gal = value);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Comments'),
          backgroundColor: Color(0xFF9CCC65),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: List.generate(com.length, (index) {
                return Card (
                    clipBehavior: Clip.antiAlias,
                    color: Colors.black45,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(com[index].author, style: TextStyle(color: Colors.white,  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4,),
                          Text(com[index].comment, style: TextStyle(color: Colors.white, fontSize: 18)),
                        ]
                    )
                );
              },
              ),)
        ));
  }
}