import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:condominusadmin/screens/widgets/image_source_sheet.dart';
import 'package:flutter/material.dart';
import '../../blocs/blocs.dart';

class ContaDialog extends StatefulWidget {
  final DocumentSnapshot? building;

  ContaDialog({this.building});

  @override
  State<ContaDialog> createState() => _ContaDialogState(building: building);
}

class _ContaDialogState extends State<ContaDialog> {
  final ContasBloc _contasBLoc;
  final TextEditingController _controller;

  _ContaDialogState({DocumentSnapshot? building})
      : _contasBLoc = ContasBloc(building: building),
        _controller = TextEditingController(
            text: building != null
                ? Map.of(building.data() as Map)['title']
                : "");

  @override
  Widget build(BuildContext context) {
    String dropdownValue = 'One';
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
                  _contasBLoc.setImage(image);
                }),
              ),
              child: StreamBuilder(
                  stream: _contasBLoc.outImage,
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
            title: Column(
              children: [
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  // elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: _contasBLoc.listContas
                      ?.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                StreamBuilder<String>(
                    stream: _contasBLoc.outTitle,
                    builder: (context, snapshot) {
                      return TextField(
                        controller: _controller,
                        onChanged: _contasBLoc.setTitle,
                        decoration: InputDecoration(
                            errorText: snapshot.hasError
                                ? snapshot.error.toString()
                                : null),
                      );
                    }),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StreamBuilder<bool>(
                  stream: _contasBLoc.outDelete,
                  builder: (context, snapshot) {
                    // if (!snapshot.hasData) return Container();
                    return ElevatedButton(
                        onPressed: snapshot.data == true
                            ? () {
                                _contasBLoc.delete;
                                Navigator.of(context).pop();
                              }
                            : null,
                        child: Text(
                          "Excluir",
                        ));
                  }),
              StreamBuilder<bool>(
                  stream: _contasBLoc.submitValid,
                  builder: (context, snapshot) {
                    return ElevatedButton(
                        onPressed: snapshot.hasData
                            ? () async {
                                await _contasBLoc.save();
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
