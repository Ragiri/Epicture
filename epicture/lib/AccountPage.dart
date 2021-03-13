import 'dart:ffi';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:epicture/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:epicture/PostPage.dart';
import 'package:epicture/FavoritePage.dart';

class AccountPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30),
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              //begin: Alignment.topRight, // sense degrader
                colors: [
                  Colors.green[900],
                  Colors.green[600],
                  Colors.green[300]
                ]
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row (
            children: [
            SizedBox(height: 40,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(userName, style: TextStyle(color: Colors.white, fontSize: 40),),
                  SizedBox(height: 10,),
                  Text(bio, style: TextStyle(color: Colors.white, fontSize: 20),),
                ],
              ),
            ),
            CircularProfileAvatar(avatar,
              radius: 50,
              backgroundColor: Colors.white,
              borderColor: Colors.green,
            ),]),
            SizedBox(height: 10,),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40), bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: FlatButton(
                              height: 50,
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                              child: Text("Post", style:  TextStyle(color: Colors.white),),
                              color: Colors.grey,
                                onPressed: () async {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => PostPage()
                                  ));
                              }
                            ),
                          ),
                          SizedBox(width: 30,),
                          Expanded(
                            child: FlatButton(
                                height: 50,
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                child: Text("Favorite", style:  TextStyle(color: Colors.white),),
                                color: Colors.grey,
                                onPressed: () async {
                                  await client.account.getFavoriteGalleries().then((value) => listFavorite = value);
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => FavoritePage()
                                ));

                                }
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}