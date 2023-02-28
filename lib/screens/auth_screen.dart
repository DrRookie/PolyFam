
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:polyfam/screens/reset_password_screen.dart';

import 'package:polyfam/services/auth_service.dart';
import 'package:polyfam/widgets/login_form.dart';
import 'package:polyfam/widgets/register_form.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/google_sign_in.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context)  => ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child:MaterialApp(
          theme: ThemeData(fontFamily: 'AnekLatin'),
          home: AuthScreen(),
          debugShowCheckedModeBanner: false,
        ),

    );

}



class AuthScreen extends StatefulWidget {
  static String routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthService authService = AuthService();

  bool loginScreen = true;
  bool registerSection = true;



  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator(),);
        else if (snapshot.hasError) {
          return Center(child: Text("Something went wrong"),);
        }
        else if(snapshot.hasData) {
          Navigator.pushReplacementNamed(context, "/interactionscreen");
        }
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
                      ])
              ),
              preferredSize:Size.zero,
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
          body: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                Padding(
                  padding:
                      registerSection ?
                  EdgeInsets.only(top: 15, bottom: 35): EdgeInsets.only(top: 10, bottom: 5),

                  child: Container(child: Image.asset("images/Logo.png"),),
                ),
                Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        loginScreen ? LoginForm() : RegisterForm(),
                        SizedBox(height: 5),
                        loginScreen ? TextButton(onPressed: () {
                          setState(() {
                            registerSection = false;
                            loginScreen = false;
                          });
                        }, child: Text('No account? Sign up here!', style: TextStyle(fontSize: 16),)) :
                        TextButton(onPressed: () {
                          setState(() {
                            loginScreen = true;
                            registerSection = true;
                          });
                        }, child: Text('Exisiting user? Login in here!',style: TextStyle(fontSize: 16),)),

                        loginScreen ?
                        SignInButton(

                          Buttons.Google,
                          onPressed: () {

                            final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                            provider.googleLogin();



                          }
                        ) : Center()
                      ],
                    )
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
