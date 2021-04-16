import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kissanmitra/screens/widgets/inputField.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';

class AddMarket extends StatefulWidget {
  @override
  _AddMarketState createState() => _AddMarketState();
}

class _AddMarketState extends State<AddMarket> {
  TextEditingController name, location;

  @override
  void initState() {
    name = TextEditingController();
    location = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Market"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyInputTextField(
              "માર્કેટિંગ યાર્ડનું નામ",
              name,
              maxline: 1,
              radius: 20,
            ),
          ),
          GestureDetector(
            onTap: () async {
              print('clikc');
              var tmp = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text("જિલ્લો પસંદ કરો"),
                        content: SingleChildScrollView(
                          child: Column(
                              children: List.generate(
                                  Statics.dists.length,
                                  (index) => RadioListTile(
                                      value: Statics.dists[index],
                                      groupValue: location.text,
                                      title: Text(Statics.dists[index]),
                                      onChanged: (value) {
                                        Navigator.pop(context, value);
                                      }))),
                        ),
                      ));
              if (tmp != null)
                setState(() {
                  location.text = tmp;
                });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  title: Text(location.text == ''
                      ? "Click to Select District"
                      : location.text),
                ),
              ),
            ),
          ),
          RaisedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('yards')
                  .doc(name.text.trim())
                  .set({
                'id': name.text.trim(),
              });
              Navigator.of(context).pop();
            },
            child: Text("Upload"),
          )
        ],
      ),
    );
  }
}
