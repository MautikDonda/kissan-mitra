import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';
import 'package:url_launcher/url_launcher.dart';

void _launchURL(_url) async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

Widget machineCard(title, image, discription, link,
        {String user = 'other', String id = '', context = ''}) =>
    Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            (image != '')
                ? Image.network(
                    image,
                    fit: BoxFit.cover,
                    // height: MediaQuery.of(context).size.height / 5,
                  )
                : Container(
                    height: 0,
                    width: 0,
                  ),
            ListTile(
              title: Text(
                title,
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Text(
                    discription,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            (link != '')
                ? GestureDetector(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            link,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.blue.shade600),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      _launchURL(link);
                    },
                  )
                : Container(
                    height: 0,
                    width: 0,
                  ),
            SizedBox(
              height: 30,
            ),
            (user == 'admin')
                ? Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          color: Colors.redAccent,
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Confirm Your Delete"),
                                    content: Text(
                                        "After Clicking 'Confirm', this notice deletes"),
                                    actions: [
                                      RaisedButton(
                                          child: Text("Cancel"),
                                          color: Colors.redAccent,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }),
                                      RaisedButton(
                                          child: Text("Confirm"),
                                          color: Colors.greenAccent,
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('noticeboard')
                                                .doc(id)
                                                .delete();
                                            Statics.showToast(
                                                "Notice Deleted Successfully");
                                            Navigator.pop(context);
                                          })
                                    ],
                                  );
                                });
                          },
                          child: Text('Detele'),
                        )),
                  )
                : Container()
          ],
        ),
      ),
    );
