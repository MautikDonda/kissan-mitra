import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kissanmitra/screens/homescreen_tabs/Agro/addPrice.dart';
import 'package:kissanmitra/screens/widgets/inputField.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:line_icons/line_icons.dart';

class FertiDetails extends StatefulWidget {
  FertiDetails(this.id);
  final String id;
  @override
  _FertiDetailsState createState() => _FertiDetailsState(this.id);
}

class _FertiDetailsState extends State<FertiDetails> {
  _FertiDetailsState(this.id);

  final String id;
  bool hide = true;
  bool hide2 = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kissan Mitra"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('fertilizers')
                .doc(id)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data.data();
                List imgurl = [data['main'].toString()];
                imgurl.addAll(data['sub']);
                TextEditingController name =
                    TextEditingController(text: data['name']);
                TextEditingController model =
                    TextEditingController(text: data['crops']);
                TextEditingController details =
                    TextEditingController(text: data['details']);
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          CarouselSlider(
                              items: List.generate(
                                imgurl.length,
                                (index) => Container(
                                  margin: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                      image: NetworkImage(imgurl[index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              options: CarouselOptions(
                                height: 180.0,
                                enlargeCenterPage: true,
                                autoPlay: true,
                                aspectRatio: 4 / 3,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enableInfiniteScroll: true,
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 800),
                                viewportFraction: 0.8,
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          MyInputTextField(
                            'Name',
                            name,
                            readOnly: true,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MyInputTextField(
                            'Crops',
                            model,
                            readOnly: true,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MyInputTextField(
                            'Details',
                            details,
                            readOnly: true,
                            maxline: 20,
                          ),
                          Divider(),
                          AddRating(id),
                          Divider(),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    hide2 = true;
                                    hide = !hide;
                                  });
                                },
                                child: Text("Ratings"),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      hide = true;
                                      hide2 = !hide2;
                                    });
                                  },
                                  child: Text("Sellers"))
                            ],
                          ),
                          Visibility(visible: !hide, child: AllRatings(id)),
                          Visibility(visible: !hide2, child: AllSellers(id)),
                          SizedBox(
                            height: 60,
                          )
                        ]),
                  ),
                );
              } else
                return Statics.loading();
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (contex) => AddPrice('fertilizers', id)));
        },
        child: Icon(LineIcons.moneyBill),
      ),
    );
  }
}

class AllSellers extends StatelessWidget {
  final String id;
  AllSellers(this.id);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("fertilizers")
          .doc(id)
          .collection('seller')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) if (snapshot.data.docs.length == 0)
          return Text("No Data Available");
        else
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) => Card(
              child: ExpansionTile(
                children: [Text(snapshot.data.docs[index].data()['address'])],
                title: Text(snapshot.data.docs[index].data()['sellerName']),
                subtitle: Text(snapshot.data.docs[index].data()['address']),
                trailing: Text('₹${snapshot.data.docs[index].data()['price']}'),
              ),
            ),
          );
        else
          return Statics.getLoadingScreen();
      },
    );
  }
}

class AddRating extends StatefulWidget {
  AddRating(this.id);
  final String id;
  @override
  _AddRatingState createState() => _AddRatingState(this.id);
}

class _AddRatingState extends State<AddRating> {
  _AddRatingState(this.id);
  final String id;
  TextEditingController more = TextEditingController();
  double rating = 0;
  @override
  Widget build(BuildContext context) {
    try {
      return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(Statics.getUid())
            .collection('ratings')
            .doc(id)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.data() == null)
              return Column(
                children: [
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      // setState(() {
                      this.rating = rating;
                      // });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MyInputTextField("More(Optional)", more),
                  RaisedButton(
                    onPressed: () async {
                      if (rating != null) {
                        String tmp =
                            Timestamp.now().microsecondsSinceEpoch.toString();
                        await FirebaseFirestore.instance
                            .collection('ratings')
                            .doc(tmp)
                            .set({
                          'for': id,
                          'id': tmp,
                          'uid': Statics.getUid(),
                          'rating': rating.toString(),
                          'more': more.text
                        });
                        //rating ma rating is stored
                        await FirebaseFirestore.instance
                            .collection('fertilizers')
                            .doc(id)
                            .collection('ratings')
                            .doc(tmp)
                            .set({
                          'for': id,
                          'id': tmp,
                          'uid': Statics.getUid(),
                          'rating': rating.toString(),
                          'more': more.text
                        }); //storing to colection of fertilizer
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(Statics.getUid())
                            .collection('ratings')
                            .doc(id)
                            .set({
                          'for': id,
                          'id': tmp,
                          'uid': Statics.getUid(),
                          'rating': rating.toString(),
                          'more': more.text
                        }); //storing to users subcllection
                        setState(() {});
                      } else
                        Statics.showToast("Select Star");
                    },
                    child: Text("Add Your Ratings"),
                  )
                ],
              );
            else
              return Column(
                children: [
                  Text("My Rating"),
                  RatingBar.builder(
                    initialRating: 2.5,
                    minRating: 1,
                    ignoreGestures: true,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        // this.rating = rating;
                      });
                    },
                  ),
                ],
              );
          } else
            return Statics.loading();
        },
      );
    } catch (e) {
      return Text("Login. To give your Experience");
    }
  }
}

class AllRatings extends StatelessWidget {
  AllRatings(this.id);
  final String id;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('fertilizers')
          .doc(id)
          .collection('ratings')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          int total = 0;
          double avg = 0;
          total = snapshot.data.docs.length;
          for (int i = 0; i < total; ++i)
            avg += double.parse(snapshot.data.docs[i].data()['rating']);

          return Column(
            children: [
              Text(
                "Average Rating: ${avg / total}",
                style: TextStyle(fontSize: 20),
              ),
              Container(
                // height: 500,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      Map data = snapshot.data.docs[index].data();
                      return Card(
                        child: ListTile(
                          title: Text(data['more']),
                          trailing: Text(data['rating']),
                        ),
                      );
                    }),
              ),
            ],
          );
        } else
          return Statics.loading();
      },
    );
  }
}
