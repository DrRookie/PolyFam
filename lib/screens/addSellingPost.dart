import 'dart:io';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polyfam/services/tweetPost_service.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_core/firebase_core.dart';
import 'package:polyfam/services/sellingPost_service.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (ctx, snapshot) => MaterialApp(
        theme: ThemeData(fontFamily: 'AnekLatin'),
        home: AddSellingScreen(),
      ),
    );
  }
}

class AddSellingScreen extends StatefulWidget {
  static String routeName = '/add-sellingpost';

  @override
  State<AddSellingScreen> createState() => _AddSellingScreenState();
}

class _AddSellingScreenState extends State<AddSellingScreen> {
  var form = GlobalKey<FormState>();
  SellingPostService fsSellingService = SellingPostService();

  String? item;

  String? location;

  String? phoneNumber;

  DateTime? datePosted;

  File? sellingPhoto;

  void saveForm() {
    bool isValid = form.currentState!.validate();
    datePosted ??= DateTime.now();

    if (sellingPhoto == null) {

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
          Path.basename(sellingPhoto!.path))
          .putFile(sellingPhoto!)
          .then((task) {
        task.ref.getDownloadURL().then((imageUrl) {
          fsSellingService.addSellingPost(item, location, phoneNumber, datePosted, imageUrl);

        });
      });
      // Hide the keyboard
      FocusScope.of(context).unfocus();
      // Resets the form
      form.currentState!.reset();
      // Shows a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Post added successfully!'),
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
          sellingPhoto = File(imageFile.path);
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
                        "What are you selling? Explain.",
                        style: TextStyle(color: Colors.greenAccent, fontSize: 18),
                      )),
                  onSaved: (value) {
                    item = value;
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
                        child: sellingPhoto != null
                            ? FittedBox(
                            fit: BoxFit.fill,
                            child: Image.file(sellingPhoto!))
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
                      label: Text('Where to meet up?',
                          style: TextStyle(
                              color: Colors.greenAccent, fontSize: 17))),
                  onSaved: (value) {
                    location = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please do not leave it empty";
                    }
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      label: Text('Phone Number?',
                          style: TextStyle(
                              color: Colors.greenAccent, fontSize: 17))),
                  onSaved: (value) {
                    phoneNumber = value ;
                  },
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please do not leave it empty";
                    } else if(double.tryParse(value) == null)
                      return "number please";
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
