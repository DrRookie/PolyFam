import 'package:flutter/material.dart';
import 'package:polyfam/screens/all_chats_screen.dart';

import '../screens/theWeatherScreen.dart';
bool _debugLocked = false;

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: MainAppBar(),
    );
  }
}

class MainAppBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
      actions:  [Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          children: [
            IconButton(icon:Icon(Icons.sunny), onPressed: () => Navigator.of(context).pushNamed(TheWeatherScreen.routeName)),
            IconButton(icon:Icon(Icons.chat), onPressed: () => Navigator.of(context).pushReplacementNamed(ChatsScreen.routeName), ),
          ],
        ),
      )],
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
    );
  }
}
