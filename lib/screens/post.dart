import 'dart:io';
import 'package:flutter/material.dart';
import 'package:garagesalesv/components/item.dart';
import '../components/item.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'itemlist.dart';
import 'camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'welcome.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garagesalesv/components/constants.dart';

class Post extends StatefulWidget {
  const Post({Key key, this.imagePath, this.item}) : super(key: key);
  final String imagePath;
  final Item item;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Post> {

   final kTextFieldDecoration = InputDecoration(
    contentPadding:
    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide:
      BorderSide(color: Colors.orange, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
      BorderSide(color: Colors.orange, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
  );

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final fireStore = Firestore.instance;
  FirebaseUser curUser;
  final _auth = FirebaseAuth.instance;
  String title = "";
  int price = 0;
  String description = "";
  String imageUrl;

  @override
  void initState() {
    super.initState();
    _getCurUserInfo();
    print("widget.imagepth:");
    print(widget.imagePath);
    if (widget.imagePath != null) {
      _uploadImageToFireBase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post New'),
        backgroundColor: Colors.orange,
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ItemList()));
            },
            child: Text("Check All Posts"),
          ),
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context) => Welcome()));

            },
            child: Text("SIGN-OUT"),
          ),
        ],
      ),
      body:  Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 1.0,
              horizontal: 32.0,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 1.0),
                  child: TextField(
                      controller: titleController,
                      onChanged: (value) {
                        setState(() {
                          title = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Title',
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 1.0),
                  child: TextField(
                      controller: priceController,
                      onChanged: (value) {
                        setState(() {
                          price = int.parse(value);
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Price",
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 1.0),
                  child: TextField(
                      controller: descriptionController,
                      onChanged: (value) {
                        setState(() {
                          description = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Description',
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Builder(
                    builder: (context) {
                      return RaisedButton(
                          onPressed: () async {
                            final cameras = await availableCameras();
                            final firstCamera = cameras.first;
                            final item = Item(curUser:curUser.email, price: price, title :title, description: description,imagePath: null);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Camera(
                                      camera: firstCamera, item: item),
                                ));
                          },
                          color: Colors.orange,
                          textColor: Colors.white,
                          child: Text('Capature Image'));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Builder(
                    builder: (context) {
                      return RaisedButton(
                        onPressed: () async {
                          try {
                            _showSnackbar(context);
                            titleController.clear();
                            priceController.clear();
                            descriptionController.clear();
                            fireStore.collection('team1Posts').add({
                              'user': curUser.email,
                              'title': widget.item.title,
                              'price': widget.item.price,
                              'description': widget.item.description,
                              'image_path': imageUrl,
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                        color: Colors.orange,
                        textColor: Colors.white,
                        child: Text('Sumbit the Post'),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: widget.imagePath == null ? null : Image.file(
                      File(widget.imagePath),
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  void _showSnackbar(BuildContext context) {
    final scaff = Scaffold.of(context);
    scaff.showSnackBar(SnackBar(
      content: Text("Success"),
      backgroundColor: Colors.orange,
      duration: Duration(seconds: 2),
    ));
  }
  void _getCurUserInfo() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        setState(() {
          curUser = user;
        });
        print('current user ${curUser.email}');
      }
    } catch (e) {
      print(e);
    }
  }

  void _uploadImageToFireBase() async {
    final StorageReference postImageRef =
    FirebaseStorage.instance.ref().child("Post Images");
    var timeKey = new DateTime.now();
    final StorageUploadTask uploadTask = postImageRef
        .child(timeKey.toString() + ".jpg")
        .putFile(File(widget.imagePath));
    var downLoadImageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    setState(() {
      imageUrl = downLoadImageUrl;
    });
    print('success');
  }

}
