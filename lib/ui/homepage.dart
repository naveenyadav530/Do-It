import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doit/color.dart';
import 'package:doit/ui/login.dart';
import 'package:doit/utils/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference todo = FirebaseFirestore.instance.collection("users");
  String input = "";
  bool progress = false;

  _addData(String data){
    todo.doc(auth.currentUser?.uid).collection("do_it").doc("todo").update({
      "doit":FieldValue.arrayUnion([data])
    }).then((value) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(const SnackBar(
            content: Text("ToDo added Successfully.")));
      Navigator.of(context).pop();
    }).catchError((e){
      _errorCheck(e);
    });

  }

  _removeData(String data){
    todo.doc(auth.currentUser?.uid).collection("do_it").doc("todo").update({
      "doit":FieldValue.arrayRemove([data])
    }).then((value) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(const SnackBar(
            content: Text("ToDo removed Successfully.")));
    }).catchError((e){
      _errorCheck(e);
    });
  }
  _errorCheck(e) {
    switch (e.code) {
      case 'network-request-failed':
        setState(() => progress = false);
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(
              content: Text("Internet Down, Check Your Connection")));
        break;

      default:
        setState(() => progress = false);
        if (kDebugMode) {
          print(e.code);
        }
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(
              content: Text("Technical Error, Please try again.")));
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: const AutoSizeText("DO IT"),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Log Out Successful')));
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LogIn()));
                });
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body:
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection("users").doc(auth.currentUser?.uid).collection("do_it").doc("todo").snapshots(),
            builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot){
              if( snapshot.hasData){
                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                List todos = data["doit"];
                return  ListView.builder(
                    itemCount:todos.length,
                    itemBuilder: (BuildContext context, int index){
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Text(todos[index]),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: dangerColor,
                            ),
                            onPressed: (){
                             _removeData(todos[index]);
                            },
                          ),
                        ),
                      );
                    });
              }
              if (snapshot.hasError) {
                print(snapshot.error);
                return const Center(child: Text('Something went wrong'));
              }

              return const Center(child: CircularProgressIndicator(color: dangerColor,),);


            },
          ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  title: Text("DO IT",style: TextStyle(color: kPrimaryColor),),
                  content: TextField(
                    onChanged: (String value) {
                      input = value;
                    },
                  ),
                  actions: [
                    InkWell(
                        onTap:  () {
                          _addData(input);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: const Text("Add",style: TextStyle(color: warningColor),),
                        ))
                  ],
                );
              });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
