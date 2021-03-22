import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kissanmitra/screens/widgets/inputField.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NewBlog extends StatefulWidget {
  @override
  _NewBlogState createState() => _NewBlogState();
}

class _NewBlogState extends State<NewBlog> {
  List image = [];

  File main;
  List<String> urls = [];

  bool uploaded;
  TextEditingController name, model, details;
  @override
  void initState() {
    uploaded = false;
    name = TextEditingController();
    model = TextEditingController();
    details = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Blog"),
      ),
      body: (!uploaded)
          ? SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                      child: Column(
                    children: [
                      GestureDetector(
                        onLongPress: () {
                          setState(() {
                            main = null;
                          });
                        },
                        onTap: () async {
                          var tmp = await Statics.cropImage16(
                              size: CropAspectRatioPreset.original,
                              quality: 80);
                          setState(() {
                            if (tmp != null) main = tmp;
                          });
                        },
                        child: (main == null)
                            ? Container(
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    color:
                                        Colors.grey.shade100.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10)),
                                height:
                                    MediaQuery.of(context).size.width * 2 / 3,
                                width: MediaQuery.of(context).size.width - 50,
                                child: Icon(Icons.add),
                              )
                            : Image.file(
                                main,
                                fit: BoxFit.cover,
                              ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputTextField("Title", name),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputTextField(
                        "Tags",
                        model,
                        hint: "Space Seperated. Eg. Kisan DhartiPutr",
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputTextField(
                        "Add More",
                        details,
                        maxline: 20,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                        child: Text("POST"),
                        onPressed: () async {
                          if (main == null)
                            Statics.showToast("Please Select an Image");
                          else if (name.text.trim().isEmpty ||
                              details.text.trim().isEmpty)
                            Statics.showToast("All Fields are mendetory");
                          else {
                            setUploadData(context);
                            setState(() {
                              uploaded = true;
                            });
                          }
                        },
                      )
                    ],
                  )),
                ),
              ),
            )
          : Statics.getLoadingScreen(),
    );
  }

  Future setUploadData(context) async {
    String tmp = Timestamp.now().millisecondsSinceEpoch.toString();
    try {
      String mainimg = '';
      await FirebaseStorage.instance
          .ref()
          .child('Posts/$tmp/main/${basename(main.path)}')
          .putFile(main)
          .then((snap) async => mainimg = await snap.ref.getDownloadURL())
          .onError((error, stackTrace) => throw error);

      var tmp2 = FirebaseFirestore.instance.collection("posts").doc();
      await tmp2.set({
        'title': name.text.trim(),
        'details': details.text.trim(),
        'img': mainimg,
        'id': tmp2.id,
        'uid': Statics.getUid(),
        'uname': Statics.name,
        'time': Timestamp.now(),
        'likes':[],
        'comments':[],
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(Statics.getUid())
          .collection("posts")
          .doc(tmp2.id)
          .set({'id': tmp2.id});
      Statics.showToast("New Post added Successfully");
      Navigator.of(context).pop("success");
    } catch (e) {
      Statics.showToast(e.toString());
      await FirebaseFirestore.instance.collection('posts').doc(tmp).delete();
      setState(() {
        uploaded = false;
      });
    }
  }
}
