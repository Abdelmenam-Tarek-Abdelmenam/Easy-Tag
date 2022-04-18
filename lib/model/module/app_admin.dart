import 'package:firebase_auth/firebase_auth.dart';

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
}
