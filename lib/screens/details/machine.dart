import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kissanmitra/screens/widgets/inputField.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MachineModel extends StatefulWidget {
  MachineModel(this.id);
  final String id;
  @override
  _MachineModelState createState() => _MachineModelState(this.id);
}

class _MachineModelState extends State<MachineModel> {
  _MachineModelState(this.id);
  final String id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kissan Mitra"),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future:
              FirebaseFirestore.instance.collection('machines').doc(id).get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data.data();
              List imgurl = [data['main'].toString()];
              imgurl.addAll(data['sub']);

              TextEditingController name =
                  TextEditingController(text: data['name']);
              TextEditingController model =
                  TextEditingController(text: data['model']);
              TextEditingController details =
                  TextEditingController(text: data['details']);
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
                          name,
                          readOnly: true,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MyInputTextField(
                          'Model',
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
