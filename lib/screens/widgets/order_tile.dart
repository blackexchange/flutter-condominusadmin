// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import './widgets.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final DocumentSnapshot? order;

  final states = ['', 'Analisando', 'Concluído', 'Inconsistência', 'Reprovado'];

  OrderTile(this.order);

  @override
  Widget build(BuildContext context) {
    final orderData = order!.data() as Map;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          key: Key(order!.id),
          initiallyExpanded: orderData['status'] != 3,
          title: Text(
            "${orderData['type']} - " "${states[orderData['status']]}",
            style: TextStyle(color: Colors.green),
          ),
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OrderHeader(order!),
                  /*Column(
                    mainAxisSize: MainAxisSize.min,
                    children: orderData['orders'].map<Widget>((p) {
                      ListTile(
                        title: Text(
                          "ok",
                          style: TextStyle(color: Colors.green),
                        ),
                        subtitle: Text("casdas"),
                        trailing: Text(
                          "2",
                          style: TextStyle(color: Colors.green, fontSize: 20),
                        ),
                        contentPadding: EdgeInsets.zero,
                      );
                    }),
                  ),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(orderData['userId'])
                              .collection("orders")
                              .doc(order?.id)
                              .delete();
                          order?.reference.delete();
                        },
                        child: Text(
                          "Excluir",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: orderData['status'] > 1
                            ? () {
                                order?.reference.update(
                                    {"status": orderData['status'] - 1});
                              }
                            : null,
                        child: Text(
                          "Regredir",
                          style: TextStyle(color: Colors.grey[850]),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: orderData['status'] < 4
                            ? () {
                                order?.reference.update(
                                    {"status": orderData['status'] + 1});
                              }
                            : null,
                        child: Text(
                          "Avançar",
                          style: TextStyle(color: Colors.green),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
