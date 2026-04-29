import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class signUpPage extends StatefulWidget {
  const signUpPage({super.key});

  @override
  State<signUpPage> createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;

  Future<void> signUp() async {

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(email.isEmpty || password.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email and password cannot be empty")));
    }

  }

  @override


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0094ff),
        title: Text('Sign Up', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child:
        Container(
          width: 500,
          height: 240,
          decoration: BoxDecoration(
            color: Color(0xffececec), // The background color of the container
            borderRadius: BorderRadius.circular(
              20,
            ), // Applies a 20px radius to all corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Insert email',
                    border: OutlineInputBorder(),
                  ),
                  controller: emailController,
                ),
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter password',
                    border: OutlineInputBorder(),
                  ),
                  controller: passwordController,
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent),
                      onPressed: () async {
                        try {
                          final userCredential = await auth.createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text
                          );

                          final user = userCredential.user;

                          if (user == null){
                            throw Exception("User login unsuccessful");
                          }

                          Navigator.pushReplacementNamed(context, "/");
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Email and password cannot be empty")));
                          print("Error: ${e}");
                        }
                      },
                      child: Text('Sign Up'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
