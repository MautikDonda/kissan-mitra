import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kissanmitra/screens/details/plant.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';
import 'package:kissanmitra/screens/widgets/one_plant.dart';

class CropsView extends StatefulWidget {
  @override
  _CropsViewState createState() => _CropsViewState();
}

class _CropsViewState extends State<CropsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crops"),
      ),
      body: SafeArea(
          child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('plants').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            // Statics.showToast(snapshot.data.docs.length.toString());
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data.docs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Plant(data['id'])));
                    },
                    child: plantCard(
                      data['name'],
                      data['main'],
                      data['details'],
                      '',
                    ),
                  );
                });
          } else {
            return Statics.loading();
          }
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            Statics.getUid();
            var res = await Navigator.of(context).pushNamed('addPlant');
            if (res.toString() == 'success') setState(() {});
          } catch (e) {
            var tmp = await Navigator.pushNamed(context, 'login');
            if (tmp.toString() == 'login') {
              var res = await Navigator.of(context).pushNamed('addPlant');
              if (res.toString() == 'success') setState(() {});
            } else {
              Statics.showToast("Login Required for Adding Data");
            }
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  machineCard(data, data2, data3, String s, {BuildContext context}) {}
}
