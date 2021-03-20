import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kissanmitra/screens/details/allsoils.dart';
import 'package:kissanmitra/screens/details/districts.dart';
import 'package:kissanmitra/screens/forms/addSoil.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';

class SoilView extends StatefulWidget {
  @override
  _SoilViewState createState() => _SoilViewState();
}

class _SoilViewState extends State<SoilView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Soil"),
      ),
      body: Container(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all()),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "We Recomands you to find crops according to your District",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Card(
              child: ListTile(
                title: Text("District"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AllDistricss(),
                  ));
                },
              ),
              elevation: 10,
            ),
            Card(
              child: ListTile(
                title: Text("Soil Type"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AllSoils(),
                  ));
                },
              ),
              elevation: 10,
            )
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: "Add Soil",
        onPressed: () async {
          try {
            Statics.getUid();
            var res = await Navigator.of(context).pushNamed('addNewSoil');
            if (res.toString() == 'add') setState(() {});
          } catch (e) {
            var tmp = await Navigator.pushNamed(context, 'login');
            if (tmp.toString() == 'login') {
              var res = await Navigator.of(context).pushNamed('addNewSoil');
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
