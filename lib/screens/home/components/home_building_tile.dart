import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../screens.dart';
import '../../building/building.dart';

class HomeBuildingTile extends StatelessWidget {
  final DocumentSnapshot building;

  HomeBuildingTile(this.building);

  @override
  Widget build(BuildContext context) {
    final buildingId = building.id;
    var data = building.data() as Map;
    return SizedBox(
      height: 200,
      width: 200,
      child: Container(
        margin: EdgeInsets.all(4),
        // padding: EdgeInsets.all(16),
        child: Card(
            child: ListTile(
          /*   leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(data["images"][0]),
                      ),*/
          title: Text(building['title']),
          trailing: Text("--"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BuildingScreen(
                      building: building,
                    )));
          },
        )),
      ),
    );
  }
}
