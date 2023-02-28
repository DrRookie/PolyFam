
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polyfam/models/profile_info.dart';
import 'package:polyfam/screens/all_chats_screen.dart';
import 'package:polyfam/screens/auth_screen.dart';
import 'package:polyfam/services/auth_service.dart';
import 'package:polyfam/services/google_sign_in.dart';
import 'package:polyfam/services/profileInfo_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';


class ProfileScreen extends StatelessWidget {
  static String routeName = '/userprofile';
  AuthService authService = AuthService();
  ProfileInfoService fsProfileInfoService = ProfileInfoService();





  logOut(BuildContext context) {


    if(authService.getCurrentUser() == null) {
      final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
      provider.logout();
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Navigator.pushReplacementNamed(context, "/auth");
    } else {
      return authService.logOut().then((value) {

      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Navigator.pushReplacementNamed(context, "/auth");
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


    return StreamBuilder<List<ProfileInformation>>(
      stream: fsProfileInfoService.getProfileInfo(),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: const Color(0xFF293462),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 332,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Color(0xFF008A5C).withOpacity(0.8),
                      spreadRadius: 0.5,
                      blurRadius: 10,
                      offset: Offset(2, 3),
                    )
                  ]),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Color(0xFF272D39),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 85, bottom: 25),
                              child: Column(
                                children: [
                                  Container(
                                      height: 130.0,
                                      width: 120.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('images/user_2.png'),
                                          fit: BoxFit.contain,
                                        ),
                                        shape: BoxShape.circle,
                                      )),
                                  Text(
                                    "ParryThePlatypus",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Archivo',
                                      color: Colors.greenAccent,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    "My name is Eric Dufmiz",
                                    style: TextStyle(
                                        fontFamily: 'AnekLatin',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "#LifeStyle #LovesOutdoors"
                                    "\n#Photography #Urban #Art",
                                    style: TextStyle(color: Colors.blueGrey),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Student at Temasek Polytechnic 📚💻",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 78),
                              child: Text(
                                "            3\nPosts made",
                                style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontFamily: 'Calvier Sans',
                                    fontSize: 18,
                                    color: Color(0xFFF13669)),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              IconButton(
                                  icon: Icon(Icons.edit_note_rounded),
                                  onPressed: () {},
                                  color: Color(0xFF31BCBC)),
                              IconButton(
                                  icon: Icon(Icons.exit_to_app_rounded),
                                  onPressed: ()=> {
                                    logOut(context)},
                                  color: Color(0xFF31BCBC)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: [
                          Color(0xFF22E4AC),
                          Color(0xFF1BD7BB),
                          Color(0xFF14C9CB),
                          Color(0xFF0FBED8),
                          Color(0xFF08B3E5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )),
                      child: Card(
                        color: Color(0xFF83361),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 305, bottom: 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "ABOUT ME",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.only(bottom: 55),
                                child: Column(
                                  children: [
                                    Center(
                                        child: Text(
                                      "My Gender:",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    )),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "My email:",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 35,
                                    ),
                                    Text(
                                      "About Me:",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
