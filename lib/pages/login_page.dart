import 'package:event_app/components/my_button.dart';
import 'package:event_app/components/my_textfield.dart';
// import 'package:event_app/screens/auth_screen.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() {
    print('Sign user in');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(
                    image: AssetImage('assets/images/Landing.png'),
                    width: 300,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Selamat Datang!',
                style: TextStyle(color: Colors.grey[700], fontSize: 20),
              ),
              SizedBox(height: 20),
              MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  }),
              SizedBox(height: 20),
              MyTextField(
                key: GlobalKey<FormState>(), // Add this
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Lupa Password?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              MyButton(
                text: 'Login',
                onTap: signUserIn,
              ),
              SizedBox(height: 20),
              MyButton(
                text: 'Register',
                onTap: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
