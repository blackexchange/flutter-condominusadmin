import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';
import '../validators/validators.dart';

class ContasBloc extends BlocBase {
  final _titleController = BehaviorSubject<String>();
  final _listContasController = BehaviorSubject<List<String>>();
  final _categoriaController = BehaviorSubject<String>();
  final _imageController = BehaviorSubject();
  final _deleteController = BehaviorSubject<bool>();

  Stream<String> get outTitle => _titleController.stream.transform(
          StreamTransformer<String, String>.fromHandlers(
              handleData: (title, sink) {
        if (title.isEmpty)
          sink.addError("Insira um nome");
        else
          sink.add(title);
      }));

  Stream<String> get outCategoria => _titleController.stream.transform(
          StreamTransformer<String, String>.fromHandlers(
              handleData: (value, sink) {
        if (value.isEmpty)
          sink.addError("Selecione a categoria");
        else
          sink.add(value);
      }));
  Stream get outImage => _imageController.stream;
  Stream get outListContas => _listContasController.stream;
  Stream<bool> get outDelete => _deleteController.stream;

  Stream<bool> get submitValid =>
      Rx.combineLatest2(outTitle, outImage, (a, b) => true);

  DocumentSnapshot? building;

  File? image;
  String? title;
  String? categoria;
  late List<String> listContas;

  ContasBloc({required this.building}) {
    listContas = ['a', 'b', 'c'];
    _listContasController.add(listContas);
    if (building != null) {
      var data = building?.data() as Map;
      title = data['title'];
      _titleController.add(data['title']);
      _imageController.add(data['image']);
      _deleteController.add(true);
    } else {
      _deleteController.add(false);
    }
  }

  void setImage(File? file) {
    this.image = file;
    _imageController.add(file);
  }

  void setTitle(String title) {
    this.title = title;
    _titleController.add(title);
  }

  void setCategoria(String value) {
    this.categoria = value;
    _categoriaController.add(value);
  }

  void delete() {
    building?.reference.delete();
  }

  Future save() async {
    /*
      if(image != null){
      StorageUploadTask task = FirebaseStorage.instance.ref().child("icons")
          .child(title).putFile(image);
      StorageTaskSnapshot snap = await task.onComplete;
      dataToUpdate["icon"] = await snap.ref.getDownloadURL();
    }
    */
    if (image == null &&
        building != null &&
        title == Map.of(building?.data() as Map)['title']) return;

    Map<String, dynamic> dataTOUpdate = {};
    if (image != null) {
      try {
        UploadTask task = FirebaseStorage.instance
            .ref()
            .child('images')
            .child(title!)
            .putFile(image!);
        TaskSnapshot snap = await task;
        dataTOUpdate["image"] = await snap.ref.getDownloadURL();
      } catch (e) {
        print(e);
      }
    }

    if (building == null || title != Map.of(building?.data() as Map)['title']) {
      dataTOUpdate['title'] = title;
    }

    if (building == null) {
      await FirebaseFirestore.instance
          .collection("units")
          .doc(title?.toLowerCase())
          .set(dataTOUpdate);
    } else {
      await building?.reference.update(dataTOUpdate);
    }
  }

  @override
  void dispose() {
    _titleController.close();
    _imageController.close();
    _deleteController.close();
  }
}
