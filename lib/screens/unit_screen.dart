import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../blocs/blocs.dart';
import '../screens/widgets/widgets.dart';
import '../validators/validators.dart';

class UnitScreen extends StatefulWidget {
  final String buildingId;
  final DocumentSnapshot? unit;

  UnitScreen({required this.buildingId, this.unit});

  @override
  State<UnitScreen> createState() => _UnitScreenState(buildingId, unit);
}

class _UnitScreenState extends State<UnitScreen> with UnitValidator {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late UnitBloc _unitBloc;

  _UnitScreenState(String buildingId, DocumentSnapshot? unit)
      : _unitBloc = UnitBloc(buildingId: buildingId, unit: unit);

  @override
  Widget build(BuildContext context) {
    final _fieldStyle = TextStyle(color: Colors.white, fontSize: 16);

    InputDecoration _bDecoration(String label) {
      return InputDecoration(
          labelText: label, labelStyle: TextStyle(color: Colors.grey));
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        elevation: 0,
        title: StreamBuilder<bool?>(
            stream: _unitBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              return Text(snapshot.data! ? "Editar Unidade" : "Criar Unidade");
            }),
        actions: [
          StreamBuilder<bool?>(builder: (context, snapshot) {
            if (snapshot.hasData)
              return StreamBuilder<bool?>(
                  stream: _unitBloc.outCreated,
                  initialData: false,
                  builder: (context, snapshot) {
                    return IconButton(
                      onPressed: snapshot.data!
                          ? null
                          : () {
                              _unitBloc.delete();
                              Navigator.of(context).pop();
                            },
                      icon: Icon(Icons.remove),
                    );
                  });
            else
              return Container();
          }),
          StreamBuilder<bool?>(
              initialData: false,
              stream: _unitBloc.outLoading,
              builder: (context, snapshot) {
                return IconButton(
                  onPressed: snapshot.data!
                      ? null
                      : () {
                          saveUnit();
                          // Navigator.of(context).pop();
                        },
                  icon: Icon(Icons.save),
                );
              }),
        ],
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: StreamBuilder<Map<String, dynamic>?>(
                stream: _unitBloc.outData,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      TextFormField(
                        initialValue: snapshot.data?['title'],
                        style: _fieldStyle,
                        decoration: _bDecoration("Título"),
                        onSaved: _unitBloc.saveTitle,
                        validator: validateTitle,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  );
                }),
          ),
          StreamBuilder<bool?>(
              initialData: false,
              stream: _unitBloc.outLoading,
              builder: (context, snapshot) {
                return IgnorePointer(
                    ignoring: !snapshot.data!,
                    child: Container(
                        color: snapshot.data!
                            ? Colors.black54
                            : Colors.transparent));
              }),
        ],
      ),
    );
  }

  void saveUnit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      bool success = await _unitBloc.save();

      final snackBar = SnackBar(
        content: const Text('Salvando dados...'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      //_scaffoldKey.currentState?.showBodyScrim(true, 10);
    }
  }
}
