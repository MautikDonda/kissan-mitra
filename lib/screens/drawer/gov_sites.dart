import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';
import 'package:url_launcher/url_launcher.dart';

class GovSites extends StatefulWidget {
  @override
  _GovSitesState createState() => _GovSitesState();
}

class _GovSitesState extends State<GovSites> {
  List data = [];
  Widget linkOpen(title, url) {
    return GestureDetector(
      onTap: () {
        _launchURL(url);
      },
      child: Text(
        title + "\n",
        style:
            TextStyle(fontSize: 32, color: Colors.blue, fontFamily: "Roboto"),
      ),
    );
  }

  Widget mobileCall(no) {
    if (no == 'null') return Text("");
    return GestureDetector(
      onTap: () {
        _launchURL("tel:$no");
      },
      child: Text(
        "📲	$no\n",
        style:
            TextStyle(fontSize: 30, color: Colors.green, fontFamily: "Roboto"),
      ),
    );
  }

  Widget myBlog(title, url, no, details) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), border: Border.all()),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            linkOpen(title, url),
            Text(
              details,
              style: TextStyle(
                fontFamily: "Roboto",
                fontSize: 16,
              ),
            ),
            mobileCall(no),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Government Sites"),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('gov_site').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: Statics.loading());
            else {
              print("My Data : ${snapshot.data.docs[2]['discription']}");
              return SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Container(
                          // margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all()),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "This is Official Government websites that is more important than another External resources.",
                              style:
                                  TextStyle(fontFamily: "Roboto", fontSize: 20),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          // margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all()),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "- Click on Title to open Url direct in your Browser.\n- Click on Mobile number to Call",
                              style:
                                  TextStyle(fontFamily: "Roboto", fontSize: 20),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        for (int i = 0; i < snapshot.data.docs.length; ++i)
                          myBlog(
                              snapshot.data.docs[i]['title'],
                              snapshot.data.docs[i]['url'],
                              snapshot.data.docs[i]['no'],
                              snapshot.data.docs[i]['discription'].toString())
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _launchURL(url) async {
    if (await canLaunch(url))
      launch(url);
    else
      Statics.showToast("Error : Can not Open Url ");
  }
}
