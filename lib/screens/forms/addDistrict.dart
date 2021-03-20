import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kissanmitra/screens/widgets/inputField.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';

class AddDistrict extends StatefulWidget {
  @override
  _AddDistrictState createState() => _AddDistrictState();
}

class _AddDistrictState extends State<AddDistrict> {
  var dist = TextEditingController();

  Map<String, bool> data = {};
  bool up = false;
  List fetchedData = [];
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add District",
        ),
      ),
      body: (!up)
          ? SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    MyInputTextField("District Name", dist),
                    SizedBox(
                      height: 12,
                    ),
                    SingleChildScrollView(
                        child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(16)),
                      height: h / 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FutureBuilder(
                          future: getData(),
                          builder: (context, snap) {
                            if (snap.hasData) {
                              // print(snap.data.docs.length);
                              return ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  // print(data.toString());
                                  return Card(
                                    elevation: 5,
                                    child: CheckboxListTile(
                                        title: Text(fetchedData[index]['name']),
                                        value: data[fetchedData[index]['name']],
                                        onChanged: (val) {
                                          setState(() {
                                            data[fetchedData[index]['name']] =
                                                val;
                                            print(data.toString());
                                          });
                                        }),
                                  );
                                },
                              );
                            } else
                              return Statics.loading();
                          },
                        ),
                      ),
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        uploadData(context);
                        setState(() {
                          up = true;
                        });
                      },
                      child: Text("Upload"),
                    )
                  ],
                ),
              ),
            )
          : Statics.getLoadingScreen(),
    );
  }

  bool fetched = false;
  Future<String> getData() async {
    if (fetched) return Future.value("DOne");
    await FirebaseFirestore.instance
        .collection("soils")
        .get()
        .then((value) async {
      value.docs.forEach((doc) {
        fetchedData.add(doc.data());
        data[doc.id.toString()] = false;
      });
    }).whenComplete(() {
      fetched = true;
    });
    return Future.value("DOne");
  }

  uploadData(context) async {
    List selected = [];
    data.forEach((key, value) {
      if (value) selected.add(key);
    });
    String d = dist.text.trim();
    await FirebaseFirestore.instance
        .collection("districts")
        .doc(d)
        .set({'name': d, 'soils': FieldValue.arrayUnion(selected)});
    Navigator.of(context).pop('add');
    Statics.showToast("New District added");
  }
}
