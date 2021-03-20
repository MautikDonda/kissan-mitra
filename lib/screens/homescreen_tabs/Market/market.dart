import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';
import 'package:line_icons/line_icon.dart';

class MarketingYard extends StatefulWidget {
  @override
  _MarketingYardState createState() => _MarketingYardState();
}

class _MarketingYardState extends State<MarketingYard> {
  String location = User.location;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: ListTile(
            title: Text("Market Yards"),
            trailing: IconButton(
              onPressed: () async {
                Statics.showToast("Clicked");
                String tmp = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    scrollable: true,
                    title: Text("Marketing Yards"),
                    content: SingleChildScrollView(
                      child: Container(
                        // child: Text("ram ram ram "),
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: SingleChildScrollView(
                          child: FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection("districts")
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List data = snapshot.data.docs;
                                return Column(
                                  children: List.generate(
                                      20,
                                      (i) => RadioListTile(
                                          title: Text(i.toString()),
                                          value: i,
                                          groupValue: location,
                                          onChanged: (val) {
                                            location = val;
                                          })),
                                );
                              } else
                                return Center(child: Statics.loading());
                            },
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pop("reload");
                        },
                        child: Text("OK"),
                      )
                    ],
                  ),
                );
                if (tmp == 'reload')
                  setState(() {
                    location = location;
                  });
              },
              tooltip: "Click to change Location",
              icon: Icon(LineIcon.searchLocation().icon),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, i) => Card(
                    child: ListTile(
                      title: Text('sdf'),
                    ),
                  )),
        ),
      ],
    );
  }
}
