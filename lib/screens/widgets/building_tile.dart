import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BuildingTile extends StatelessWidget {
  final DocumentSnapshot building;

  BuildingTile(this.building);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(building.data()["icon"]),
            ),
            title: Text(
              building.data()['name'],
              style: TextStyle(
                  color: Colors.grey[850], fontWeight: FontWeight.w500),
            )),
      ),
    );
  }
}
