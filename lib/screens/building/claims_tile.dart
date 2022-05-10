import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../screens.dart';
import 'building.dart';

class ClaimsTile extends StatelessWidget {
  final DocumentSnapshot building;

  ClaimsTile(this.building);

  @override
  Widget build(BuildContext context) {
    final buildingId = building.id;
    var data = building.data() as Map;
    return Container(
      margin: EdgeInsets.all(2),
      child: Card(
          child: ExpansionTile(title: Text(building['title']), children: [
        ListTile(
          /*   leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(data["images"][0]),
                        ),*/
          title: Text(building['desc']),
          trailing: Text("--"),
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
