import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kissanmitra/screens/details/machine.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';
import 'package:kissanmitra/screens/widgets/one_Machine_card.dart';

class MachineView extends StatefulWidget {
  @override
  _MachineViewState createState() => _MachineViewState();
}

class _MachineViewState extends State<MachineView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Machines"),
      ),
      body: SafeArea(
          child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('machines').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data.docs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MachineModel(data['id'])));
                    },
                    child: machineCard(
                        data['name'], data['main'], data['details'], '',
                        context: context),
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
            var res = await Navigator.of(context).pushNamed('addMachine');
            if (res.toString() == 'success') setState(() {});
          } catch (e) {
            var tmp = await Navigator.pushNamed(context, 'login');
            if (tmp.toString() == 'login') {
              var res = await Navigator.of(context).pushNamed('addMachine');
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
}
