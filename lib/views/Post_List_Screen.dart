import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:to_do_app/views/Add_Post_Screen.dart';
import 'package:to_do_app/views/SignIn_Screen.dart';

class Post_List_Screen extends StatefulWidget {
  const Post_List_Screen({Key? key}) : super(key: key);

  @override
  State<Post_List_Screen> createState() => _Post_List_ScreenState();
}

class _Post_List_ScreenState extends State<Post_List_Screen> {
  final Db_ref = FirebaseDatabase.instance.ref("User");
  final user = FirebaseAuth.instance;

  final filterController = TextEditingController();
  final Update_Tast_Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post List"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text("Confrimation"),
                          content: const Text("Are you sure to log out"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  user.signOut();
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignIn_Screen()));
                                },
                                child: const Text("Yes")),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("No"))
                          ],
                        ));
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AddPostScreen()));
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          TextField(
            controller: filterController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search_outlined),
              hintText: "Search here",
            ),
            onChanged: (String value) {
              setState(() {});
            },
          ),
          Expanded(
            child: StreamBuilder(
              stream: Db_ref.onValue,
              builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as Map;
                List<dynamic> list = [];
                list.clear();
                list = map.values.toList();
                if (!snapshot.hasData) {
                  ProgressDialog progressDialog = ProgressDialog(
                    context,
                    title: const Text("loading"),
                    message: const Text("Wait"),
                  );
                  progressDialog.show();

                }else{
                  return ListView.builder(
                      itemCount: snapshot.data!.snapshot.children.length,
                      itemBuilder: (context, index) {
                        //for filtration purpose
                        final filter = filterController.text.toString();
                        final subtitle = list[index]["Post"].toString();
                        final  taskId = list[index]["UserId"].toString();
                        if (filter.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Card(
                              child: ListTile(
                                  title: Text(list[index]["UserId"]),
                                  subtitle: Text(list[index]["Post"].toString()),
                                  trailing: PopupMenuButton(
                                    child: const Icon(Icons.more_vert),
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                          child: ListTile(
                                            onTap:(){
                                              Navigator.pop(context);
                                              ShowMyDialog(subtitle, taskId);
                                            },
                                            leading: Icon(Icons.edit_outlined),
                                            title: Text("Edite"),
                                          )),
                                      PopupMenuItem(
                                          child: ListTile(
                                            onTap: () {
                                              Db_ref.child(taskId).remove();
                                              Navigator.of(context).pop();
                                            },
                                            leading: Icon(Icons.delete_outline),
                                            title: Text("Delete"),
                                          ))
                                    ],
                                  )),
                            ),
                          );
                        } else if (subtitle.toString().toLowerCase().contains(filter.toString().toLowerCase())) {
                          return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Card(
                                  child: ListTile(
                                      title:
                                      Text(list[index]["UserId"].toString()),
                                      subtitle: Text(list[index]["Post"]),
                                      trailing: PopupMenuButton(
                                        child:
                                        const Icon(Icons.more_vert_outlined),
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                              value: 1,
                                              child: ListTile(
                                                onTap:(){
                                                  Navigator.pop(context);
                                                  ShowMyDialog(subtitle,taskId);
                                                },
                                                leading: Icon(Icons.edit_outlined),
                                                title: Text("Edite"),
                                              )),
                                          PopupMenuItem(
                                              value: 1,
                                              child: ListTile(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Db_ref.child(taskId).remove();
                                                },
                                                leading: const Icon(
                                                    Icons.delete_outline),
                                                title: Text("Delete"),
                                              )),
                                        ],
                                      ))));
                        } else {
                          return Container();
                        }
                      });
                }
               return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
  Future<void> ShowMyDialog(String Task_text , String id) async {
    Update_Tast_Controller.text = Task_text;
    return showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text("Updating"),
      content:  TextField(
        controller:  Update_Tast_Controller,
      ),

      actions: [
        TextButton(onPressed: (){
          Db_ref.child(id).update({
            "Post": Update_Tast_Controller.text,
          });
          Navigator.pop(context);
        }, child: const Text("Update")),
        TextButton(onPressed: (){
          Navigator.of(context).pop();
        }, child: const Text("No"))

      ],
    ));
  }
  }
