import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'welcome.dart';
import 'package:flutter/rendering.dart';

class Detail extends StatefulWidget {
  Detail({Key key, this.title, this.imageUrl, this.description, this.price, this.user}) : super(key: key);
  final String title;
  final String user;
  final int price;
  final String imageUrl;
  final String description;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: Column(
          children: <Widget>[
            myAppBar(),
            imageDisplay(),
            SizedBox(height: 10),
            Expanded (
              child: contents(),
            ),          ],
        ),
      ),
    );
  }

  Widget imageDisplay(){
    return Container(
      child: Stack(
        children: <Widget>[
          (widget.imageUrl == "" || widget.imageUrl == null) ? Image.asset('images/image.jpg'): Image.network(widget.imageUrl),
        ],
      ),
    );
  }


  Widget myAppBar(){
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            child: Image.asset("images/back_button.png"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Container(
            child: Column(
              children: <Widget>[
                Text('Product Detail Page',
                     style: TextStyle(
                         fontSize: 20,
                         color: Colors.orange

                ),),
              ],
            ),
          ),
          FlatButton(
            textColor: Colors.black,
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context) => Welcome()));
            },
            child: Text("Log Out"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
    );
  }

  Widget contents(){
    return Container(
      color: Colors.blueGrey,

      padding: EdgeInsets.only(left: 80, top: 70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          content('Title: ',widget.title),
          SizedBox(height: 10.0),
          content('Price: ',widget.price.toString()),
          SizedBox(height: 10.0),
          content('Sell By ',widget.user),
          SizedBox(height: 10.0),
          content('Description: ', widget.description),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }

  Widget content(String des, String content){
    return Text(
      des + content,
      textAlign: TextAlign.left,
      style: TextStyle(height: 1.5, color: Colors.white, fontSize: 16),);
  }
}


