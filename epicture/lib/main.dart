import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert' show json;
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
import 'package:epicture/HomePage.dart';

void main() async {
 /* final client = imgur.Imgur(imgur.Authentication.fromToken('be640aac496ff82a10f7d8dceb62aab49fb2570f'));
  List<imgur.GalleryAlbumImage> resp = await client.gallery.list();
  int i = 0;

  print(resp[1].images[0].link);
  li[0] = resp[0].images[0].link;
  print (li[0]);
  for (var res in resp) {
    li[i] = res.images[0].link;
    print(res.images[0].link);
    print("lol");
    i++;
  }*/
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: _Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _Login extends StatefulWidget {
  _Login({Key key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<_Login> {
  final String ClientId = "f1d5d4a59d33b94";
  bool isLoggedIn = false;
  final webViewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    webViewPlugin.onStateChanged.listen((WebViewStateChanged state) async {
      var uri = Uri.parse(state.url.replaceFirst('#', '?'));
      if (uri.query.contains('access_token')) {
        accessToken = uri.queryParameters["access_token"];
        userName = uri.queryParameters["account_username"];
        webViewPlugin.close();
        await client.gallery.list().then((value) => gal = value);
        SharedPreferences.getInstance().then((SharedPreferences prefs) {
          print(state.url);
          print("SHARED: " + uri.queryParameters["access_token"]);
          prefs.setString('user_access_token', uri.queryParameters["access_token"]);
          prefs.setString('user_refresh_token', uri.queryParameters["refresh_token"]);
          prefs.setString('user_account_name', uri.queryParameters["account_username"]);
          prefs.setString('account_id', ClientId);
          setState(() {
            this.isLoggedIn = true;
          });
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    if (!this.isLoggedIn) {
      return WebviewScaffold(
          url: "https://api.imgur.com/oauth2/authorize?client_id="+ ClientId
              +"&response_type=token",
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: AppBar(
              backgroundColor: Color(0xFF9CCC65),
              title: Text("Connexion"),
            ),
          )
      );
    } else {
      return MyStatelessWidget();
    }
  }
}

