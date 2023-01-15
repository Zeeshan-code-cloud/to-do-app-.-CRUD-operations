import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:to_do_app/views/Post_List_Screen.dart';
import 'package:to_do_app/views/SignIn_Screen.dart';

class SignUp_Screen extends StatefulWidget {
  const SignUp_Screen({Key? key}) : super(key: key);

  @override
  State<SignUp_Screen> createState() => _SignUp_ScreenState();
}

class _SignUp_ScreenState extends State<SignUp_Screen> {
  final auth = FirebaseAuth.instance;
  final Db_ref = FirebaseDatabase.instance.ref("User");
  final FormKey = GlobalKey<FormState>();
  final email_controller = TextEditingController();
  final Password_controller = TextEditingController();
  final Confirm_Password_conroller = TextEditingController();

  final fullNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register yourself"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Form(
              key: FormKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: fullNameController,
                      decoration: const InputDecoration(
                        hintText: "Full Name",
                        prefixIcon: Icon(
                          Icons.person_outline_rounded,
                        ),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "enter full name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      controller: email_controller,
                      obscureText: false,
                      decoration: const InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(
                          Icons.email_outlined,
                        ),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      controller: Password_controller,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                        ),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "enter password";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      controller: Confirm_Password_conroller,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                        ),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return " enter password";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (FormKey.currentState!.validate()) {
                        var Email = email_controller.text.trim();
                        var Password = Password_controller.text.trim();
                        var Confirm_Password = Confirm_Password_conroller.text.trim();
                        var fullName = fullNameController.text.trim();

                        if (Email.isEmpty ||
                            Password.isEmpty ||
                            Confirm_Password.isEmpty) {
                          Fluttertoast.showToast(msg: "fill all field");
                        }
                        if (Password.length < 6) {
                          Fluttertoast.showToast(msg: "Weak Password");
                          return;
                        }
                        if (Password != Confirm_Password) {
                          Fluttertoast.showToast(
                              msg: "Passwords are not matching");
                          return;
                        }
                        ProgressDialog progressDialog = ProgressDialog(
                          context,
                          title: const Text("Sign Up"),
                          message: const Text("Wait"),
                        );
                        progressDialog.show();
                        try {
                          UserCredential userCredential =
                              await auth.createUserWithEmailAndPassword(
                                  email: Email, password: Password);

                          if (userCredential.user != null) {
                            final uid = userCredential.user!.uid.toString();
                            Db_ref.child(uid).set({
                              "Full Name": fullName,
                              "email": Email,
                              "user Id": uid,
                            });
                            progressDialog.dismiss();
                            Navigator.of(context).pop();
                            Fluttertoast.showToast(msg: "Success");
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const Post_List_Screen()));
                          } else {
                            Fluttertoast.showToast(msg: "Operation Failed");
                          }
                        } on FirebaseAuthException catch (e) {
                          progressDialog.dismiss();
                          if (e.code == "weak-password") {
                            Fluttertoast.showToast(
                                msg: "Provide Strong password");
                          }
                          if (e.code == "email-already-in-use") {
                            Fluttertoast.showToast(
                                msg: "email already in other acount");
                            return;
                          }
                          if (e.code == "operation-not-allowed") {
                            Fluttertoast.showToast(
                                msg: "following acount are disabled");
                          }
                        }
                      }
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already  have an acount"),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignIn_Screen()));
                  },
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
