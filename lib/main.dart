import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polyfam/screens/addInteractionPost.dart';
import 'package:polyfam/screens/auth_screen.dart';
import 'package:polyfam/screens/chat_message_screen.dart';
import 'package:polyfam/screens/editInteractionPost.dart';
import 'package:polyfam/screens/interaction_screen.dart';
import 'package:polyfam/screens/profile_screen.dart';
import 'package:polyfam/screens/reset_password_screen.dart';
import 'package:polyfam/screens/theWeatherScreen.dart';
import 'package:polyfam/services/auth_service.dart';
import 'package:polyfam/services/google_sign_in.dart';
import 'package:polyfam/widgets/BackgroundImage_widget.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/profile_info.dart';
import 'screens/all_chats_screen.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}




class MyApp extends StatelessWidget {

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child:

          // SystemChrome.setSystemUIOverlayStyle(
          //     const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

          FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : StreamBuilder<User?>(
                stream: authService.getAuthUser(),
                builder: (context, snapshotEmailAndPassword) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: snapshotEmailAndPassword.connectionState == ConnectionState.waiting
                        ? Center(child: CircularProgressIndicator())
                        : snapshotEmailAndPassword.hasData
                            ? InteractionScreen()
                            : AuthScreen(),
                    routes: {
                      TheWeatherScreen.routeName: (_) {
                        return TheWeatherScreen();
                      },
                      ResetPasswordScreen.routeName: (_) {
                        return ResetPasswordScreen();
                      },
                      MainScreen.routeName: (_) {
                        return MainScreen();
                      },
                      InteractionScreen.routeName: (_) {
                        return InteractionScreen();
                      },
                      ChatsScreen.routeName: (_) {
                        return ChatsScreen();
                      },
                      ChatMessageScreen.routeName: (_) {
                        return ChatMessageScreen();
                      },
                      ProfileScreen.routeName: (_) {
                        return ProfileScreen();
                      },
                      AddInteractionScreen.routeName: (_) {
                        return AddInteractionScreen();
                      },
                      EditInteractionScreen.routeName: (_) {
                        return EditInteractionScreen();
                      },
                      AuthScreen.routeName: (_) {
                        return AuthScreen();
                      },
                    },
                  );
                }),
      ));
}

class MainScreen extends StatelessWidget {
  static String routeName = '/main';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        BackgroundImageWidget(),
        Positioned(
          top: 190,
          left: 70,
          child: Column(
            children: [
              Image.asset(
                "images/Logo.png",
                colorBlendMode: BlendMode.darken,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("explore expand excite",
                  style: TextStyle(
                      fontFamily: 'Calvier Sans',
                      fontSize: 20,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Color(0xFF008A5C),
                          offset: Offset(5, 5),
                          blurRadius: 9,
                        )
                      ])),
              const SizedBox(
                height: 200,
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context)
                    .pushReplacementNamed(AuthScreen.routeName),
                child: const Text(
                  'GET STARTED',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      shadows: [
                        Shadow(
                            color: Colors.black26,
                            offset: Offset(2.8, 5.5),
                            blurRadius: 10)
                      ]),
                ),
                style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF008A5C),
                    fixedSize: const Size(246, 52),
                    shape: const StadiumBorder()),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
