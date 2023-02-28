import 'dart:io';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polyfam/services/tweetPost_service.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_core/firebase_core.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (ctx, snapshot) => MaterialApp(
        theme: ThemeData(fontFamily: 'AnekLatin'),
        home: AddInteractionScreen(),
      ),
    );
  }
}

class AddInteractionScreen extends StatefulWidget {
  static String routeName = '/add-interactionpost';

  @override
  State<AddInteractionScreen> createState() => _AddInteractionScreenState();
}

class _AddInteractionScreenState extends State<AddInteractionScreen> {
  var form = GlobalKey<FormState>();
  TweetPostService fsTweetService = TweetPostService();

  String? tweet;

  String? tag;

  DateTime? postDate;

  File? interactionPhoto;

  void saveForm() {
    bool isValid = form.currentState!.validate();
    postDate ??= DateTime.now();

    if (interactionPhoto == null) {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.black,
        content: Text('Please include a image!' ,style: TextStyle(color: Colors.amber),),
      ));
      return;
    }

    if (isValid) {
      form.currentState!.save();

      FirebaseStorage.instance
          .ref()
          .child(DateTime.now().toString() +
              '_' +
              Path.basename(interactionPhoto!.path))
          .putFile(interactionPhoto!)
          .then((task) {
        task.ref.getDownloadURL().then((imageUrl) {
          fsTweetService.addTweetPost(imageUrl,postDate, tweet, tag);

        });
      });
      // Hide the keyboard
      FocusScope.of(context).unfocus();
      // Resets the form
      form.currentState!.reset();
      // Shows a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Tweet added successfully!'),
      ));
      Navigator.of(context).pushReplacementNamed('/interactionscreen');
    }
  }

  Future<void> pickImage(mode) {
    ImageSource chosenSource =
        mode == 0 ? ImageSource.camera : ImageSource.gallery;
    return ImagePicker()
        .pickImage(
            source: chosenSource,
            maxWidth: 600,
            imageQuality: 50,
            maxHeight: 150)
        .then((imageFile) {
      if (imageFile != null) {
        setState(() {
          interactionPhoto = File(imageFile.path);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      label: Text(
                    "What's Happening?",
                    style: TextStyle(color: Colors.greenAccent, fontSize: 18),
                  )),
                  onSaved: (value) {
                    tweet = value;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please do not leave it empty";
                    }
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 150,
                        height: 100,
                        decoration: BoxDecoration(color: Colors.grey),
                        child: interactionPhoto != null
                            ? FittedBox(
                                fit: BoxFit.fill,
                                child: Image.file(interactionPhoto!))
                            : Center()),
                    Column(
                      children: [
                        TextButton.icon(
                            icon: Icon(Icons.camera_alt),
                            onPressed: () => pickImage(0),
                            label: Text('Take Photo')),
                        TextButton.icon(
                            icon: Icon(Icons.image),
                            onPressed: () => pickImage(1),
                            label: Text('Add Image')),
                      ],
                    )
                  ],
                ),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      label: Text('Provide a tag',
                          style: TextStyle(
                              color: Colors.greenAccent, fontSize: 17))),
                  onSaved: (value) {
                    tag = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please do not leave it empty";
                    }
                  },
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 340),
                  child: IconButton(
                      onPressed: () {
                        saveForm();
                      },
                      icon: Icon(Icons.save),
                      color: Colors.greenAccent),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
