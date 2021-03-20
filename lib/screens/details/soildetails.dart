import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kissanmitra/screens/widgets/inputField.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';

class TheSoilDetails extends StatefulWidget {
  TheSoilDetails(this.name);
  final String name;

  @override
  _TheSoilDetailsState createState() => _TheSoilDetailsState(this.name);
}

class _TheSoilDetailsState extends State<TheSoilDetails> {
  _TheSoilDetailsState(this.name);
  final String name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          //type,seasons,crops,needs-fertilizer
          future:
              FirebaseFirestore.instance.collection('soils').doc(name).get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data.data();
              List imgurl = [];
              imgurl.addAll(data['sub']);

              TextEditingController soil =
                  TextEditingController(text: data['soil']);
              TextEditingController fert =
                  TextEditingController(text: data['fertilizer']);
              TextEditingController details =
                  TextEditingController(text: data['details']);
              TextEditingController mon =
                  TextEditingController(text: data['mon']);
              TextEditingController sum =
                  TextEditingController(text: data['sum']);
              TextEditingController win =
                  TextEditingController(text: data['win']);

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                              aspectRatio: 16 / 9,
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
                          soil,
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
                        SizedBox(
                          height: 10,
                        ),
                        MyInputTextField(
                          'Fertilizer for Soil',
                          fert,
                          readOnly: true,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MyInputTextField(
                          'Monsoon Crops',
                          mon,
                          readOnly: true,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MyInputTextField(
                          'Summer Crops',
                          sum,
                          readOnly: true,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MyInputTextField(
                          'Winter Crops',
                          win,
                          readOnly: true,
                        ),
                      ]),
                ),
              );
            } else
              return Statics.loading();
          },
        ),
      ),
    );
  }
}
