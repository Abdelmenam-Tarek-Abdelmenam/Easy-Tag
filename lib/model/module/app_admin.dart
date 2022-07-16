import 'package:auto_id/model/local/pref_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AppAdmin {
  String id;
  String? email;
  String? photoUrl;
  String? name;
  bool isAnonymous;

  AppAdmin({
    required this.id,
    this.name,
    this.email,
    this.photoUrl,
    required this.isAnonymous,
  });

  factory AppAdmin.fromFirebaseUser(User user, {bool anonymous = false}) {
    return AppAdmin(
        id: user.uid,
        email: user.email,
        photoUrl: user.photoURL,
        name: user.displayName,
        isAnonymous: anonymous);
  }

  static AppAdmin empty = AppAdmin(id: '', isAnonymous: false);
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
