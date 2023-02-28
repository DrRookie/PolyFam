import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polyfam/services/auth_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  static String routeName = '/reset-password';

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String? email;
  var form = GlobalKey<FormState>();

  reset() {
    bool isValid = form.currentState!.validate();
    if (isValid) {
      form.currentState!.save();
      AuthService authService = AuthService();
      return authService.forgotPassword(email).then((value) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please check your email for to reset your password!'),
        ));
        Navigator.of(context).pop();
      }).catchError((error) {
        FocusScope.of(context).unfocus();
        String message = error.toString();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF272D39),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          child: Text("explore expand excite",
              style: TextStyle(
                  fontFamily: 'Calvier Sans',
                  fontSize: 17,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Color(0xFF008A5C),
                      offset: Offset(5, 5),
                      blurRadius: 9,
                    )
                  ])),
          preferredSize: Size.zero,
        ),
        shadowColor: Color(0xff008A5C),
        backgroundColor: Color(0xFF272D39),
        title: Padding(
          padding: const EdgeInsets.only(left: 115),
          child: Text(
            'PolyFam',
            style: TextStyle(
                fontSize: 35,
                fontFamily: 'Calvier Sans',
                color: Color(0xFF1DB180)),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(50),
        child: Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Please enter your registered email",
                style: TextStyle(
                    fontFamily: 'Archivo', fontSize: 18, color: Colors.amber),
              ),
              SizedBox(
                height: 15,
              ),
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
                  if (value == null)
                    return "Please provide an email address.";
                  else if (!value.contains('@'))
                    return "Please provide a valid email address.";
                  else
                    return null;
                },
                onSaved: (value) {
                  email = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    reset();
                  },
                  child: Text('Reset Password')),
            ],
          ),
        ),
      ),
    );
  }
}
