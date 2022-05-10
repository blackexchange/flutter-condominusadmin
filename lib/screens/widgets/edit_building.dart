import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:condominusadmin/screens/widgets/image_source_sheet.dart';
import 'package:flutter/material.dart';
import '../../blocs/blocs.dart';

class EditBuilding extends StatefulWidget {
  final DocumentSnapshot? building;

  EditBuilding({this.building});

  @override
  State<EditBuilding> createState() => _EditBuildingState(building: building);
}

class _EditBuildingState extends State<EditBuilding> {
  final BuildingBloc _buildingBloc;
  final TextEditingController _controller;

  _EditBuildingState({DocumentSnapshot? building})
      : _buildingBloc = BuildingBloc(building: building),
        _controller = TextEditingController(
            text: building != null
                ? Map.of(building.data() as Map)['title']
                : "");

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                builder: (context) =>
                    ImageSourceSheet(onImageSelected: (image) {
                  Navigator.of(context).pop();
                  _buildingBloc.setImage(image);
                }),
              ),
              child: StreamBuilder(
                  stream: _buildingBloc.outImage,
                  builder: (context, snapshot) {
                    var data = null;
                    if (snapshot.data != null) {
                      if (snapshot.data is File) {
                        data = snapshot.data;
                      } else {
                        data = snapshot.data.toString();
                      }

                      return CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: data is File
                            ? Image.file(data as File, fit: BoxFit.cover)
                            : Image.network(data as String, fit: BoxFit.cover),
                      );
                    }
                    return Icon(Icons.image);
                  }),
            ),
            title: StreamBuilder<String>(
                stream: _buildingBloc.outTitle,
                builder: (context, snapshot) {
                  return TextField(
                    controller: _controller,
                    onChanged: _buildingBloc.setTitle,
                    decoration: InputDecoration(
                        errorText: snapshot.hasError
                            ? snapshot.error.toString()
                            : null),
                  );
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StreamBuilder<bool>(
                  stream: _buildingBloc.outDelete,
                  builder: (context, snapshot) {
                    // if (!snapshot.hasData) return Container();
                    return ElevatedButton(
                        onPressed: snapshot.data == true
                            ? () {
                                _buildingBloc.delete;
                                Navigator.of(context).pop();
                              }
                            : null,
                        child: Text(
                          "Excluir",
                        ));
                  }),
              StreamBuilder<bool>(
                  stream: _buildingBloc.submitValid,
                  builder: (context, snapshot) {
                    return ElevatedButton(
                        onPressed: snapshot.hasData
                            ? () async {
                                await _buildingBloc.save();
                                Navigator.of(context).pop();
                              }
                            : null,
                        child: Text(
                          "Salvar",
                        ));
                  })
            ],
          )
        ],
      ),
    ));
  }
}
