import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/views/Post_List_Screen.dart';

class AddPostScreen extends StatefulWidget {
  AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final AddPostController = TextEditingController();

  final Db_ref = FirebaseDatabase.instance.ref("User");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Posts"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            TextField(
              maxLines: 5,
              controller: AddPostController,
              decoration: const InputDecoration(
                hintText: "Whats on in your mind",
              ),
            ),
            const SizedBox(height: 22.0),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          String uid = DateTime.now().millisecondsSinceEpoch.toString();
                          Db_ref.child(uid).set({
                            "Post" : AddPostController.text.trim(),
                            "UserId" : uid,
                          }
                          );

                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const Post_List_Screen()));
                        }, child: const Text("submit"))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
