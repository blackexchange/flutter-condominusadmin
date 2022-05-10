import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../screens.dart';
import 'building.dart';

class FinanceiroTile extends StatelessWidget {
  final DocumentSnapshot building;

  FinanceiroTile(this.building);

  @override
  Widget build(BuildContext context) {
    final buildingId = building.id;
    var data = building.data() as Map;
    return Container(
      margin: EdgeInsets.all(2),
      child: Card(
          child: ExpansionTile(
              title: Text(
                building['date'],
              ),
              children: [
            ListTile(
              leading: Text(building['type']),
              title: Text(building['desc']),
              trailing: Icon(Icons.check),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditFinanceiro(
                          unit: building,
                        )));
              },
            ),
          ])),
    );
  }
}
