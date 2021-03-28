import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kissanmitra/screens/widgets/inputField.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddFertilizer extends StatefulWidget {
  @override
  _AddFertilizerState createState() => _AddFertilizerState();
}

class _AddFertilizerState extends State<AddFertilizer> {
  List image = [];

  File main;
  List<String> urls = [];
  List<File> img = [
    null,
    null,
    null,
    null,
    null,
  ];

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
        title: Text('Add Fertilizer'),
      ),
      body: (!uploaded)
          ? SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                      child: Column(
                    children: [
                      MyInputTextField("Name", name),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputTextField("Crops", model),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputTextField(
                        "Details",
                        details,
                        maxline: 20,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Text(
                        "Main Image",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                      Divider(
                        thickness: 1,
                      ),
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
                      Divider(
                        thickness: 1,
                      ),
                      Text(
                        "Sub Image",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            myImageAdd(0),
                            myImageAdd(1),
                            myImageAdd(2),
                            myImageAdd(3),
                            myImageAdd(4),
                          ],
                        ),
                      ),
                      RaisedButton(
                        child: Text("Upload"),
                        onPressed: () async {
                          if (main == null)
                            Statics.showToast("Please Select an Image");
                          else if (model.text.trim().isEmpty ||
                              name.text.trim().isEmpty ||
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

  Future<String> uploadImage(String tmp) async {
    int a = 0;
    for (int i = 0; i < 5; ++i) if (img[i] != null) a += 1;
    for (int i = 0; i < 5; ++i) {
      if (img[i] != null) {
        String fileName = basename(img[i].path);
        var ref =
            FirebaseStorage.instance.ref().child('fertilizers/$tmp/sub/$fileName');

        await ref.putFile(img[i]);
        String link = await ref.getDownloadURL();
        urls.add(link);
      }
    }
    if (urls.length == a) return Future.value("Done");
  }

  Widget myImageAdd(int i) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          img[i] = null;
        });
      },
      onTap: () async {
        var tmp = await Statics.cropImage16();
        print("Path : $tmp");
        setState(() {
          if (tmp != null) img[i] = tmp;
        });
      },
      child: (img[i] == null)
          ? Container(
              decoration: BoxDecoration(
                  border: Border.all(),
                  color: Colors.grey.shade100.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10)),
              height: 50,
              width: 50,
              child: Icon(Icons.add),
            )
          : SizedBox(
              height: 50,
              width: 50,
              child: Image.file(
                img[i],
                fit: BoxFit.cover,
              ),
            ),
    );
  }

  Future setUploadData(context) async {
    String tmp = Timestamp.now().millisecondsSinceEpoch.toString();
    try {
      String mainimg = '';
      await FirebaseStorage.instance
          .ref()
          .child('fertilizers/$tmp/main/${basename(main.path)}')
          .putFile(main)
          .then((snap) async => mainimg = await snap.ref.getDownloadURL())
          .onError((error, stackTrace) => throw error);
      await uploadImage(tmp);

      print("DEBUG : urls $urls , main : $main sub : $image");
      await FirebaseFirestore.instance
          .collection("fertilizers")
          .doc(tmp.toString())
          .set({
        'name': name.text.trim(),
        'crops': model.text.trim(),
        'details': details.text.trim(),
        'main': mainimg,
        'id': tmp,
        'sub': FieldValue.arrayUnion(urls)
      });
      await FirebaseFirestore.instance
          .collection('fertilizers')
          .doc(tmp)
          .update({'sub': FieldValue.arrayUnion(urls)});
      // Statics.showToast(urls.toString());
      Statics.showToast("New Machine added Successfully");
      Navigator.of(context).pop("success");
    } catch (e) {
      Statics.showToast(e.toString());
      await FirebaseFirestore.instance.collection('fertilizers').doc(tmp).delete();
      setState(() {
        uploaded = false;
      });
    }
  }
}
