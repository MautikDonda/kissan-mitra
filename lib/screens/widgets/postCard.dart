import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kissanmitra/screens/widgets/inputField.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';

class PostCard extends StatefulWidget {
  PostCard(this.data);
  Map data;
  @override
  _PostCardState createState() => _PostCardState(this.data);
}

class _PostCardState extends State<PostCard> {
  _PostCardState(this.data);
  Map data;
  bool commentClick = false;
  TextEditingController comment = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = data['time'];
    Icon like = data['likes'].contains(Statics.getUid())
        ? Icon(
            FontAwesomeIcons.solidThumbsUp,
            color: Colors.red,
          )
        : Icon(FontAwesomeIcons.thumbsUp);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      Text(data['uname']),
                      Text(
                        Statics.timeAgoSinceDate(timestamp.toDate().toString()),
                        style: TextStyle(
                            fontSize: 12, color: Colors.blue.withOpacity(0.6)),
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(child: Image.network(data['img'])),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(data['details']),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Column(
                    children: [
                      IconButton(
                          onPressed: () async {
                            if (data['likes'].contains(Statics.getUid())) {
                              data['likes'].remove(Statics.getUid());
                            } else
                              data['likes'].add(Statics.getUid());
                            await FirebaseFirestore.instance
                                .collection('posts')
                                .doc(data['id'])
                                .update({
                              'likes': data['likes'],
                            });
                          },
                          tooltip: 'Like',
                          icon: like),
                      Text(
                          "${NumberFormat.compact().format(data['likes'].length)}"),
                    ],
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Column(
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              commentClick = !commentClick;
                            });
                          },
                          tooltip: 'Comment',
                          icon: Icon(FontAwesomeIcons.comment)),
                      Text(
                          "${NumberFormat.compact().format(data['comments'].length)}"),
                    ],
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Column(
                    children: [
                      IconButton(
                          onPressed: () {},
                          tooltip: 'Share',
                          icon: Icon(FontAwesomeIcons.share)),
                      Text('Share')
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
              visible: commentClick,
              child: AnimatedContainer(
                duration: Duration(seconds: 5),
                height: 100,
                curve: Curves.elasticInOut,
                child: Form(
                    child: Row(children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: MyInputTextField(
                        "Comment",
                        comment,
                        maxline: 5,
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        var tmp = FirebaseFirestore.instance
                            .collection('comments')
                            .doc();
                        data['comments'].add(tmp.id);
                        await tmp.set({
                          'title': comment.text,
                          'id': tmp.id,
                          'name': Statics.name,
                          'sid': Statics.getUid()
                        }).then((value) async {
                          await FirebaseFirestore.instance
                              .collection('posts')
                              .doc(data['id'])
                              .update({'comments': data['comments']});
                          comment.text = '';
                          setState(() {
                            commentClick = false;
                          });
                        });
                      },
                      icon: Icon(Icons.send))
                ])),
              ),
            )
          ],
        ),
      ),
    );
  }
}
