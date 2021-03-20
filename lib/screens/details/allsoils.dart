import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kissanmitra/screens/details/soildetails.dart';
import 'package:kissanmitra/screens/forms/addSoil.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';

class AllSoils extends StatefulWidget {
  final String dist;
  AllSoils({this.dist = 'all'});
  @override
  _AllSoilsState createState() => _AllSoilsState(dist: dist);
}

class _AllSoilsState extends State<AllSoils> {
  _AllSoilsState({this.dist = 'all'});
  List data = [];
  final String dist;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((dist == 'all') ? "All Soils" : dist),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 5,
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        TheSoilDetails(data[index])));
                              },
                              title: Text(data[index]),
                            ),
                          );
                        });
                  else
                    return Statics.loading();
                })),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
          ),
          tooltip: "Add Soil",
          onPressed: () async {
            try {
              print(Statics.getUid());
              var res = await Navigator.of(context).pushNamed('addNewSoil');
              if (res.toString() == 'add') setState(() {});
            } catch (e) {
              print(e.toString());
              var tmp = await Navigator.pushNamed(context, 'login');
              if (tmp.toString() == 'login') {
                var res = await Navigator.of(context).pushNamed('addNewSoil');
                if (res.toString() == 'add') setState(() {});
              } else {
                Statics.showToast("Login Required for Adding Data");
              }
            }
          }),
    );
  }

  bool fetched = false;
  Future getData() async {
    if (fetched) return Future.value("Done");
    data.clear();
    if (dist == 'all') {
      var ref = await FirebaseFirestore.instance
          .collection("soils")
          .get()
          .then((value) async {
        value.docs.forEach((element) {
          data.add(element.id);
        });
        setState(() {
          fetched = true;
        });
      });
    } else {
      FirebaseFirestore.instance
          .collection("districts")
          .doc(dist)
          .get()
          .then((value) {
        data = value.data()['soils'];
        setState(() {
          fetched = true;
        });
      });
    }
    print(data.toString());
    return Future.value("Done");
  }
}
