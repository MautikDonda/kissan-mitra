import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kissanmitra/screens/homescreen_tabs/Market/add_market.dart';
import 'package:kissanmitra/screens/widgets/inputField.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';
import 'package:line_icons/line_icon.dart';

class MarketingYard extends StatefulWidget {
  @override
  _MarketingYardState createState() => _MarketingYardState();
}

class _MarketingYardState extends State<MarketingYard> {
  // String location = ''; //= CurrentUser.location;
  String date = DateTime.now().toString().substring(0, 10);
  @override
  Widget build(BuildContext context) {
    print(date);
    return Scaffold(
      body: Column(
        children: [
          Card(
            elevation: 20,
            child: ListTile(
              title: Text(Statics.yard != ''
                  ? Statics.yard
                  : "એક પણ માર્કેટિંગ યાર્ડ પસંદ કરેલ નથી"),
              trailing: IconButton(
                onPressed: () async {
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
                                  .collection("yards")
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List data = snapshot.data.docs;
                                  return Column(
                                    children: List.generate(
                                        data.length,
                                        (i) => RadioListTile(
                                            title: Text(data[i]['id']),
                                            value: data[i]['id'],
                                            groupValue: Statics.yard,
                                            onChanged: (val) {
                                              Statics.yard = val;
                                              Navigator.pop(context, "reload");
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
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => AddMarket(),
                            ));
                          },
                          child: Text("Add Market"),
                        ),
                        RaisedButton(
                          color: Colors.greenAccent,
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
                      Statics.yard = Statics.yard;
                    });
                },
                tooltip: "Click to change Location",
                icon: Icon(LineIcon.searchLocation().icon),
              ),
            ),
          ),
          Expanded(
            child: (Statics.yard == '')
                ? Center(
                    child: Text("એક માર્કેટીંગ યાર્ડ પસંદ કરો",
                        style: TextStyle(
                          fontSize: 20,
                        )))
                : FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('yards')
                        .doc(Statics.yard)
                        .collection('date')
                        .doc(date)
                        .get(),
                    builder: (context, snapshot) {
                      // print(snapshot);
                      if (Statics.yard == '')
                        return Text("Select one Marketing Yard");
                      if (snapshot.hasData) {
                        // print("data : ");
                        // print(snapshot.data.data());
                        var data = snapshot.data.data();
                        if (data == null)
                          return Center(
                              child: Text(
                            "આજ ના ભાવની માહિતી ઉપલબ્ધ નથી",
                            style: TextStyle(fontSize: 20),
                          ));
                        List crop = data['crops'];
                        List min = data['min'];
                        List max = data['max'];

                        return ListView.builder(
                            itemCount: crop.length,
                            itemBuilder: (context, i) => Card(
                                  elevation: 10,
                                  child: ListTile(
                                    title: Text(crop[i]),
                                    subtitle: Text(
                                        "   Min:${min[i]}    Max:${max[i]}"),
                                  ),
                                ));
                      } else
                        return Statics.getLoadingScreen();
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Statics.yard == ''
          ? null
          : FloatingActionButton(
              child: Icon(Icons.add),
              tooltip: 'આજ નો ભાવ ઉમેરો',
              onPressed: () async {
                var res = await showDialog(
                  context: context,
                  builder: (context) {
                    TextEditingController min = TextEditingController();
                    TextEditingController max = TextEditingController();
                    TextEditingController crop = TextEditingController();
                    print(crop.text);
                    return AlertDialog(
                      title: Text(Statics.yard),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: DropdownButton(
                              onTap: () {},
                              onChanged: (val) {
                                setState(() {
                                  crop.text = val;
                                });
                              },
                              items: List.generate(
                                Statics.crops.length,
                                (index) => DropdownMenuItem(
                                  value: Statics.crops[index],
                                  child: Text(
                                    Statics.crops[index],
                                  ),
                                ),
                              ),
                            ),
                            subtitle: Text("પાક પસંદ કરો"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MyInputTextField(
                              "લઘુત્તમ ભાવ",
                              min,
                              type: TextInputType.number,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MyInputTextField(
                              "મહત્તમ ભાવ",
                              max,
                              type: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        RaisedButton(
                          onPressed: () async {
                            // print("${crop.text} ${min.text} ${max.text}");
                            try {
                              await FirebaseFirestore.instance
                                  .collection('yards')
                                  .doc(Statics.yard)
                                  .collection('date')
                                  .doc(date)
                                  .update({
                                'crops': FieldValue.arrayUnion([crop.text]),
                                'min': FieldValue.arrayUnion([min.text]),
                                'max': FieldValue.arrayUnion([max.text])
                              });
                            } catch (e) {
                              await FirebaseFirestore.instance
                                  .collection('yards')
                                  .doc(Statics.yard)
                                  .collection('date')
                                  .doc(date)
                                  .set({
                                'crops': [crop.text],
                                'min': [min.text],
                                'max': [max.text]
                              });
                            }

                            Navigator.of(context).pop('true');
                          },
                          child: Text("OK"),
                        )
                      ],
                    );
                  },
                );
                if (res == 'true') setState(() {});
              },
            ),
    );
  }
}
