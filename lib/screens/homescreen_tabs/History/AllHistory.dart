import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';

class AllHistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                        20,
                        (index) => DataRow(cells: [
                              DataCell(Text(index.toString())),
                              DataCell(Text('Crop$index')),
                              DataCell(Text('B$index')),
                              DataCell(Text('$index')),
                              DataCell(Text('S$index')),
                              DataCell(Text('$index')),
                              DataCell(Text('$index')),
                              DataCell(Text('BAPS')),
                              DataCell(Text('$index')),
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
                    onPressed: () {},
                    child: Text("Add"),
                  )),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: RaisedButton(
                    onPressed:  () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Filter"),
                    content: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('machines')
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData)
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text("Crop"),
                                trailing: DropdownButton(
                                    underline: null,
                                    onTap: () {},
                                    onChanged: (val) {},
                                    items: List.generate(
                                        snapshot.data.docs.length,
                                        (index) => DropdownMenuItem(
                                            value: snapshot.data.docs[index]
                                                ['name'],
                                            child: Text(snapshot
                                                .data.docs[index]['name'])))),
                              ),
                              ListTile(
                                title: Text("Location"),
                                trailing: DropdownButton(items: [
                                  DropdownMenuItem(child: Text('Bhavnagar'))
                                ]),
                              ),
                            ],
                          );
                        else
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(child: Statics.loading()),
                            ],
                          );
                      },
                    ),
                    actions: [
                      RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"),
                        color: Colors.green,
                      )
                    ],
                  ));
        },
      
                    child: Text("Filter"),
                  ))
                ],
              ),
            )
          ],
        ),
      ),
     );
  }
}
