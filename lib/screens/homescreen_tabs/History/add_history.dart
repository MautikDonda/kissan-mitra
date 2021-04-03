import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kissanmitra/screens/widgets/inputField.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';

class AddHistory extends StatefulWidget {
  @override
  _AddHistoryState createState() => _AddHistoryState();
}

class _AddHistoryState extends State<AddHistory> {
  TextEditingController bname, bcontact, qua, price, sname, scontact, more;
  bool uploading;
  DateTime date;
  String crop = '', dis = '';
  Set tmpset = {};
  List crops = Statics.crops;
  List dists = Statics.dists;
  @override
  void initState() {
    uploading = false;
    bname = TextEditingController();
    sname = TextEditingController();
    more = TextEditingController();
    scontact = TextEditingController();
    bcontact = TextEditingController();
    qua = TextEditingController();
    price = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: uploading
          ? Statics.getLoadingScreen()
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        // margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all()),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "This data is used by Farmer's who are user of this App. It will Help other. So, Please fill up correct details.",
                            style:
                                TextStyle(fontFamily: "Roboto", fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 2,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Text("Buyer Details"),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(height: 2, color: Colors.grey),
                        )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyInputTextField("Name", bname),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyInputTextField("Contact", bcontact),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 2,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Text("Seller Details"),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(height: 2, color: Colors.grey),
                        )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyInputTextField("Name", sname),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyInputTextField("Contact", scontact),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 2,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Text("Crops Details"),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(height: 2, color: Colors.grey),
                        )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField(
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                        hint: Text("--  Select Crop  --"),
                        items: List.generate(
                            crops.length,
                            (index) => DropdownMenuItem(
                                value: crops[index],
                                child: Text(crops[index].toString()))),
                        onChanged: (val) {
                          setState(() {
                            crop = val;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyInputTextField(
                        "Quantity(મણ)",
                        qua,
                        type: TextInputType.number,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyInputTextField(
                        'Price(મણ)',
                        price,
                        type: TextInputType.number,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField(
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                        hint: Text("--  Select State  --"),
                        items: List.generate(
                            dists.length,
                            (index) => DropdownMenuItem(
                                value: dists[index],
                                child: Text(dists[index].toString()))),
                        onChanged: (val) {
                          setState(() {
                            dis = val;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyInputTextField(
                        "Marketing Yard Details",
                        more,
                        hint: "Marketin Yard Location(Optional)",
                        maxline: 3,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                          onPressed: () async {
                            var date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2021, 1, 1),
                                lastDate: DateTime(2031, 1, 1));
                            if (date != null)
                              setState(() {
                                this.date = date;
                              });
                          },
                          child: Container(
                            child: date != null
                                ? Text(date.toString().substring(0, 10))
                                : Text("Select Date"),
                            width: double.infinity,
                          )),
                    ),
                    RaisedButton(
                      onPressed: () async {
                        if (bname.text.isEmpty ||
                            bcontact.text.isEmpty ||
                            sname.text.isEmpty ||
                            scontact.text.isEmpty ||
                            qua.text.isEmpty ||
                            price.text.isEmpty ||
                            crop == "" ||
                            date == null) {
                          Statics.showToast("Fill all The Fields");
                          return;
                        }
                        uploadData(context);
                        setState(() {
                          uploading = true;
                        });
                      },
                      child: Text("SUBMIT"),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  uploadData(context) async {
    String currenttime = Timestamp.now().microsecondsSinceEpoch.toString();
    try {
      await FirebaseFirestore.instance
          .collection('history')
          .doc(currenttime)
          .set({
        'buyer name': bname.text,
        'buyer contact': bcontact.text,
        'seller name': sname.text,
        'seller contact': scontact.text,
        'location': dis,
        'crop': crop,
        "quantity": qua.text,
        'price': price.text,
        'date': date,
        'more': more.text,
        'id': currenttime
      });
      Navigator.of(context).pop('true');
    } catch (e) {
      Statics.showToast("Error : $e");
      setState(() {
        uploading = false;
      });
    }
  }
}
