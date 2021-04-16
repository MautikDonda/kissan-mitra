import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kissanmitra/screens/widgets/inputField.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddPlant extends StatefulWidget {
  @override
  _AddPlantState createState() => _AddPlantState();
}

class _AddPlantState extends State<AddPlant> {
  TextEditingController name, duration, details;
  List image = [];
  List<String> urls = [];
  List<File> img = [
    null,
    null,
    null,
    null,
    null,
  ];

  File main;
  bool uploaded;
  @override
  void initState() {
    uploaded = false;
    name = TextEditingController();
    duration = TextEditingController();
    details = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (!uploaded)
          ? SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                      child: Column(
                    children: [
                      Divider(
                        thickness: 1,
                      ),
                      Text(
                        "New Plant Details",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputTextField("Name", name),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputTextField("duration", duration),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputTextField(
                        "Details",
                        details,
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 8,
                              child: (main != null)
                                  ? Text(
                                      '${main.path}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    )
                                  : Text("No Image Selected",
                                      textAlign: TextAlign.center),
                            ),
                            Expanded(
                              flex: 2,
                              child: IconButton(
                                  icon: Icon(Icons.image_outlined),
                                  // tooltip: 'Choose Image',
                                  onPressed: () async {
                                    var tmp = await ImagePicker.pickImage(
                                        imageQuality: 50,
                                        source: ImageSource.gallery);

                                    // Statics.showToast(tmp.path);
                                    setState(() {
                                      main = new File(tmp.path);
                                    });
                                  }),
                            )
                          ],
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
                          else if (duration.text.trim().isEmpty ||
                              name.text.trim().isEmpty ||
                              details.text.trim().isEmpty)
                            Statics.showToast("All Fields are mendetory");
                          else {
                            uploadData(context);
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

  Future<void> uploadImage(String tmp) async {
    int a = 0;
    for (int i = 0; i < 5; ++i) if (img[i] != null) a += 1;
    for (int i = 0; i < 5; ++i) {
      if (img[i] != null) {
        String fileName = basename(img[i].path);
        var ref =
            FirebaseStorage.instance.ref().child('plants/$tmp/sub/$fileName');

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

  Future<void> uploadData(context) async {
    String tmp = Timestamp.now().millisecondsSinceEpoch.toString();
    try {
      List urls = [];
      String mainimg = '';
      await FirebaseStorage.instance
          .ref()
          .child('plants/$tmp/main/${basename(main.path)}')
          .putFile(main)
          .then((snap) async => mainimg = await snap.ref.getDownloadURL())
          .onError((error, stackTrace) => throw error);

      await uploadImage(tmp);
      print("DEBUG : urls $urls , main : $main sub : $image");
      await FirebaseFirestore.instance
          .collection("plants")
          .doc(tmp.toString())
          .set({
        'name': name.text.trim(),
        'duration': duration.text.trim(),
        'details': details.text.trim(),
        'main': mainimg,
        'id': tmp,
        'sub': FieldValue.arrayUnion(urls)
      });
      await FirebaseFirestore.instance
          .collection('plants')
          .doc(tmp)
          .update({'sub': FieldValue.arrayUnion(urls)});
      // Statics.showToast(urls.toString());
      Statics.showToast("New Plant added Successfully");
      Navigator.of(context).pop("success");
    } catch (e) {
      setState(() {
        uploaded = false;
      });
      print(e);
      await FirebaseFirestore.instance.collection('plants').doc(tmp).delete();
    }
  }
}
