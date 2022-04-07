import 'package:cloud_firestore/cloud_firestore.dart';
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
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection("buildings").get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.pinkAccent)),
            );
          } else {
            var count = 0;
            if (snapshot.data != null && snapshot.data!.docs.isEmpty) {
              count = snapshot.data!.docs.length;
            }
            return ListView.builder(
                itemCount: count,
                itemBuilder: (context, index) {
                  return BuildingsTab(snapshot.data?.docs[index]);
                });
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
}
