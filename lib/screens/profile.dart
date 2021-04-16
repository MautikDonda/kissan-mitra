import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kissanmitra/screens/widgets/inputField.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(Statics.getUid())
            .get(),
        builder: (context, snap) {
          if (snap.hasData) {
            Map data = snap.data.data();
            return Column(
              children: [
                SizedBox(
                  height: 160,
                  width: 160,
                  child: ClipOval(
                      child: Image.network(data['dp'] ??
                          'https://www.pngfind.com/pngs/m/536-5364301_farmers-drawing-rice-farm-farmer-planting-clip-art.png')),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: MyInputTextField(
                    'નામ',
                    TextEditingController(text: data['name']),
                    maxline: 1,
                    readOnly: true,
                    radius: 10,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: MyInputTextField(
                    'E-mail',
                    TextEditingController(text: data['email']),
                    maxline: 1,
                    readOnly: true,
                    radius: 10,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: MyInputTextField(
                    'જીલ્લો',
                    TextEditingController(text: data['location']),
                    maxline: 1,
                    readOnly: true,
                    radius: 10,
                  ),
                ),
              ],
            );
          }
          return Statics.getLoadingScreen();
        },
      ),
    );
  }

  myTextField(TextEditingController _title1, String labelText) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
      child: TextFormField(
        controller: _title1,
        enabled: true,
        readOnly: true,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1),
              borderRadius: BorderRadius.circular(16),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1),
              borderRadius: BorderRadius.circular(16),
            ),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.black)),
      ),
    );
  }
}
