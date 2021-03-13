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
import 'package:epicture/CommentPage.dart';
import 'package:epicture/SearchPage.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
final SnackBar snackBar = const SnackBar(content: Text('Showing Snackbar'));


String accessToken;
String userName;
List<imgur.GalleryAlbumImage> gal = List<imgur.GalleryAlbumImage>.filled(500, null, growable: true);
List<imgur.GalleryAlbumImage> search = List<imgur.GalleryAlbumImage>.filled(500, null, growable: true);
List<imgur.Image> listimageaccount = List<imgur.Image>.filled(500, null, growable: true);
List<imgur.GalleryAlbumImage> listFavorite = List<imgur.GalleryAlbumImage>.filled(500, null, growable: true);
final client = imgur.Imgur(imgur.Authentication.fromToken(accessToken));
List<imgur.Comment> com = List<imgur.Comment>.filled(500, null, growable: true);
String avatar;
String bio;
String searchName;


class MyStatelessWidget extends StatefulWidget {
  MyStatelessWidget({Key key}) : super(key: key);
  @override
  MyStatelessWidgetState createState() => MyStatelessWidgetState();
}

class MyStatelessWidgetState extends State<MyStatelessWidget> {
  final AppBarController appBarController = AppBarController();
  bool typing = false;
  String searchValue;
  TextEditingController t = TextEditingController();
  TextEditingController d = TextEditingController();

  @override
  void initState() {
    super.initState();
    client.gallery.list().then((value) => gal = value);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: SearchAppBar(
        primary: Color(0xFF9CCC65),
        appBarController: appBarController,
        autoSelected: false,
        searchHint: "Search",
        mainTextColor: Colors.white,
        onChange: (String value) async {
          setState(() {
            searchValue = value;
          });
        },
        mainAppBar: AppBar(
          leading:  IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Show Snackbar',
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: t,
                              decoration: InputDecoration(
                                hintText: 'Title',
                              ),
                            ),
                            TextField(
                              controller: d,
                              decoration: InputDecoration(
                                hintText: 'Description',
                              ),
                            ),
                            Center(
                                child: ButtonBar(
                                  alignment: MainAxisAlignment.start,
                                  children: [
                                    FlatButton(
                                      textColor: const Color(0xFF9CCC65),
                                      onPressed: () async {
                                        File file;
                                        file = await ImagePicker.pickImage(source: ImageSource.gallery);
                                        await client.image.uploadImage(
                                            imagePath: file.path,
                                            title: t.text,
                                            description: d.text)
                                            .then((image) => print('Uploaded image to: ${image.link}'));
                                      },
                                      child: Icon(Icons.image),
                                    ),
                                    FlatButton(
                                      textColor: const Color(0xFF9CCC65),
                                      onPressed: () async {
                                        File file;
                                        file = await ImagePicker.pickVideo(source: ImageSource.gallery);
                                        await client.image.uploadVideo(
                                            videoPath: file.path,
                                            title: 'A title',
                                            description: 'A description')
                                            .then((video) => print('Uploaded image to: ${video.link}'));
                                      },
                                      child: Icon(Icons.video_library),
                                    ),
                                  ],
                                )),],
                        ),
                      );
                    });
              }
          ),
          title: typing ? TextBox() : Text("Epicture"),
          backgroundColor: Color(0xFF9CCC65),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.account_circle),
              tooltip: 'Next page',
              onPressed: () async {
                Future<imgur.Account> fetchAlbum() async {
                  final response = await http.get(
                      'https://api.imgur.com/3/account/' + userName, headers: {"Authorization": "Client-ID f1d5d4a59d33b94"});
                  if (response.statusCode != 200) {
                    throw Exception('Failed to load album');
                  }
                    final Map<String, dynamic> responseJson = json.decode(response.body);
                    await client.account.getImages().then((value) => listimageaccount = value);
                    await client.account.getFavoriteGalleries().then((value) => listFavorite = value);
                    print(listFavorite[0].images[0].link);
                    print(listimageaccount[0].link);
                    bio = responseJson["data"]["bio"];
                    print(response.body);
                    print(imgur.Account.fromJson(jsonDecode(response.body)).bio);
                    return imgur.Account.fromJson(jsonDecode(response.body));
                }
                fetchAlbum().then((value) => value.bio);
                await client.account.getAvatar(
                    username: userName).then((value) =>
                      avatar = value.location,
                    );
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => AccountPage()
                ));
              },
            ),
        IconButton(
        icon: const Icon(Icons.search),
        tooltip: 'Next page',
        onPressed: () async {
          setState(() {
            typing = !typing;
          });
        }
    )
      ])),
      body:
        Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
            children: List.generate(gal.length, (index) {
                    return Card (
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                          children: [
                            gal[index].images != null ? Image.network(gal[index].images[0].link)  : Image.network("https://1080motion.com/wp-content/uploads/2018/06/NoImageFound.jpg.png"),
                            gal[index].title != null ? Text(gal[index].title, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF9CCC65), fontSize: 24),) : Text("Fail to load", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF9CCC65), fontSize: 24)),
                            gal[index].description != null ? Text(gal[index].description, style: TextStyle(color: Color(0xFF9CCC65), fontSize: 18),) : Text(""),
                            ButtonBar(
                                alignment: MainAxisAlignment.start,
                                buttonMinWidth: 16,
                                children: [
                                  FlatButton(
                                    textColor: const Color(0xFF9CCC65),
                                    onPressed: () async {
                                          if (gal[index].vote != imgur.VoteType.up) {
                                            client.image.vote(gal[index].id, imgur.VoteType.up);
                                            setState(() {
                                              gal[index].vote = imgur.VoteType.up;
                                            });
                                          } else {
                                            client.image.vote(gal[index].id, imgur.VoteType.veto);
                                            setState(() {
                                              gal[index].vote = imgur.VoteType.veto;
                                            });
                                          }
                                    },
                                    child: gal[index].vote == imgur.VoteType.up ? Icon(Icons.thumb_up) : Icon(Icons.thumb_up_alt_outlined),
                                  ),
                                  FlatButton(
                                    textColor: const Color(0xFF9CCC65),
                                    onPressed: () async {
                                      if (gal[index].vote != imgur.VoteType.down) {
                                        client.image.vote(gal[index].id, imgur.VoteType.down);
                                        setState(() {
                                          gal[index].vote = imgur.VoteType.down;
                                        });
                                      } else {
                                        client.image.vote(gal[index].id, imgur.VoteType.veto);
                                        setState(() {
                                          gal[index].vote = imgur.VoteType.veto;
                                        });
                                      }
                                    },
                                    child: gal[index].vote == imgur.VoteType.down ? Icon(Icons.thumb_down) : Icon(Icons.thumb_down_alt_outlined),
                                  ),
                                  FlatButton(
                                    textColor: const Color(0xFF9CCC65),
                                    onPressed: () async {
                                      if (gal[index].favorite != true) {
                                        client.image.favorite(gal[index].id);
                                        setState(() {
                                          gal[index].favorite = true;
                                        });
                                      } else {
                                        client.image.favorite(gal[index].id);
                                        setState(() {
                                          gal[index].favorite = false;
                                        });
                                      }
                                    },
                                    child: gal[index].favorite == true ? Icon(Icons.star) : Icon(Icons.star_border_outlined),
                                  ),
                                  FlatButton(
                                    textColor: const Color(0xFF9CCC65),
                                    onPressed: () async {
                                      final cli = imgur.Imgur(imgur.Authentication.fromToken(accessToken));
                                      com = await cli.image.getComments(gal[index].id, sort: imgur.BestSort.best);
                                      print(gal[index].id);
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
                                  gal.isNotEmpty ? Text(gal[index].views.toString(), style: TextStyle(color: Color(0xFF9CCC65), fontSize: 14),) : Text(""),
                                ]
                            )
                          ]));
                  }),
              ),
        ),
    );
  }
}

class TextBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.white,
      child: TextField(
      textInputAction: TextInputAction.search,
        onSubmitted: (value) async {
        searchName = value;
      await client.gallery.search(value).then((value) => search = value);
      print(search[0].link);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => SearchPage()
      ));
    },
    decoration: InputDecoration(
    border: InputBorder.none,
    prefixIcon: Icon(Icons.search),
    hintText: 'Search ',
    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    )),
    );
  }
}