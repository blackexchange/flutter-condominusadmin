import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:condominusadmin/screens/building/admin_bloc.dart';
import 'package:flutter/material.dart';
import '../../blocs/blocs.dart';
import '../../screens/widgets/widgets.dart';
import '../../validators/validators.dart';

class EditFinanceiro extends StatefulWidget {
  final DocumentSnapshot? unit;

  EditFinanceiro({required this.unit});

  @override
  State<EditFinanceiro> createState() => _EditFinanceiroState(unit);
}

class _EditFinanceiroState extends State<EditFinanceiro>
    with FinanceiroValidator {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late AdminBloc _adminBloc;

  _EditFinanceiroState(DocumentSnapshot? unit)
      : _adminBloc = AdminBloc(unit: unit);

  @override
  Widget build(BuildContext context) {
    //final _buildingBloc = BlocProvider.getBloc<BuildingBloc>();

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
            stream: _adminBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              return Text(
                  snapshot.data! ? "Editar Lançamento" : "Novo Lançamento");
            }),
        actions: [
          StreamBuilder<bool?>(builder: (context, snapshot) {
            //     if (snapshot.hasData)
            return StreamBuilder<bool?>(
                stream: _adminBloc.outCreated,
                initialData: false,
                builder: (context, snapshot) {
                  return IconButton(
                    onPressed: snapshot.data!
                        ? null
                        : () {
                            _adminBloc.delete();
                            Navigator.of(context).pop();
                          },
                    icon: Icon(Icons.remove),
                  );
                });
            //  else
            // return Container();
          }),
          StreamBuilder<bool?>(
              initialData: false,
              stream: _adminBloc.outLoading,
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
                stream: _adminBloc.outData,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      TextFormField(
                        initialValue: snapshot.data?['title'],
                        style: _fieldStyle,
                        decoration: _bDecoration("Título"),
                        onSaved: _adminBloc.saveTitle,
                        validator: validateTitle,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        initialValue: snapshot.data?['desc'],
                        style: _fieldStyle,
                        decoration: _bDecoration("Descrição"),
                        onSaved: _adminBloc.saveDesc,
                        //  validator: validateTitle,
                      ),
                      TextFormField(
                        initialValue: snapshot.data?['date'],
                        style: _fieldStyle,
                        decoration: _bDecoration("Data"),
                        onSaved: _adminBloc.saveDate,
                        validator: validateTitle,
                      ),
                      TextFormField(
                        initialValue: snapshot.data?['value'].toString(),
                        style: _fieldStyle,
                        decoration: _bDecoration("Valor"),
                        onSaved: _adminBloc.saveValue,
                        validator: validateValue,
                      ),
                    ],
                  );
                }),
          ),
          StreamBuilder<bool?>(
              initialData: false,
              stream: _adminBloc.outLoading,
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

      bool success = await _adminBloc.save();

      final snackBar = SnackBar(
        content: const Text('Salvando dados...'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      //_scaffoldKey.currentState?.showBodyScrim(true, 10);
    }
  }
}
