import 'package:flutter/material.dart';

class Agro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Card(
            child: ListTile(
              onTap: () {},
              title: Text("Pestisides"),
            ),
          ),
          Card(
              child: ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/fertilizers');
            },
            title: Text("Fertilizers"),
          ))
        ],
      ),
    );
  }
}
