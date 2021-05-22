import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kissanmitra/screens/widgets/inputField.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';

class AddPrice extends StatelessWidget {
  final String collection, id;
  AddPrice(this.collection, this.id);

  @override
  Widget build(BuildContext context) {
    TextEditingController shopName = TextEditingController();
    TextEditingController price = TextEditingController();
    TextEditingController contact = TextEditingController();
    TextEditingController address = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text("Add Your Business Details")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyInputTextField(
              "Shop Name",
              shopName,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyInputTextField(
              "Price",
              price,
              type: TextInputType.number,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyInputTextField(
              "Contact",
              contact,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyInputTextField(
              "address",
              address,
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                print(shopName.text);
                await FirebaseFirestore.instance
                    .collection('$collection')
                    .doc(id)
                    .collection("seller")
                    .doc(Statics.getUid())
                    .set({
                  'shopname': shopName.text.trim(),
                  'sellerName': CurrentUser.name,
                  'address': address.text.trim(),
                  'price': price.text.trim(),
                  'id': Statics.getUid(),
                  'pid': id
                });
                Statics.showToast("Added Successfully");
                Navigator.pop(context);
              },
              child: Text("Add"))
        ],
      ),
    );
  }
}
