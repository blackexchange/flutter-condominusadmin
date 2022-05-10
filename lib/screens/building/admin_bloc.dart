import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdminBloc extends BlocBase {
  final _dataController = BehaviorSubject<Map<String, dynamic>?>();
  final _loading = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();

  Stream<Map<String, dynamic>?> get outData => _dataController.stream;
  Stream<bool?> get outLoading => _loading.stream;
  Stream<bool?> get outCreated => _createdController.stream;

  //final String buildingId;
  final DocumentSnapshot? unit;
  String? idBuilding;
  var parentUnit;

  Map<String, dynamic>? unsaved;

  AdminBloc({required this.unit}) {
    if (unit != null) {
      parentUnit = unit?.reference.parent;
      if (parentUnit?.id == "units") {
        idBuilding = unit!.id;
        unsaved = {
          "title": "",
          "value": "",
          "desc": "",
          "date": "",
          "type": "D",
        };
        _createdController.add(false);
      } else {
        //&& unit!.reference.parent.parent != null)
        var data = unit!.data() as Map<String, dynamic>;
        idBuilding = unit!.id;
        unsaved = data;
        // unsaved!['images'] = data['images']!;
        // unsaved!['sizes'] = List.of(data['sizes'] as Iterable);
        _createdController.add(true);
      }
    }

    _dataController.add(unsaved);
  }

  void delete() {
    unit?.reference.delete();
  }

  void saveTitle(String? title) {
    unsaved!['title'] = title!;
  }

  void saveValue(String? value) {
    unsaved!['value'] = value!;
  }

  void saveDate(String? value) {
    unsaved!['date'] = value!;
  }

  void saveDesc(String? title) {
    unsaved!['desc'] = title!;
  }

  void saveSizes(List? sizes) {
    // unsaved!['quartos'] = sizes!;
  }

  Future<bool> save() async {
    _loading.add(true);

    try {
      if (parentUnit.id == 'financeiro') {
        // await _uploadImages(unit.id);
        await unit?.reference.update(unsaved!);
      } else {
        DocumentReference dr = await FirebaseFirestore.instance
            .collection("units")
            .doc(idBuilding)
            .collection('financeiro')
            .add(Map.from(unsaved!));

        // await _uploadImages(dr.id);
        // await dr.update(unsaved!);
      }
      unsaved = {
        "title": "",
        "value": "",
        "desc": "",
        "date": "",
        "type": "D",
      };
      parentUnit = null;

      _createdController.add(true);

      _loading.add(false);
      return true;
    } catch (e) {
      _loading.add(false);
      return false;
    }
  }

  Future _uploadImages(String unitId) async {
    /* for (int i = 0; i < unsaved['image'].length; i++) {
      if (unsaved['image'][i] is String) continue;
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(buildingId)
          .child(unitId)
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(unsaved['image'][i]);

      TaskSnapshot s = await uploadTask;
      String download = await s.ref.getDownloadURL();
      unsaved['image'][i] = download;
    }*/
  }

  @override
  void dispose() {
    _dataController.close();
    _loading.close();
    _createdController.close();
  }
}
