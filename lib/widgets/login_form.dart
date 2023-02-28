import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:polyfam/screens/reset_password_screen.dart';
import 'package:polyfam/services/auth_service.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String? email;
  String? password;

  var form = GlobalKey<FormState>();

  login() {
    bool isValid = form.currentState!.validate();

    if (isValid) {
      form.currentState!.save();

      AuthService authService = AuthService();

      return authService.login(email, password).then((value) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login successfully!'),
        ));
        Navigator.of(context).pushReplacementNamed('/interactionscreen');
      }).catchError((error) {
        FocusScope.of(context).unfocus();
        String message = error.toString().contains('] ')
            ? error.toString().split('] ')[1]
            : 'An error has occurred.';
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Email/Password is wrong, Try Again!'),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            style: TextStyle(color: Colors.amber),
            decoration: InputDecoration(
              icon: Icon(Icons.email, color: Colors.blueGrey),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 3, color: Color(0xFF1DB180)),
                borderRadius: BorderRadius.circular(15),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                width: 3,
                color: Color(0xFF1DB180),
              )),
              labelStyle: TextStyle(color: Colors.white),
              label: Text('Email'),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null) {
                return "Please provide an email address.";
              } else if (!value.contains('@')) {
                return "Please provide a valid email address.";
              } else {
                return null;
              }
            },
            onSaved: (value) {
              email = value;
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: TextFormField(
              style: TextStyle(color: Colors.amber),
              decoration: InputDecoration(
                icon: Icon(Icons.password, color: Colors.blueGrey),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Color(0xFF1DB180))),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 3, color: Color(0xFF1DB180)),
                  borderRadius: BorderRadius.circular(15),
                ),
                label: Text('Password'),
                labelStyle: TextStyle(color: Colors.white),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null)
                  return 'Please provide a password.';
                else if (value.length <= 6)
                  return 'Password must be at least 6 characters.';
                else
                  return null;
              },
              onSaved: (value) {
                password = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35),
            child: TextButton(onPressed: () {
              Navigator.of(context).pushNamed(ResetPasswordScreen.routeName);
            }, child: Text('Forgotten Password?', style: TextStyle(fontSize: 16, fontFamily: 'Archivo', color: Colors.purple),)),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 115),
            child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.red,
                    primary: Colors.pink,
                    fixedSize: const Size(150, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),

                onPressed: () {
                  login();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.login),
                    Padding(
                      padding: const EdgeInsets.only(left:22 ),
                      child: Text('Login', style: TextStyle(fontSize: 18, fontFamily: 'Calvier Sans'),),
                    ),
                  ],
                )),
          ),

        ],
      ),
    );
  }
}
