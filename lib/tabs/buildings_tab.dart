import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:condominusadmin/screens/widgets/building_tile.dart';
import 'package:flutter/material.dart';

class BuildingsTab extends StatefulWidget {
  @override
  State<BuildingsTab> createState() => _BuildingsTabState();
}

class _BuildingsTabState extends State<BuildingsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("units").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.pinkAccent)),
            );
          } else {
            final int cont = snapshot.data!.docs.length;
            return ListView.builder(
                itemCount: cont,
                itemBuilder: (context, index) {
                  return BuildingTile(snapshot.data!.docs[index]);
                });
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
}
