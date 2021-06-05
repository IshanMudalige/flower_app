import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flower_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';


class AddScreen extends StatefulWidget {

  final Callback goBack;

  const AddScreen({Key key, this.goBack}) : super(key: key);

  @override
  _AddScreen createState() => _AddScreen();
}

class _AddScreen extends State<AddScreen> {
  double width, height;

  bool _validate = false;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerDesc = TextEditingController();
  TextEditingController controllerCat = TextEditingController();

  File _image;
  final _picker = ImagePicker();

  Future getImageFromCamera() async {
    PickedFile image = await _picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(image.path);
    });
  }

  Future getImageFromGallery() async {
    PickedFile image = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image.path);
    });
  }

  void saveResult() async {
    print(">>>>>>>>>> saving");
    String fileName = basename(_image.path);
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      FirebaseDatabase.instance.reference().child("FlowersList").child(time)
          .set({
        'name': controllerName.text,
        'desc': controllerDesc.text,
        'cat': controllerCat.text,
        'imgName': fileName,
        'token':'my',
        'id':time,
        'rating':'.'
      });
      uploadImageToFirebase();
    }catch(Exception){
      print('error');
    }
  }

  Future uploadImageToFirebase() async {
    String fileName = basename(_image.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('$fileName');
    UploadTask uploadTask = ref.putFile(_image);
    uploadTask.then((res) {
      res.ref.getDownloadURL();
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),

            ),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Add Flower',
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_sharp,
            ),
            onPressed: () {widget.goBack();},
            color: Colors.black,
            splashRadius: 20,
          ),
        ),
        body: _body(context));
  }

  Widget _body(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0,8,0,0),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap:  (){_settingModalBottomSheet(context);},
              child:Container(
              margin: EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.grey)),
              child:  _image == null
                  ? new Center(child:Icon(Icons.camera_alt_outlined,size:40))
                  : new ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child:Image.file(_image,height: height/3,fit: BoxFit.fill,)),
            ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              child: Column(
                children: [
                  buildTextField('Flower Name', controllerName, 1),
                  SizedBox(height: 8,),
                  buildTextField('Category', controllerCat, 1),
                  SizedBox(height: 8,),
                  buildTextField('Description', controllerDesc, 15),
                  SizedBox(height: 8,),
                  button(context),
                  SizedBox(height: 8,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String hintText, TextEditingController controller, int maxLines) {
    return TextField(
      maxLines: maxLines,
      controller: controller,
      decoration: InputDecoration(
        errorText: _validate ? 'Value Can\'t Be Empty' : null,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 14.0,
        ),
        focusedBorder:OutlineInputBorder(
          borderSide: const BorderSide(color: lightPink,),
          borderRadius: BorderRadius.circular(10.0),
        ),
        labelText: hintText,
        labelStyle: TextStyle(color: Colors.grey,),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Widget button(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints.expand(width: width * 0.6, height: height * 0.07),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            if (controllerName.text.isEmpty || controllerDesc.text.isEmpty || controllerCat.text.isEmpty){
              _validate = true;
            }else if(_image == null) {
              _validate = false;
              final snackBar = SnackBar(
                backgroundColor: lightPink2,
                content: Text('Please select an image',style:TextStyle(color:darkPink)),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }else {
              _validate = false;
              saveResult();
              setState(() {
                controllerName.clear();
                controllerDesc.clear();
                controllerCat.clear();
                _image = null;
              });
              final snackBar = SnackBar(
                backgroundColor: lightPink2,
                content: Text('Flower successfully added',style:TextStyle(color:darkPink)),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          });
          },
        child: Text('Add'),
        style: ElevatedButton.styleFrom(
          primary: darkPink,
          textStyle: TextStyle(color: Colors.white),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }


  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            padding: EdgeInsets.only(top: 32,bottom: 32),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(icon: Icon(Icons.camera_alt_outlined,color: darkPink,),iconSize: 50, onPressed: (){Navigator.pop(context);getImageFromCamera();}),
                    Text('Camera')
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(icon: Icon(Icons.image_outlined,color: darkPink),iconSize: 50, onPressed: (){Navigator.pop(context);getImageFromGallery();}),
                    Text('Gallery')
                  ],
                ),
              ],
            ),
          );
        }
    );
  }


}

typedef Callback = void Function();
