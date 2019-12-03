import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'post.dart';
import 'welcome.dart';
import 'package:garagesalesv/screens/detail.dart';


class ItemList extends StatefulWidget {
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {


  @override
  Widget build(BuildContext context) {
    final title = 'Items For Sale';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Items List'),
          backgroundColor: Colors.orange,
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) => Welcome()));

              },
              child: Text("LOG OUT"),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
        ),
        body:
        BuildItemList(),
        floatingActionButton: FloatingActionButton.extended(
          icon:Icon(Icons.add),
          label: Text('NEW POST'),
          backgroundColor: Colors.pink,
          onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Post()));
          },
        ),
      ),
    );
  }
}


class BuildItemList extends StatefulWidget {
  @override
  _BuildItemListState createState() => _BuildItemListState();
}

class _BuildItemListState extends State<BuildItemList> {
  final fireStore = Firestore.instance;

  final List<Widget> lists = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fireStore.collection('team1Posts').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.orange,
            ),
          );
        }

        final documents = snapshot.data.documents;
        for (var doc in documents) {
          final user = doc.data['user'];
          final price = doc.data['price'];
          final title = doc.data['title'];
          final description = doc.data['description'];
          final imageUrl = doc.data['image_path'];

          lists.add(ListTile(
              leading: (imageUrl == "" || imageUrl == null) ? Image.asset('images/image.jpg') : Image.network(imageUrl),
              title: Text(title + "        " + '\$'+price.toString()),
              subtitle: Text('Sell by ' + user),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () => _onTapped(title, imageUrl, description, price,user),
          ));
        }
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          children: lists,
        );
      },
    );
  }

  void _onTapped(String title, String imageUrl, String description, int price, String user) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Detail(title: title, imageUrl: imageUrl, description: description, price: price, user: user),
        ));
  }
}
