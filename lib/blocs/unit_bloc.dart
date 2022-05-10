import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UnitBloc extends BlocBase {
  final _dataController = BehaviorSubject<Map<String, dynamic>?>();
  final _loading = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();

  Stream<Map<String, dynamic>?> get outData => _dataController.stream;
  Stream<bool?> get outLoading => _loading.stream;
  Stream<bool?> get outCreated => _createdController.stream;

  final String buildingId;
  final DocumentSnapshot? unit;

  Map<String, dynamic>? unsaved;

  UnitBloc({required this.buildingId, required this.unit}) {
    if (unit != null) {
      var data = unit!.data() as Map<String, dynamic>;
      unsaved = data;
      // unsaved!['images'] = data['images']!;
      // unsaved!['sizes'] = List.of(data['sizes'] as Iterable);
      _createdController.add(true);
    } else {
      unsaved = {"title": ""};
      _createdController.add(false);
    }

    _dataController.add(unsaved);
  }

  void delete() {
    unit?.reference.delete();
  }

  void saveTitle(String? title) {
    unsaved!['title'] = title!;
  }

  void saveSizes(List? sizes) {
    // unsaved!['quartos'] = sizes!;
  }

  Future<bool> save() async {
    _loading.add(true);
    try {
      if (unit != null) {
        // await _uploadImages(unit.id);
        await unit?.reference.update(unsaved!);
      } else {
        DocumentReference dr = await FirebaseFirestore.instance
            .collection("units")
            .doc(buildingId)
            .collection('registereds')
            .add(Map.from(unsaved!)..remove("images"));

        // await _uploadImages(dr.id);
        await dr.update(unsaved!);
      }
      unsaved = {"title": ""};

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
