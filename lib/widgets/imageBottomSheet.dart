import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomBottomSheet extends StatefulWidget {

  Function pickImage;

  CustomBottomSheet(this.pickImage);

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text('Choose Image:', style: TextStyle(fontFamily: 'Quicksand',fontWeight: FontWeight.bold, fontSize: 23, color: Colors.black)),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                  icon: Icon(Icons.camera_alt, color: Colors.black, size: 35,),
                  onPressed: () {
                    widget.pickImage(ImageSource.camera);
                  },
                  label: Text('CAMERA', style: TextStyle(fontFamily: 'Quicksand',fontWeight: FontWeight.bold, fontSize: 23, color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      elevation: 0
                  )
              ),
              ElevatedButton.icon(
                  icon: Icon(Icons.image, color: Colors.black, size: 35,),
                  onPressed: () {
                    widget.pickImage(ImageSource.gallery);
                  },
                  label: Text('GALLERY', style: TextStyle(fontFamily: 'Quicksand',fontWeight: FontWeight.bold, fontSize: 23, color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      elevation: 0
                  )
              ),
            ],
          )
        ],
      ),
    );
  }
}