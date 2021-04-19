import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kissanmitra/screens/details/allsoils.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';

class AllDistricss extends StatefulWidget {
  @override
  _AllDistricssState createState() => _AllDistricssState();
}

class _AllDistricssState extends State<AllDistricss> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Districts'),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("districts")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active)
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 5,
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AllSoils(
                                        dist: snapshot.data.docs[index]
                                            ['name'])));
                              },
                              title: Text(snapshot.data.docs[index]['name']),
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
        tooltip: "Add Dist.",
        onPressed: () async {
          try {
            Statics.getUid();
            var res = await Navigator.of(context).pushNamed('/addDistrict');
            if (res.toString() == 'add') setState(() {});
          } catch (e) {
            var tmp = await Navigator.pushNamed(context, 'login');
            if (tmp.toString() == 'login') {
              var res = await Navigator.of(context).pushNamed('/addDistrict');
              if (res.toString() == 'add') setState(() {});
            } else {
              Statics.showToast("Login Required for Adding Data");
            }
          }
        },
      ),
    );
  }
}
