import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:to_do_app/views/Post_List_Screen.dart';

import 'SinUp_Screen.dart';

class SignIn_Screen extends StatefulWidget {
  const SignIn_Screen({Key? key}) : super(key: key);

  @override
  State<SignIn_Screen> createState() => _SignIn_ScreenState();
}

class _SignIn_ScreenState extends State<SignIn_Screen> {
  final FormKey = GlobalKey<FormState>();
  //condition for accessing the form form

  final auth = FirebaseAuth.instance;

  final email_controller = TextEditingController();
  final Password_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(
          children: [
            Form(
                key: FormKey,
                child: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller:  email_controller,
                        decoration: const InputDecoration(
                          hintText: "Emial",
                          prefixIcon: Icon(
                            Icons.email_outlined,
                          ),
                          border: InputBorder.none,
                        ),
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return "Please enter email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12.0),
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
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return "Please enter password";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 22.0),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async{
                                if (FormKey.currentState!.validate()) {
                                  var email = email_controller.text.trim();
                                  var password = Password_controller.text.trim();

                                  ProgressDialog progressDialog = ProgressDialog(
                                    context,
                                    title: const Text("Sign Up"),
                                    message: const Text("Wait"),
                                  );
                                  progressDialog.show();
                                  try{
                                   UserCredential userCredential = await  auth.signInWithEmailAndPassword(email: email, password: password);
                                   if (userCredential != null) {
                                     progressDialog.dismiss();
                                     Navigator.of(context).push(MaterialPageRoute(
                                         builder: (context) => const Post_List_Screen()));
                                     Fluttertoast.showToast(msg: "operation completed");
                                   }else{
                                     progressDialog.dismiss();
                                     Fluttertoast.showToast(msg: "operation are not completed");
                                   }
                                }on FirebaseAuthException catch (e){
                                    progressDialog.dismiss();
                                    if (e.code =='invalid-email') {
                                    Fluttertoast.showToast(msg: "email are invalid");
                                  } else if(e.code =='user-disabled'){
                                    Fluttertoast.showToast(msg: "you are restricted");
                                  }else if(e.code =='wrong-password'){
                                    Fluttertoast.showToast(msg: "Wrong password");
                                  }else if (e.code =='user-not-found') {
                                    Fluttertoast.showToast(msg: "Incorrect email");
                                  }
                                }
                                }
                              },
                              child: const Text("Log In"),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an acount"),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const SignUp_Screen()));
                              },
                              child: const Text(
                                "Create Acount",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ))
                        ],
                      )
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
