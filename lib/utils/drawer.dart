import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doit/ui/about_us.dart';
import 'package:doit/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../color.dart';

class NavigationDrawer extends StatefulWidget {
  NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  String name = "User Name";
  String email = "Email Address";

  final appUserRef =
  FirebaseFirestore.instance.collection('users').withConverter<Users>(
    fromFirestore: (snapshot, _) => Users.fromJson(snapshot.data()!),
    toFirestore: (users, _) => users.toJson(),
  );
  FirebaseAuth auth = FirebaseAuth.instance;

  _fetchData() async {
    Users appUser = await appUserRef.doc(auth.currentUser?.uid).get().then((snapshot) => snapshot.data()!);
    setState(() {
      name = appUser.full_name;
      email = appUser.email_address!;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: kPrimaryColor,
        child: ListView(
          children: [
            buildHeader(
              urlImage:Image.asset("assets/profile.png"),
              name: name,
              email:email, onClicked: () {},
            ),
            Divider(color: Colors.white70,),
            Container(
              padding: padding,
              child: Column(
                children: [
                  buildMenuItem(
                    text: "Share",
                    icon: Icons.share,
                    onClicked: () => selectedItem(context, 0),
                  ),
                  buildMenuItem(
                    text: "About Us",
                    icon: Icons.info,
                    onClicked: () => selectedItem(context, 1),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,

  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: AutoSizeText(
        text,
        style: TextStyle(color: color),
      ),
      hoverColor: hoverColor,
      onTap:onClicked,
    );
  }

  void selectedItem(BuildContext context, int index){
    Navigator.of(context).pop();
    switch(index){
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>AboutUs(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>AboutUs(),
        ));
        break;

      default:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>AboutUs(),
        ));
        break;

    }
  }
  Widget buildHeader({

    required Image urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) => InkWell(
    onTap: onClicked,
    child: Container(
      padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
      child: Row(
        children: [
          CircleAvatar(radius: 30, backgroundImage: AssetImage("assets/images/profile.png")),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                name,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 4),
              AutoSizeText(
                email,
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget buildSearchField() {
    final color = Colors.white;

    return TextField(
      style: TextStyle(color: color),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        hintText: 'Search',
        hintStyle: TextStyle(color: color),
        prefixIcon: Icon(Icons.search, color: color),
        filled: true,
        fillColor: Colors.white12,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
      ),

    );
  }
}
