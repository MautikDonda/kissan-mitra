import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kissanmitra/screens/homescreen_tabs/History/add_history.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';

class AllHistoryView extends StatefulWidget {
  @override
  _AllHistoryViewState createState() => _AllHistoryViewState();
}

class _AllHistoryViewState extends State<AllHistoryView> {
  bool fetched = false, loading = false;

  Map data = {};

  List ids = [], search = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: loading
            ? Statics.getLoadingScreen()
            : FutureBuilder(
                future: getData(),
                builder: (context, s) {
                  if (fetched) {
                    // print(data);
                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: [
                                  DataColumn(
                                      label: Text('Index'),
                                      numeric: true,
                                      onSort: (n, b) {
                                        print("$n  $b");
                                      }),
                                  DataColumn(label: Text('Crop')),
                                  DataColumn(label: Text('Buyer Name')),
                                  DataColumn(
                                      label: Text('Buyer Contact'),
                                      numeric: true,
                                      onSort: (n, b) {
                                        print("$n  $b");
                                      }),
                                  DataColumn(label: Text('Seller Name')),
                                  DataColumn(
                                      label: Text('Seller Contact'),
                                      numeric: true,
                                      onSort: (n, b) {
                                        print("$n  $b");
                                      }),
                                  DataColumn(
                                      label: Text('Price'),
                                      numeric: true,
                                      onSort: (n, b) {
                                        print("$n  $b");
                                      }),
                                  DataColumn(label: Text('Location')),
                                  DataColumn(
                                      label: Text('Quantity'),
                                      numeric: true,
                                      onSort: (n, b) {
                                        print("$n  $b");
                                      }),
                                ],
                                rows: List.generate(
                                    search.length,
                                    (index) => DataRow(cells: [
                                          DataCell(Text(index.toString())),
                                          DataCell(Text(
                                              data[search[index]]['crop'])),
                                          DataCell(Text(data[search[index]]
                                              ['buyer name'])),
                                          DataCell(Text(data[search[index]]
                                              ['buyer contact'])),
                                          DataCell(Text(data[search[index]]
                                              ['seller name'])),
                                          DataCell(Text(data[search[index]]
                                              ['seller contact'])),
                                          DataCell(Text(
                                              data[search[index]]['price'])),
                                          DataCell(Text(
                                              data[search[index]]['location'])),
                                          DataCell(Text(
                                              data[search[index]]['quantity'])),
                                        ])),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                  child: RaisedButton(
                                onPressed: () async {
                                  String tmp = await Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => AddHistory()));
                                  if (tmp == 'true')
                                    setState(() {
                                      fetched = false;
                                      data.clear();
                                      ids.clear();
                                    });
                                },
                                child: Text("Add"),
                              )),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                  child: RaisedButton(
                                onPressed: () async {
                                  String crop = '', location = '';
                                  String tmp = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text("Filter"),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ListTile(
                                                  title: Text("Crop"),
                                                  trailing: DropdownButton(
                                                      underline: null,
                                                      onTap: () {},
                                                      onChanged: (val) {
                                                        crop = val;
                                                      },
                                                      items: List.generate(
                                                          Statics.crops.length,
                                                          (index) => DropdownMenuItem(
                                                              value: Statics
                                                                  .crops[index],
                                                              child: Text(
                                                                  Statics.crops[
                                                                      index])))),
                                                ),
                                                ListTile(
                                                  title: Text("Location"),
                                                  trailing: DropdownButton(
                                                      underline: null,
                                                      onTap: () {},
                                                      onChanged: (val) {
                                                        location = val;
                                                      },
                                                      items: List.generate(
                                                          Statics.dists.length,
                                                          (index) => DropdownMenuItem(
                                                              value: Statics
                                                                  .dists[index],
                                                              child: Text(
                                                                  Statics.dists[
                                                                      index])))),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              RaisedButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop('true');
                                                },
                                                child: Text("OK"),
                                                color: Colors.green,
                                              )
                                            ],
                                          ));

                                  if (tmp == 'true') {
                                    if (crop == '' && location == '')
                                      print(search);
                                    else {
                                      dataFiltering(crop, location);
                                      setState(() {
                                        loading = true;
                                      });
                                    }
                                  }
                                },
                                child: Text("Filter"),
                              ))
                            ],
                          ),
                        )
                      ],
                    );
                  } else
                    return Statics.getLoadingScreen();
                },
              ),
      ),
    );
  }

  dataFiltering(crop, location) {
    List tmp=[];
    for(int i=0;i<ids.length;++i) {
      print("this ");
      String element = ids[i];
      search.clear();
      if (crop != '' && data[element]['crop'] == crop) search.add(element);
      if (location != '' && data[element]['location'] == location)
        search.add(element);
      print('list $search');
    }

    setState(() {
      loading = false;
      search = search;
    });
  }

  getData() async {
    if (fetched) return;
    await FirebaseFirestore.instance
        .collection('history')
        .get()
        .then((value) async {
      value.docs.forEach((element) async {
        data[element.id] = element.data();
        ids.add(element.id);
      });
    }).whenComplete(() {
      setState(() {
        fetched = true;
        search = ids;
      });
    });
  }
}
