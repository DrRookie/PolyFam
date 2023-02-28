

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:polyfam/services/auth_service.dart';
import 'package:polyfam/services/profileInfo_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:polyfam/widgets/profilePicture_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Navigator.pop(context);
    });
    return MaterialApp(
      theme: ThemeData(fontFamily: 'AnekLatin'),
      home: RegisterForm(),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  State<RegisterForm> createState() => _RegisterFormState();

}

class _RegisterFormState extends State<RegisterForm> {


  String? fullName;
  String? username;
  String? email;
  String? password;
  String? confirmPassword;
  String? aboutMe;
  String? hashtags;
  String? whatPoly;
  String? imageUrl;

  File? image;

  var form = GlobalKey<FormState>();

  Future<void> pickImage(mode) {

    return ImagePicker()
        .pickImage(source: mode)
        .then((imageFile) {
      if (imageFile != null) {
        setState(() {
          image = File(imageFile.path);
        });
      }
    });
  }


  register() {
    bool isValid = form.currentState!.validate();



    if (isValid) {
      form.currentState!.save();


        aboutMe = " ";
        hashtags = " ";


      if (password != confirmPassword) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Password and Confirm Password does not match!'),
        ));
      }

      AuthService authService = AuthService();
      ProfileInfoService profileInfoService = ProfileInfoService();



      return authService.register(email, password).then((value) {
        if (image == null) {
          return profileInfoService.addProfile(image, fullName, username, email,  whatPoly).then((value) {
            FocusScope.of(context).unfocus();
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User Registered successfully!'),));

            Navigator.of(context).pushReplacementNamed('/interactionscreen');
          });
        }
        else {
          return FirebaseStorage.instance.ref().child(DateTime.now().toString()+'_'+Path.basename(image!.path)).putFile(image!).then((task) {
            task.ref.getDownloadURL().then((imageUrl) {
              return profileInfoService.addProfile(imageUrl, fullName, username, email,  whatPoly).then((value) {
                FocusScope.of(context).unfocus();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User Registered successfully!'),));
                Navigator.of(context).pushReplacementNamed('/interactionscreen');

              });
            });
          });
        }



      }).catchError((error) {
        FocusScope.of(context).unfocus();
        String message = error.toString().contains('] ')
            ? error.toString().split('] ')[1]
            : 'An error has occurred.';
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: form,
      child: Padding(
        padding: EdgeInsets.only(bottom:MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditProfilePicture(image, pickImage),
            ),
      ]
    ),

            TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                icon: Icon(Icons.person, color: Colors.blueGrey),
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
                label: Text('Full Name'),
              ),
              onSaved: (value) {
                fullName = value;
              },
              validator: (fullName) {
                if (fullName == null) {
                  return "Please provide your name";
                } else {
                  return null;
                }
              },

            ),
            SizedBox(height: 10,),
            DropdownButtonFormField(
              style: TextStyle(color: Colors.lightBlue),
              decoration: InputDecoration(


                enabledBorder: OutlineInputBorder(
                  borderSide:
                  const BorderSide(width: 3, color: Color(0xFF1DB180)),
                  borderRadius: BorderRadius.circular(15),
                ),
                icon: Icon(Icons.school_rounded, color: Colors.blueGrey),
                label: Text('Choose the poly your from', style: TextStyle(color: Colors.white),),
              ),
              items: [
                DropdownMenuItem(child: Text('Singapore Poly',), value: 'Singapore Poly'),
                DropdownMenuItem(child: Text('Temasek Poly'), value: 'Temasek Poly'),
                DropdownMenuItem(child: Text('Nee Agnn Poly'), value: 'Nee Agnn Poly'),
                DropdownMenuItem(child: Text('Nanyang Poly'), value: 'Nanyang Poly'),
                DropdownMenuItem(child: Text('Republic Poly'), value: 'Republic Poly'),
              ],
              onChanged: (value) { whatPoly = value as String; },
              validator: (value) {
                if (value == null)
                  return "Please choose!";
                else
                  return null;
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
                style: TextStyle(color: Colors.amber),
                onSaved: (value) {
                  username = value;
                },
                validator: (username) {
                  if (username!.isEmpty) {
                    return "Please create a username!";
                  } else if (username.length > 16) {
                    return "Username should be < 15 characters";
                  }
                  return null;
                },
              decoration: InputDecoration(
                icon: Icon(Icons.account_box_outlined, color: Colors.blueGrey),
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
                label: Text('Username'),
              ),),
            SizedBox(height: 10,),
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
            SizedBox(height: 10,),
            TextFormField(
              style: TextStyle(color: Colors.green),
              decoration: InputDecoration(
                icon: Icon(Icons.password, color: Colors.blueGrey),
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
                label: Text('Password'),
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
            SizedBox(height: 15,),
            TextFormField(
              style: TextStyle(color: Colors.amber),
              decoration: InputDecoration(
                icon: Icon(Icons.password, color: Colors.blueGrey),
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
                label: Text('Confirm Password'),
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
                confirmPassword = value;
              },
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 115),
              child: ElevatedButton(

                  style: ElevatedButton.styleFrom(
                      shadowColor: Colors.red,
                      primary: Colors.pink,
                      fixedSize: const Size(159, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),

                  onPressed: () {
                    register();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.how_to_reg_rounded),
                      Padding(
                        padding: const EdgeInsets.only(left:15 ),
                        child: Text('Register', style: TextStyle(fontSize: 18, fontFamily: 'Archivo'),),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
