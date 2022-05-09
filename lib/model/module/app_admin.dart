import 'package:auto_id/model/local/pref_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AppAdmin {
  late String id;
  String? email;
  String? photoUrl;
  String? name;

  AppAdmin({
    required this.id,
    this.name,
    this.email,
    this.photoUrl,
  });

  AppAdmin.fromFirebaseUser(User user) {
    id = user.uid;
    email = user.email;
    photoUrl = user.photoURL;
    name = user.displayName;
  }

  static AppAdmin empty = AppAdmin(id: '');
  bool get isEmpty => id == '';
  Future<bool> get isAdmin async {
    bool? isAdmin = PreferenceRepository.getDataFromSharedPreference(
        key: PreferenceKey.isAdmin);
    if (isAdmin == null) {
      isAdmin = (await _adminsId).contains(id);
      PreferenceRepository.putDataInSharedPreference(
          value: isAdmin, key: PreferenceKey.isAdmin);
    }
    return isAdmin;
  }

  Future<List<String>> get _adminsId async {
    DataSnapshot snap =
        await FirebaseDatabase.instance.ref().child("admin").get();
    dynamic value = snap.value;
    return (List<String>.from(value));
  }
}
