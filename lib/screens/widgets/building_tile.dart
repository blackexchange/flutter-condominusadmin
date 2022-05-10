import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:condominusadmin/screens/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../screens.dart';
import '../widgets/widgets.dart';

class BuildingTile extends StatelessWidget {
  final DocumentSnapshot building;

  BuildingTile(this.building);

  @override
  Widget build(BuildContext context) {
    final buildingId = building.id;
    var data = building.data() as Map;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          leading: GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => EditBuilding(building: building));
            },
            child: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(data['image'])),
          ),
          title: Text(
            data['title'],
            style:
                TextStyle(color: Colors.grey[850], fontWeight: FontWeight.w500),
          ),
          children: [
            FutureBuilder<QuerySnapshot>(
                future: building.reference.collection("registereds").get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return Column(
                      children: snapshot.data!.docs.map((e) {
                    var data = e.data() as Map;
                    return ListTile(
                      /*   leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(data["images"][0]),
                      ),*/
                      title: Text(data['title']),
                      trailing: Text("--"),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UnitScreen(
                                  buildingId: building.id,
                                  unit: e,
                                )));
                      },
                    );
                  }).toList()
                        ..add(ListTile(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UnitScreen(buildingId: building.id))),
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(Icons.add, color: Colors.blueAccent),
                          ),
                          title: Text("Adicionar"),
                        )));
                })
          ],
        ),
      ),
    );
  }
}
