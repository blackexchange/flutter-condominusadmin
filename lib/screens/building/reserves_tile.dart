import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../screens.dart';
import 'building.dart';

class ReservesTile extends StatelessWidget {
  final DocumentSnapshot building;

  ReservesTile(this.building);

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
              leading: Text(building['area']['title']),
              title: Text(building['unit']['title']),
              trailing: Icon(Icons.check),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BuildingScreen(
                          building: building,
                        )));
              },
            ),
          ])),
    );
  }
}
